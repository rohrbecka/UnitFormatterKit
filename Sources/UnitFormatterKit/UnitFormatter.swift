import Foundation

/// A ``NumberFormatter`, which is better at handling units as the original.
///
/// ``Foundation/NumberFormatter`` is able to handle units by simply adding a positive and negative suffix
/// to the number, which is a nice workaround for labels. But if the user shall be able to enter a value into a textfield
/// he is forced to enter the value with the suffix (exactly!).
///
/// For a unit like "mm" this may be easy, but for "kN / mV/V" it becomes complicated to get the slashes and whitespaces
/// correct.
///
/// ``UnitFormatter`` gives the user the possibility to omit the unit completely and will return a value.
/// For this, the ``number(from:)`` method of NumberFormatter is overridden and only the Unicode decimal digits and
/// decimal separators (period, comma and the arabic decimal separator) are kept and converted into a number.
///
/// As ``UnitFormatter`` is simply overriding ``NumberFormatter`` you may simply replace your use of
/// ``NumberFormatter`` by using ``UnitFormatter`` and setting the appropriate ``unit`` and
/// ``paddingString``. By default the ``paddingString``is set to a Unicode 'NO-BREAK SPACE'
/// (Unicode 0x00A0).
public class UnitFormatter: NumberFormatter {

    /// The string representing the Unit of the formatted value.
    public var unit: String?


    /// The string (character) used between the number string and the ``unit``.
    ///
    /// By default this is set to a Unicode 'NO-BREAK SPACE'.
    public var paddingString = "\u{00A0}"



    override public func string(for obj: Any?) -> String? {
        if let number = obj as? NSNumber {
            guard let numberString = super.string(for: number) else {
                return nil
            }
            if let unit {
                return numberString + paddingString + unit
            } else {
                return numberString
            }
        } else {
            return nil
        }
    }



    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if let result = number(fromFullString: string) {
            obj?.pointee = result
            return true
        } else {
            return false
        }
    }



    /// Converts the given String into a  NSNumber.
    ///
    /// If the process fails, `nil` is returned.
    private func number(fromFullString string: String) -> NSNumber? {
        let numberString = string.allButNumbersRemoved
        var returnValue: AnyObject?
        super.getObjectValue(&returnValue,
                             for: String(numberString),
                             errorDescription: nil)
        if let value = returnValue as? NSNumber {
            return value
        } else {
            return nil
        }
    }



    /// Copies the ``UnitFormatter``.
    ///
    /// This overrides the ``NumberFormatter``s `copy()` method to copy also the additional properties
    /// of ``UnitFormatter``.
    override public func copy() -> Any {
        let newObject = super.copy()
        if let newObject = newObject as? Self {
            newObject.unit = self.unit
            newObject.paddingString = self.paddingString
        }
        return newObject
    }
}
