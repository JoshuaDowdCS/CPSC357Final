import Foundation

enum ComparisonMark: String, Codable {
	case correct
	case partial
	case higher
	case lower
	case miss

	var label: String {
		switch self {
		case .correct: "✓"
		case .partial: "◐"
		case .higher: "↑"
		case .lower: "↓"
		case .miss: "✗"
		}
	}
}

/// Feedback for one submitted guess against the hidden champion.
struct GuessFeedback: Identifiable, Codable {
	var id: String { guess.name }
	let guess: Champion
	let isCorrectChampion: Bool
	let traitMark: ComparisonMark
	let matchedTraits: [String]
	let costMark: ComparisonMark
	let rangeMark: ComparisonMark
	let traitSummary: String
}

enum GuessEvaluator {
	static func evaluate(guess: Champion, target: Champion) -> GuessFeedback {
		let matchedTraits = guess.traits
			.filter { target.traits.contains($0) }
			.sorted()

		let traitMark: ComparisonMark
		if matchedTraits.count == target.traits.count && matchedTraits.count == guess.traits.count {
			traitMark = .correct
		} else if matchedTraits.isEmpty {
			traitMark = .miss
		} else {
			traitMark = .partial
		}

		let costMark = mark(actual: guess.cost, target: target.cost)
		let rangeMark = mark(actual: guess.range, target: target.range)

		let traitSummary: String
		if matchedTraits.isEmpty {
			traitSummary = "No match"
		} else {
			traitSummary = matchedTraits.joined(separator: ", ")
		}

		return GuessFeedback(
			guess: guess,
			isCorrectChampion: guess.name == target.name,
			traitMark: traitMark,
			matchedTraits: matchedTraits,
			costMark: costMark,
			rangeMark: rangeMark,
			traitSummary: traitSummary
		)
	}

	/// Arrows point toward the hidden value (Wordle-style), not the guess direction.
	private static func mark(actual: Int, target: Int) -> ComparisonMark {
		if actual == target { return .correct }
		if actual > target { return .lower }
		return .higher
	}
}
