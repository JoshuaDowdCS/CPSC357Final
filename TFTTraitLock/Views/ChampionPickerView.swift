import SwiftUI

/// All Set 17 units pinned to the bottom of the play screen.
struct ChampionPickerView: View {
	let champions: [Champion]
	@Binding var selectedChampion: Champion?
	let isDisabled: Bool
	let onSubmit: () -> Void

	private let columns = [GridItem(.adaptive(minimum: 92), spacing: 8)]

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text("All Units")
					.font(.headline)
				Spacer()
				Button("Lock In Guess", action: onSubmit)
					.buttonStyle(.borderedProminent)
					.disabled(isDisabled || selectedChampion == nil)
			}

			ScrollView {
				LazyVGrid(columns: columns, spacing: 8) {
					ForEach(champions) { champion in
						ChampionChipView(
							champion: champion,
							isSelected: selectedChampion?.name == champion.name
						)
						.onTapGesture {
							guard !isDisabled else { return }
							withAnimation(.easeInOut(duration: 0.2)) {
								selectedChampion = champion
							}
						}
					}
				}
			}
		}
		.frame(maxHeight: 320)
	}
}

struct ChampionChipView: View {
	let champion: Champion
	let isSelected: Bool

	var body: some View {
		VStack(spacing: 4) {
			Text(champion.name)
				.font(.caption.weight(.semibold))
				.multilineTextAlignment(.center)
				.lineLimit(2)
				.minimumScaleFactor(0.8)

			Text("\(champion.cost)•R\(champion.range)")
				.font(.caption2)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, minHeight: 54)
		.padding(6)
		.background(isSelected ? Color.purple.opacity(0.35) : Color.gray.opacity(0.12))
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
		)
		.cornerRadius(8)
	}
}
