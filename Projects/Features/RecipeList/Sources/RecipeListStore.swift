import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine
import AddRecipe
import RecipeDetail

typealias RecipeListState = (
    recipes: IdentifiedArrayOf<Recipe>,
    hasLoadedRecipes: Bool,
    isLoadingRecipes: Bool,
    isShowingAddRecipe: Bool,
    selectionRecipe: Identified<Recipe.ID, RecipeDetailState>?
)

public enum RecipeListAction: Equatable {
    case recipes
    case deleteRecipes(IndexSet)
    case recipesResponse(Result<[Recipe], CookbookClient.Failure>)
    case isShowingAddRecipeChanged(Bool)
    case selectedRecipe(Recipe.ID?)
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
        state.recipes = IdentifiedArrayOf(recipes)
        state.isLoadingRecipes = false
        
        return .none
    case let .recipesResponse(.failure(error)):
        // TODO: Handle error
        state.isLoadingRecipes = false
        
        return .none
    case let .isShowingAddRecipeChanged(isShowingAddRecipe):
        state.isShowingAddRecipe = isShowingAddRecipe
        return .none
    case let .deleteRecipes(indexSet):
        let recipes = indexSet.map { state.recipes[$0] }
        state.recipes.remove(atOffsets: indexSet)
        return Effect.merge(
            recipes.map {
                environment.cookbookClient
                    .deleteRecipe($0)
                    .catch { _ in Empty<Void, Never>() }
                    .ignoreOutput()
                    .eraseToEffect()
            }
        )
        .fireAndForget()
    case let .selectedRecipe(recipeID):
        guard
            let recipeID = recipeID,
            let recipe = state.recipes[id: recipeID]
        else {
            state.selectionRecipe = nil
            return .none
        }
        state.selectionRecipe = Identified(
            RecipeDetailState(recipe: recipe),
            id: recipeID
        )
        
        return .none
    }
}
