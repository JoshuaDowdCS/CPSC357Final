import SwiftUI
import SwiftData

struct PlayView: View {
	@Bindable var game: GameController
	@Environment(\.modelContext) private var modelContext
	@State private var selectedChampion: Champion?
	@State private var showPresentationCard = false
	@State private var revealHint = false
	@State private var didPersistRound = false

	var body: some View {
		NavigationStack {
			VStack(spacing: 12) {
				header

				GuessBoardView(rows: game.feedbackRows)

				if game.isFinished {
					resultBanner
				}

				ChampionPickerView(
					champions: ChampionCatalog.sortedByName(),
					selectedChampion: $selectedChampion,
					isDisabled: !game.canSubmitGuess,
					onSubmit: submitSelectedGuess
				)
			}
			.padding(.horizontal)
			.navigationTitle("Trait Lock")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Info") { showPresentationCard = true }
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button("New") {
						withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
							game.startNewRound()
							selectedChampion = nil
							revealHint = false
							didPersistRound = false
						}
					}
				}
			}
			.sheet(isPresented: $showPresentationCard) {
				PresentationCardView()
			}
			.gesture(
				DragGesture(minimumDistance: 40)
					.onEnded { value in
						if value.translation.height < -60 {
							withAnimation(.easeInOut(duration: 0.35)) {
								revealHint.toggle()
							}
						}
					}
			)
		}
	}

	private var header: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text("\(game.mode.rawValue) • \(game.guessesRemaining) guesses left")
				.font(.subheadline)
				.foregroundStyle(.secondary)

			if revealHint {
				Text("Hint: target costs \(game.target.cost) gold and has range \(game.target.range).")
					.font(.caption)
					.padding(8)
					.background(Color.orange.opacity(0.15))
					.cornerRadius(8)
					.transition(.move(edge: .top).combined(with: .opacity))
			} else {
				Text("Swipe up on the board to reveal a cost/range hint.")
					.font(.caption)
					.foregroundStyle(.secondary)
			}

			HStack(spacing: 8) {
				FeedbackLegendPill(title: "Trait (names shown)", color: .yellow)
				FeedbackLegendPill(title: "Cost", color: .green)
				FeedbackLegendPill(title: "Range", color: .blue)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}

	private var resultBanner: some View {
		VStack(spacing: 8) {
			Text(game.didWin ? "Board solved!" : "Out of guesses")
				.font(.headline)
				.foregroundStyle(game.didWin ? .green : .red)

			Text("Answer: \(game.target.name)")
				.font(.subheadline)

			if !didPersistRound {
				Button("Save result") {
					game.persistRound(using: modelContext)
					didPersistRound = true
				}
				.buttonStyle(.borderedProminent)
			} else {
				Text("Saved to SwiftData")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
		.padding()
		.background(Color.gray.opacity(0.12))
		.cornerRadius(12)
	}

	private func submitSelectedGuess() {
		guard let champion = selectedChampion else { return }
		withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
			game.submitGuess(champion)
		}
		selectedChampion = nil
	}
}

struct FeedbackLegendPill: View {
	let title: String
	let color: Color

	var body: some View {
		Text(title)
			.font(.caption.weight(.semibold))
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.background(color.opacity(0.2))
			.cornerRadius(8)
	}
}
