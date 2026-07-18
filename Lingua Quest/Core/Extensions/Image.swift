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
        case timer = "timer"
        case chevronDown = "chevron.down"
        case cameraFill = "camera.fill"
        case photoBadgePlus = "photo.badge.plus"
        case photo = "photo"
        case checkmark = "checkmark"
        case xmark = "xmark"
    }
    
    enum Asset: String {
        case appBackground = "app_background"
        case dialogMascot = "image"
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
        case emptyGalleryBird = "empty_gallery_bird"
        case star = "star"
        case star2 = "star2"
        case ball = "ball"
        case xpIcon = "xp_icon"
        case coinsIcon = "coins_icon"
        case onboardingbackground = "onboarding"
        case english = "English"
        case french = "French"
        case spanish = "Spanish"
        case german = "German"
        case japanease = "Japanese"
        case advanced = "advanced"
        case intermediate = "intermediate"
        case beginner = "beginner"
        case apple = "apple"
        case table = "table"
        case leaf = "leaf"
        case cup = "cup"
        case bicycle = "bicycle"
        case dog = "dog"
        
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
