import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public struct AddRecipeView: View {
    struct State: Equatable {
        let name: String
        let currentIngredient: String
        let ingredients: [String]
    }
    
    enum Action {
        case nameChanged(String)
        case tappedOnAddIngredient
        case currentIngredientChanged(String)
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
            VStack(alignment: .leading, spacing: 10) {
                Text("Name of recipe")
                TextField("Best recipe", text: viewStore.binding(get: \.name, send: Action.nameChanged))
                Text("Ingredients")
                VStack {
                    ForEach(viewStore.ingredients, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Add the best ingredient", text: viewStore.binding(get: \.currentIngredient, send: Action.currentIngredientChanged))
                Button(
                    "Add ingredient",
                    action: { viewStore.send(.tappedOnAddIngredient) }
                )
            }
            .padding()
        }
    }
}

extension AddRecipeView.State {
    init(state: AddRecipeState) {
        name = state.name
        currentIngredient = state.currentIngredient
        ingredients = state.ingredients
    }
}

extension AddRecipeAction {
    init(action: AddRecipeView.Action) {
        switch action {
        case let .nameChanged(name):
            self = .nameChanged(name)
        case let .currentIngredientChanged(currentIngredient):
            self = .currentIngredientChanged(currentIngredient)
        case .tappedOnAddIngredient:
            self = .addedIngredient
        }
    }
}

struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(
            store: Store(
                initialState: AddRecipeState(
                    ingredients: ["Soup"]
                ),
                reducer: addRecipeReducer,
                environment: AddRecipeEnvironment(
                    
                )
            )
        )
    }
}
