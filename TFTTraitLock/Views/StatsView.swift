import SwiftUI
import SwiftData

struct StatsView: View {
	@Query(sort: \GameRecord.playedAt, order: .reverse) private var records: [GameRecord]

	private var wins: Int { records.filter(\.didWin).count }
	private var losses: Int { records.count - wins }

	private var winRate: Double {
		guard !records.isEmpty else { return 0 }
		return Double(wins) / Double(records.count)
	}

	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 16) {
				Text("SwiftData Stats")
					.font(.title2.weight(.bold))

				StatCard(title: "Games Played", value: "\(records.count)")
				StatCard(title: "Wins", value: "\(wins)")
				StatCard(title: "Losses", value: "\(losses)")
				StatCard(title: "Win Rate", value: String(format: "%.0f%%", winRate * 100))

				if let best = records.filter(\.didWin).min(by: { $0.guessCount < $1.guessCount }) {
					Text("Best solve: \(best.targetChampionName) in \(best.guessCount) guesses")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}

				Spacer()
			}
			.padding()
			.navigationTitle("Stats")
		}
	}
}

struct StatCard: View {
	let title: String
	let value: String

	var body: some View {
		HStack {
			Text(title)
			Spacer()
			Text(value)
				.font(.title3.weight(.semibold))
		}
		.padding()
		.background(Color.gray.opacity(0.12))
		.cornerRadius(10)
	}
}
