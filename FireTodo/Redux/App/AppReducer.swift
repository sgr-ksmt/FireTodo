//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum AppReducer {
    static var reduce: Reducer<AppState> {
        return { action, state in
            var state = state ?? AppState()
            state.authState = AuthReducer.reduce(action, state.authState)
            state.signUpState = SignUpReducer.reduce(action, state.signUpState)
            state.tasksState = TasksReducer.reduce(action, state.tasksState)
            state.editTaskState = EditTaskReducer.reduce(action, state.editTaskState)
            return state
        }
    }
}
