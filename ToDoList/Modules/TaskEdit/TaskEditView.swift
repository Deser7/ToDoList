//
//  TaskEditView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 29.09.2025.
//

import SwiftUI
import SwiftData

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel: TaskEditViewModel
    @State private var title: String
    @State private var details: String
    @FocusState private var detailsFocused: Bool
    
    let onSaved: (() -> Void)?
    
    init(viewModel: TaskEditViewModel, onSaved: (() -> Void)? = nil) {
        self._viewModel = State(initialValue: viewModel)
        self.onSaved = onSaved
        _title = State(initialValue: viewModel.title)
        _details = State(initialValue: viewModel.details)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Измените название", text: $title)
                        .textInputAutocapitalization(.sentences)
                }
                Section("Описание") {
                    ZStack(alignment: .topLeading) {
                        if details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text("Изменить описание")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $details)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 140)
                            .focused($detailsFocused)
                            .textInputAutocapitalization(.sentences)
                            .autocorrectionDisabled(false)
                    }
                }
            }
            .navigationTitle("Редактировать задачу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        do {
                            viewModel.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                            viewModel.details = details.trimmingCharacters(in: .whitespacesAndNewlines)
                            try viewModel.save(in: modelContext)
                            onSaved?()
                            dismiss()
                        } catch {
                            print("Ошибка сохранения: \(error)")
                        }
                    }
                    .disabled(!viewModel.isValidTitle(title))
                }
            }
            .onAppear { detailsFocused = false }
        }
    }
}

#Preview {
    TaskEditView(viewModel: TaskEditViewModel(task: TaskItem(title: "")))
}
