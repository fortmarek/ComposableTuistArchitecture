import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public struct AddRecipeView: View {
    struct State: Equatable {
        let name: String
    }
    
    enum Action {
        case nameChanged(String)
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
            VStack(alignment: .center, spacing: 10) {
                Text("Name of recipe")
                TextField("Best recipe", text: viewStore.binding(get: \.name, send: Action.nameChanged))
                
            }
            .padding()
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
                initialState: AddRecipeState(),
                reducer: addRecipeReducer,
                environment: AddRecipeEnvironment(
                    
                )
            )
        )
    }
}
