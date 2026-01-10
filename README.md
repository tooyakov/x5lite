# X5 Lite - iOS Native App

Нативное iOS приложение для платформы X5, созданное на SwiftUI с интеграцией Apple Pay.

## 📱 Возможности

- **WebView интеграция**: Загружает веб-приложение X5 с определением платформы iOS
- **Apple Pay**: Нативные платежи через Apple Pay
- **JavaScript Bridge**: Двусторонняя коммуникация между нативным кодом и веб-приложением
- **Кастомный User Agent**: `X5_IOS_CLIENT` для определения платформы на стороне сервера

## 🚀 Быстрый старт

### Требования

- macOS 13.0+
- Xcode 15.0+
- iOS 15.0+ (для запуска приложения)
- Apple Developer Account (для тестирования Apple Pay)

### Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/yourusername/x5lite.git
cd x5lite/x5lite-ios
```

2. Откройте проект в Xcode:
```bash
open x5lite.xcodeproj
```

3. **ВАЖНО**: Настройте Merchant ID для Apple Pay:
   - Откройте файл `x5lite/Services/PaymentService.swift`
   - Замените `merchant.com.x5lite.payments` на ваш реальный Merchant ID
   - Откройте `x5lite.entitlements` и обновите Merchant ID там же

4. Выберите целевое устройство или симулятор

5. Нажмите `Cmd + R` для запуска

## 🔧 Конфигурация

### Apple Pay Setup

1. **Создайте Merchant ID** в [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list):
   - Identifiers → Register a New Identifier → Merchant IDs
   - Пример: `merchant.com.x5lite.payments`

2. **Обновите код**:
   ```swift
   // x5lite/Services/PaymentService.swift
   private let merchantIdentifier = "ваш-merchant-id"
   ```

3. **Обновите Entitlements**:
   ```xml
   <!-- x5lite.entitlements -->
   <key>com.apple.developer.in-app-payments</key>
   <array>
       <string>ваш-merchant-id</string>
   </array>
   ```

4. **Настройте Bundle ID** в Xcode:
   - Project Settings → Signing & Capabilities
   - Добавьте capability "Apple Pay"
   - Выберите ваш Merchant ID

### URL конфигурация

Если нужно изменить URL веб-приложения:

```swift
// x5lite/Views/WebView.swift
if let url = URL(string: "ваш-новый-url") {
    let request = URLRequest(url: url)
    webView.load(request)
}
```

## 📂 Структура проекта

```
x5lite-ios/
├── x5lite/
│   ├── App/
│   │   ├── x5liteApp.swift          # Точка входа
│   │   └── Info.plist               # Конфигурация приложения
│   ├── Views/
│   │   ├── ContentView.swift        # Главный экран
│   │   └── WebView.swift            # WebKit обертка
│   ├── Services/
│   │   ├── WebViewManager.swift     # Управление WebView
│   │   └── PaymentService.swift     # Apple Pay сервис
│   ├── Models/
│   │   └── PaymentRequest.swift     # Модели данных
│   └── Resources/
│       └── Assets.xcassets/         # Ресурсы приложения
└── README.md
```

## 🔌 JavaScript Integration

Для инициации платежа из веб-приложения используйте:

```javascript
// Проверка платформы по User Agent
const isIOSApp = navigator.userAgent.includes('X5_IOS_CLIENT');

if (isIOSApp) {
    // Отправка запроса на платеж
    window.webkit.messageHandlers.paymentHandler.postMessage({
        amount: 9.99,
        currency: 'USD',
        description: 'Premium подписка',
        plan_id: 'premium_monthly'
    });
    
    // Обработка результата
    window.paymentCallback = function(result) {
        if (result.status === 'success') {
            console.log('Платеж успешен:', result.transactionId);
        } else {
            console.log('Платеж отменен или ошибка');
        }
    };
}
```

## 🧪 Тестирование

### Тестирование Apple Pay

В симуляторе iOS:
1. Settings → Wallet & Apple Pay
2. Добавьте тестовую карту (работает только на реальном устройстве с реальной картой)

На реальном устройстве:
1. Настройте Apple Pay в Wallet
2. Используйте тестовые карты от вашего payment processor

### Debug WebView

Для отладки веб-контента:
1. Запустите приложение в симуляторе/устройстве
2. Safari → Develop → [Your Device] → x5lite
3. Откроется Web Inspector для просмотра консоли и Network

## 📝 Roadmap

- [ ] Жидкое стекло (Glassmorphism) дизайн для кнопок
- [ ] Оффлайн режим с кешированием
- [ ] Push-уведомления
- [ ] Улучшенная обработка ошибок
- [ ] Аналитика и метрики

## 🤝 Contributing

Pull requests приветствуются! Для больших изменений сначала откройте issue для обсуждения.

## 📄 License

[MIT](LICENSE)

## 👤 Author

Создано для платформы X5

## 🐛 Известные проблемы

- Apple Pay работает только на реальных устройствах с настроенным Apple Pay
- Для тестирования в симуляторе платежи будут симулироваться
- Требуется backend интеграция для обработки payment tokens

## 📧 Поддержка

По вопросам и предложениям: [GitHub Issues](https://github.com/yourusername/x5lite/issues)
