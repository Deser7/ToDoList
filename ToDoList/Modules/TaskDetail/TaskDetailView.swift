//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let date: String
    let details: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(date)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 8)
                    
                    Text(details)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.primary)
            
                    Spacer()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    TaskDetailView(
        title: "Занятия спортом",
        date: "02/10/24",
        details: "Сходить в спортивный магазин и купить много одежды для тренирок. Не забыть использовать бонусы и скидки. Оплатить картой с хорошим кэшбэком."
    )
}
