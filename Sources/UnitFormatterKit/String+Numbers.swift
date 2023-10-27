import Foundation

extension String {
    /// A ``String`` in which all characters but the numerical characters are removed.
    ///
    /// Only the negative sign, the decimal points (including the dot, the comma and the arabic decimal separator) and the
    /// decimal digits (according to the Unicode standard) are removed.
    internal var allButNumbersRemoved: String {
        let numberCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-.,\u{066b}"))
        return String(self.compactMap {ch in
            let charset = CharacterSet(charactersIn: String(ch))
            if charset.isSubset(of: numberCharacters) {
                return ch
            } else {
                return nil
            }
        })
    }
}
