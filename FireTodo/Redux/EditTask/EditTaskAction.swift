//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum EditTaskAction: Action {
    case startRequest
    case endRequest
    case closeView
    case reset

    static func saveTask(_ taskData: Model.Task, userID: String) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            dispatch(EditTaskAction.startRequest)
            Snapshot(data: taskData, path: Model.Path.tasks(userID: userID)).set { result in
                dispatch(EditTaskAction.endRequest)
                switch result {
                case .success:
                    dispatch(EditTaskAction.closeView)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    static func updateTask(_ taskData: Model.Task, taskID: String, userID: String) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            dispatch(EditTaskAction.startRequest)
            Snapshot(data: taskData, path: Model.Path.task(userID: userID, taskID: taskID)).update { result in
                dispatch(EditTaskAction.endRequest)
                switch result {
                case .success:
                    dispatch(EditTaskAction.closeView)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
