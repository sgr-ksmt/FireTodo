//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift
import Firebase

enum TasksAction: Action {
    case updateTasks(tasks: [Snapshot<Model.Task>])
    case registerListener(listener: ListenerRegistration)
    case removeListener

    static func subscribe(userID: String) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            let listener = Snapshot<Model.Task>.listen(Model.Path.tasks(userID: userID)) { result in
                switch result {
                case let .success(tasks):
                    dispatch(TasksAction.updateTasks(tasks: tasks))
                case let .failure(error):
                    print(error)
                    // error handling
                    dispatch(TasksAction.updateTasks(tasks: []))
                }
            }
            dispatch(TasksAction.registerListener(listener: listener))
        }
    }

    static func unsubscribe() -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            getState()?.tasksState.tasksListener?.remove()
            dispatch(TasksAction.removeListener)
        }
    }

    static func deleteTask(_ task: Snapshot<Model.Task>) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            task.remove()
        }
    }

    static func toggleTaskCompleted(_ task: Snapshot<Model.Task>) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            task.data.completed.toggle()
            task.update()
        }
    }
}
