//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI

struct RightDownFloatButton: View {

    private let action: () -> Void
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 44.0, height: 44.0)
                        .background(Color.primary)
                        .clipShape(Circle())
                        .shadow(color: .primary, radius: 4.0)
                }
                .offset(x: -32, y: -16)
            }
        }
    }
}

struct RightDownFloatButton_Previews: PreviewProvider {
    static var previews: some View {
        RightDownFloatButton()
    }
}

