import SwiftUI

struct ContentView: View {
    @StateObject private var webViewManager = WebViewManager()
    
    var body: some View {
        ZStack {
            WebView(manager: webViewManager)
                .edgesIgnoringSafeArea(.all)
            
            if webViewManager.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Загрузка...")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.9))
            }
        }
    }
}

#Preview {
    ContentView()
}
