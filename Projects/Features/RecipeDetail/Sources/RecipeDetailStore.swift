import ComposableArchitecture
import ComposableTuistArchitectureSupport

public struct RecipeDetailState: Equatable {
    public init(
        recipe: Recipe
    ) {
        self.recipe = recipe
    }
    
    var recipe: Recipe
}

public enum RecipeDetailAction: Equatable {
    case loadDetail
}

public struct RecipeDetailEnvironment {
    public init() {
        
    }
}

public let recipeDetailReducer = Reducer<RecipeDetailState, RecipeDetailAction, RecipeDetailEnvironment> { state, action, environment in
    switch action {
    case .loadDetail:
        // TODO: Load detail
        return .none
    }
}
