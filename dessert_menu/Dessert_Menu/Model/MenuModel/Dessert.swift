import Foundation

struct Dessert: Codable {
	let meals: [Meals]?

	enum CodingKeys: String, CodingKey {
		case meals = "meals"
	}
}
