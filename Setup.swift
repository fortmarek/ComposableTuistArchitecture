import ProjectDescription

let supportSourcesPath = "Projects/ComposableTuistArchitectureSupport/Sources"

let generatedFiles: [String] = [
    "\(supportSourcesPath)/Model/Generated/Assets.swift",
]

func parentDirectory(for file: String) -> String {
    file.components(separatedBy: "/").dropLast().joined(separator: "/")
}

func upCommands(for file: String) -> [Up] {
    [
        .custom(name: "\(file)'s intermediate directories", meet: ["mkdir", "-p", parentDirectory(for: file)], isMet: ["test", "-e", parentDirectory(for: file)]),
        .custom(name: "\(file)", meet: ["touch", file], isMet: ["test", "-e", file])
    ]
}

// Generate all files generated during build phase, so they are added to `.xcodeproj` during the first `tuist generate`
let setup = Setup(
    generatedFiles.flatMap {
        upCommands(for: $0)
    } + [
        .mint()
    ]
)
