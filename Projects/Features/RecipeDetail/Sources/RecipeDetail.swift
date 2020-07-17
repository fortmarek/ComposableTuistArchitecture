import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public struct RecipeDetailView: View {
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    let store: Store<RecipeDetailState, RecipeDetailAction>
    
    public init(store: Store<RecipeDetailState, RecipeDetailAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(
            self.store
                .scope(state: State.init, action: RecipeDetailAction.init)
        ) { viewStore in
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
                initialState: RecipeDetailState(recipe: .mock()),
                reducer: recipeDetailReducer,
                environment: RecipeDetailEnvironment(
                    
                )
            )
        )
    }
}
