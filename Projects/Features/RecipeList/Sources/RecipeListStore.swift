import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine
import AddRecipe

typealias RecipeListState = (
    recipes: [Recipe],
    hasLoadedRecipes: Bool,
    isLoadingRecipes: Bool
)

public enum RecipeListAction: Equatable {
    case recipes
    case recipesResponse(Result<[Recipe], CookbookClient.Failure>)
}

struct RecipeListEnvironment {
    let cookbookClient: CookbookClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let recipeListReducer = Reducer<RecipeListState, RecipeListAction, RecipeListEnvironment> { state, action, environment in
    switch action {
    case .recipes:
        guard !state.hasLoadedRecipes else { return .none }
        state.hasLoadedRecipes = true
        
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
