//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum TasksReducer {
    static var reduce: Reducer<TasksState> {
        return { action, state in
            var state = state ?? TasksState()
            switch action {
            case let action as TasksAction:
                switch action {
                case let .updateTasks(tasks):
                    state.tasks = tasks
                    return state
                case .registerListener(let listener):
                    state.tasksListener = listener
                    return state
                case .removeListener:
                    state.tasksListener = nil
                    return state
                }
            default:
                break
            }
            return state
        }
    }
}
