//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import FireSnapshot
import Foundation

extension Snapshot: Identifiable {
    public var id: String {
        reference.documentID
    }
}
