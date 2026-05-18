import SwiftUI

struct CompendiumView: View {
	@State private var searchText = ""
	@State private var selectedChampion: Champion?

	private var filteredChampions: [Champion] {
		let sorted = ChampionCatalog.sortedByName()
		guard !searchText.isEmpty else { return sorted }
		return sorted.filter {
			$0.name.localizedCaseInsensitiveContains(searchText)
				|| $0.traits.contains { $0.localizedCaseInsensitiveContains(searchText) }
		}
	}

	var body: some View {
		NavigationStack {
			List(filteredChampions) { champion in
				Button {
					selectedChampion = champion
				} label: {
					VStack(alignment: .leading, spacing: 4) {
						Text(champion.name)
							.font(.headline)
						Text(champion.traits.joined(separator: " • "))
							.font(.caption)
							.foregroundStyle(.secondary)
						Text("Cost \(champion.cost) • Range \(champion.range)")
							.font(.caption2)
					}
				}
			}
			.navigationTitle("Set 17 Compendium")
			.searchable(text: $searchText, prompt: "Search champion or trait")
			.sheet(item: $selectedChampion) { champion in
				ChampionDetailView(champion: champion)
			}
		}
	}
}

struct ChampionDetailView: View {
	let champion: Champion
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 16) {
				Text(champion.name)
					.font(.largeTitle.weight(.bold))

				Group {
					Text("Traits")
						.font(.headline)
					ForEach(champion.traits, id: \.self) { trait in
						Text("• \(trait)")
					}

					Text("Cost: \(champion.cost) gold")
					Text("Attack range: \(champion.range)")
				}

				Spacer()
			}
			.padding()
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Done") { dismiss() }
				}
			}
		}
	}
}
