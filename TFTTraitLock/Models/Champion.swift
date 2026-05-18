import Foundation

/// One playable Set 17 unit used by the guess engine and champion grid.
struct Champion: Identifiable, Hashable, Codable {
	var id: String { name }
	let name: String
	let traits: [String]
	let cost: Int
	/// Attack range in hexes (Set 17).
	let range: Int
}

enum ChampionCatalog {
	/// Set 17 roster: traits/costs from assignment sheet; ranges from Set 17 game data.
	static let all: [Champion] = [
		Champion(name: "Aatrox", traits: ["N.O.V.A.", "Bastion"], cost: 2, range: 1),
		Champion(name: "Akali", traits: ["N.O.V.A.", "Marauder"], cost: 4, range: 1),
		Champion(name: "Aurelion Sol", traits: ["Mecha", "Conduit"], cost: 3, range: 6),
		Champion(name: "Aurora", traits: ["Anima", "Voyager"], cost: 5, range: 4),
		Champion(name: "Bard", traits: ["Meeple", "Conduit"], cost: 2, range: 4),
		Champion(name: "Bel'Veth", traits: ["Primordian", "Challenger", "Marauder"], cost: 2, range: 2),
		Champion(name: "Blitzcrank", traits: ["Party Animal", "Space Groove", "Vanguard"], cost: 5, range: 1),
		Champion(name: "Briar", traits: ["Anima", "Primordian", "Rogue"], cost: 1, range: 1),
		Champion(name: "Caitlyn", traits: ["N.O.V.A.", "Fateweaver"], cost: 1, range: 4),
		Champion(name: "Cho'Gath", traits: ["Dark Star", "Brawler"], cost: 4, range: 1),
		Champion(name: "Corki", traits: ["Meeple", "Fateweaver"], cost: 3, range: 4),
		Champion(name: "Diana", traits: ["Arbiter", "Challenger"], cost: 3, range: 1),
		Champion(name: "Ezreal", traits: ["Timebreaker", "Sniper"], cost: 5, range: 6),
		Champion(name: "Fiora", traits: ["Divine Duelist", "Anima", "Marauder"], cost: 3, range: 1),
		Champion(name: "Fizz", traits: ["Meeple", "Rogue"], cost: 2, range: 1),
		Champion(name: "Gnar", traits: ["Meeple", "Sniper"], cost: 2, range: 6),
		Champion(name: "Gragas", traits: ["Psionic", "Brawler"], cost: 5, range: 1),
		Champion(name: "Graves", traits: ["Factory New"], cost: 2, range: 4),
		Champion(name: "Gwen", traits: ["Space Groove", "Rogue"], cost: 3, range: 2),
		Champion(name: "Illaoi", traits: ["Anima", "Vanguard", "Shepherd"], cost: 2, range: 1),
		Champion(name: "Jax", traits: ["Stargazer", "Bastion"], cost: 5, range: 1),
		Champion(name: "Jhin", traits: ["Dark Star", "Eradicator", "Sniper"], cost: 2, range: 6),
		Champion(name: "Jinx", traits: ["Anima", "Challenger"], cost: 3, range: 4),
		Champion(name: "Kai'Sa", traits: ["Dark Star", "Rogue"], cost: 4, range: 4),
		Champion(name: "Karma", traits: ["Dark Star", "Voyager"], cost: 4, range: 4),
		Champion(name: "Kindred", traits: ["N.O.V.A.", "Challenger"], cost: 4, range: 6),
		Champion(name: "LeBlanc", traits: ["Arbiter", "Shepherd"], cost: 4, range: 4),
		Champion(name: "Leona", traits: ["Arbiter", "Vanguard"], cost: 1, range: 1),
		Champion(name: "Lissandra", traits: ["Dark Star", "Shepherd", "Replicator"], cost: 3, range: 4),
		Champion(name: "Lulu", traits: ["Stargazer", "Replicator"], cost: 3, range: 4),
		Champion(name: "Maokai", traits: ["N.O.V.A.", "Brawler"], cost: 4, range: 1),
		Champion(name: "Master Yi", traits: ["Psionic", "Marauder"], cost: 2, range: 1),
		Champion(name: "Meepsie", traits: ["Meeple", "Shepherd", "Voyager"], cost: 2, range: 1),
		Champion(name: "Milio", traits: ["Timebreaker", "Fateweaver"], cost: 3, range: 4),
		Champion(name: "Miss Fortune", traits: ["Gun Goddess"], cost: 2, range: 6),
		Champion(name: "Mordekaiser", traits: ["Dark Star", "Conduit", "Vanguard"], cost: 4, range: 1),
		Champion(name: "Morgana", traits: ["Dark Lady"], cost: 4, range: 2),
		Champion(name: "Nami", traits: ["Space Groove", "Replicator"], cost: 4, range: 4),
		Champion(name: "Nasus", traits: ["Space Groove", "Vanguard"], cost: 4, range: 1),
		Champion(name: "Nunu", traits: ["Stargazer", "Vanguard"], cost: 3, range: 1),
		Champion(name: "Ornn", traits: ["Space Groove", "Bastion"], cost: 2, range: 1),
		Champion(name: "Pantheon", traits: ["Timebreaker", "Brawler", "Replicator"], cost: 3, range: 1),
		Champion(name: "Poppy", traits: ["Meeple", "Bastion"], cost: 2, range: 1),
		Champion(name: "Pyke", traits: ["Psionic", "Voyager"], cost: 4, range: 1),
		Champion(name: "Rammus", traits: ["Meeple", "Bastion"], cost: 4, range: 1),
		Champion(name: "Rek'Sai", traits: ["Primordian", "Brawler"], cost: 3, range: 1),
		Champion(name: "Rhaast", traits: ["Redeemer"], cost: 4, range: 1),
		Champion(name: "Riven", traits: ["Timebreaker", "Rogue"], cost: 3, range: 1),
		Champion(name: "Samira", traits: ["Space Groove", "Sniper"], cost: 5, range: 6),
		Champion(name: "Shen", traits: ["Bulwark", "Bastion"], cost: 5, range: 1),
		Champion(name: "Sona", traits: ["Commander", "Psionic", "Shepherd"], cost: 4, range: 4),
		Champion(name: "Tahm Kench", traits: ["Oracle", "Brawler"], cost: 4, range: 1),
		Champion(name: "Talon", traits: ["Stargazer", "Rogue"], cost: 1, range: 1),
		Champion(name: "Teemo", traits: ["Space Groove", "Shepherd"], cost: 4, range: 4),
		Champion(name: "The Mighty Mech", traits: ["Mecha", "Voyager"], cost: 4, range: 1),
		Champion(name: "Twisted Fate", traits: ["Stargazer", "Fateweaver"], cost: 3, range: 4),
		Champion(name: "Urgot", traits: ["Mecha", "Brawler", "Marauder"], cost: 3, range: 2),
		Champion(name: "Veigar", traits: ["Meeple", "Replicator"], cost: 5, range: 4),
		Champion(name: "Vex", traits: ["Doomer"], cost: 3, range: 6),
		Champion(name: "Viktor", traits: ["Psionic", "Conduit"], cost: 4, range: 4),
		Champion(name: "Xayah", traits: ["Stargazer", "Sniper"], cost: 5, range: 6),
		Champion(name: "Zed", traits: ["Galaxy Hunter"], cost: 2, range: 1),
		Champion(name: "Zoe", traits: ["Arbiter", "Conduit"], cost: 2, range: 4),
	]

	static func champion(named name: String) -> Champion? {
		all.first { $0.name.compare(name, options: .caseInsensitive) == .orderedSame }
	}

	static func sortedByName() -> [Champion] {
		all.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
	}
}
