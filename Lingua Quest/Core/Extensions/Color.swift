//
//  Color.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

extension Color {
    // MARK: - Canonical Design Tokens
    
    // Brand Colors
    static let appBrandPrimary = Color("TokenBrandPrimary")         // #FF9F29
    static let appBrandBrown = Color("TokenBrandBrown")             // #8A5100
    static let appBrandBrownDark = Color("TokenBrandBrownDark")     // #683D00
    
    // Backgrounds & Surfaces
    static let appBackgroundPrimary = Color("TokenBackgroundPrimary") // #F3FAFF
    static let appBackgroundWarm = Color("TokenBackgroundWarm")       // #FEF8F0
    static let appSurfaceCard = Color("TokenSurfaceCard")             // #FFFFFF
    static let appSurfaceCardWarm = Color("TokenSurfaceCardWarm")     // #F9F3EB
    static let appSurfaceNavBar = Color("TokenSurfaceNavBar")         // #FFF8F5
    static let appSurfaceCardMuted = Color("TokenSurfaceCardMuted")   // #E7E2DA
    
    // Borders
    static let appBorderBrown = Color("TokenBorderBrown")             // #DBC2AD
    static let appBorderCool = Color("TokenBorderCool")               // #CFE6F2
    static let appBorderWarm = Color("TokenBorderWarm")               // #DAC2AE
    static let appBorderLight = Color("TokenBorderLight")             // #F1DFD1
    
    // Text
    static let appTextPrimary = Color("TokenTextPrimary")             // #071E27
    static let appTextDark = Color("TokenTextDark")                   // #1D1B17
    static let appTextSlate = Color("TokenTextSlate")                 // #1E293B
    static let appTextHeading = Color("TokenTextHeading")             // #231A11
    static let appTextSecondary = Color("TokenTextSecondary")         // #554434
    
    // Accents & Icons
    static let appSemanticSuccess = Color("TokenSemanticSuccess")     // #006B5C
    static let appGlowTeal = Color("TokenGlowTeal")                   // #68FADD
    static let appGlowGold = Color("TokenGlowGold")                   // #D0AE00
    static let appIconBrown = Color("TokenIconBrown")                 // #887361
    static let appTextOnPrimary = Color("TokenTextOnPrimary")         // #FFFFFF
    static let appAccentGold = Color("TokenAccentGold")               // #F59E0B
    static let appAccentRed = Color("TokenAccentRed")                 // #F43F5E
    static let appAccentStreakRed = Color("TokenAccentStreakRed")     // #BF0025
    static let appAccentTealDark = Color("TokenAccentTealDark")       // #006A62
    static let appAccentEarth = Color("TokenAccentEarth")             // #877462
    static let appBadgeTealBg = Color("TokenBadgeTealBg")             // #70F8E8
    static let appBadgeTealText = Color("TokenBadgeTealText")         // #007168
    static let appAccentTeal = Color("TokenAccentTeal")               // #006B59
    static let appAccentOrange = Color("TokenAccentOrange")           // #FF9900
    static let appAccentActiveLevel = Color("TokenAccentActiveLevel") // #7BF4FF
    
    // MARK: - Additional Custom Tokens
    static let appCategorySelectedOrange = Color("TokenCategorySelectedOrange") // #FF9500
    static let appCategoryUnselectedBg = Color("TokenCategoryUnselectedBg")     // #FDF2E8
    static let appEmptyCircleBg = Color("TokenEmptyCircleBg")                   // #F2FAF2
    static let appEmptyStateSubtitle = Color("TokenEmptyStateSubtitle")         // #666666
    static let appEmptyStateTitle = Color("TokenEmptyStateTitle")               // #594D40
    static let appHeaderBirdCircleBg = Color("TokenHeaderBirdCircleBg")         // #FFC785
    static let appHeaderTitleDark = Color("TokenHeaderTitleDark")               // #262626
    static let appRed = Color("TokenRed")                                       // #CC4D4D
    static let appTealGreen = Color("TokenTealGreen")                           // #338073
    static let appTextSelectedBrown = Color("TokenTextSelectedBrown")           // #66330D
    static let appTextUnselectedBrown = Color("TokenTextUnselectedBrown")       // #4D4033
    static let appCardImageBackground = Color("TokenCardImageBackground")       // #E6D9CC
    static let appTextDarkGray = Color("TokenTextDarkGray")                     // #4D4D4D
    static let appProgressBar = Color("TokenFirstProgressBar")                  // #006B5F
    static let appSecondaryProgressBar = Color("TokenSecondaryProgressBar")     // #FEEADC
    
    // Restored from HEAD
    static let appOutLineButton = Color("OutlineButton")
    static let appDarkGreen = Color("DarkGreen")
    static let appSecondaryColor = Color("AppSecondaryColor")
    
    // MARK: - Deprecated Tokens (Do not use in new code)
    
    @available(*, deprecated, renamed: "appBrandPrimary")
    static let appPrimaryColor = appBrandPrimary
    
    @available(*, deprecated, renamed: "appBackgroundPrimary")
    static let appBackgroundLightBlue = appBackgroundPrimary
    
    @available(*, deprecated, renamed: "appBorderCool")
    static let appBorderLightBlue = appBorderCool
    
    @available(*, deprecated, renamed: "appGlowGold")
    static let appGlowYellow = appGlowGold
    
    @available(*, deprecated, renamed: "appTextSecondary")
    static let appTextBrown = appTextSecondary
    
    @available(*, deprecated, renamed: "appTextPrimary")
    static let appTextDarkBlue = appTextPrimary
    
    @available(*, deprecated, renamed: "appBackgroundWarm")
    static let appViewBackground = appBackgroundWarm
    
    @available(*, deprecated, renamed: "appSurfaceCard")
    static let appCardBackground = appSurfaceCard
    
    @available(*, deprecated, renamed: "appSecondaryProgressBar")
    static let appSecondryProgressBar = appSecondaryProgressBar

}
