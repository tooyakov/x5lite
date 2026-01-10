import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var manager: WebViewManager
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = manager.webView
        webView.navigationDelegate = context.coordinator
        
        // Настройка JavaScript bridge для коммуникации с веб-приложением
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "paymentHandler")
        
        // Загружаем сайт
        if let url = URL(string: "https://x5-233568038472.us-west1.run.app/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Обновления не требуются
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Обработка начала загрузки
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.manager.isLoading = true
        }
        
        // Обработка завершения загрузки
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.manager.isLoading = false
        }
        
        // Обработка ошибок загрузки
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.manager.isLoading = false
            print("Ошибка загрузки: \(error.localizedDescription)")
        }
        
        // Обработка сообщений от JavaScript
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "paymentHandler" {
                if let messageBody = message.body as? [String: Any] {
                    handlePaymentRequest(messageBody)
                }
            }
        }
        
        private func handlePaymentRequest(_ data: [String: Any]) {
            // Извлекаем данные о платеже
            guard let amount = data["amount"] as? Double,
                  let currency = data["currency"] as? String else {
                print("Неверный формат данных платежа")
                return
            }
            
            // Инициируем Apple Pay
            PaymentService.shared.processPayment(
                amount: amount,
                currency: currency
            ) { success, transactionId in
                // Отправляем результат обратно в веб-приложение
                let result = success ? "success" : "failed"
                let script = """
                    window.paymentCallback && window.paymentCallback({
                        status: '\(result)',
                        transactionId: '\(transactionId ?? "")'
                    });
                """
                
                DispatchQueue.main.async {
                    self.parent.manager.webView.evaluateJavaScript(script) { _, error in
                        if let error = error {
                            print("Ошибка отправки результата: \(error)")
                        }
                    }
                }
            }
        }
    }
}
