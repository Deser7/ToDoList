//
//  CustomSearchBarView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftUI

struct CustomSearchBarView: View {
    @Binding var text: String
    let onVoiceSearch: () -> Void
    
    @State private var isEditing = false
    @State private var viewModel = CustomSearchBarViewModel()
    @State private var isInitialized = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary.opacity(0.5))
                    .padding(.leading, 8)
                
                TextField("Search", text: $text)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .onTapGesture {
                        isEditing = true
                    }
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.primary.opacity(0.5))
                    }
                }
                
                Button(action: {
                    if isInitialized {
                        viewModel.toggleRecording()
                    }
                    onVoiceSearch()
                }) {
                    Image(systemName: viewModel.microphoneIcon)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(viewModel.isRecording ? .red : .gray)
                        .scaleEffect(viewModel.isRecording ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isRecording)
                }
                .disabled(!viewModel.canRecord || !isInitialized)
                .padding(.trailing, 8)
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThickMaterial)
            )
            
            // Дополнительная панель с результатами (показывается при редактировании)
            if isEditing {
                VStack(spacing: 8) {
                    // Текущий текст (живой результат)
                    if !viewModel.currentText.isEmpty {
                        HStack {
                            Text("Сейчас:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(viewModel.currentText)
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.green.opacity(0.1))
                        )
                    }
                    
                    // Финальный текст
                    if !viewModel.finalizedText.isEmpty {
                        HStack {
                            Text("Результат:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(viewModel.finalizedText)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.blue.opacity(0.1))
                        )
                    }
                    
                    // ✅ Отображение ошибок
                    if let errorMessage = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.red.opacity(0.1))
                        )
                    }
                    
                    // Кнопка очистки результатов
                    if !viewModel.finalizedText.isEmpty || !viewModel.currentText.isEmpty {
                        Button("Очистить результаты") {
                            viewModel.clearText()
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isEditing)
        .onChange(of: viewModel.currentText) { _, newValue in
            // Обновляем поле поиска с текущим текстом
            text = newValue
        }
        .onChange(of: viewModel.finalizedText) { _, newValue in
            // Обновляем поле поиска с финальным текстом
            text = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        .onAppear {
#if DEBUG
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                if !isInitialized {
                    viewModel.initializeVoiceSearch()
                    isInitialized = true
                }
            }
#else
            if !isInitialized {
                viewModel.initializeVoiceSearch()
                isInitialized = true
            }
#endif
        }
    }
}


#Preview {
    CustomSearchBarView(
        text: .constant(""),
        onVoiceSearch: {}
    )
    .onAppear {
        print("Превью режим - голосовой поиск отключен")
    }
}
