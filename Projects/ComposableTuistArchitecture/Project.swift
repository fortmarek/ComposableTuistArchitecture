import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "ComposableTuistArchitecture",
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "0.6.0")
        ),
    ],
    features: [
        "RecipeList",
        "AddRecipe",
        "RecipeDetail",
    ],
    dependencies: [
        .project(
            target: "ComposableTuistArchitectureKit",
            path: .relativeToRoot("Projects/ComposableTuistArchitectureKit")
        ),
        .package(product: "ComposableArchitecture"),
        .package(product: "CasePaths"),
    ]
)
