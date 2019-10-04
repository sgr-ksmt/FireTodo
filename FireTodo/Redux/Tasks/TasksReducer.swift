//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum TasksReducer {
    static var reducer: Reducer<TasksState> {
        return { action, state in
            var state = state ?? TasksState()
            guard let action = action as? TasksAction else {
                return state
            }
            switch action {
            case let .updateTasks(tasks):
                state.tasks = tasks
                return state
            case let .updateListener(listener):
                state.tasksListener = listener
                return state
            }
        }
    }
}
