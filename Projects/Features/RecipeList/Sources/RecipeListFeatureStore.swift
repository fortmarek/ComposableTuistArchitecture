import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine
import AddRecipe

public let recipeListFeatureReducer = Reducer.combine(
  recipeListReducer.pullback(
    state: \RecipeListFeatureState.recipeList,
    action: /RecipeListFeatureAction.recipeList,
    environment: { $0 }
  ),
  addRecipeReducer.pullback(
    state: \RecipeListFeatureState.addRecipe,
    action: /RecipeListFeatureAction.addRecipe,
    environment: { _ in AddRecipeEnvironment() }
  )
)

public enum RecipeListFeatureAction {
    case recipeList(RecipeListAction)
    case addRecipe(AddRecipeAction)
}

public struct RecipeListFeatureState {
    public init(
        recipeList: RecipeListState = RecipeListState(),
        addRecipe: AddRecipeState = AddRecipeState()
    ) {
        self.recipeList = recipeList
        self.addRecipe = addRecipe
    }
    
    var recipeList: RecipeListState
    var addRecipe: AddRecipeState
}
