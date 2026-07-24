//
//  Image.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

extension Image {
    
  
    enum Icon: String {
        case google = "googleIcon"
        case apple = "appleIcon"
    }
    
    enum SystemIcon: String {
        case eyeFill = "eye.fill"
        case eyeSlashFill = "eye.slash.fill"
        case lockFill = "lock.fill"
        case keyFill = "key.horizontal.fill"
        case envelopeFill = "envelope.fill"
        case arrowRight = "arrow.right"
        case arrowLeft = "arrow.left"
        case personFill = "person.fill"
        case chevronLeft = "chevron.left"
        case checkmarkCircleFill = "checkmark.circle.fill"
        case checkmark = "checkmark"
        case timer = "timer"
        case chevronDown = "chevron.down"
        case cameraFill = "camera.fill"
        case dollarsignCircleFill = "dollarsign.circle.fill"
        case speakerWave2Fill = "speaker.wave.2.fill"
        case photoBadgePlus = "photo.badge.plus"
        case photo = "photo"
        case xmark = "xmark"
        case magnifyingglass = "magnifyingglass"
        case houseFill = "house.fill"
        case photoOnRectangle = "photo.on.rectangle"
        case exclamationmarkTriangleFill = "exclamationmark.triangle.fill"
        case bookFill = "book.fill"

        case play = "play.fill"
        case sparkles = "sparkles"
        case rightChevron = "chevron.right"
        case gift = "gift"
        case pencil = "pencil"
        case personCropCircleFill = "person.crop.circle.fill"
        case starCircleFill = "star.circle.fill"
        case flameFill = "flame.fill"
        case globeAmericasFill = "globe.americas.fill"
        case globe = "globe"
        case birdFill = "bird.fill"
        case diamondFill = "diamond.fill"
        case medalFill = "medal.fill"
        case trophyFill = "trophy.fill"
        case starFill = "star.fill"
        case rosette = "rosette"
        case boltFill = "bolt.fill"
        case boltSlashFill = "bolt.slash.fill"
        case cameraRotateFill = "camera.rotate.fill"
        case lightbulbFill = "lightbulb.fill"
        case target = "target"
        case bellFill = "bell.fill"
        case moonFill = "moon.fill"
        case sliderHorizontal3 = "slider.horizontal.3"
        case questionmarkCircleFill = "questionmark.circle.fill"
        case infoCircleFill = "info.circle.fill"
        case speakerSlashFill = "speaker.slash.fill"
        case forwardFill = "forward.fill"
        case forwardEndFill = "forward.end.fill"
        case micFill = "mic.fill"
        case pauseFill = "pause.fill"
        case trash = "trash"
        case checkmarkCircle = "checkmark.circle"
        
        // Added for Edit Profile
        case person = "person"
        case squareAndPencil = "square.and.pencil"
        case infoCircle = "info.circle"
        case textformatAlt = "textformat.alt"
        
        // Added for Widget
        case handTapFill = "hand.tap.fill"
        case characterBookClosedFill = "character.book.closed.fill"
    }
    
    enum Asset: String {
        case appBackground = "app_background"
        case linquaQuest = "linguaQuest"
        case bird = "bird"
        case bird2 = "bird2"
        case bird3 = "bird3"
        case onBoardingFirstBird = "onBoardingBird"
        case onBoardingBottomSVG = "onBoardingSVG"
        case loginBird = "login_bird"
        case registerationBird = "registeration_bird"
        case forgetPasswordBird = "forget_pass_bird"
        case verifyEmailBird = "verify_email_bird"
        case resetPasswordBird = "reset_pass_bird"
        case weakPasswordBird = "weak_pass_bird"
        case strongPasswordBird = "strong_pass_bird"
        case myCaptureBird = "my_capture_bird"
        case leaderBoardBird = "leader_board_bird"
        case achivementBird = "achivement_bird"
        case star = "star"
        case star2 = "star2"
        case ball = "ball"
        case xpIcon = "xp_icon"
        case coinsIcon = "coins_icon"
        case onboardingbackground = "onboarding"
        case advanced = "advanced"
        case intermediate = "intermediate"
        case beginner = "beginner"
        case gameLevelBackground = "GameLevelBackground"
        case homeBackground = "LinguaQuestHome"
        case english = "English"
        case french = "French"
        case spanish = "Spanish"
        case german = "German"
        case japanease = "Japanese"
        case apple = "apple"
        case table = "table"
        case leaf = "leaf"
        case cup = "cup"
        case bicycle = "bicycle"
        case dog = "dog"
        case kitchen = "kitchen_world"
        case city = "city_world"
        case appleLogo = "appleLogo"
        case appBarBird = "appBarBird"
        case chooseLanguageBird = "choose_language_bird"
        case logoutBird = "logout_bird"
        case world = "world_icon"
        case birdIdea = "BirdIdea"
        case user1 = "user1"
        case user2 = "user2"
        case user3 = "user3"
        case mascotSettings = "mascot_settings"
        case mascotReward = "mascot_reward"
        case notEnoughCoins = "NotEnoughCoins"
        case skip = "Skip"
        case perfect = "perfect"
        case micBird = "Mic"
        case emptyGallary = "emptyGallary"
    }
    
    init(icon: Icon) {
        self.init(icon.rawValue)
    }
    
    init(asset: Asset) {
        self.init(asset.rawValue)
    }
    
    init(systemIcon: SystemIcon) {
        self.init(systemName: systemIcon.rawValue)
    }
}
