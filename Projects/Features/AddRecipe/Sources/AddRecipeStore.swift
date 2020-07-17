import ComposableArchitecture
import ComposableTuistArchitectureSupport

public struct AddRecipeState {
    public init(
        name: String = "",
        ingredients: [String] = [],
        currentIngredient: String = ""
    ) {
        self.name = name
        self.ingredients = ingredients
        self.currentIngredient = ""
    }
    
    var name: String
    var ingredients: [String]
    var currentIngredient: String
}

public enum AddRecipeAction: Equatable {
    case currentIngredientChanged(String)
    case addedIngredient
    case nameChanged(String)
}

public struct AddRecipeEnvironment {
}

public let addRecipeReducer = Reducer<AddRecipeState, AddRecipeAction, AddRecipeEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        state.name = name
        return .none
    case let .currentIngredientChanged(ingredient):
        state.currentIngredient = ingredient
        return .none
    case .addedIngredient:
        state.ingredients.append(state.currentIngredient)
        state.currentIngredient = ""
        return .none
    }
}
