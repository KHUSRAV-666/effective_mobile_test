# Effective Mobile Test - Rick & Morty App

Приложение на Flutter для просмотра персонажей вселенной "Рик и Морти". Проект демонстрирует работу с пагинацией, локальным хранением данных и кешированием изображений.

## Функциональные возможности

- **Список героев**: Загрузка персонажей из Rick and Morty API.
- **Пагинация**: Бесконечный скролл с автоматической подгрузкой.
- **Офлайн-режим**: Текстовые данные сохраняются в **SQLite**, а изображения кешируются во внутреннюю память.
- **Pull-to-Refresh**: Принудительное обновление данных с очисткой локального кеша.
- **Избранное**: Возможность сохранять персонажей локально.

## Технологический стек

- **Flutter**: 3.35.7
- **State Management**: [Riverpod]
- **Local Database**: [sqflite]
- **Image Caching**: [cached_network_image] & [flutter_cache_manager]
- **Networking**: [http]
- **Architecture** | Clean Architecture |

## Требования

Перед запуском убедитесь, что у вас установлены:

- Flutter SDK (версия 3.x.x)
- Dart SDK (версия 3.x.x)
- Android Studio / Xcode (для эмуляторов)

## Сборка и запуск

1. **Клонируйте репозиторий:**

   ```bash
   git clone [https://github.com/KHUSRAV-666/effective_mobile_test.git](https://github.com/KHUSRAV-666/effective_mobile_test.git)
   cd effective_mobile_test

   ```

2. ```bash
   flutter pub get

   ```

3. ```bash
   flutter run
   ```

## Сборка APK

# Debug версия
```bash
   flutter build apk --debug
```

# Release версия
```bash
   flutter build apk --release
```