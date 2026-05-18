import SwiftUI
import SwiftData

struct HistoryView: View {
	@Query(sort: \GameRecord.playedAt, order: .reverse) private var records: [GameRecord]
	@Environment(\.modelContext) private var modelContext

	var body: some View {
		NavigationStack {
			Group {
				if records.isEmpty {
					ContentUnavailableView(
						"No games yet",
						systemImage: "clock",
						description: Text("Finish a round on the Play tab and save the result.")
					)
				} else {
					List {
						ForEach(records) { record in
							VStack(alignment: .leading, spacing: 4) {
								HStack {
									Text(record.targetChampionName)
										.font(.headline)
									Spacer()
									Text(record.didWin ? "Win" : "Loss")
										.foregroundStyle(record.didWin ? .green : .red)
								}
								Text("\(record.gameMode) • \(record.guessCount) guesses • \(record.playerName)")
									.font(.caption)
									.foregroundStyle(.secondary)
								Text(record.guesses.joined(separator: ", "))
									.font(.caption2)
									.lineLimit(2)
							}
						}
						.onDelete(perform: deleteRecords)
					}
				}
			}
			.navigationTitle("History")
		}
	}

	private func deleteRecords(at offsets: IndexSet) {
		for index in offsets {
			modelContext.delete(records[index])
		}
		try? modelContext.save()
	}
}
