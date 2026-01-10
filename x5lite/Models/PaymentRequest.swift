import Foundation

/// Модель для запроса платежа, передаваемого от веб-приложения
struct PaymentRequest: Codable {
    let amount: Double
    let currency: String
    let description: String?
    let planId: String?
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case description
        case planId = "plan_id"
    }
}

/// Модель ответа о результате платежа
struct PaymentResponse: Codable {
    let status: PaymentStatus
    let transactionId: String?
    let error: String?
    
    enum PaymentStatus: String, Codable {
        case success
        case failed
        case cancelled
    }
}
