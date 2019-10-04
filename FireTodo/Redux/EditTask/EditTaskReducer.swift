//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum EditTaskReducer {
    static var reducer: Reducer<EditTaskState> {
        return { action, state in
            var state = state ?? EditTaskState()
            guard let action = action as? EditTaskAction else {
                return state
            }
            switch action {
            case .startRequest:
                state.requesting = true
                return state
            case .endRequest:
                state.requesting = false
                return state
            case .closeView:
                state.saved = true
                return state
            case .reset:
                return EditTaskState()
            }
        }
    }
}
