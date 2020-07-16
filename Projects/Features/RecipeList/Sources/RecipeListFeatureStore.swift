import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine
import AddRecipe
import RecipeDetail

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
        state: \.addRecipeFeatureState,
        action: /RecipeListFeatureAction.addRecipe,
        environment: {
            AddRecipeFeatureEnvironment(
                cookbookClient: $0.cookbookClient,
                mainQueue: $0.mainQueue
            )
        }
    ),
    recipeDetailFeatureReducer.pullback(
        state: \.recipeDetailFeatureState,
        action: /RecipeListFeatureAction.recipeDetail,
        environment: { _ in 
            RecipeDetailFeatureEnvironment()
        }
    )
)

public enum RecipeListFeatureAction {
    case recipeList(RecipeListAction)
    case addRecipe(AddRecipeFeatureAction)
    case recipeDetail(RecipeDetailFeatureAction)
}

public struct RecipeListFeatureState {
    public init(
        recipes: [Recipe] = [],
        hasLoadedRecipes: Bool = false,
        isLoadingRecipes: Bool = false,
        isShowingAddRecipe: Bool = false,
        addRecipeScreenState: AddRecipeScreenState = ("", "", []),
        recipeDetailFeatureState: RecipeDetailFeatureState = RecipeDetailFeatureState()
    ) {
        self.recipes = recipes
        self.hasLoadedRecipes = hasLoadedRecipes
        self.isLoadingRecipes = isLoadingRecipes
        self.isShowingAddRecipe = isShowingAddRecipe
        self.addRecipeScreenState = addRecipeScreenState
        self.recipeDetailFeatureState = recipeDetailFeatureState
    }
    
    var recipes: [Recipe]
    var hasLoadedRecipes: Bool
    var isLoadingRecipes: Bool
    var isShowingAddRecipe: Bool
    
    var recipeList: RecipeListState {
        get { (recipes, hasLoadedRecipes, isLoadingRecipes, isShowingAddRecipe) }
        set { (recipes, hasLoadedRecipes, isLoadingRecipes, isShowingAddRecipe) = newValue }
    }
    
    var addRecipeScreenState: AddRecipeScreenState
    
    var addRecipeFeatureState: AddRecipeFeatureState {
        get { AddRecipeFeatureState(recipes: recipes, isShowingAddRecipe: isShowingAddRecipe, addRecipeScreenState: addRecipeScreenState) }
        set {
            recipes = newValue.recipes
            isShowingAddRecipe = newValue.isShowingAddRecipe
            addRecipeScreenState = newValue.addRecipeScreenState
        }
    }
    
    var recipeDetailFeatureState: RecipeDetailFeatureState
}
