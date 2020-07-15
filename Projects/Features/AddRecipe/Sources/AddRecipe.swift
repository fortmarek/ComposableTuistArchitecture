import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public func makeAddRecipeView(store: Store<AddRecipeState, AddRecipeAction>) -> some View {
    AddRecipeView(store: store)
}

struct AddRecipeView: View {
    struct State: Equatable {
        let name: String
        let ingrediences: [String]
        let currentIngredience: String
    }
    
    enum Action {
        case nameChanged(String)
        case addIngredienceButtonTapped
        case currentIngredienceChanged(String)
    }
    
    let store: Store<AddRecipeState, AddRecipeAction>
    
    var body: some View {
        WithViewStore(
            self.store.scope(state: State.init, action: AddRecipeAction.init)
        ) { store in
            VStack {
                VStack(alignment: .leading) {
                    Text("Name of recipe")
                    TextField(store.name, text: store.binding(get: { $0.name }, send: Action.nameChanged))
                        .border(Color.black, width: 1)
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("Ingrediences")
                    ForEach(store.ingrediences, id: \.self) {
                        Text($0)
                    }
                    TextField(
                        "Ingredience",
                        text: store.binding(
                            get: { $0.currentIngredience },
                            send: Action.currentIngredienceChanged
                        )
                    )
                    .border(Color.black, width: 1)
                    Button("Add", action: { store.send(.addIngredienceButtonTapped) })
                }
                .padding()
            }
        }
    }
}

extension AddRecipeView.State {
    init(state: AddRecipeState) {
        name = state.name
        ingrediences = state.ingrediences
        currentIngredience = state.currentIngredience
    }
}

extension AddRecipeAction {
    init(action: AddRecipeView.Action) {
        switch action {
        case let .nameChanged(name):
            self = .nameChanged(name)
        case let .currentIngredienceChanged(ingredience):
            self = .currentIngredienceChanged(ingredience)
        case .addIngredienceButtonTapped:
            self = .addIngredience
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
