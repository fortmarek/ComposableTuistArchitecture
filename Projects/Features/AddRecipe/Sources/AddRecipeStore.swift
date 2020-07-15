import ComposableArchitecture

public struct AddRecipeState {
    public init(
        
    ) {
        
    }
}

public enum AddRecipeAction: Equatable {}

public struct AddRecipeEnvironment {
    public init(
        
    ) {
        
    }
}

public func addRecipeReducer(
    state: inout AddRecipeState,
    action: AddRecipeAction,
    environment: AddRecipeEnvironment
) -> [Effect<AddRecipeAction, Never>] {
    switch action {
        
    }
}
