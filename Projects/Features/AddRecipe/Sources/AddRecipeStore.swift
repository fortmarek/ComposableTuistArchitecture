import ComposableArchitecture

public struct AddRecipeState {
    public init(
        name: String = ""
    ) {
        self.name = name
    }
    
    public var name: String
}

public enum AddRecipeAction: Equatable {
    case nameChanged(String)
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
        return .none
    }
}
