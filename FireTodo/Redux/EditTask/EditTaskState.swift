//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

struct EditTaskState: StateType {
    var requesting: Bool = false
    var saved: Bool = false
    var error: Error?
}
