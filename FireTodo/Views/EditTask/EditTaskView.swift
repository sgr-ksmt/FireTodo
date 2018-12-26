//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI

class EditTaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var desc: String = ""
    @Published var color: TaskColor = .red
    private var completed: Bool = false
    init(task: Snapshot<Model.Task>?) {
        guard let task = task else {
            return
        }
        title = task.data.title
        desc = task.data.desc
        color = task.data.taskColor
        completed = task.data.completed
    }

    var canSave: Bool {
        !title.isEmpty
    }

    var saveData: Model.Task {
        let task = Model.Task()
        task.title = title
        task.desc = desc
        task.taskColor = color
        task.completed = completed
        return task
    }
}

struct EditTaskView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject private var viewModel: EditTaskViewModel

    private let task: Snapshot<Model.Task>?
    var isEditing: Bool {
        task != nil
    }

    init(task: Snapshot<Model.Task>? = nil) {
        self.task = task
        viewModel  = EditTaskViewModel(task: task)
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 32.0) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Title")
                        TextField("e.g. Buy iPhone11 Pro", text: $viewModel.title)
                    }

                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Description")
                        TextField("[Optional]", text: $viewModel.desc)
                    }

                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Color")
                        HStack(spacing: 16.0) {
                            ForEach(TaskColor.allCases) { color in
                                ColorSelectView(color: color.color, selected: color == self.viewModel.color)
                                    .onTapGesture {
                                        withAnimation {
                                            self.viewModel.color = color
                                        }
                                }
                            }

                            Spacer()
                        }
                    }

                    Spacer()
                }
                .padding()
                .navigationBarTitle(!isEditing ? "Create Task" : "Edit Task")
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    },
                    trailing: Button(action: {
                        guard let user = self.store.state.authState.user else {
                            return
                        }
                        if !self.isEditing {
                            self.store.dispatch(EditTaskAction.saveTask(self.viewModel.saveData, userID: user.reference.documentID))
                        } else if let taskID = self.task?.reference.documentID {
                            self.store.dispatch(EditTaskAction.updateTask(self.viewModel.saveData, taskID: taskID, userID: user.reference.documentID))
                        }
                    }) {
                        Text(!isEditing ? "Save" : "Edit")
                    }
                    .disabled(!viewModel.canSave)
                )
            }

            LoadingView(isLoading: self.store.state.editTaskState.requesting)
        }
        .onReceive(store.objectWillChange) { _ in
            if self.store.state.editTaskState.saved {
                self.presentationMode.wrappedValue.dismiss()
                self.store.dispatch(EditTaskAction.reset)
            }
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView()
    }
}
