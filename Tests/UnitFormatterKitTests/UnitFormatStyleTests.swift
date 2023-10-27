//
//  UnitFormatStyleTests.swift
//  
//
//  Created by André Rohrbeck on 26.10.23.
//

import XCTest
import UnitFormatterKit

// MARK: Double
final class UnitFormatStyleTests: XCTestCase {

    func testConversionToStringForOptionals() {
        let value0: Double? = 123.45
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "123,45_mm")
        let value1: Double? = 56.8
        XCTAssertEqual(value1.formatted(UnitFormatStyle("kN")), "56,8 kN")
        let value2: Double? = nil
        XCTAssertEqual(value2.formatted(UnitFormatStyle("kN")), "")
        let value3: Double? = -4711
        XCTAssertEqual(value3.formatted(UnitFormatStyle("°", padding: "")), "-4.711°")
    }

    func testConversionToStringForDouble() {
        let value0: Double = 123.45
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "123,45_mm")
        let value1: Double = 56.8
        XCTAssertEqual(value1.formatted(UnitFormatStyle("kN")), "56,8 kN")
    }

    func testConversionToNumberFromString() {
        XCTAssertEqual(try? Double("123,45_mm", format: UnitFormatStyle("mm", padding: "_")), 123.45)
        XCTAssertNil(try? Double("", format: UnitFormatStyle("mm")))
        XCTAssertEqual(try? Double("-08,15_mm", format: UnitFormatStyle("mm", padding: "_")), -8.15)
    }

    func testConversionToNumberFailsGivenAStringWithNoDigits() {
        XCTAssertThrowsError(try Double("abcdefghijk", format: UnitFormatStyle("mm"))) {error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 2048)
            XCTAssertEqual(nsError.domain, "NSCocoaErrorDomain")
            XCTAssert(nsError.debugDescription != "")
        }
    }
}

// MARK: - Float16
extension UnitFormatStyleTests {
    func testConversionToStringForOptionalFloat16() {
        let value0: Float16? = 0.5
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "0,5_mm")
    }

    func testConversionToStringForFloat16 () {
        let value0: Float16 = 0.5
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "0,5_mm")
    }

    func testConversionFromStringToFloat16() {
        XCTAssertEqual(try? Float16("0,5_mm", format: UnitFormatStyle("mm", padding: "_")), 0.5)
        XCTAssertEqual(try? Float16("-0,5_mm", format: UnitFormatStyle("xxm")), -0.5)
    }
}

// MARK: - Float32
extension UnitFormatStyleTests {
    func testConversionToStringForOptionalFloat32() {
        let value0: Float32? = 0.5
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "0,5_mm")
    }

    func testConversionToStringForFloat32 () {
        let value0: Float32 = 0.5
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "0,5_mm")
    }

    func testConversionFromStringToFloat32() {
        XCTAssertEqual(try? Float32("0,5_mm", format: UnitFormatStyle("mm", padding: "_")), 0.5)
        XCTAssertEqual(try? Float32("-0,5_mm", format: UnitFormatStyle("xxm")), -0.5)
    }
}

// MARK: - Float80
extension UnitFormatStyleTests {
    func testConversionToStringForOptionalFloat64() {
        let value0: Float64? = 0.5
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "0,5_mm")
    }
    
    func testConversionToStringForFloat64 () {
        let value0: Float64 = 0.5
        XCTAssertEqual(value0.formatted(UnitFormatStyle("mm", padding: "_")), "0,5_mm")
    }

    func testConversionFromStringToFloat64() {
        XCTAssertEqual(try? Float64("0,5_mm", format: UnitFormatStyle("mm", padding: "_")), 0.5)
        XCTAssertEqual(try? Float64("-0,5_mm", format: UnitFormatStyle("xxm")), -0.5)
    }
}
