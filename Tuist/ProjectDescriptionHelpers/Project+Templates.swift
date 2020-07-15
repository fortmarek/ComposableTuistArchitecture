import ProjectDescription

extension Project {
    public static let platform: Platform = .iOS
    
    public static func app(
        name: String,
        packages: [Package] = [],
        platform: Platform = platform,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return project(
            name: name,
            packages: packages,
            product: .app,
            platform: platform,
            dependencies:
            dependencies,
            infoPlist: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]
                        ]
                    ]
                ]
            ]
        )
    }
    
    public static func framework(
        name: String,
        platform: Platform = platform,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return project(
            name: name,
            product: .framework,
            platform: platform,
            dependencies: dependencies
        )
    }
    
    public static func feature(
        name: String,
        platform: Platform = platform,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return self.framework(
            name: name,
            platform: platform,
            dependencies: dependencies + [
                .project(
                    target: "ComposableTuistArchitectureSupport",
                    path: .relativeToRoot("Projects/ComposableTuistArchitectureSupport")
                )
            ]
        )
    }
    
    public static func project(
        name: String,
        packages: [Package] = [],
        product: Product,
        platform: Platform = platform,
        dependencies: [TargetDependency] = [],
        infoPlist: [String: InfoPlist.Value] = [:]
    ) -> Project {
        return Project(
            name: name,
            packages: packages,
            targets: [
                Target(
                    name: name,
                    platform: platform,
                    product: product,
                    bundleId: "io.tuist.\(name)",
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sources/**"],
                    resources: [],
                    dependencies: dependencies
                ),
                Target(
                    name: "\(name)Tests",
                    platform: platform,
                    product: .unitTests,
                    bundleId: "io.tuist.\(name)Tests",
                    infoPlist: .default,
                    sources: "Tests/**",
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ]
        )
    }
    
}
