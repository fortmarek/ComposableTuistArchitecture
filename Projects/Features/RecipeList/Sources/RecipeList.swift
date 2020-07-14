import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public typealias RecipeListState = ()

public enum RecipeListAction: Equatable {}

public typealias RecipeListEnvironment = Void

public func recipelistReducer(
    state: inout RecipeListState,
    action: RecipeListAction,
    environment: RecipeListEnvironment
) -> [Effect<RecipeListAction, Never>] {
    switch action {
        
    }
}

public struct RecipeListView: View {
    struct State: Equatable {
        
    }
    let store: Store<RecipeListState, RecipeListAction>
    
    public var body: some View {
        WithViewStore(
            self.store.scope(state: State.init(recipelistState:), action: { $0 })
        ) { store in
            Text("RecipeList")
        }
    }
}

extension RecipeListView.State {
    init(recipelistState: RecipeListState) {
        
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
