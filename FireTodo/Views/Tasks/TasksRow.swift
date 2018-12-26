//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI

struct TasksRow: View {
    private let task: Snapshot<Model.Task>
    private let onTapCompleted: () -> Void
    @State var opacity: Double = 0.0
    init(task: Snapshot<Model.Task>, onTapCompleted: @escaping () -> Void) {
        self.task = task
        self.onTapCompleted = onTapCompleted
    }
    var body: some View {
        VStack {
            HStack(spacing: 16.0) {
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(task.data.title)
                        .font(.headline)
                        .lineLimit(1)

                    Text(task.data.desc)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer()

                Image(systemName: task.data.completed ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .onTapGesture(perform: onTapCompleted)
            }
        }
        .padding()
        .background(task.data.taskColor.color)
        .cornerRadius(16.0)
        .padding([.horizontal], 16.0)
        .padding([.bottom], 8.0)
        .opacity(opacity)
        .onAppear {
            withAnimation {
                self.opacity = 1.0
            }
        }
    }
}

//struct TasksRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TasksRow(task: .init(title: "test")) {}
//    }
//}
