import XCTest
import UIKit
@testable import TFYProgressSwiftHUD

final class TFYProgressSwiftHUDPackageTests: XCTestCase {
    override func tearDown() {
        TFYProgressSwiftHUD.dismiss()
        TFYProgressSwiftHUD.resetAppearance()
        super.tearDown()
    }

    func testPublicEnumCoverage() {
        XCTAssertEqual(AnimationType.allCases.count, 11)
        XCTAssertEqual(AnimatedIcon.allCases.count, 3)
        XCTAssertEqual(AlertIcon.allCases.count, 19)
        XCTAssertTrue(AlertIcon.allCases.allSatisfy { $0.image != nil })
    }

    func testAppearanceCanBeCustomizedAndReset() {
        TFYProgressSwiftHUD.animationType = .circleStrokeSpin
        TFYProgressSwiftHUD.minimumDismissTimeInterval = 0.4
        TFYProgressSwiftHUD.maximumDismissTimeInterval = 1.2
        XCTAssertEqual(TFYProgressSwiftHUD.animationType, .circleStrokeSpin)
        XCTAssertEqual(TFYProgressSwiftHUD.minimumDismissTimeInterval, 0.4, accuracy: 0.001)
        XCTAssertEqual(TFYProgressSwiftHUD.maximumDismissTimeInterval, 1.2, accuracy: 0.001)

        TFYProgressSwiftHUD.resetAppearance()
        XCTAssertEqual(TFYProgressSwiftHUD.animationType, .systemActivityIndicator)
        XCTAssertEqual(TFYProgressSwiftHUD.minimumDismissTimeInterval, 1.25, accuracy: 0.001)
        XCTAssertEqual(TFYProgressSwiftHUD.maximumDismissTimeInterval, 5, accuracy: 0.001)
    }

    func testPresentationInsideSpecificHostView() {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        TFYProgressSwiftHUD.show("Scoped HUD", in: host, interaction: false)
        XCTAssertTrue(TFYProgressSwiftHUD.isVisible)
        XCTAssertEqual(host.subviews.count, 1)
    }

    func testProgressAcceptsInvalidValuesWithoutCrashing() {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        TFYProgressSwiftHUD.showProgress(1.5, status: "Over range", in: host)
        TFYProgressSwiftHUD.showProgress(.infinity, status: "Non-finite", in: host)
        XCTAssertTrue(TFYProgressSwiftHUD.isVisible)
    }
}
