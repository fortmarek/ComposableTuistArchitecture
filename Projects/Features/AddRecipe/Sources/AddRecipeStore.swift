import ComposableArchitecture
import ComposableTuistArchitectureSupport

public struct AddRecipeState {
    public init(
        name: String = ""
    ) {
        self.name = name
    }
    
    var name: String
}

public enum AddRecipeAction: Equatable {
    case nameChanged(String)
}

public struct AddRecipeEnvironment {
}

public let addRecipeReducer = Reducer<AddRecipeState, AddRecipeAction, AddRecipeEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        state.name = name
        return .none
    }
}
