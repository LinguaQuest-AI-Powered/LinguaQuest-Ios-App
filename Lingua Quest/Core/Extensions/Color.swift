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
    static let appBrandPrimary = Color("TokenBrandPrimary")                        // Light & Dark #FF9F29
    static let appBrandBrown = Color("TokenBrandBrown")                            // Light #8A5100      Dark #D4944A
    static let appBrandBrownDark = Color("TokenBrandBrownDark")                    // Light & Dark #683D00
    
    // Backgrounds & Surfaces
    static let appBackgroundPrimary = Color("TokenBackgroundPrimary")              // Light #F3FAFF      Dark #1C2B3A
    static let appBackgroundWarm = Color("TokenBackgroundWarm")                    // Light #FEF8F0      Dark #0D1B2A
    static let appSurfaceCard = Color("TokenSurfaceCard")                          // Light #FFFFFF      Dark #1C2B3A
    static let appSurfaceCardWarm = Color("TokenSurfaceCardWarm")                  // Light #F9F3EB      Dark #1E2D3D
    static let appSurfaceNavBar = Color("TokenSurfaceNavBar")                      // Light #FFF8F5      Dark #152232
    static let appSurfaceCardMuted = Color("TokenSurfaceCardMuted")                // Light #E7E2DA      Dark #263545
    
    // Borders
    static let appBorderBrown = Color("TokenBorderBrown")                          // Light #DBC2AD      Dark #3A4F5E
    static let appBorderCool = Color("TokenBorderCool")                            // Light #CFE6F2      Dark #2A3F50
    static let appBorderLight = Color("TokenBorderLight")                          // Light #F1DFD1      Dark #2A3F50
    
    // Text
    static let appTextPrimary = Color("TokenTextPrimary")                          // Light #071E27      Dark #E0EBF5
    static let appTextSlate = Color("TokenTextSlate")                              // Light #1E293B      Dark #CBD5E1
    static let appTextHeading = Color("TokenTextHeading")                          // Light #231A11      Dark #F5EDE4
    static let appTextSecondary = Color("TokenTextSecondary")                      // Light #554434      Dark #D9CDBF
    
    // Accents & Icons
    static let appSemanticSuccess = Color("TokenSemanticSuccess")                  // Light #006B5C      Dark #00917A
    static let appGlowTeal = Color("TokenGlowTeal")                                // Light #68FADD      Dark #4ADBC0
    static let appGlowGold = Color("TokenGlowGold")                                // Light #D0AE00      Dark #B89800
    static let appIconBrown = Color("TokenIconBrown")                              // Light #887361      Dark #C4A882
    static let appTextOnPrimary = Color("TokenTextOnPrimary")                      // Light & Dark #FFFFFF
    static let appAccentGold = Color("TokenAccentGold")                            // Light #F59E0B      Dark #FBBF24
    static let appAccentRed = Color("TokenAccentRed")                              // Light #F43F5E      Dark #FB7185
    static let appAccentStreakRed = Color("TokenAccentStreakRed")                  // Light #BF0025      Dark #E63956

    static let appBadgeTealBg = Color("TokenBadgeTealBg")                          // Light #70F8E8      Dark #1A4A44
    static let appBadgeTealText = Color("TokenBadgeTealText")                      // Light #007168      Dark #5EECD8
    static let appAccentTeal = Color("TokenAccentTeal")                            // Light #006B59      Dark #00917A
    static let appAccentOrange = Color("TokenAccentOrange")                        // Light #FF9900      Dark #FFB340
    static let appAccentActiveLevel = Color("TokenAccentActiveLevel")              // Light #7BF4FF      Dark #2FB7C4
    
    // MARK: - Additional Custom Tokens
    static let appEmptyCircleBg = Color("TokenEmptyCircleBg")                      // Light #F2FAF2      Dark #1A2E28
    static let appEmptyStateSubtitle = Color("TokenEmptyStateSubtitle")            // Light #666666      Dark #A3A3A3
    static let appEmptyStateTitle = Color("TokenEmptyStateTitle")                  // Light #594D40      Dark #D9CDBF
    static let appHeaderBirdCircleBg = Color("TokenHeaderBirdCircleBg")            // Light #FFC785      Dark #4D3A24
    static let appHeaderTitleDark = Color("TokenHeaderTitleDark")                  // Light #262626      Dark #E6E6E6
    static let appRed = Color("TokenRed")                                          // Light #CC4D4D      Dark #E66666
    static let appTealGreen = Color("TokenTealGreen")                              // Light #338073      Dark #4DB3A2
    static let appTextSelectedBrown = Color("TokenTextSelectedBrown")              // Light #66330D      Dark #3D1F08
    static let appTextUnselectedBrown = Color("TokenTextUnselectedBrown")          // Light #4D4033      Dark #B3A699
    static let appCardImageBackground = Color("TokenCardImageBackground")          // Light #E6D9CC      Dark #2A3340
    static let appTextDarkGray = Color("TokenTextDarkGray")                        // Light #4D4D4D      Dark #B3B3B3
    static let appProgressBar = Color("TokenFirstProgressBar")                     // Light #006B5F      Dark #00F2D1
    static let appSecondaryProgressBar = Color("TokenSecondaryProgressBar")        // Light #FEEADC      Dark #343150
    
    // Outline Button
    static let appOutlineButton = Color("TokenOutlineButton")                      // Light & Dark #2DD4BF
    
    // Glow
    static let appGlowOrange = Color("TokenGlowOrange")                            // Light #FFF0B3      Dark #FFE680
    static let appGlowRed = Color("TokenGlowRed")                                  // Light #FFC2D1      Dark #FFA3B5
    
    // MARK: - Leaderboard Colors
    static let appPodiumGold = Color("TokenPodiumGold")                            // Light & Dark #D8B233
    static let appPodiumBronze = Color("TokenPodiumBronze")                        // Light & Dark #B27F33
    static let appPodiumBrownText = Color("TokenPodiumBrownText")                  // Light & Dark #663319
    static let appLeaderboardDarkText = Color("TokenLeaderboardDarkText")          // Light & Dark #333333
    static let appLeaderboardBackground = Color("TokenLeaderboardBackground")      // Light & Dark #F9F2EA
}
