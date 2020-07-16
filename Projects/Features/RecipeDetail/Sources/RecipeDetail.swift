import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public func makeRecipeDetailView(store: Store<RecipeDetailFeatureState, RecipeDetailFeatureAction>) -> some View {
    RecipeDetailView(store: store)
}

public struct RecipeDetailView: View {
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    let store: Store<RecipeDetailFeatureState, RecipeDetailFeatureAction>
    
    public var body: some View {
        WithViewStore(
            self.store
                .scope(state: \.recipeDetail, action: RecipeDetailFeatureAction.init)
                .scope(state: State.init, action: RecipeDetailAction.init)
        ) { store in
            Text("RecipeDetail")
        }
    }
}

extension RecipeDetailView.State {
    init(state: RecipeDetailState) {
        
    }
}

extension RecipeDetailAction {
    init(action: RecipeDetailView.Action) {
        switch action {
            
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(
            store: Store(
                initialState: RecipeDetailFeatureState(),
                reducer: recipeDetailFeatureReducer,
                environment: RecipeDetailFeatureEnvironment(
                    
                )
            )
        )
    }
}
