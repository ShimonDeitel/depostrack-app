import Foundation

struct DepositItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String          // Client / Job
    var amount: Double         // Amount
    var date: Date             // Date
    var isComplete: Bool       // Received
    var notes: String = ""
    var createdAt: Date = Date()
}
