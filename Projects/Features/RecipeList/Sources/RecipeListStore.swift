import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine
import AddRecipe

public struct RecipeListState {
    public init(
        recipes: [Recipe] = [],
        isLoadingRecipes: Bool = false
    ) {
        self.recipes = recipes
        self.isLoadingRecipes = isLoadingRecipes
    }
    
    var recipes: [Recipe] = []
    var isLoadingRecipes: Bool = false
}

public enum RecipeListAction: Equatable {
    case recipes
    case recipesResponse(Result<[Recipe], CookbookClient.Failure>)
}

public struct RecipeListEnvironment {
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

public let recipeListReducer = Reducer<RecipeListState, RecipeListAction, RecipeListEnvironment> { state, action, environment in
    switch action {
    case .recipes:
        state.isLoadingRecipes = true
        
        return environment.cookbookClient
            .recipes()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(RecipeListAction.recipesResponse)
    case let .recipesResponse(.success(recipes)):
        state.recipes = recipes
        state.isLoadingRecipes = false
        
        return .none
    case let .recipesResponse(.failure(error)):
        // TODO: Handle error
        state.isLoadingRecipes = false
        
        return .none
    }
}

extension RecipeListState {
    init(recipeListFeatureState: RecipeListFeatureState) {
        self = recipeListFeatureState.recipeList
    }
}
