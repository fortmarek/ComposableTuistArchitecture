import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public struct AddRecipeView: View {
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    let store: Store<AddRecipeState, AddRecipeAction>
    
    public init(store: Store<AddRecipeState, AddRecipeAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(
            self.store
                .scope(state: State.init, action: AddRecipeAction.init)
        ) { viewStore in
            
        }
    }
}

extension AddRecipeView.State {
    init(state: AddRecipeState) {
        
    }
}

extension AddRecipeAction {
    init(action: AddRecipeView.Action) {
        switch action {
            
        }
    }
}

struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(
            store: Store(
                initialState: AddRecipeState(),
                reducer: addRecipeReducer,
                environment: AddRecipeEnvironment(
                    
                )
            )
        )
    }
}
