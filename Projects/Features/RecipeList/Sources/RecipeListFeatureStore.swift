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
    addRecipeReducer.pullback(
        state: \.addRecipeState,
        action: /RecipeListFeatureAction.addRecipe,
        environment: {
            AddRecipeEnvironment(
                cookbookClient: $0.cookbookClient,
                mainQueue: $0.mainQueue
            )
        }
    ),
    Reducer { state, action, _ in
        switch action {
        case .recipeList:
            return .none
        case let .addRecipe(addRecipeAction):
            switch addRecipeAction {
            case .currentIngredientChanged, .nameChanged, .addedIngredient, .addRecipe, .addedRecipe(.failure):
                return .none
            case let .addedRecipe(.success(recipe)):
                state.recipes.append(recipe)
                state.isShowingAddRecipe = false
                return .none
            }
        }
    }
)

public enum RecipeListFeatureAction {
    case recipeList(RecipeListAction)
    case addRecipe(AddRecipeAction)
}

public struct RecipeListFeatureState {
    public init(
        recipes: IdentifiedArrayOf<Recipe> = [],
        hasLoadedRecipes: Bool = false,
        isLoadingRecipes: Bool = false,
        isShowingAddRecipe: Bool = false,
        addRecipeState: AddRecipeState = AddRecipeState()
    ) {
        self.recipes = recipes
        self.hasLoadedRecipes = hasLoadedRecipes
        self.isLoadingRecipes = isLoadingRecipes
        self.isShowingAddRecipe = isShowingAddRecipe
        self.addRecipeState = addRecipeState
    }
    
    var recipes: IdentifiedArrayOf<Recipe>
    var hasLoadedRecipes: Bool
    var isLoadingRecipes: Bool
    var isShowingAddRecipe: Bool
    
    var recipeList: RecipeListState {
        get { (recipes, hasLoadedRecipes, isLoadingRecipes, isShowingAddRecipe) }
        set { (recipes, hasLoadedRecipes, isLoadingRecipes, isShowingAddRecipe) = newValue }
    }
    
    var addRecipeState: AddRecipeState
}
