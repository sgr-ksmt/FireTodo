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

    static func saveTask(_ task: Snapshot<Model.Task>) -> AppThunkAction {
        AppThunkAction { dispatch, _ in
            dispatch(EditTaskAction.startRequest)
            task.create { result in
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

    static func updateTask(_ task: Snapshot<Model.Task>) -> AppThunkAction {
        AppThunkAction { dispatch, _ in
            dispatch(EditTaskAction.startRequest)
            task.update { result in
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
