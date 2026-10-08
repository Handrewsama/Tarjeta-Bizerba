import Foundation

extension ContactCard {
    var vCard: String {
        func esc(_ value: String) -> String {
            value.replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: ";", with: "\\;")
                .replacingOccurrences(of: ",", with: "\\,")
                .replacingOccurrences(of: "\n", with: "\\n")
        }

        return """
BEGIN:VCARD
VERSION:3.0
N:\(esc(lastName));\(esc(firstName));;;
FN:\(esc(fullName))
ORG:\(esc(company))
TITLE:\(esc(jobTitle))
TEL;TYPE=CELL:\(esc(phone))
TEL;TYPE=WORK:\(esc(workPhone))
EMAIL;TYPE=INTERNET:\(esc(email))
URL:\(esc(website))
ADR;TYPE=WORK:;;\(esc(address))
END:VCARD
"""
    }
}
