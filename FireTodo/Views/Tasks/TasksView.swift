//
// Copyright © Suguru Kishimoto. All rights reserved.
//

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
    @State private var showEditTask: Bool = false
    @State private var showProfile: Bool = false
    @State private var editTask: Snapshot<Model.Task>?
    @ObservedObject private var deleteActionSheetState: DeleteActionSheetState = .init()
    @State private var hideCompletedTasks: Bool = true

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
                                            self.editTask = task
                                            self.showEditTask = true
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
                            self.showEditTask = true
                        }
                    }
                    .layoutPriority(1)
                }
            }
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showProfile = true
                }) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                }
            )
        }
        .background(
            EmptyView().sheet(isPresented: $showEditTask) {
                EditTaskView(task: self.editTask)
                    .environmentObject(self.store)
                    .onDisappear {
                        self.editTask = nil
                }
            }
            .background(EmptyView().sheet(isPresented: $showProfile) {
                ProfileView()
                    .environmentObject(self.store)
            })
        )
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
                    ActionSheet.Button.cancel()])
        }
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

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
