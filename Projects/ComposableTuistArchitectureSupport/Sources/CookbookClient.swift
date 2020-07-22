import Foundation
import Combine
import ComposableArchitecture

public struct Recipe: Codable, Identifiable, Equatable {
    public init(
        id: String,
        name: String,
        description: String,
        ingredients: [String],
        duration: Int,
        score: Double,
        info: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.score = score
        self.info = info
    }
    
    public let id: String
    public let name: String
    public let description: String
    public let ingredients: [String]
    public let duration: Int
    public let score: Double
    public let info: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        ingredients = try container.decodeIfPresent([String].self, forKey: .ingredients) ?? []
        duration = try container.decode(Int.self, forKey: .duration)
        score = try container.decode(Double.self, forKey: .score)
        info = try container.decodeIfPresent(String.self, forKey: .info) ?? ""
    }
}

public extension Recipe {
    static func mock(
        id: String = "",
        name: String = "",
        description: String = "",
        ingredients: [String] = [],
        duration: Int = 0,
        score: Double = 0,
        info: String = ""
    ) -> Recipe {
        .init(
            id: id,
            name: name,
            description: description,
            ingredients: ingredients,
            duration: duration,
            score: score,
            info: info
        )
    }
}

public struct Rating: Identifiable, Equatable, Codable {
    public let score: Int
    public let recipe: Recipe.ID
    public let id: String
    
    public init(
        score: Int,
        recipe: Recipe.ID,
        id: Rating.ID
    ) {
        self.score = score
        self.recipe = recipe
        self.id = id
    }
}

public extension Rating {
    static func mock(
        score: Int = 2,
        recipe: Recipe.ID = "",
        id: Rating.ID = ""
    ) -> Rating {
        .init(
            score: score,
            recipe: recipe,
            id: id
        )
    }
}

public struct CookbookClient {
    public let recipes: () -> Effect<[Recipe], Failure>
    public let addRecipe: (Recipe) -> Effect<Recipe, Failure>
    public let deleteRecipe: (Recipe) -> Effect<Void, Failure>
    public let rateRecipe: (Recipe.ID, Int) -> Effect<Rating, Failure>
    
    public struct Failure: Error, Equatable {}
}

public extension CookbookClient {
    static let live = CookbookClient(
        recipes: {
            let url = URL(string: "https://cookbook.ack.ee/api/v1/recipes")!
            let jsonDecoder = JSONDecoder()
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .decode(type: [Recipe].self, decoder: jsonDecoder)
                .mapError { error in Failure() }
                .eraseToEffect()
        },
        addRecipe: { recipe in
            let url = URL(string: "https://cookbook.ack.ee/api/v1/recipes")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let jsonEncoder = JSONEncoder()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! jsonEncoder.encode(recipe)
            
            let jsonDecoder = JSONDecoder()
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { data, error in data }
                .decode(type: Recipe.self, decoder: jsonDecoder)
                .mapError { error in Failure() }
                .eraseToEffect()
        },
        deleteRecipe: { recipe in
            let url = URL(string: "https://cookbook.ack.ee/api/v1/recipes/\(recipe.id)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { data, error in }
                .mapError { error in Failure() }
                .eraseToEffect()
        },
        rateRecipe: { recipeID, rating in
            let url = URL(string: "https://cookbook.ack.ee/api/v1/recipes/\(recipeID)/rating")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            struct PostRating: Codable {
                let rating: Int
            }
            
            let jsonEncoder = JSONEncoder()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! jsonEncoder.encode(PostRating(rating: rating))
            
            let jsonDecoder = JSONDecoder()
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { data, error in data }
                .decode(type: Rating.self, decoder: jsonDecoder)
                .mapError { error in Failure() }
                .eraseToEffect()
        }
    )
}

// MARK: - Mock

public extension CookbookClient {
    static func mock(
        recipes: @escaping () -> Effect<[Recipe], Failure> = {
            Effect(value: [])
        },
        addRecipe: @escaping (Recipe) -> Effect<Recipe, Failure> = {
            Effect(
                value: $0
            )
        },
        deleteRecipe: @escaping (Recipe) -> Effect<Void, Failure> = { _ in
            Effect(value: ())
        },
        rateRecipe: @escaping (Recipe.ID, Int) -> Effect<Rating, Failure> = { recipeID, rating in
            Effect(value: Rating.mock(score: rating, recipe: recipeID))
        }
    ) -> Self {
        Self(
            recipes: recipes,
            addRecipe: addRecipe,
            deleteRecipe: deleteRecipe,
            rateRecipe: rateRecipe
        )
    }
}
