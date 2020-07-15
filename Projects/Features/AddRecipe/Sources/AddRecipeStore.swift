import ComposableArchitecture

public struct AddRecipeState {
    public init(
        name: String = "",
        currentIngredience: String = "",
        ingrediences: [String] = []
    ) {
        self.name = name
        self.currentIngredience = currentIngredience
        self.ingrediences = ingrediences
    }
    
    public var name: String
    public var currentIngredience: String
    public var ingrediences: [String]
}

public enum AddRecipeAction: Equatable {
    case nameChanged(String)
    case currentIngredienceChanged(String)
    case addIngredience
}

public struct AddRecipeEnvironment {
    public init(
        
    ) {
        
    }
}

public let addRecipeReducer = Reducer<AddRecipeState, AddRecipeAction, AddRecipeEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        state.name = name
    case let .currentIngredienceChanged(currentIngredience):
        state.currentIngredience = currentIngredience
    case .addIngredience:
        state.ingrediences.append(state.currentIngredience)
        state.currentIngredience = ""
    }
    
    return .none
}
