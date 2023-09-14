import Foundation
struct Meals: Codable {
	let strMeal: String?
	let strMealThumb: String?
	let idMeal: String?

	enum CodingKeys: String, CodingKey {

		case strMeal = "strMeal"
		case strMealThumb = "strMealThumb"
		case idMeal = "idMeal"
	}
}
