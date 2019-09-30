//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import SwiftUI

struct PresentationView: View, Identifiable {
    typealias ID = AnyHashable
    private let _id: ID
    var id: ID {
        _id
    }

    private let _body: AnyView
    var body: some View {
        _body
    }

    init?<V>(view: V?) where V: View & Identifiable {
        guard let view = view else { return nil }
        self._body = AnyView(view)
        self._id = view.id
    }
}
