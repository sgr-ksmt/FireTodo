//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var authState: AuthState = .init()
    var signUpState: SignUpState = .init()
    var tasksState: TasksState = .init()
    var editTaskState: EditTaskState = .init()
}
