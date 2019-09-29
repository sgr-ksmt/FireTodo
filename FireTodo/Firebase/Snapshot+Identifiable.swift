//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import FireSnapshot

extension Snapshot: Identifiable {
    public var id: String {
        reference.documentID
    }
}
