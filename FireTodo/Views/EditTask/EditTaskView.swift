//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Combine
import FireSnapshot
import SwiftUI

private class EditTaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var desc: String = ""
    @Published var color: TaskColor = .red

    let isEditing: Bool
    let task: Snapshot<Model.Task>
    private var cancellables: [AnyCancellable] = []
    init(mode: EditTaskViewMode) {
        isEditing = mode.isEditing
        self.task = mode.task
        title = self.task.data.title
        desc = self.task.data.desc
        color = self.task.data.taskColor

        bind()
    }

    private func bind() {
        cancellables.append(contentsOf: [
            $title.sink { [task] in task.title = $0 },
            $desc.sink { [task] in task.desc = $0 },
            $color.sink { [task] in task.taskColor = $0 },
        ])
    }

    var canSave: Bool {
        !title.isEmpty
    }
}

enum EditTaskViewMode {
    case new(userID: String)
    case edit(editTask: Snapshot<Model.Task>)

    var task: Snapshot<Model.Task> {
        switch self {
        case let .new(userID):
            return Snapshot(data: .init(), path: .tasks(userID: userID))
        case let .edit(editTask):
            return editTask
        }
    }

    var isEditing: Bool {
        if case .edit = self {
            return true
        }
        return false
    }
}

struct EditTaskView: View, Identifiable {
    var id = UUID()

    @EnvironmentObject private var store: AppStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject private var viewModel: EditTaskViewModel

    init(mode: EditTaskViewMode) {
        viewModel = EditTaskViewModel(mode: mode)
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
                .navigationBarTitle(!viewModel.isEditing ? "Create Task" : "Edit Task")
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    },
                    trailing: Button(action: {
                        if !self.viewModel.isEditing {
                            self.store.dispatch(EditTaskAction.saveTask(self.viewModel.task))
                        } else {
                            self.store.dispatch(EditTaskAction.updateTask(self.viewModel.task))
                        }
                    }) {
                        Text(!viewModel.isEditing ? "Save" : "Edit")
                    }
                    .disabled(!viewModel.canSave)
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())

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

#if DEBUG
struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(mode: .new(userID: "xxx")).environmentObject(AppMain().store)
    }
}
#endif
