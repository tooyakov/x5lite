import Foundation
import PassKit

class PaymentService: NSObject {
    static let shared = PaymentService()
    
    // ВАЖНО: Замените на ваш реальный Merchant ID из Apple Developer Portal
    private let merchantIdentifier = "merchant.com.x5lite.payments"
    
    private var paymentCompletion: ((Bool, String?) -> Void)?
    
    private override init() {
        super.init()
    }
    
    /// Проверяет доступность Apple Pay на устройстве
    func canMakePayments() -> Bool {
        return PKPaymentAuthorizationController.canMakePayments()
    }
    
    /// Инициирует процесс оплаты через Apple Pay
    func processPayment(
        amount: Double,
        currency: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        self.paymentCompletion = completion
        
        // Проверяем доступность Apple Pay
        guard canMakePayments() else {
            print("Apple Pay недоступен на этом устройстве")
            completion(false, nil)
            return
        }
        
        // Создаем запрос платежа
        let request = createPaymentRequest(amount: amount, currency: currency)
        
        // Создаем контроллер авторизации
        let paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController.delegate = self
        
        // Показываем интерфейс Apple Pay
        paymentController.present { presented in
            if !presented {
                print("Не удалось показать Apple Pay")
                completion(false, nil)
            }
        }
    }
    
    private func createPaymentRequest(amount: Double, currency: String) -> PKPaymentRequest {
        let request = PKPaymentRequest()
        
        // Настройка merchant
        request.merchantIdentifier = merchantIdentifier
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = currency
        request.supportedNetworks = [.visa, .masterCard, .amex, .discover]
        
        // Создание элемента платежа
        let paymentItem = PKPaymentSummaryItem(
            label: "Подписка X5",
            amount: NSDecimalNumber(value: amount)
        )
        request.paymentSummaryItems = [paymentItem]
        
        return request
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate

extension PaymentService: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // Контроллер закрыт
        }
    }
    
    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // Обработка успешной авторизации платежа
        // ВАЖНО: Здесь нужно отправить payment.token на ваш backend для обработки
        
        // Для демонстрации считаем платеж успешным
        let transactionId = UUID().uuidString
        
        // Симулируем обработку платежа
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Успешный платеж
            let result = PKPaymentAuthorizationResult(status: .success, errors: nil)
            completion(result)
            
            // Вызываем callback
            self.paymentCompletion?(true, transactionId)
            self.paymentCompletion = nil
        }
        
        /* 
         РЕАЛЬНАЯ ИНТЕГРАЦИЯ:
         В продакшене здесь нужно:
         1. Отправить payment.token.paymentData на ваш backend
         2. Backend обработает платеж через Apple Pay API
         3. Вернуть результат и обновить статус подписки пользователя
         
         Пример:
         let paymentData = payment.token.paymentData
         sendToBackend(paymentData) { success, transactionId in
             let status: PKPaymentAuthorizationStatus = success ? .success : .failure
             let result = PKPaymentAuthorizationResult(status: status, errors: nil)
             completion(result)
             self.paymentCompletion?(success, transactionId)
             self.paymentCompletion = nil
         }
        */
    }
}
