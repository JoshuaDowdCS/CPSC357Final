import Foundation
import Observation
import SwiftData

enum GameMode: String, CaseIterable, Identifiable {
	case daily = "Daily"
	case practice = "Practice"

	var id: String { rawValue }
}

/// Central rules/state for a single TFT Wordle round.
@Observable
@MainActor
final class GameController {
	var mode: GameMode = .daily
	var maxGuesses: Int = 6
	var playerName: String = "Joshua Dowd"

	private(set) var target: Champion
	private(set) var feedbackRows: [GuessFeedback] = []
	private(set) var isFinished = false
	private(set) var didWin = false

	var guessesRemaining: Int {
		max(0, maxGuesses - feedbackRows.count)
	}

	var canSubmitGuess: Bool {
		!isFinished && feedbackRows.count < maxGuesses
	}

	init(seedDate: Date = .now) {
		target = GameController.dailyChampion(for: seedDate)
	}

	func startNewRound(seedDate: Date = .now) {
		target = mode == .daily ? GameController.dailyChampion(for: seedDate) : GameController.randomChampion()
		feedbackRows = []
		isFinished = false
		didWin = false
	}

	func submitGuess(_ champion: Champion) {
		guard canSubmitGuess else { return }
		let feedback = GuessEvaluator.evaluate(guess: champion, target: target)
		feedbackRows.append(feedback)

		if feedback.isCorrectChampion {
			isFinished = true
			didWin = true
		} else if feedbackRows.count >= maxGuesses {
			isFinished = true
			didWin = false
		}
	}

	func persistRound(using context: ModelContext) {
		guard isFinished else { return }
		let record = GameRecord(
			targetChampionName: target.name,
			guessNames: feedbackRows.map(\.guess.name),
			didWin: didWin,
			guessCount: feedbackRows.count,
			gameMode: mode.rawValue,
			playerName: playerName
		)
		context.insert(record)
		try? context.save()
	}

	static func dailyChampion(for date: Date) -> Champion {
		let catalog = ChampionCatalog.all
		let dayKey = Calendar.current.startOfDay(for: date).timeIntervalSince1970
		let index = Int(dayKey) % catalog.count
		return catalog[index]
	}

	static func randomChampion() -> Champion {
		ChampionCatalog.all.randomElement() ?? ChampionCatalog.all[0]
	}
}
