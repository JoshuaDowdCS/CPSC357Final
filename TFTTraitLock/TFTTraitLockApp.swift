import SwiftUI
import SwiftData

@main
struct TFTTraitLockApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(for: GameRecord.self)
	}
}
