import XCTest

final class DepostrackUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddFlowCreatesNewItem() {
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Item")
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Item"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissesOnTapOutside() {
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.staticTexts.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.exists)
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<30 {
            app.buttons["addButton"].tap()
            let titleField = app.textFields["titleField"]
            if !titleField.waitForExistence(timeout: 1) {
                break
            }
            titleField.tap()
            titleField.typeText("Item \(i)")
            app.buttons["saveButton"].tap()
        }
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["purchaseButton"].waitForExistence(timeout: 2))
    }

    func testCancelDismissesAddSheet() {
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["cancelButton"].waitForExistence(timeout: 2))
        app.buttons["cancelButton"].tap()
        XCTAssertFalse(app.textFields["titleField"].exists)
    }
}
