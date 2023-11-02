import Foundation

/// A ``ParseableFormatStyle`` which supports units added to a numeric value.
///
/// The format styles supplied by Apple are ont able to handle units other than currency or percent.
/// A formatter supporting a unit is missing. This gap is closed by the ``UnitFormatStyle``.
///
/// Using this format style (e. g. in SwiftUI context) gives the possibility to show a value with unit to
/// the user, but doesn't put the burden on the User to enter the exact unit when entering a value.
/// In fact the user can enter anything (either wrong, correct or no unit at all). Only the numeric characters
/// are interpreted.
@available(macOS 12, iOS 15, *)
public struct UnitFormatStyle<Value: BinaryFloatingPoint> {
    /// The physical unit to be displayed at the end of the string representing the ``Value``.
    public var unit: String

    /// The padding string placed between the numerical value and the unit.
    public var padding: String

    /// Creates a ``UnitFormatStyle``.
    ///
    /// The padding is by default an n-broad space as this is correct for most units.
    /// For special units like 'degrees' (e. g. 180,0°) you have to override the default setting to
    /// the empty string.
    ///
    /// - Parameter unit: The physical unit.
    /// - Parameter padding: The string placed between the numerical value and the unit.
    public init(_ unit: String, padding: String = " ") {
        self.unit = unit
        self.padding = padding
    }
}

@available(macOS 12, iOS 15, *)
extension UnitFormatStyle: ParseableFormatStyle{
    public var parseStrategy: UnitParseStrategy<Value> {
        UnitParseStrategy()
    }

    public func format(_ value: Value?) -> String {
        guard let value else {
            return ""
        }
        return value.formatted(FloatingPointFormatStyle<Value>()) + padding + unit
    }
}

@available(macOS 12, iOS 15, *)
public struct UnitParseStrategy<Value: BinaryFloatingPoint>: ParseStrategy {
    public func parse(_ string: String) throws -> Value? {
        if string == "" {
            return nil
        } else {
            let reducedString = string.allButNumbersRemoved
            if let value = try? Value(reducedString, format: FloatingPointFormatStyle<Value>()) {
                return value
            } else {
                return nil
            }
        }
    }
}

// MARK: Formatting to Strings
@available(macOS 12, iOS 15, *)
extension Optional where Wrapped: BinaryFloatingPoint {
    public func formatted(_ formatStyle: UnitFormatStyle<Wrapped>) -> String {
        formatStyle.format(self)
    }
}

@available(macOS 12, iOS 15, *)
extension BinaryFloatingPoint {
    public func formatted(_ formatStyle: UnitFormatStyle<Self>) -> String {
        formatStyle.format(self)
    }
}

// MARK: Initialisers for all BinaryFloatingPoint
@available(macOS 12, iOS 15, *)
extension Double {
    public init(_ value: String, format: UnitFormatStyle<Self>) throws {
        self = try Self.valueFromString(value, format: format)
    }
}

@available(macOS 12, iOS 15, *)
extension Float32 {
    public init(_ value: String, format: UnitFormatStyle<Self>) throws {
        self = try Self.valueFromString(value, format: format)
    }
}

// MARK: - Parsing
@available(macOS 12, iOS 15, *)
extension BinaryFloatingPoint {
    fileprivate static func valueFromString(_ value: String, format: UnitFormatStyle<Self>) throws -> Self {
        guard let value = try? format.parseStrategy.parse(value) else {
            throw NSError(domain: "NSCocoaErrorDomain", code: 2048,
                          userInfo: NSError.parsingErrorUserInfo(string: value, format: format))
        }
        return value
    }
}

// MARK: - ParsingError
@available(macOS 12, iOS 15, *)
extension NSError {
    fileprivate 
    static func parsingErrorUserInfo<Value: BinaryFloatingPoint>(string: String,
                                                                 format: UnitFormatStyle<Value>) -> [String: Any]{
        let exampleString = format.format(3.14)
        return [NSDebugDescriptionErrorKey:
            "Cannot parse \(string). String should adhere to the specified format, such as '\(exampleString)'"]
    }
}
