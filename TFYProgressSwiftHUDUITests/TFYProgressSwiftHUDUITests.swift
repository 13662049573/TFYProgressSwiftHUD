import XCTest

final class TFYProgressSwiftHUDUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testDemoListsAndRunsCoreExample() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tables["hud.demo.table"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.navigationBars["TFYProgressSwiftHUD"].exists)

        let loadingExample = app.cells["hud.demo.0.3"]
        XCTAssertTrue(loadingExample.waitForExistence(timeout: 2))
        loadingExample.tap()
        XCTAssertTrue(app.staticTexts["tfy.hud.status"].waitForExistence(timeout: 2))
        XCTAssertEqual(app.staticTexts["tfy.hud.status"].label, "正在提交，请勿重复操作")
        XCTAssertTrue(app.buttons["重置"].exists)
    }

    func testLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
