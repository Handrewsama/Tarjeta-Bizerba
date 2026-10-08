import Foundation
import SwiftUI

struct ContactCard: Codable {
    var firstName = "Antonio"
    var lastName = "Mongay"
    var jobTitle = "Sales Representative"
    var company = "Bizerba Iberia España S.A.U"
    var phone = "+34 617 37 51 36"
    var workPhone = "+34 900 80 11 09"
    var email = "antonio.mongay@bizerba.com"
    var website = "https://www.bizerba.com"
    var address = "Calle Palaudàs, 461, 08019 Barcelona, Spain"

    var fullName: String { "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces) }
}

@MainActor
final class CardStore: ObservableObject {
    @Published var card: ContactCard {
        didSet { save() }
    }

    private let key = "digitalCard"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode(ContactCard.self, from: data) {
            card = saved
        } else {
            card = ContactCard()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(card) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func reset() {
        card = ContactCard()
    }
}
