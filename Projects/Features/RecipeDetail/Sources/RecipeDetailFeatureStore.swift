import ComposableArchitecture
import ComposableTuistArchitectureSupport

public struct RecipeDetailFeatureEnvironment {
    public init(
        
    ) {
        
    }
}

public let recipeDetailFeatureReducer = Reducer<RecipeDetailFeatureState, RecipeDetailFeatureAction, RecipeDetailFeatureEnvironment>.combine(
    recipeDetailReducer.pullback(
        state: \.recipeDetail,
        action: /RecipeDetailFeatureAction.recipeDetail,
        environment: { _ in
            RecipeDetailEnvironment(
                
            )
        }
    )
)

public enum RecipeDetailFeatureAction {
    case recipeDetail(RecipeDetailAction)
}

public typealias RecipeDetailScreenState = (
    
)

public struct RecipeDetailFeatureState {
    public init(
        
    ) {
        
    }
    
    var recipeDetail: RecipeDetailState {
        get { () }
        set { () = newValue }
    }
}
