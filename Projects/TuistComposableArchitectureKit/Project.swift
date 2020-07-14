import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "TuistComposableArchitectureKit",
    dependencies: [
        .project(
            target: "TuistComposableArchitectureSupport",
            path: .relativeToManifest("../TuistComposableArchitectureSupport")
        )
    ]
)
