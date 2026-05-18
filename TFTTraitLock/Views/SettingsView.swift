import SwiftUI

struct SettingsView: View {
	@Bindable var game: GameController
	@Bindable var notifications: NotificationService

	var body: some View {
		NavigationStack {
			Form {
				Section("Player Input") {
					TextField("Player name", text: $game.playerName)
						.textInputAutocapitalization(.words)

					Picker("Mode", selection: $game.mode) {
						ForEach(GameMode.allCases) { mode in
							Text(mode.rawValue).tag(mode)
						}
					}

					Stepper("Max guesses: \(game.maxGuesses)", value: $game.maxGuesses, in: 4 ... 8)

					Button("Apply settings and start new round") {
						game.startNewRound()
					}
				}

				Section("Daily Reminder (Advanced)") {
					Toggle("Notify me for today's puzzle", isOn: $notifications.isDailyReminderEnabled)

					DatePicker(
						"Reminder time",
						selection: $notifications.reminderTime,
						displayedComponents: .hourAndMinute
					)
					.disabled(!notifications.isDailyReminderEnabled)

					Text("Permission: \(notifications.authorizationLabel)")
						.font(.caption)
						.foregroundStyle(.secondary)

					Text(notifications.statusMessage)
						.font(.caption)
						.foregroundStyle(.secondary)

					Button("Allow notifications") {
						Task { await notifications.requestPermissionAndEnableReminder() }
					}

					Button("Send test notification (3 sec)") {
						Task { await notifications.sendTestNotification() }
					}
				}
			}
			.navigationTitle("Settings")
		}
	}
}
