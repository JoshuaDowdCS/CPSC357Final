import SwiftUI

/// Required presentation card scene (does not count toward the 5 functional scenes).
struct PresentationCardView: View {
	@State private var pulse = false

	var body: some View {
		VStack(spacing: 18) {
			Text("TFT Trait Lock")
				.font(.largeTitle.weight(.bold))
				.scaleEffect(pulse ? 1.04 : 1.0)

			Text("Set 17 • Wordle for Champions")
				.font(.title3)
				.foregroundStyle(.secondary)

			VStack(alignment: .leading, spacing: 10) {
				PresentationLine(text: "Student: Joshua Dowd")
				PresentationLine(text: "Course: CPSC 357 • Spring 2026")
			}
			.frame(maxWidth: .infinity, alignment: .leading)

			RoundedRectangle(cornerRadius: 16)
				.fill(
					LinearGradient(
						colors: [.purple, .indigo, .blue],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
				.frame(height: 120)
				.overlay {
					Text("Guess • Compare • Learn")
						.font(.title2.weight(.semibold))
						.foregroundStyle(.white)
				}
				.shadow(color: .purple.opacity(pulse ? 0.5 : 0.2), radius: pulse ? 18 : 8)

			Spacer()
		}
		.padding()
		.onAppear {
			withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
				pulse = true
			}
		}
	}
}

struct PresentationLine: View {
	let text: String

	var body: some View {
		Text(text)
			.padding(.horizontal, 10)
			.padding(.vertical, 8)
			.background(Color.gray.opacity(0.15))
			.cornerRadius(8)
	}
}

#Preview {
	PresentationCardView()
}
