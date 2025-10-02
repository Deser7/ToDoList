# 📝 ToDoList

Современное iOS-приложение для управления задачами на SwiftUI + SwiftData с архитектурой MVVM.

## ✨ Особенности

- **SwiftUI** интерфейс с анимациями
- **SwiftData** для локального хранения
- **Автозагрузка** задач из API при первом запуске
- **Умный поиск** по названию и описанию
- **Контекстные действия** (редактирование, удаление, шаринг)

## 🛠 Технологии

- iOS 17+ / Swift 6
- SwiftUI + SwiftData + Observation
- MVVM архитектура
- Swift Testing с моками и in-memory БД

## 🏗 Структура

```
ToDoList/
├── Models/      # TaskItem, Response, NetworkError
├── Services/    # NetworkManager, API
├── Modules/     # TaskList, TaskEdit, Components
└── Extensions/  # Date helpers
```

## 🚀 Запуск

```bash
git clone <repository-url>
cd ToDoList
open ToDoList.xcodeproj
```

Нажмите ⌘ + R для запуска или ⌘ + U для тестов.

## 📱 Функции

- ✅ Создание/редактирование задач
- ✅ Отметка выполнения
- ✅ Поиск и фильтрация
- ✅ Свайп для удаления
- ✅ Синхронизация с [DummyJSON API](https://dummyjson.com/todos)

---

**Автор**: Андрей Спиридонов | **Создано**: 28.09.2025
