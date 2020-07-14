import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "TuistComposableArchitecture",
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "0.6.0")
        ),
    ],
    platform: .iOS,
    dependencies: [
        .project(
            target: "TuistComposableArchitectureKit",
            path: .relativeToManifest("../TuistComposableArchitectureKit")
        ),
        .package(product: "ComposableArchitecture"),
    ]
)
