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
    @State private var showSaveError = false
    
    @FocusState private var detailsFocused: Bool
    
    let onSaved: (() -> Void)?
    
    init(viewModel: TaskEditViewModel, onSaved: (() -> Void)? = nil) {
        self._viewModel = State(initialValue: viewModel)
        self.onSaved = onSaved
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Введите название", text: $viewModel.title)
                        .textInputAutocapitalization(.sentences)
                }
                Section("Описание") {
                    ZStack(alignment: .topLeading) {
                        if viewModel.createCleanText(viewModel.details).isEmpty {
                            Text("Добавьте описание")
                                .foregroundStyle(.secondary.opacity(0.5))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $viewModel.details)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 140)
                            .focused($detailsFocused)
                            .textInputAutocapitalization(.sentences)
                            .autocorrectionDisabled(false)
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        do {
                            try viewModel.save(in: modelContext)
                            onSaved?()
                            dismiss()
                        } catch {
                            showSaveError = true
                        }
                    }
                    .disabled(!viewModel.isValidTitle(viewModel.title))
                }
            }
            .alert("Ошибка сохранения", isPresented: $showSaveError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Не удалось сохранить задачу. Попробуйте ещё раз.")
            }
            .onAppear { detailsFocused = false }
        }
    }
}

#Preview {
    TaskEditView(viewModel: TaskEditViewModel(task: TaskItem(title: "")))
}
