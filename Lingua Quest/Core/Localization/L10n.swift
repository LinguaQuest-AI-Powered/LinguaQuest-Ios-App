//
//  L10n.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import Foundation

enum L10n {

    enum Network {
        static var invalidURL: String { localized("network.error.invalid_url") }
        static var noConnection: String { localized("network.error.no_connection") }
        static var decodingFailed: String { localized("network.error.decoding_failed") }
        static var unauthorized: String { localized("network.error.unauthorized") }
        static var unknown: String { localized("network.error.unknown") }
        static func serverError(statusCode: Int) -> String {
            String(format: localized("network.error.server_error"), statusCode)
        }
    }

    enum Common {
        static var retry: String { localized("common.retry") }
        static var cancel: String { localized("common.cancel") }
        static var ok: String { localized("common.ok") }
    }

    enum Auth {
        static var emailPlaceholder: String { localized("auth.email_placeholder") }
        static var passwordPlaceholder: String { localized("auth.password_placeholder") }
        static var continueWithGoogle: String { localized("auth.continue_google") }
        static var continueWithApple: String { localized("auth.continue_apple") }
        static var welcomeBack: String { localized("auth.welcome_back") }
        static var readyToContinue: String { localized("auth.ready_to_continue") }
        static var forgotPassword: String { localized("auth.forgot_password") }
        static var logIn: String { localized("auth.log_in") }
        static var orContinueWith: String { localized("auth.or_continue_with") }
        static var newHere: String { localized("auth.new_here") }
        static var signUp: String { localized("auth.sign_up") }
        
        static var createYourAccount: String { localized("auth.create_your_account") }
        static var createAccountDescription: String { localized("auth.create_account_description") }
        static var usernamePlaceholder: String { localized("auth.username_placeholder") }
        static var confirmPasswordPlaceholder: String { localized("auth.confirm_password_placeholder") }
        static var createAccount: String { localized("auth.create_account") }
        static var alreadyHaveAccount: String { localized("auth.already_have_account") }
        
        static var forgetPassword: String { localized("auth.forget_password") }
        static var forgetPasswordDesc: String { localized("auth.forget_password_desc") }
        static var enterEmail: String { localized("auth.enter_email") }
        static var sendResetLink: String { localized("auth.send_reset_link") }
        static var backToLogin: String { localized("auth.back_to_login") }
        
        static var newPasswordTitle: String { localized("auth.new_password_title") }
        static var newPasswordDesc: String { localized("auth.new_password_desc") }
        static var newPasswordLabel: String { localized("auth.new_password_label") }
        static var newPasswordPlaceholder: String { localized("auth.new_password_placeholder") }
        static var passwordStrength: String { localized("auth.password_strength") }
        static var confirmNewPasswordLabel: String { localized("auth.confirm_new_password_label") }
        static var confirmNewPasswordPlaceholder: String { localized("auth.confirm_new_password_placeholder") }
        static var resetPassword: String { localized("auth.reset_password") }
        
        static var verifyYourEmail: String { localized("auth.verify_your_email") }
        static var verifyEmailDesc: String { localized("auth.verify_email_desc") }
        static var resendCode: String { localized("auth.resend_code") }
        static var verify: String { localized("auth.verify") }
        static var googleLabel: String { localized("auth.google_label") }
        static var appleLabel: String { localized("auth.apple_label") }
    }
    
