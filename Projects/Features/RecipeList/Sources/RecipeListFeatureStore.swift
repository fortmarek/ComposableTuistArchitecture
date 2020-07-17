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
    recipeDetailReducer
        .pullback(
            state: \.value,
            action: .self,
            environment: { $0 }
        )
        .optional
        .pullback(
            state: \.selectionRecipe,
            action: /RecipeListFeatureAction.recipeDetail,
            environment: {
                RecipeDetailEnvironment(
                    cookbookClient: $0.cookbookClient,
                    mainQueue: $0.mainQueue
                )
            }
        ),
    Reducer { state, action, _ in
        switch action {
        case .recipeList:
            return .none
        case .recipeDetail:
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
    case recipeDetail(RecipeDetailAction)
}

public struct RecipeListFeatureState {
    public init(
        recipes: IdentifiedArrayOf<Recipe> = [],
        hasLoadedRecipes: Bool = false,
        isLoadingRecipes: Bool = false,
        isShowingAddRecipe: Bool = false,
        addRecipeState: AddRecipeState = AddRecipeState(),
        selectionRecipe: Identified<Recipe.ID, RecipeDetailState>? = nil
    ) {
        self.recipes = recipes
        self.hasLoadedRecipes = hasLoadedRecipes
        self.isLoadingRecipes = isLoadingRecipes
        self.isShowingAddRecipe = isShowingAddRecipe
        self.addRecipeState = addRecipeState
        self.selectionRecipe = selectionRecipe
    }
    
    var recipes: IdentifiedArrayOf<Recipe>
    var hasLoadedRecipes: Bool
    var isLoadingRecipes: Bool
    var isShowingAddRecipe: Bool
    var selectionRecipe: Identified<Recipe.ID, RecipeDetailState>?
    
    var recipeList: RecipeListState {
        get { (recipes, hasLoadedRecipes, isLoadingRecipes, isShowingAddRecipe, selectionRecipe) }
        set { (recipes, hasLoadedRecipes, isLoadingRecipes, isShowingAddRecipe, selectionRecipe) = newValue }
    }
    
    var addRecipeState: AddRecipeState
}
