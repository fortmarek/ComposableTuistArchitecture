import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public func makeAddRecipeView(store: Store<AddRecipeState, AddRecipeAction>) -> some View {
    AddRecipeView(store: store)
}

public struct AddRecipeView: View {
    struct State: Equatable {
        let name: String
    }
    
    enum Action {
        case nameChanged(String)
    }
    
    let store: Store<AddRecipeState, AddRecipeAction>
    
    public var body: some View {
        WithViewStore(
            self.store.scope(state: State.init, action: AddRecipeAction.init)
        ) { store in
            VStack {
                TextField(store.name, text: store.binding(get: { $0.name }, send: Action.nameChanged))
            }
            Text("AddRecipe")
        }
    }
}

extension AddRecipeView.State {
    init(state: AddRecipeState) {
        name = state.name
    }
}

extension AddRecipeAction {
    init(action: AddRecipeView.Action) {
        switch action {
        case let .nameChanged(name):
            self = .nameChanged(name)
        }
    }
}

struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(
            store: Store(
                initialState: AddRecipeState(
                    name: ""
                ),
                reducer: addRecipeReducer,
                environment: AddRecipeEnvironment(
                    
                )
            )
        )
    }
}
