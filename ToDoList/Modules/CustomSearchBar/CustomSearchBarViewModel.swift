//
//  CustomSearchBarViewModel.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 03.10.2025.
//

import AVFoundation
import Observation
import Speech

@Observable
final class CustomSearchBarViewModel {
    var finalizedText = ""
    var currentText = ""
    var isRecording = false
    var hasPermissions = false
    var errorMessage: String?
    
    private var transcriber: SpeechTranscriber?
    private var recognitionTask: Task<Void, Never>?
    
    var canRecord: Bool {
        hasPermissions && !isRecording
    }
    
    var microphoneIcon: String {
        isRecording ? "stop.fill" : "mic.fill"
    }
    
    func initializeVoiceSearch() {
#if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("🚫 Превью режим - голосовой поиск отключен")
            return
        }
#endif
        
        setupSpeechTranscriber()
        Task {
            await self.requestPermissions()
        }
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        guard hasPermissions else {
            errorMessage = "Нет разрешений для записи"
            return
        }
        
        isRecording = true
        errorMessage = nil
        
        Task {
            do {
                try await setupAudioSession()
                try startTranscription()
            } catch {
                await MainActor.run {
                    errorMessage = "Ошибка запуска записи: \(error.localizedDescription)"
                    isRecording = false
                }
            }
        }
    }
    
    func stopRecording() {
        // Отменяем задачу распознавания
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Деактивируем аудиосессию
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("❌ Ошибка деактивации аудиосессии: \(error)")
        }
        
        // Обновляем состояние
        isRecording = false
    }
    
    func clearText() {
        currentText = ""
        finalizedText = ""
    }
    
    private func setupSpeechTranscriber() {
        // SpeechTranscriber не выбрасывает ошибки при инициализации
        transcriber = SpeechTranscriber(
            locale: Locale(identifier: "ru-RU"),
            preset: .progressiveTranscription
        )
        
        print("✅ SpeechTranscriber инициализирован")
        
        
    }
    
    private func requestPermissions() async {
        // Проверяем текущий статус разрешений
        let speechAuth = SFSpeechRecognizer.authorizationStatus()
        
        // Запрашиваем разрешение только если оно не определено
        if speechAuth == .notDetermined {
            await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { status in
                    continuation.resume()
                }
            }
        }
        
        // Запрашиваем разрешение на микрофон (новый API для iOS 17+)
        let micAuth = await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        
        // Проверяем финальный статус
        let finalSpeechAuth = SFSpeechRecognizer.authorizationStatus()
        
        await MainActor.run {
            hasPermissions = finalSpeechAuth == .authorized && micAuth
            if !hasPermissions {
                errorMessage = "Разрешения отклонены"
            }
        }
    }
    
    
    
    private func startTranscription() throws {
        guard let transcriber = transcriber else {
            throw NSError(domain: "SpeechError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transcriber не инициализирован"])
        }
        
        recognitionTask = Task {
            do {
                // Используем правильный API для получения результатов
                for try await result in transcriber.results {
                    await MainActor.run {
                        // Используем правильный API для получения результатов
                        let _transcriber = result as SpeechTranscriber.Result
                        currentText = String(_transcriber.text.characters)
                        
                        if _transcriber.isFinal {
                            finalizedText += String(_transcriber.text.characters) + " "
                            stopRecording()
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Ошибка обработки результатов: \(error.localizedDescription)"
                    stopRecording()
                }
            }
        }
    }
    
    private func setupAudioSession() async throws {
        try AVAudioSession.sharedInstance().setCategory(
            .record,
            mode: .measurement,
            options: [.duckOthers, .allowBluetoothHFP]
        )
        try AVAudioSession.sharedInstance().setActive(true)
    }
}

