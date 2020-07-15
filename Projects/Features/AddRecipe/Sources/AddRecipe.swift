import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public func makeAddRecipeView(store: Store<AddRecipeState, AddRecipeAction>) -> some View {
    AddRecipeView(store: store)
}

public struct AddRecipeView: View {
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    let store: Store<AddRecipeState, AddRecipeAction>
    
    public var body: some View {
        WithViewStore(
            self.store.scope(state: State.init, action: AddRecipeAction.init)
        ) { store in
            Text("AddRecipe")
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
                initialState: AddRecipeState(
                    
                ),
                reducer: addRecipeReducer,
                environment: AddRecipeEnvironment(
                    
                )
            )
        )
    }
}
