import SwiftUI
import SwiftData

struct ContentView: View {
	@State private var game = GameController()
	@State private var notifications = NotificationService()

	var body: some View {
		TabView {
			PlayView(game: game)
				.tabItem {
					Label("Play", systemImage: "gamecontroller")
				}

			CompendiumView()
				.tabItem {
					Label("Units", systemImage: "square.grid.3x3")
				}

			StatsView()
				.tabItem {
					Label("Stats", systemImage: "chart.bar")
				}

			HistoryView()
				.tabItem {
					Label("History", systemImage: "clock")
				}

			SettingsView(game: game, notifications: notifications)
				.tabItem {
					Label("Settings", systemImage: "slider.horizontal.3")
				}

			
		}
		.task {
			await notifications.restoreScheduledReminderIfNeeded()
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: GameRecord.self, inMemory: true)
}
