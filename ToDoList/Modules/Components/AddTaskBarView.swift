//
//  AddTaskBarView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 30.09.2025.
//

import SwiftUI

struct AddTaskBarView: View {
    let total: Int
    let onAddTap: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("\(total) Задач")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.primary)
            
            Spacer()
            
            Button(action: onAddTap) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.yellowDone)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Добавить задачу")
        }
        .frame(height: 49)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    AddTaskBarView(total: 7, onAddTap: {})
}
