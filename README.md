# PackOnce

PackOnce is a SwiftUI (iOS 17+) checklist app that keeps your packs and templates ready offline. It uses SwiftData for persistence and StoreKit 2 for the Pro upgrade.

## Running the app
1. Open `PackOnce.xcodeproj` in Xcode 15+.
2. Select the **PackOnce** iOS target and an iOS 17+ simulator or device.
3. Build and run. Seed templates are inserted on first launch.

## StoreKit configuration
Update your own product identifiers inside `Data/StoreKitService.swift` (default placeholder `com.example.packonce.pro`). Pricing shows a placeholder if products fail to load. A hidden debug toggle in Settings simulates Pro in DEBUG builds.

## Features to test
- Complete onboarding then verify the Packs, Templates, and Settings tabs.
- Create packs from templates, edit items, and confirm template update prompts appear for linked items.
- Check the “Don’t forget” section for rule-based suggestions.
- Test text sharing (free) and PDF export (Pro) from a pack detail.
- Toggle settings for moving checked items, collapsing packed items, haptics, and large text mode.
- Restore purchases and open the paywall sheet.

## Repository hygiene
Binary assets and generated folders are intentionally excluded. Add your own icons or assets locally if desired.
