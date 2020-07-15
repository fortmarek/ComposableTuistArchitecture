import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine

public struct AddRecipeFeatureEnvironment {
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

public let addRecipeFeatureReducer = Reducer<AddRecipeFeatureState, AddRecipeFeatureAction, AddRecipeFeatureEnvironment>.combine(
  addRecipeReducer.pullback(
    state: \.addRecipe,
    action: /AddRecipeFeatureAction.addRecipe,
    environment: {
        AddRecipeEnvironment(
            cookbookClient: $0.cookbookClient,
            mainQueue: $0.mainQueue
        )
    }
  )
)

public enum AddRecipeFeatureAction {
    case addRecipe(AddRecipeAction)
}

public struct AddRecipeFeatureState {
    public init(
        recipes: [Recipe] = [],
        name: String = "",
        currentIngredient: String = "",
        ingredients: [String] = []
    ) {
        self.recipes = recipes
        self.name = name
        self.currentIngredient = currentIngredient
        self.ingredients = ingredients
    }
    
    var recipes: [Recipe]
    var name: String
    var currentIngredient: String
    var ingredients: [String]
    
    var addRecipe: AddRecipeState {
        get { (name, currentIngredient, ingredients, recipes) }
        set { (name, currentIngredient, ingredients, recipes) = newValue }
    }
}
