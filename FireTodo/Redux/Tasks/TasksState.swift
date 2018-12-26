//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift
import Firebase

struct TasksState: StateType {
    var tasks: [Snapshot<Model.Task>] = []
    var tasksListener: ListenerRegistration?
}
