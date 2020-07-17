import ComposableArchitecture
import ComposableTuistArchitectureSupport
import Combine

public struct RecipeDetailState: Equatable {
    public init(
        recipe: Recipe,
        hasLoadedDetail: Bool = false,
        currentRating: Int = 0
    ) {
        self.recipe = recipe
        self.hasLoadedDetail = hasLoadedDetail
        self.currentRating = currentRating
    }
    
    var recipe: Recipe
    var hasLoadedDetail: Bool
    var currentRating: Int
}

public enum RecipeDetailAction: Equatable {
    case loadDetail
    case recipeDetail(Result<Recipe, CookbookClient.Failure>)
    case changedRating(Int)
}

public struct RecipeDetailEnvironment {
    public init(
        cookbookClient: CookbookClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.cookbookClient = cookbookClient
        self.mainQueue = mainQueue
    }
    
    let cookbookClient: CookbookClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

public let recipeDetailReducer = Reducer<RecipeDetailState, RecipeDetailAction, RecipeDetailEnvironment> { state, action, environment in
    switch action {
    case .loadDetail:
        guard !state.hasLoadedDetail else { return .none }
        state.hasLoadedDetail = true
        
        return environment.cookbookClient
            .recipeDetail(state.recipe.id)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(RecipeDetailAction.recipeDetail)
    case let .recipeDetail(.success(recipe)):
        state.recipe = recipe
        return .none
    case .recipeDetail(.failure):
        // Handle error
        return .none
    case let .changedRating(rating):
        state.currentRating = rating
        
        return environment.cookbookClient
            .rateRecipe(state.recipe.id, rating)
            .map { _ in }
            .catch { _ in Empty<Void, Never>() }
            .ignoreOutput()
            .eraseToEffect()
            .fireAndForget()
    }
}
