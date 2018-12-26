//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum EditTaskReducer {
    static var reduce: Reducer<EditTaskState> {
        return { action, state in
            var state = state ?? EditTaskState()
            switch action {
            case let action as EditTaskAction:
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
            default:
                break
            }
            return state
        }
    }
}
