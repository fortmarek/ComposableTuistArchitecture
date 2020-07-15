import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine
import AddRecipe

public struct RecipeListFeatureEnvironment {
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

public let recipeListFeatureReducer = Reducer<RecipeListFeatureState, RecipeListFeatureAction, RecipeListFeatureEnvironment>.combine(
  recipeListReducer.pullback(
    state: \.recipeList,
    action: /RecipeListFeatureAction.recipeList,
    environment: {
        RecipeListEnvironment(
            cookbookClient: $0.cookbookClient,
            mainQueue: $0.mainQueue
        )
    }
  ),
  addRecipeFeatureReducer.pullback(
    state: \.addRecipe,
    action: /RecipeListFeatureAction.addRecipe,
    environment: {
        AddRecipeFeatureEnvironment(
            cookbookClient: $0.cookbookClient,
            mainQueue: $0.mainQueue
        )
    }
  )
)

public enum RecipeListFeatureAction {
    case recipeList(RecipeListAction)
    case addRecipe(AddRecipeFeatureAction)
}

public struct RecipeListFeatureState {
    public init(
        recipes: [Recipe] = [],
        hasLoadedRecipes: Bool = false,
        isLoadingRecipes: Bool = false,
        addRecipe: AddRecipeFeatureState = AddRecipeFeatureState()
    ) {
        self.recipes = recipes
        self.hasLoadedRecipes = hasLoadedRecipes
        self.isLoadingRecipes = isLoadingRecipes
        self.addRecipe = addRecipe
    }
    
    var recipes: [Recipe]
    var hasLoadedRecipes: Bool
    var isLoadingRecipes: Bool
    
    var recipeList: RecipeListState {
        get { (recipes, hasLoadedRecipes, isLoadingRecipes) }
        set { (recipes, hasLoadedRecipes, isLoadingRecipes) = newValue }
    }
    
    var addRecipe: AddRecipeFeatureState
}
