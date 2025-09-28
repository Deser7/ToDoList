//
//  TaskCellView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftUI

struct TaskCellView: View {
    let title: String
    let details: String
    let timestamp: Date
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Button(action: onToggle) {
                    Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                        .font(.system(size: 24))
                        .foregroundStyle(isCompleted ? .yellowDone : .stroke)
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                        .opacity(isCompleted ? 0.5 : 1)
                        .strikethrough(isCompleted, pattern: .solid, color: .secondary)
                    
                    if !details.isEmpty {
                        Text(details)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.primary)
                            .opacity(isCompleted ? 0.5 : 1)
                            .lineLimit(2)
                    }
                    
                    Text(timestamp.dateStringWithSeparator)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.primary)
                        .opacity(0.5)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.stroke)
                .opacity(0.5)
                .padding(16)
        }
    }
}

#Preview {
    TaskCellView(
        title: "Уборка в квартире",
        details: "Провести генеральную уборку в квартире",
        timestamp: Date.now,
        isCompleted: false,
        onToggle: {}
    )
}
