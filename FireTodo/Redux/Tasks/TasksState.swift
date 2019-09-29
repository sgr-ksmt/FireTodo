//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FireSnapshot
import Foundation
import ReSwift

struct TasksState: StateType {
    var tasks: [Snapshot<Model.Task>] = []
    var tasksListener: ListenerRegistration?
}
