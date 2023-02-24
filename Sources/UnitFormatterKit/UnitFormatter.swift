import Foundation

/// A NumberFormatter, which is better at handling units as the original.
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



    override public func string(for obj: Any?) -> String {
        if let number = obj as? NSNumber {
            return string(from: number) ?? ""
        } else {
            return ""
        }
    }



    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = number(from: string)
        return true
    }

    

    override public func string(from number: NSNumber) -> String? {
        guard let numberString = super.string(from: number) else {
            return nil
        }
        if let unit {
            return numberString + paddingString + unit
        } else {
            return numberString
        }
    }



    override public func number(from string: String) -> NSNumber? {
        let numberCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,\u{066b}"))
        let numberString = string.compactMap { ch in
            let charset = CharacterSet(charactersIn: String(ch))
            if charset.isSubset(of: numberCharacters) {
                return ch
            } else {
                return nil
            }
        }
        return super.number(from: String(numberString))
    }
}
