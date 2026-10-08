import SwiftUI

@main
struct BizerbaDigitalCardApp: App {
    @StateObject private var store = CardStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
