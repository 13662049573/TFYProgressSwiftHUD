import XCTest
import UIKit
@testable import TFYProgressSwiftHUD

final class TFYProgressSwiftHUDTests: XCTestCase {
    override func tearDown() {
        TFYProgressSwiftHUD.dismiss()
        TFYProgressSwiftHUD.resetAppearance()
        super.tearDown()
    }

    func testAllDocumentedCasesAreExposed() {
        XCTAssertEqual(AnimationType.allCases.count, 11)
        XCTAssertEqual(AnimatedIcon.allCases.count, 3)
        XCTAssertEqual(AlertIcon.allCases.count, 19)
    }

    func testScopedPresentationAndDismissal() {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        TFYProgressSwiftHUD.show("Testing", in: host, interaction: false)
        XCTAssertTrue(TFYProgressSwiftHUD.isVisible)
        XCTAssertEqual(host.subviews.count, 1)

        let dismissed = expectation(description: "HUD dismissed")
        TFYProgressSwiftHUD.dismiss { dismissed.fulfill() }
        wait(for: [dismissed], timeout: 1)
        XCTAssertFalse(TFYProgressSwiftHUD.isVisible)
    }

    func testTimingValuesAreNormalized() {
        TFYProgressSwiftHUD.minimumDismissTimeInterval = -2
        TFYProgressSwiftHUD.maximumDismissTimeInterval = -4
        XCTAssertEqual(TFYProgressSwiftHUD.minimumDismissTimeInterval, 0)
        XCTAssertEqual(TFYProgressSwiftHUD.maximumDismissTimeInterval, 0)
    }
}
