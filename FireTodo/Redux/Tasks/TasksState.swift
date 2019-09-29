//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift
import Firebase
import FireSnapshot

struct TasksState: StateType {
    var tasks: [Snapshot<Model.Task>] = []
    var tasksListener: ListenerRegistration?
}
