import XCTest
@testable import Depostrack

@MainActor
final class DepostrackTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(title: "Test Item", amount: 10, date: Date(), isComplete: false)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testAddRespectsFreeLimit() {
        store.isPro = false
        for i in 0..<Store.freeLimit {
            store.add(title: "Item \(i)", amount: 1, date: Date(), isComplete: false)
        }
        XCTAssertFalse(store.canAddMore)
        let result = store.add(title: "One Too Many", amount: 1, date: Date(), isComplete: false)
        XCTAssertFalse(result)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProUsersBypassLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(title: "Item \(i)", amount: 1, date: Date(), isComplete: false)
        }
        XCTAssertEqual(store.items.count, Store.freeLimit + 5)
    }

    func testDeleteRemovesItem() {
        store.add(title: "To Delete", amount: 5, date: Date(), isComplete: false)
        let idx = store.items.firstIndex { $0.title == "To Delete" }!
        store.delete(at: IndexSet(integer: idx))
        XCTAssertFalse(store.items.contains { $0.title == "To Delete" })
    }

    func testToggleComplete() {
        store.add(title: "Toggle Me", amount: 5, date: Date(), isComplete: false)
        let item = store.items.first { $0.title == "Toggle Me" }!
        store.toggleComplete(item)
        let updated = store.items.first { $0.id == item.id }!
        XCTAssertTrue(updated.isComplete)
    }

    func testUpdateModifiesFields() {
        store.add(title: "Original", amount: 5, date: Date(), isComplete: false)
        var item = store.items.first!
        item.title = "Updated"
        item.amount = 99
        store.update(item)
        XCTAssertEqual(store.items.first?.title, "Updated")
        XCTAssertEqual(store.items.first?.amount, 99)
    }

    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }
}
