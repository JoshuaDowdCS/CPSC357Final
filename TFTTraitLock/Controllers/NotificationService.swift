import Foundation
import Observation
import UserNotifications

/// Advanced feature: local notifications reminding the player to complete the daily puzzle.
@Observable
@MainActor
final class NotificationService {
	private enum Storage {
		static let enabled = "dailyReminderEnabled"
		static let hour = "dailyReminderHour"
		static let minute = "dailyReminderMinute"
	}

	private enum Identifier {
		static let daily = "edu.cpsc357.traitlock.daily"
		static let test = "edu.cpsc357.traitlock.test"
	}

	var isDailyReminderEnabled: Bool {
		didSet {
			UserDefaults.standard.set(isDailyReminderEnabled, forKey: Storage.enabled)
			Task { await applyReminderPreference() }
		}
	}

	var reminderHour: Int {
		didSet {
			UserDefaults.standard.set(reminderHour, forKey: Storage.hour)
			Task { await rescheduleDailyReminderIfNeeded() }
		}
	}

	var reminderMinute: Int {
		didSet {
			UserDefaults.standard.set(reminderMinute, forKey: Storage.minute)
			Task { await rescheduleDailyReminderIfNeeded() }
		}
	}

	private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
	private(set) var statusMessage = "Notifications not configured yet."

	init() {
		let defaults = UserDefaults.standard
		isDailyReminderEnabled = defaults.bool(forKey: Storage.enabled)
		reminderHour = defaults.object(forKey: Storage.hour) as? Int ?? 18
		reminderMinute = defaults.object(forKey: Storage.minute) as? Int ?? 0
	}

	var reminderTime: Date {
		get {
			var components = DateComponents()
			components.hour = reminderHour
			components.minute = reminderMinute
			return Calendar.current.date(from: components) ?? .now
		}
		set {
			let parts = Calendar.current.dateComponents([.hour, .minute], from: newValue)
			reminderHour = parts.hour ?? 18
			reminderMinute = parts.minute ?? 0
		}
	}

	var authorizationLabel: String {
		switch authorizationStatus {
		case .authorized, .provisional, .ephemeral:
			"Allowed"
		case .denied:
			"Denied — enable in Settings app"
		case .notDetermined:
			"Not asked yet"
		@unknown default:
			"Unknown"
		}
	}

	func refreshAuthorizationStatus() async {
		let settings = await UNUserNotificationCenter.current().notificationSettings()
		authorizationStatus = settings.authorizationStatus
	}

	func restoreScheduledReminderIfNeeded() async {
		await refreshAuthorizationStatus()
		await applyReminderPreference()
	}

	func requestPermissionAndEnableReminder() async {
		do {
			let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
			await refreshAuthorizationStatus()
			if granted {
				isDailyReminderEnabled = true
				statusMessage = "Daily reminder scheduled for \(formattedReminderTime)."
			} else {
				isDailyReminderEnabled = false
				statusMessage = "Permission denied. Turn on notifications in Settings."
			}
		} catch {
			isDailyReminderEnabled = false
			statusMessage = "Could not request notification permission."
		}
	}

	func sendTestNotification() async {
		await refreshAuthorizationStatus()
		guard authorizationStatus == .authorized || authorizationStatus == .provisional else {
			statusMessage = "Allow notifications first."
			return
		}

		let content = UNMutableNotificationContent()
		content.title = "Trait Lock (Test)"
		content.body = "Notifications work. Today's Set 17 puzzle is waiting."
		content.sound = .default

		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
		let request = UNNotificationRequest(identifier: Identifier.test, content: content, trigger: trigger)

		do {
			try await UNUserNotificationCenter.current().add(request)
			statusMessage = "Test notification arrives in about 3 seconds."
		} catch {
			statusMessage = "Could not schedule test notification."
		}
	}

	private func applyReminderPreference() async {
		if isDailyReminderEnabled {
			if authorizationStatus == .notDetermined {
				await requestPermissionAndEnableReminder()
				return
			}
			await rescheduleDailyReminderIfNeeded()
		} else {
			cancelDailyReminder()
			statusMessage = "Daily reminder turned off."
		}
	}

	private func rescheduleDailyReminderIfNeeded() async {
		await refreshAuthorizationStatus()
		guard isDailyReminderEnabled else { return }
		guard authorizationStatus == .authorized || authorizationStatus == .provisional else {
			statusMessage = "Notifications are not allowed."
			return
		}

		cancelDailyReminder()

		var components = DateComponents()
		components.hour = reminderHour
		components.minute = reminderMinute

		let content = UNMutableNotificationContent()
		content.title = "Trait Lock Daily"
		content.body = "A new Set 17 champion puzzle is ready. Guess traits, cost, and range."
		content.sound = .default

		let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
		let request = UNNotificationRequest(identifier: Identifier.daily, content: content, trigger: trigger)

		do {
			try await UNUserNotificationCenter.current().add(request)
			statusMessage = "Daily reminder set for \(formattedReminderTime)."
		} catch {
			statusMessage = "Could not schedule daily reminder."
		}
	}

	private func cancelDailyReminder() {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Identifier.daily])
	}

	private var formattedReminderTime: String {
		var components = DateComponents()
		components.hour = reminderHour
		components.minute = reminderMinute
		guard let date = Calendar.current.date(from: components) else { return "—" }
		return date.formatted(date: .omitted, time: .shortened)
	}
}
