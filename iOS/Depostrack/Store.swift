import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [DepositItem] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Seed data has 4 items; keep this well above that
    /// so a fresh install never hits the paywall immediately.
    static let freeLimit = 25

    private let fileName = "depostrack_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([DepositItem].self, from: data) else {
            items = Self.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Self.freeLimit
    }

    @discardableResult
    func add(title: String, amount: Double, date: Date, isComplete: Bool, notes: String = "") -> Bool {
        guard canAddMore else { return false }
        let item = DepositItem(title: title, amount: amount, date: date, isComplete: isComplete, notes: notes)
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: DepositItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: DepositItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func toggleComplete(_ item: DepositItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx].isComplete.toggle()
        save()
    }

    static func seedData() -> [DepositItem] {
        [
        DepositItem(title: "Harper Wedding Photography", amount: 500.0, date: Date(), isComplete: true, notes: "Applied to invoice #204"),
        DepositItem(title: "Diaz Kitchen Reno", amount: 1200.0, date: Date(), isComplete: false, notes: "Awaiting wire transfer"),
        DepositItem(title: "Nolan Event Catering", amount: 300.0, date: Date(), isComplete: true, notes: "Confirmed"),
        DepositItem(title: "Ellis Landscaping Job", amount: 450.0, date: Date(), isComplete: false, notes: "Invoiced, unpaid")
        ]
    }
}
