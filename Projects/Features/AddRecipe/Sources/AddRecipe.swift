import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI

public struct AddRecipeView: View {
    struct State: Equatable {
        let name: String
        let ingredients: [String]
        let currentIngredient: String
    }
    
    enum Action {
        case nameChanged(String)
        case addIngredientButtonTapped
        case currentIngredientChanged(String)
        case addRecipeButtonTapped
    }
    
    let store: Store<AddRecipeState, AddRecipeAction>
    
    public init(store: Store<AddRecipeState, AddRecipeAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(
            self.store
                .scope(state: State.init, action: AddRecipeAction.init)
        ) { store in
            NavigationView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Name of recipe")
                        TextField(store.name, text: store.binding(get: { $0.name }, send: Action.nameChanged))
                            .border(Color.black, width: 1)
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                        ForEach(store.ingredients, id: \.self) {
                            Text($0)
                        }
                        TextField(
                            "Ingredient",
                            text: store.binding(
                                get: { $0.currentIngredient },
                                send: Action.currentIngredientChanged
                            )
                        )
                        .border(Color.black, width: 1)
                        Button("Add", action: { store.send(.addIngredientButtonTapped) })
                    }
                    .padding()
                }
                .navigationTitle("Add Recipe")
                .navigationBarItems(trailing: Button("Add", action: { store.send(.addRecipeButtonTapped) }))
            }
        }
    }
}

extension AddRecipeView.State {
    init(state: AddRecipeState) {
        name = state.name
        ingredients = state.ingredients
        currentIngredient = state.currentIngredient
    }
}

extension AddRecipeAction {
    init(action: AddRecipeView.Action) {
        switch action {
        case let .nameChanged(name):
            self = .nameChanged(name)
        case let .currentIngredientChanged(ingredient):
            self = .currentIngredientChanged(ingredient)
        case .addIngredientButtonTapped:
            self = .addIngredient
        case .addRecipeButtonTapped:
            self = .addRecipe
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
                    cookbookClient: .mock(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
