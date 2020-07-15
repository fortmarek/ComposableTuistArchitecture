import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "ComposableTuistArchitectureSupport",
    dependencies: [
        .package(product: "ComposableArchitecture"),
        .package(product: "CasePaths"),
    ]
)
