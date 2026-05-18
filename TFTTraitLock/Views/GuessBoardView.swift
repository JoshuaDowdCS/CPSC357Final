import SwiftUI

struct GuessBoardView: View {
	let rows: [GuessFeedback]

	var body: some View {
		ScrollView {
			VStack(spacing: 10) {
				ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
					GuessRowView(feedback: row)
						.transition(.asymmetric(
							insertion: .scale(scale: 0.85).combined(with: .opacity),
							removal: .opacity
						))
						.animation(
							.spring(response: 0.55, dampingFraction: 0.78)
								.delay(Double(index) * 0.04),
							value: rows.count
						)
				}

				ForEach(0 ..< max(0, 6 - rows.count), id: \.self) { _ in
					EmptyGuessRowView()
				}
			}
		}
		.frame(maxHeight: 300)
	}
}

struct GuessRowView: View {
	let feedback: GuessFeedback
	@State private var flipped = false

	var body: some View {
		HStack(spacing: 8) {
			Text(feedback.guess.name)
				.font(.subheadline.weight(.semibold))
				.lineLimit(1)
				.minimumScaleFactor(0.7)
				.frame(maxWidth: .infinity, alignment: .leading)

			FeedbackTile(
				title: "Trait",
				mark: feedback.traitMark,
				subtitle: feedback.traitSummary,
				width: 108,
				lineLimit: 3
			)
			FeedbackTile(title: "Cost", mark: feedback.costMark, subtitle: "\(feedback.guess.cost)")
			FeedbackTile(title: "Range", mark: feedback.rangeMark, subtitle: "\(feedback.guess.range)")
		}
		.padding(10)
		.background(feedback.isCorrectChampion ? Color.green.opacity(0.2) : Color.gray.opacity(0.12))
		.cornerRadius(10)
		.rotation3DEffect(.degrees(flipped ? 0 : 88), axis: (x: 1, y: 0, z: 0))
		.opacity(flipped ? 1 : 0.2)
		.onAppear {
			withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
				flipped = true
			}
		}
	}
}

struct EmptyGuessRowView: View {
	var body: some View {
		HStack(spacing: 8) {
			RoundedRectangle(cornerRadius: 6)
				.fill(Color.gray.opacity(0.12))
				.frame(height: 44)
		}
	}
}

struct FeedbackTile: View {
	let title: String
	let mark: ComparisonMark
	let subtitle: String
	var width: CGFloat = 72
	var lineLimit: Int = 1

	var body: some View {
		VStack(spacing: 2) {
			Text(title)
				.font(.caption2)
			Text(mark.label)
				.font(.headline)
			Text(subtitle)
				.font(.caption2)
				.multilineTextAlignment(.center)
				.lineLimit(lineLimit)
				.minimumScaleFactor(0.75)
		}
		.frame(width: width)
		.frame(minHeight: 56)
		.background(tileColor.opacity(0.25))
		.cornerRadius(8)
	}

	private var tileColor: Color {
		switch mark {
		case .correct: .green
		case .partial: .yellow
		case .higher, .lower: .orange
		case .miss: .gray
		}
	}
}
