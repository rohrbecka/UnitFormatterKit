import XCTest
import Foundation

@testable import UnitFormatterKit


final class UnitFormatterTests: XCTestCase {

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        formatter.positiveSuffix = " mm"
        formatter.negativeSuffix = " mm"
        return formatter
    }()

    let unitFormatter: UnitFormatter = {
        let formatter = UnitFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        formatter.unit = "mm"
        return formatter
    }()

    func testUnitFormatter() throws {
        XCTAssertEqual(unitFormatter.string(from: NSNumber(1.23)), "1,23 mm")
        XCTAssertEqual(unitFormatter.number(from: "1,34 mm")?.doubleValue, 1.34)

        XCTAssertEqual(unitFormatter.number(from: "1,34")?.doubleValue , 1.34)
    }

    func testUnitFormatterForNegativeNumbers () throws {
        XCTAssertEqual(unitFormatter.string(from: NSNumber(-1.23)), "-1,23 mm")
        XCTAssertEqual(unitFormatter.number(from: "-1,2345")?.doubleValue, -1.2345)
    }
}
