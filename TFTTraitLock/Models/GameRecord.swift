import Foundation
import SwiftData

/// Persisted result for stats/history screens.
@Model
final class GameRecord {
	var id: UUID
	var playedAt: Date
	var targetChampionName: String
	var guessNames: String
	var didWin: Bool
	var guessCount: Int
	var gameMode: String
	var playerName: String

	init(
		targetChampionName: String,
		guessNames: [String],
		didWin: Bool,
		guessCount: Int,
		gameMode: String,
		playerName: String
	) {
		self.id = UUID()
		self.playedAt = .now
		self.targetChampionName = targetChampionName
		self.guessNames = guessNames.joined(separator: "|")
		self.didWin = didWin
		self.guessCount = guessCount
		self.gameMode = gameMode
		self.playerName = playerName
	}

	var guesses: [String] {
		guessNames.split(separator: "|").map(String.init)
	}
}
