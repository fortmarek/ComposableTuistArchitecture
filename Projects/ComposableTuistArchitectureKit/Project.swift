import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "ComposableTuistArchitectureKit",
    dependencies: [
        .project(
            target: "ComposableTuistArchitectureSupport",
            path: .relativeToManifest("../ComposableTuistArchitectureSupport")
        )
    ]
)
