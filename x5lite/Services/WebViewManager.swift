import Foundation
import WebKit

class WebViewManager: ObservableObject {
    @Published var isLoading: Bool = false
    let webView: WKWebView
    
    init() {
        // Настройка конфигурации WebView
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Создание WebView
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        
        // ВАЖНО: Добавляем кастомный User Agent для определения iOS платформы
        let customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1 X5_IOS_CLIENT"
        webView.customUserAgent = customUserAgent
        
        // Включаем инспектор для отладки
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
    }
}
