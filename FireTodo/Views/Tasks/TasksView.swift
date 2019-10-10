//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import FireSnapshot
import SwiftUI

class DeleteActionSheetState: ObservableObject {
    @Published var showActionSheet: Bool = false
    @Published var task: Snapshot<Model.Task>? {
        didSet {
            showActionSheet = task != nil
        }
    }
}

struct TasksView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject private var deleteActionSheetState: DeleteActionSheetState = .init()
    @State private var hideCompletedTasks: Bool = true
    @State private var presentation: PresentationView?

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Hide Completed Tasks")
                        Toggle("", isOn: $hideCompletedTasks.animation())
                    }
                    .padding()

                    ZStack {
                        ScrollView(.vertical, showsIndicators: true) {
                            ForEach(store.state.tasksState.tasks) { task in
                                if !self.hideCompletedTasks || !task.data.completed {
                                    TasksRow(task: task) {
                                        self.store.dispatch(TasksAction.toggleTaskCompleted(task))
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            guard let editTask = try? task.replicated() else {
                                                return
                                            }
                                            self.presentation = PresentationView(view: EditTaskView(mode: .edit(editTask: editTask)))
                                        }) { Text("Edit") }

                                        Button(action: {
                                            self.deleteActionSheetState.task = task
                                        }) { Text("Delete") }
                                    }
                                    .animation(.easeIn(duration: 0.3))
                                }
                            }

                            WidthFillPlaceHolderView()
                        }

                        RightDownFloatButton {
                            guard let user = self.store.state.authState.user else {
                                return
                            }
                            self.presentation = PresentationView(view: EditTaskView(mode: .new(userID: user.reference.documentID)))
                        }
                    }
                    .layoutPriority(1)
                }
            }
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentation = PresentationView(view: ProfileView())
                }) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
            })
            .sheet(item: $presentation, content: { $0.environmentObject(self.store) })
            .actionSheet(isPresented: $deleteActionSheetState.showActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("Would you want to delete this task?\"\(deleteActionSheetState.task?.data.title ?? "")\""),
                    buttons: [
                        ActionSheet.Button.destructive(Text("Delete")) {
                            if let task = self.deleteActionSheetState.task {
                                self.store.dispatch(TasksAction.deleteTask(task))
                            }
                        },
                        ActionSheet.Button.cancel(),
                    ]
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if let userID = self.store.state.authState.user?.reference.documentID {
                self.store.dispatch(TasksAction.subscribe(userID: userID))
            }
        }
        .onDisappear {
            self.store.dispatch(TasksAction.unsubscribe())
        }
    }
}

#if DEBUG
struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView().environmentObject(AppMain().store)
    }
}
#endif