    enum Components {
        static var appName: String { localized("components.app_name") }
    }
    enum Onboarding {
        static var beginnerTitle: String { localized("onboarding.level.beginner.title") }
        static var intermediateTitle: String { localized("onboarding.level.intermediate.title") }
        static var advancedTitle: String { localized("onboarding.level.advanced.title") }
        static var beginnerDescription: String { localized("onboarding.level.beginner.description") }
        static var intermediateDescription: String { localized("onboarding.level.intermediate.description") }
        static var advancedDescription: String { localized("onboarding.level.advanced.description") }
        static var languageEnglish: String { localized("onboarding.language.english") }
        static var languageSpanish: String { localized("onboarding.language.spanish") }
        static var languageFrench: String { localized("onboarding.language.french") }
        static var languageGerman: String { localized("onboarding.language.german") }
        static var languageJapanese: String { localized("onboarding.language.japanese") }
        static var languagePickerTitle: String { localized("onboarding.language_picker.title") }
        static var languageSelectorISpeak: String { localized("onboarding.language_selector.i_speak") }
        static var languageSelectorPlaceholder: String { localized("onboarding.language_selector.placeholder") }
        static var languageStepTitle: String { localized("onboarding.language_step.title") }
        static var languageStepSubtitle: String { localized("onboarding.language_step.subtitle") }
        static var languageStepIWantToLearn: String { localized("onboarding.language_step.i_want_to_learn") }
        static var searchLanguage: String { localized("onboarding.search_language") }
        static var commonContinue: String { localized("onboarding.common.continue") }
        static var levelStepTitle: String { localized("onboarding.level_step.title") }
        static var levelStepSubtitle: String { localized("onboarding.level_step.subtitle") }
        static var welcomeTitlePart1: String { localized("onboarding.welcome.title_part1") }
        static var welcomeTitlePart2: String { localized("onboarding.welcome.title_part2") }
        static var welcomeGetStarted: String { localized("onboarding.welcome.get_started") }
        static var welcomeAlreadyHaveAccount: String { localized("onboarding.welcome.already_have_account") }
        static var alertErrorTitle: String { localized("onboarding.alert.error_title") }
        static var alertLanguageMessage: String { localized("onboarding.alert.language_message") }
        static var alertLevelMessage: String { localized("onboarding.alert.level_message") }
    }
    
    enum Game {
        static var parkWorld: String { localized("game.park_world") }
        static var letsLearn: String { localized("game.lets_learn") }
        static func levelTitle(_ level: Int) -> String { String(format: localized("game.level_title"), "\(level)") }
        static var tapForHelp: String { localized("game.tap_for_help") }
        static func scanInstruction(_ word: String) -> String { String(format: localized("game.scan_instruction"), word) }
        static var openCamera: String { localized("game.open_camera") }
        static var skip: String { localized("game.skip") }
    }
    
    enum Gallery {
        static var myCaptures: String { localized("gallery.my_captures") }
        static func objectsCollected(_ count: Int) -> String {
            String(format: localized("gallery.objects_collected"), count)
        }
        static var capturesSoFar: String { localized("gallery.captures_so_far") }
        static var addNew: String { localized("gallery.add_new") }
        static var noCapturesYet: String { localized("gallery.no_captures_yet") }
        static var noCapturesSubtitle: String { localized("gallery.no_captures_subtitle") }
        
        enum Categories {
            static var allItems: String { localized("gallery.categories.all_items") }
            static var kitchen: String { localized("gallery.categories.kitchen") }
            static var park: String { localized("gallery.categories.park") }
            static var street: String { localized("gallery.categories.street") }
        }
    }

    enum Home {
        static var exploreWorlds: String { localized("home.explore_worlds") }
        static var seeMore: String { localized("home.see_more") }
        static var currentlyLearning: String { localized("home.currently_learning") }
        static func level(_ count: Int) -> String { String(format: localized("home.level"), count) }
        static func daysStreak(_ days: Int) -> String { String(format: localized("home.days_streak"), days) }
        static var progress: String { localized("home.progress") }
        static var continueLessonTitle: String { localized("home.continue_lesson") }
        static var continueButton: String { localized("home.continue") }
        static var lessonApple: String { localized("home.lesson.apple") }
        static var lessonAppleDesc: String { localized("home.noun_la_pomme") }
        static var kitchenWorld: String { localized("home.kitchen_world") }
        static var cityWorld: String { localized("home.city_world") }
        static var difficultyEasy: String { localized("home.difficulty.easy") }
        static var difficultyMedium: String { localized("home.difficulty.medium") }
        static var dailyStreakBonus: String { localized("home.daily_streak_bonus") }
        static var claimDailyReward: String { localized("home.claim_daily_reward") }
    }

    private static func localized(_ key: String) -> String {
        return String(localized: String.LocalizationValue(key))
    }
}
