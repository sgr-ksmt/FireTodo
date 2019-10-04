//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum AppReducer {
    static var reducer: Reducer<AppState> {
        return { action, state in
            var state = state ?? AppState()
            state.authState = AuthReducer.reducer(action, state.authState)
            state.signUpState = SignUpReducer.reducer(action, state.signUpState)
            state.tasksState = TasksReducer.reducer(action, state.tasksState)
            state.editTaskState = EditTaskReducer.reducer(action, state.editTaskState)
            return state
        }
    }
}
