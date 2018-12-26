//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI

struct ColorSelectView: View {
    private let color: Color
    private let selected: Bool

    init(color: Color, selected: Bool) {
        self.color = color
        self.selected = selected
    }

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(selected ? Color.primary : color)

            if selected {
                Circle()
                    .foregroundColor(color)
                    .padding([.all], 4.0)
            }
        }
        .frame(width: 44.0, height: 44.0)
    }
}

struct ColorSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectView(color: .red, selected: true)
    }
}
