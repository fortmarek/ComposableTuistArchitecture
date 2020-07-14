import Foundation
import Combine
import ComposableArchitecture

public struct Recipe: Codable, Identifiable, Equatable {
    public init(
        id: String,
        name: String,
        duration: Int,
        score: Int
    ) {
        self.id = id
        self.name = name
        self.duration = duration
        self.score = score
    }
    
    public let id: String
    public let name: String
    public let duration: Int
    public let score: Int
}

public struct CookbookClient {
    public let recipes: () -> Effect<[Recipe], Failure>
    
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
                .mapError { _ in Failure() }
                .eraseToEffect()
        }
    )
}

// MARK: - Mock

public extension CookbookClient {
  static func mock(
    recipes: @escaping () -> Effect<[Recipe], Failure> = {
        Effect(value: [])
    }
  ) -> Self {
    Self(
      recipes: recipes
    )
  }
}
