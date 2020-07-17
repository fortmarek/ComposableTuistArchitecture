import Foundation
import UIKit
import ComposableArchitecture
import ComposableTuistArchitectureSupport
import Combine
import SwiftUI

public struct UIKit_RecipeDetailView: UIViewControllerRepresentable {
    private let store: Store<RecipeDetailState, RecipeDetailAction>
    
    public init(store: Store<RecipeDetailState, RecipeDetailAction>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Context) -> RecipeDetailViewController {
        RecipeDetailViewController(store: store)
    }

    public func updateUIViewController(_ uiViewController: RecipeDetailViewController, context: Context) {
        
    }
}

public final class RecipeDetailViewController: UIViewController {
    struct State: Equatable {
        let recipe: Recipe
    }
    
    enum Action {
        case loadRecipe
    }
    
    // MARK: - Private properties
    
    private weak var nameLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    
    private let store: Store<RecipeDetailState, RecipeDetailAction>
    private let viewStore: ViewStore<State, Action>
    private var cancellables: Set<AnyCancellable> = []
    
    init(store: Store<RecipeDetailState, RecipeDetailAction>) {
        self.store = store
        viewStore = ViewStore(
            store
                .scope(state: State.init, action: RecipeDetailAction.init)
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 10
        view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        vStack.addArrangedSubview(nameLabel)
        self.nameLabel = nameLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        vStack.addArrangedSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStore.publisher
            .map(\.recipe)
            .map(\.name)
            .sink(receiveValue: { [weak self] in self?.nameLabel.text = $0 })
            .store(in: &self.cancellables)
        
        viewStore.publisher
            .map(\.recipe)
            .map(\.description)
            .sink(receiveValue: { [weak self] in self?.descriptionLabel.text = $0 })
            .store(in: &self.cancellables)
        
        viewStore.send(.loadRecipe)
    }
}


extension RecipeDetailViewController.State {
    init(state: RecipeDetailState) {
        recipe = state.recipe
    }
}

extension RecipeDetailAction {
    init(action: RecipeDetailViewController.Action) {
        switch action {
        case .loadRecipe:
            self = .loadDetail
        }
    }
}
