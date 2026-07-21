When working on the **Lingua Quest** iOS project, follow these rules strictly and without exception.

---

## 1. File Headers

Every newly created Swift file **MUST** include a reference header at the very top:

```swift
//
//  [Filename].swift
//  Lingua Quest
//
//  Created by siam on [Current Date].
//
```

> **⚠️ IMPORTANT**: If an existing file already has a header with a different author's name, **DO NOT** modify or change the author's name. Leave the original author's name as is.

---

## 2. Localization

- **DO NOT** use hardcoded strings anywhere in the UI.
- All text must be localized and retrieved from `L10n` (located at `Core/Localization/L10n.swift`).
- Use the namespaced format: `L10n.Common.ok`, `L10n.Network.invalidURL`, etc.
- When adding new strings, add them to the appropriate namespace in `L10n.swift` using `localized("...")` and make sure they are defined in the `.lproj` localization files.

---

## 3. Colors and Themes

- **Support both Dark and Light themes** — every new color must have both variants.
- If a new color is needed:
  1. Add it to `Assets.xcassets` with Light + Dark variants.
  2. Add it as an extension to `Color` in a dedicated file (e.g., `Core/Extensions/Color+Ext.swift`) if applicable.
- **NEVER** instantiate colors with hardcoded strings like `Color("appBlack")`.

---

## 4. Typography

- Use custom text styles if they are defined for the project (e.g. `AppTextStyle`). 
- Otherwise, maintain consistency with SwiftUI's standard scalable fonts and avoid hardcoded font sizes.

---

## 5. Navigation & Routing

- Use `Router` and `AppRoute` or `AppSheet` enums for **ALL** navigation (located in `Core/Routing/`).
- **DO NOT** use `NavigationLink` or `@Environment(\.dismiss)` directly in views unless absolutely necessary for a standard SwiftUI component.
- **Router Injection**: Inject `RouterProtocol` into the **ViewModel** via Swinject (e.g., `init(router: RouterProtocol)`). The View should delegate actions to the ViewModel (like `viewModel.onCardTapped()`), and the ViewModel should handle the actual routing (e.g., `router.push(...)`). Avoid using `@Environment(Router.self)` directly in Views if they have a ViewModel.
- Navigation actions examples:
  ```swift
  router.push(.productDetails(id: "123"))
  router.pushAndReplace(.login)
  router.pushAndRemoveAll(.home)
  router.pop()
  router.popToRoot()
  router.present(.someSheet)
  router.dismissSheet()
  ```
- When adding a new screen:
  1. Add a case to `AppRoute` or `AppSheet`.
  2. Map it to the corresponding view in `Router.swift` inside the `view(for:)` function.

---

## 6. Architecture — Clean Architecture Layers

Every feature module must follow the three-layer structure and be placed inside a `Modules/` directory:

```
Modules/[FeatureName]/
├── Data/
│   ├── DataSources/
│   │   ├── Remote/
│   │   │   ├── [FeatureName]RemoteDataSource.swift
│   │   │   └── [FeatureName]Endpoint.swift
│   │   └── Local/          ← (optional, if needed)
│   ├── DTOs/
│   └── RepositoryImpl/
├── Domain/         ← Entities, RepositoryProtocol, UseCases
└── Presentation/   ← Views, ViewModels
```

**Rules**:
- **Endpoints belong in the Module**: Endpoints for a specific feature must be defined in `Data/DataSources/Remote/` of that module, **NOT** in the global `Core/Network` layer.
- Domain layer must have **ZERO** framework imports (no SwiftUI, Apollo, Firebase).
- Presentation depends on Domain (not Data).
- Data depends on Domain (not Presentation).

---

## 7. Dependency Injection

- **Separate Assembly per Module**: Each feature module MUST have its own dedicated Assembly file located in `Core/DI/` (e.g., `Core/DI/HomeAssembly.swift`) that conforms to Swinject's `Assembly`.
- All module assemblies must be registered in the central `Resolver` located at `Core/DI/Resolver.swift`.
- ViewModels **never** create their own dependencies — they receive them via initializer injection.

---

## 8. Network Layer

- The base networking protocols and error handling live in `Core/Network/` (e.g., `APIClient.swift`, `NetworkError.swift`, `Endpoint.swift`).
- Use the central `APIClientProtocol` to execute requests.
- **Reminder**: Do not add feature-specific endpoints to `Core/Network/`. Add them to `Modules/[FeatureName]/Data/DataSources/Remote/`.

---

## 9. ViewModels

- Always mark ViewModels with `@MainActor` and `@Observable` (using `Observation` framework).
- Do NOT use `ObservableObject` or `@Published` unless required by older APIs.
- Use `@State` in views to own the ViewModel lifecycle.
- ViewModel naming: `FeatureNameViewModel` (e.g., `HomeViewModel`).

---
## 10. Views & Animations

- **Backgrounds**: Use `Color.appViewBackground.ignoresSafeArea()` for standard view backgrounds.
- **Navigation Bar**: Use a Custom back button in the `.toolbar` instead of the default one.
- **Animations**: Always add dynamic, modern animations to your Views. Use `.spring()`, `.easeInOut()`, and staggering delays when elements appear (`.onAppear`) or states change. The UI should feel lively, engaging, and premium (e.g. bouncing mascots, typewriter text, pulsing buttons, smooth transitions).

## 11. Xcode Project References (`project.pbxproj`)

- When creating, deleting, or moving files, update the Xcode project references (`project.pbxproj`) **manually**.
- **DO NOT** use external or automated scripts to update the Xcode project file — they often corrupt the project structure.

## 12. File Size Limits (Keep Files Small)

- **Maximum File Size**: Do not let SwiftUI views or files grow excessively large. As a rule of thumb, keep files under 200-250 lines.
- **Split and Extract**: If a file grows large, extract subviews, bottom sheets, or complex components into separate files.
- **Shared Components**: Place generic, reusable extracted components inside `Modules/Shared/Presentation/Components/`.
- use custom bottom sheet `CustomBottomSheet` for custom bottom sheets.
- use custom dialog `DialogCardContainer` for custom dialogs.
- use custom text field `CustomTextField` for custom text fields.
- use custom button `AppButton` for custom buttons.
...

## 13. Code Comments
- **NO ARABIC COMMENTS**: It is strictly forbidden to write any comments in Arabic within the codebase. All code comments, TODOs, and documentation must be in English. If you encounter any existing Arabic comments, you must delete or translate them to English immediately.

## 14. Dialogs and Overlays
- All custom dialogs must be displayed using the `.appDialog(isPresented: $isPresented)` modifier which relies on the shared `DialogOverlay`.
- **DO NOT** create manual `ZStack` overlays or hardcoded backgrounds (like `Color.black.opacity(...)` or `.ultraThinMaterial`) inside individual dialog views. Let the `DialogOverlay` handle the background blur and dimming.
- Use `DialogCardContainer` for the actual card UI, and rely on its internal layout logic without adding custom manual padding hacks for mascots.

## 15. API Parsing & Optional Fields
- Define Data Transfer Object (DTO) properties as Optional (`?`) for fields that might be missing or occasionally `null` in API responses (e.g., summaries, nested objects) to prevent `keyNotFound` decoding crashes.
- Handle these optionals cleanly in the Repository Mapper by providing empty arrays `[]` or default values like `0`.
- When using the `?? []` operator with closures (e.g., `.map`), **always explicitly declare the array type** (e.g., `let explorers: [ExplorerEntity] = ...`) to prevent the Swift compiler from incorrectly inferring `[Any]` and throwing a `Cannot convert value of type '[Any]'` error.
