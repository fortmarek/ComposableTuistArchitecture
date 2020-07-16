import ComposableArchitecture
import ComposableTuistArchitectureSupport

typealias RecipeDetailState = ()

public enum RecipeDetailAction: Equatable {}

struct RecipeDetailEnvironment {
}

let recipeDetailReducer = Reducer<RecipeDetailState, RecipeDetailAction, RecipeDetailEnvironment> { state, action, environment in
    switch action {
        
    }
}

extension RecipeDetailFeatureAction {
    init(_ recipeDetailAction: RecipeDetailAction) {
        switch recipeDetailAction {
            
        }
    }
}
