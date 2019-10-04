//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import FireSnapshot
import Foundation
import ReSwift

enum EditTaskAction: Action {
    case startRequest
    case endRequest
    case closeView
    case reset

    static func saveTask(_ taskData: Model.Task, userID: String) -> AppThunkAction {
        AppThunkAction { dispatch, _ in
            dispatch(EditTaskAction.startRequest)
            Snapshot(data: taskData, path: .tasks(userID: userID)).create { result in
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
        AppThunkAction { dispatch, _ in
            dispatch(EditTaskAction.startRequest)
            Snapshot(data: taskData, path: .task(userID: userID, taskID: taskID)).update { result in
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
