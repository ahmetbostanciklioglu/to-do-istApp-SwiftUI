import SwiftUI
import SwiftData

@main
struct ToDolistApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Item.self])
    }
}



