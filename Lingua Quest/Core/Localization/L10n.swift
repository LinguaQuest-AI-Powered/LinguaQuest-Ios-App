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
        static var offlineTitle: String { localized("network.error.offline_title") }
        static var offlineSubtitle: String { localized("network.error.offline_subtitle") }
        static var encodingFailed: String { localized("network.error.encoding_failed") }
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
        static var loading: String { localized("common.loading") }
        static var error: String { localized("common.error") }
        static var errorOccurred: String { localized("common.error_occurred") }
        static var goBack: String { localized("common.go_back") }
        static var openSettings: String { localized("common.open_settings") }
        static var remove: String { localized("common.remove") }
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
        static var verifyResetCodeTitle: String { localized("auth_verify_reset_code_title") }
        static var verifyResetCodeDesc: String { localized("auth_verify_reset_code_desc") }
        static var otpSentTitle: String { localized("auth.otp_sent_title") }
        static var otpSentDesc: String { localized("auth.otp_sent_desc") }
        
        enum Error {
            static var invalidCredentials: String { localized("auth_error_invalid_credentials") }
            static var emailNotVerified: String { localized("auth_error_email_not_verified") }
            static var emailAlreadyExists: String { localized("auth_error_email_already_exists") }
            static var usernameAlreadyTaken: String { localized("auth_error_username_already_taken") }
            static var emailNotFound: String { localized("auth_error_email_not_found") }
            static var invalidOtp: String { localized("auth_error_invalid_otp") }
            static var otpNotFound: String { localized("auth_error_otp_not_found") }
            static var otpCooldown: String { localized("auth_error_otp_cooldown") }
            static var maxOtpAttemptsExceeded: String { localized("auth_error_max_otp_attempts") }
            static var invalidResetToken: String { localized("auth_error_invalid_reset_token") }
            static var sessionExpired: String { localized("auth_error_session_expired") }
            static var invalidFirebaseToken: String { localized("auth_error_invalid_firebase_token") }
            static var internalServerError: String { localized("auth_error_internal_server") }
            static var generic: String { localized("auth_error_generic") }
            static var passwordsDoNotMatch: String { localized("auth_error_passwords_do_not_match") }
            static var missingOnboardingLanguages: String { localized("auth_error_missing_onboarding_languages") }
            static var invalidOtpLength: String { localized("auth_error_invalid_otp_length") }
            static var emailRequired: String { localized("auth_error_email_required") }
            static var weakPassword: String { localized("auth_error_weak_password") }
            static var emailAndPasswordRequired: String { localized("auth_error_email_and_password_required") }
            static var allFieldsRequired: String { localized("auth_error_all_fields_required") }
            static var invalidEmailFormat: String { localized("auth_error_invalid_email_format") }
            static var invalidUsernameFormat: String { localized("auth_error_invalid_username_format") }
            static var oauthProfileSetupComingSoon: String { localized("auth_error_oauth_profile_setup_coming_soon") }
            static var oauthCancelledOrFailed: String { localized("auth_error_oauth_cancelled_or_failed") }
        }
    }
    
    enum Components {
        static var appName: String { localized("components.app_name") }
    }
    
    enum Tabs {
        static var home: String { localized("tabs.home") }
        static var gallery: String { localized("tabs.gallery") }
        static var profile: String { localized("tabs.profile") }
        static var lingos: String { localized("tabs.lingos") }
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
        static var find: String { localized("game.find") }
        static var openCamera: String { localized("game.open_camera") }
        static var skip: String { localized("game.skip") }
        static var noAvailableLevels: String { localized("game.no_available_levels") }
        static var needHintTitle: String { localized("game.need_hint_title") }
        static var hintRevealFirstLetter: String { localized("game.hint.reveal_first_letter") }
        static var hintShowCategoryClue: String { localized("game.hint.show_category_clue") }
        static var hintGetHint: String { localized("game.hint.get_hint") }
        static var useHint: String { localized("game.hint.use") }
        static var hintRevealFirstLetterMock: String { localized("game.hint.reveal_first_letter_mock") }
        static var hintShowCategoryClueMock: String { localized("game.hint.show_category_clue_mock") }
        static var notQuite: String { localized("game.result.not_quite") }
        static func didntSeeItem(_ item: String) -> String { String(format: localized("game.result.didnt_see_item"), item) }
        static var makeSureLit: String { localized("game.result.make_sure_lit") }
        static var retryCamera: String { localized("game.result.retry_camera") }
        static var changeWord: String { localized("game.result.change_word") }
        static var perfect: String { localized("game.result.perfect") }
        static var youFoundIt: String { localized("game.result.you_found_it") }
        static var nextLevel: String { localized("game.result.next_level") }
        static var analyzing: String { localized("game.result.analyzing") }
        static var analyzingSubtitle: String { localized("game.result.analyzing_subtitle") }
        static var noImageData: String { localized("game.result.no_image_data") }
        static func xpPoints(_ points: Int) -> String { String(format: localized("game.result.xp_points"), points) }
        static func coinsValue(_ points: Int) -> String { String(format: localized("game.result.coins_value"), points) }
        static func levelProgress(_ level: Int) -> String { String(format: localized("game.result.level_progress"), level) }
        static var notEnoughCoinsTitle: String { localized("game.not_enough_coins.title") }
        static var notEnoughCoinsSubtitle: String { localized("game.not_enough_coins.subtitle") }
        static var currentBalance: String { localized("game.not_enough_coins.current_balance") }
        static var missingBalance: String { localized("game.not_enough_coins.missing_balance") }
        static var getMoreCoins: String { localized("game.not_enough_coins.get_more") }
        static var skipWordTitle: String { localized("game.skip_word.title") }
        static func skipWordSubtitle(_ coins: Int) -> String { String(format: localized("game.skip_word.subtitle"), coins) }
        static var skipWordAction: String { localized("game.skip_word.action") }
    }
    
    enum DailyMission {
        static var title: String { localized("daily_mission.title") }
        static var subtitle: String { localized("daily_mission.subtitle") }
        static var captureNow: String { localized("daily_mission.capture_now") }
        static var completed: String { localized("daily_mission.completed") }
        static var notAvailable: String { localized("daily_mission.not_available") }
        static var notAvailableSubtitle: String { localized("daily_mission.not_available_subtitle") }
        static var findWord: String { localized("daily_mission.find_word") }
        static var analyzing: String { localized("daily_mission.analyzing") }
        static var analyzingSubtitle: String { localized("daily_mission.analyzing_subtitle") }
        static var successTitle: String { localized("daily_mission.success_title") }
        static var successSubtitle: String { localized("daily_mission.success_subtitle") }
        static var failTitle: String { localized("daily_mission.fail_title") }
        static func failSubtitle(_ word: String) -> String { String(format: localized("daily_mission.fail_subtitle"), word) }
        static var tryAgain: String { localized("daily_mission.try_again") }
        static var later: String { localized("daily_mission.later") }
        static var backToHome: String { localized("daily_mission.back_to_home") }
        static var alreadySolvedTitle: String { localized("daily_mission.already_solved_title") }
        static var alreadySolvedSubtitle: String { localized("daily_mission.already_solved_subtitle") }
        static var rewardXP: String { localized("daily_mission.reward_xp") }
        static var rewardCoins: String { localized("daily_mission.reward_coins") }
        static var noImageData: String { localized("daily_mission.no_image_data") }
        static var retryButton: String { localized("daily_mission.retry") }
    }
    
    enum Gallery {
        static var myJournal: String { localized("gallery.my_journal") }
        static var myCaptures: String { localized("gallery.my_captures") }
        static var capturesTab: String { localized("gallery.tab.captures") }
        static var wordsTab: String { localized("gallery.tab.words") }
        static var filterAll: String { localized("gallery.filter.all") }
        static func objectsCollected(_ count: Int) -> String {
            String(format: localized("gallery.objects_collected"), count)
        }
        static var capturesSoFar: String { localized("gallery.captures_so_far") }
        static var addNew: String { localized("gallery.add_new") }
        static var noCapturesYet: String { localized("gallery.no_captures_yet") }
        static var noCapturesSubtitle: String { localized("gallery.no_captures_subtitle") }
        static var emptyFilterWordsTitle: String { localized("gallery.empty.filter.words.title") }
        static var emptyFilterWordsSubtitle: String { localized("gallery.empty.filter.words.subtitle") }
        static var emptyFilterItemsTitle: String { localized("gallery.empty.filter.items.title") }
        static var emptyFilterItemsSubtitle: String { localized("gallery.empty.filter.items.subtitle") }
        
        enum Categories {
            static var allItems: String { localized("gallery.categories.all_items") }
            static var kitchen: String { localized("gallery.categories.kitchen") }
            static var park: String { localized("gallery.categories.park") }
            static var street: String { localized("gallery.categories.street") }
            static var words: String { localized("gallery.categories.words") }
        }
    }

    enum Home {
        static var exploreWorlds: String { localized("home.explore_worlds") }
        static var seeMore: String { localized("home.see_more") }
        static var currentlyLearning: String { localized("home.currently_learning") }
        static func level(_ count: Int) -> String { String(format: localized("home.level"), count) }
        static func daysStreak(_ days: Int) -> String { String(format: localized("home.days_streak"), days) }
        static var progress: String { localized("home.progress") }
        static var start: String { localized("home.start") }
        static var voicePracticeTitle: String { localized("home.voice_practice_title") }
        static var voicePracticeSubtitle: String { localized("home.voice_practice_subtitle") }
        static func voicePracticeProgress(completed: Int, total: Int) -> String {
            String(format: localized("home.voice_practice_progress"), completed, total)
        }
        static var continueLessonTitle: String { localized("home.continue_lesson") }
        static var continueButton: String { localized("home.continue") }
        static var featureAiChat: String { localized("home.feature_ai_chat") }
        static var featureSpeaking: String { localized("home.feature_speaking") }
        static var practiceAndLearn: String { localized("home.practice_and_learn") }
        static var lessonApple: String { localized("home.lesson.apple") }
        static var lessonAppleDesc: String { localized("home.noun_la_pomme") }
        static var kitchenWorld: String { localized("home.kitchen_world") }
        static var cityWorld: String { localized("home.city_world") }
        static var difficultyEasy: String { localized("home.difficulty.easy") }
        static var difficultyMedium: String { localized("home.difficulty.medium") }
        static var difficultyHard: String { localized("home.difficulty.hard") }
        static var dailyStreakBonus: String { localized("home.daily_streak_bonus") }
        static var claimDailyReward: String { localized("home.claim_daily_reward") }
        static var dailyRewardTitle: String { localized("daily_reward.title") }
        static var dailyRewardSubtitle: String { localized("daily_reward.subtitle") }
        static var claimReward: String { localized("daily_reward.claim") }
                
        static func dailyRewardCoinsFormat(_ amount: Int) -> String {
            String(format: localized("daily_reward.coins_format"), amount)
        }
                
        static func dayFormat(_ day: Int) -> String {
            String(format: localized("daily_reward.day_format"), day)
        }
        
        static func unlockAtLevel(_ level: Int) -> String {
            String(format: localized("home.unlock_at_level"), level)
        }
        
        static var myLanguagesTitle: String { localized("home.my_languages_title") }
        static var addNewLanguage: String { localized("home.add_new_language") }
        static var removeLanguageTitle: String { localized("home.remove_language_title") }
        static var removeLanguageMessage: String { localized("home.remove_language_message") }
        
        static var aiChatTitle: String { localized("home.ai_chat_title") }
        
        static var objectDetectionTitle: String { localized("home.object_detection_title") }
        static var objectDetectionSubtitle: String { localized("home.object_detection_subtitle") }
        static func objectDetectionProgress(completed: Int, total: Int) -> String {
            String(format: localized("home.object_detection_progress"), completed, total)
        }
        static var currentQuest: String { localized("home.current_quest") }
        static var findAndCapture: String { localized("home.find_and_capture") }
        static func levelProgress(current: Int, total: Int) -> String {
            String(format: localized("home.level_progress"), current, total)
        }
    }
    
    enum Profile {
        static var title: String { localized("profile.title") }
        static var coins: String { localized("profile.stats.coins") }
        static var totalXP: String { localized("profile.stats.total_xp") }
        static var streak: String { localized("profile.stats.streak") }
        static var worlds: String { localized("profile.stats.worlds") }
        static var viewAll: String { localized("profile.view_all") }
        static var achievementsTitle: String { localized("profile.achievements.title") }
        static var topExplorersTitle: String { localized("profile.top_explorers.title") }
        static var settingsCardTitle: String {
            localized("profile.settingsCardTitle")
        }
        static var settingsCardSubtitle: String {
            localized("profile.settingsCardSubtitle")
        }
        
        
        static func userLevel(_ level: Int) -> String {
            String(format: localized("profile.user_level"), level)
        }
        
        static func learningTitle(_ language: String) -> String {
            String(format: localized("profile.learning.title"), language)
        }
            
        static func xpToNextMilestone(current: Int, total: Int) -> String {
            String(format: localized("profile.learning.xp_progress"), current, total)
        }
        
        static func explorerXP(_ amount: String) -> String {
            String(format: localized("profile.leaderboard.xp"), amount)
        }
    }
    
    enum Settings {
        static var title: String { localized("settings.title") }
        static var subtitle: String { localized("settings.subtitle") }
        static func explorerName(_ name: String) -> String { String(format: localized("settings.explorer_name"), name) }
        static var accountJourney: String { localized("settings.account_journey") }
        static var editProfile: String { localized("settings.edit_profile") }
        static var learningLanguage: String { localized("settings.learning_language") }
        static var dailyGoal: String { localized("settings.daily_goal") }
        static var learningStreak: String { localized("settings.learning_streak") }
        static var appExperience: String { localized("settings.app_experience") }
        static var appLanguage: String { localized("settings.app_language") }
        static var notifications: String { localized("settings.notifications") }
        static var darkMode: String { localized("settings.dark_mode") }
        static var soundEffects: String { localized("settings.sound_effects") }
        static var privacySecurity: String { localized("settings.privacy_security") }
        static var helpSupport: String { localized("settings.help_support") }
        static var aboutApp: String { localized("settings.about_app") }
        static var saveChanges: String { localized("settings.save_changes") }
        static var logOut: String { localized("settings.log_out") }
        static var logOutConfirmation: String { localized("settings.log_out_confirmation") }
        static var chooseLanguage: String { localized("settings.choose_language") }
        
        static var dailyReminder: String { localized("settings.daily_reminder") }
        static var reminderTime: String { localized("settings.reminder_time") }
        static var repeatFrequency: String { localized("settings.repeat") }
        static var repeatEveryDay: String { localized("settings.repeat_every_day") }
        static var repeatWeekdays: String { localized("settings.repeat_weekdays") }
        static var repeatWeekends: String { localized("settings.repeat_weekends") }
        static var repeatCustom: String { localized("settings.repeat_custom") }
        
        static var notificationsEnabledToast: String { localized("settings.toast_notifications_enabled") }
        static var notificationsPausedToast: String { localized("settings.toast_notifications_paused") }
        static var selectReminderTime: String { localized("settings.select_reminder_time") }
    }
    
    enum LockScreenVocabulary {
        static var toggleLabel: String { localized("lock_screen_vocab.toggle_label") }
        static var activationTitle: String { localized("lock_screen_vocab.activation_title") }
        static var activationSubtitle: String { localized("lock_screen_vocab.activation_subtitle") }
        static var activateAction: String { localized("lock_screen_vocab.activate_action") }
        static var activatedToast: String { localized("lock_screen_vocab.activated_toast") }
        static var disabledToast: String { localized("lock_screen_vocab.disabled_toast") }
        static var tapToOpenAndListen: String { localized("lock_screen_vocab.tap_to_open_and_listen") }
    }
    
    enum WordInsight {
        static var title: String { localized("word_insight.title") }
        static var sentenceLabel: String { localized("word_insight.sentence_label") }
        static var exampleLabel: String { localized("word_insight.example") }
        static var translationLabel: String { localized("word_insight.translation_label") }
        static var memoryLabel: String { localized("word_insight.memory_label") }
        static var funFactLabel: String { localized("word_insight.fun_fact_label") }
        static var emptyResponseError: String { localized("word_insight.error.empty") }
        static var parsingError: String { localized("word_insight.error.parsing") }
    }

    enum Leaderboard {
        static var title: String { localized("leaderboard.title") }
        static var you: String { localized("leaderboard.you") }
    }

    enum Achievements {
        static var title: String { localized("achievements.title") }
        static var myTrophies: String { localized("achievements.my_trophies") }
        static var subtitle: String { localized("achievements.subtitle") }
        static var filterAll: String { localized("achievements.filter_all") }
        static var filterEarned: String { localized("achievements.filter_earned") }
        static var filterLocked: String { localized("achievements.filter_locked") }
        static var earnedLabel: String { localized("achievements.earned_label") }
        static var inProgressLabel: String { localized("achievements.in_progress_label") }
        static var xpGainedLabel: String { localized("achievements.xp_gained_label") }
        static var claimRewards: String { localized("achievements.claim_rewards") }
    }
    
    enum Worlds {
        static var filterAll: String { localized("worlds.filter.all") }
        static var allWorldsTitle: String { localized("worlds.all_worlds.title") }
        static var allWorldsSubtitle: String { localized("worlds.all_worlds.subtitle") }
        static var parkWorld: String { localized("worlds.park") }
        static var marketWorld: String { localized("worlds.market") }
        static var airportWorld: String { localized("worlds.airport") }
        static var schoolWorld: String { localized("worlds.school") }
        
        static func worldsCountFormat(_ count: Int) -> String {
            String(format: localized("worlds.count_format"), count)
        }
    }
    
    enum EditProfile {
        static var title: String { localized("edit_profile.title") }
        static var changePhoto: String { localized("edit_profile.change_photo") }
        static var displayName: String { localized("edit_profile.display_name") }
        static var displayNamePlaceholder: String { localized("edit_profile.display_name_placeholder") }
        static var tagline: String { localized("edit_profile.tagline") }
        static var taglinePlaceholder: String { localized("edit_profile.tagline_placeholder") }
        static var infoText: String { localized("edit_profile.info_text") }
        static var saveChanges: String { localized("edit_profile.save_changes") }
        static var cancel: String { localized("edit_profile.cancel") }
        static var choosePhotoSource: String { localized("edit_profile.choose_photo_source") }
        static var camera: String { localized("edit_profile.camera") }
        static var gallery: String { localized("edit_profile.gallery") }
        static var uploadingPhoto: String { localized("edit_profile.uploading_photo") }
        static var tabPersonalInfo: String { localized("edit_profile.tab_personal_info") }
        static var tabSecurity: String { localized("edit_profile.tab_security") }
        static var changePassword: String { localized("edit_profile.change_password") }
        static var oldPassword: String { localized("edit_profile.old_password") }
        static var oldPasswordPlaceholder: String { localized("edit_profile.old_password_placeholder") }
        static var newPassword: String { localized("edit_profile.new_password") }
        static var newPasswordPlaceholder: String { localized("edit_profile.new_password_placeholder") }
        static var newPasswordHint: String { localized("edit_profile.new_password_hint") }
    }


    enum AddLanguage {
        static var title: String { localized("add_language.title") }
        static var subtitle: String { localized("add_language.subtitle") }
        static var searchPlaceholder: String { localized("add_language.search_placeholder") }
        static var addSelectedFormat: (Int) -> String = { count in
            String(format: localized("add_language.add_selected_format"), count)
        }
        static var addSelected: String { localized("add_language.add_selected") }
        static var emptyAllAddedTitle: String { localized("add_language.empty_all_added_title") }
        static var emptyAllAddedSubtitle: String { localized("add_language.empty_all_added_subtitle") }
        static var emptySearchTitle: String { localized("add_language.empty_search_title") }
        static var emptySearchSubtitle: String { localized("add_language.empty_search_subtitle") }
    }

    enum SpeakingLab {
        static func lessonTitle(_ number: Int) -> String { String(format: localized("speaking_lab.lesson_title"), number) }
        static var voicePractice: String { localized("speaking_lab.voice_practice") }
        static var youCanDoIt: String { localized("speaking_lab.you_can_do_it") }
        static var listening: String { localized("speaking_lab.listening") }
        static var pronounceThis: String { localized("speaking_lab.pronounce_this") }
        static var listen: String { localized("speaking_lab.listen") }
        static var tapAndHoldToRecord: String { localized("speaking_lab.tap_and_hold_to_record") }
        static var recording: String { localized("speaking_lab.recording") }
        static var mockTargetSentence: String { localized("speaking_lab.mock_target_sentence") }
        static var reviewRecording: String { localized("speaking_lab.review_recording") }
        static var reviewRecordingSubtitle: String { localized("speaking_lab.review_recording_subtitle") }
        static var discard: String { localized("speaking_lab.discard") }
        static var process: String { localized("speaking_lab.process") }
        static var rating: String { localized("speaking_lab.rating") }
        static var continueTitle: String { localized("speaking_lab.continue_title") }
        static var returnHome: String { localized("speaking_lab.return_home") }
        static var retry: String { localized("speaking_lab.retry") }
        static var feedbackGreatJob: String { localized("speaking_lab.feedback_great_job") }
        static var feedbackNeedsWork: String { localized("speaking_lab.feedback_needs_work") }
        static var pronunciationCheck: String { localized("speaking_lab.pronunciation_check") }
        static var score: String { localized("speaking_lab.score") }
        static var evaluatingTitle: String { localized("speaking_lab.evaluating_title") }
        static var evaluatingSubtitle: String { localized("speaking_lab.evaluating_subtitle") }
        static var loadingSentences: String { localized("speaking_lab.loading_sentences") }
        static var failedToLoad: String { localized("speaking_lab.failed_to_load") }
    }

    enum BossLevel {
        static var title: String { localized("boss_level.title") }
        static var statusConnecting: String { localized("boss_level.status_connecting") }
        static var statusConnected: String { localized("boss_level.status_connected") }
        static var statusDisconnected: String { localized("boss_level.status_disconnected") }
        static var statusSpeaking: String { localized("boss_level.status_speaking") }
        static var statusListening: String { localized("boss_level.status_listening") }
        static var statusError: String { localized("boss_level.status_error") }
        static var tapToTalk: String { localized("boss_level.tap_to_talk") }
        static var aiIsThinking: String { localized("boss_level.ai_is_thinking") }
        static var holdToSpeak: String { localized("boss_level.hold_to_speak") }
        static var releaseToSend: String { localized("boss_level.release_to_send") }
        static var muteMic: String { localized("boss_level.mute_mic") }
        static var unmuteMic: String { localized("boss_level.unmute_mic") }
        static var endSession: String { localized("boss_level.end_session") }
        static var liveTranscript: String { localized("boss_level.live_transcript") }
        static var lingoPersona: String { localized("boss_level.lingo_persona") }
        static var connectionError: String { localized("boss_level.connection_error") }
        static var phase: String { localized("boss_level.phase") }
        static func meetBoss(_ name: String) -> String { String(format: localized("boss_level.meet_boss"), name) }
        static var yourGoal: String { localized("boss_level.your_goal") }
        static var readCarefully: String { localized("boss_level.read_carefully") }
        static var startRoleplay: String { localized("boss_level.start_roleplay") }
        static func objectivePrefix(_ obj: String) -> String { String(format: localized("boss_level.objective_prefix"), obj) }
        static var endPhase: String { localized("boss_level.end_phase") }
        static var timeoutFeedback: String { localized("boss_level.timeout_feedback") }
        static var interactiveRoleplays: String { localized("boss_level.interactive_roleplays") }
        static var interactiveScenarios: String { localized("boss_level.interactive_scenarios") }
        static var roleplayTag: String { localized("boss_level.roleplay_tag") }
        static var browseRoleplays: String { localized("boss_level.browse_roleplays") }
        static var finishStage: String { localized("boss_level.finish_stage") }
        static var finishStageTitle: String { localized("boss_level.finish_stage_title") }
        static var finishStageSubtitle: String { localized("boss_level.finish_stage_subtitle") }
        static var yesEvaluate: String { localized("boss_level.yes_evaluate") }
        static var keepTalking: String { localized("boss_level.keep_talking") }
        static var yourObjective: String { localized("boss_level.your_objective") }
        static var objectiveTitle: String { localized("boss_level.objective_title") }
        static var objectiveComplete: String { localized("boss_level.objective_complete") }
        static var objectiveFailed: String { localized("boss_level.objective_failed") }
        static func fluencyScore(_ score: Int) -> String { String(format: localized("boss_level.fluency_score"), score) }
        static var resultFinish: String { localized("boss_level.result_finish") }
        static var evaluating: String { localized("boss_level.evaluating") }
        static var evaluatingSubtitle: String { localized("boss_level.evaluating_subtitle") }
        static var resultVictory: String { localized("boss_level.result_victory") }
        static var resultStageFailed: String { localized("boss_level.result_stage_failed") }
        static var resultTryAgain: String { localized("boss_level.result_try_again") }
        static var outstanding: String { localized("boss_level.outstanding") }
        static var needsWork: String { localized("boss_level.needs_work") }
        static var overallFluency: String { localized("boss_level.overall_fluency") }
        static var grammar: String { localized("boss_level.grammar") }
        static var vocabulary: String { localized("boss_level.vocabulary") }
        static var whatWentWell: String { localized("boss_level.what_went_well") }
        static var areasToImprove: String { localized("boss_level.areas_to_improve") }
    }

    enum About {
        static var title: String { localized("about.title") }
        static var appName: String { localized("about.app_name") }
        static var subtitle: String { localized("about.subtitle") }
        static var missionTitle: String { localized("about.mission_title") }
        static var missionDescription: String { localized("about.mission_description") }
        static var featuresTitle: String { localized("about.features_title") }
        static var featureAiTitle: String { localized("about.feature_ai_title") }
        static var featureAiDesc: String { localized("about.feature_ai_desc") }
        static var featureCameraTitle: String { localized("about.feature_camera_title") }
        static var featureCameraDesc: String { localized("about.feature_camera_desc") }
        static var featureGameTitle: String { localized("about.feature_game_title") }
        static var featureGameDesc: String { localized("about.feature_game_desc") }
        static var communityTitle: String { localized("about.community_title") }
        static var rateApp: String { localized("about.rate_app") }
        static var instagram: String { localized("about.instagram") }
        static var website: String { localized("about.website") }
        static var privacyPolicy: String { localized("about.privacy_policy") }
        static var termsOfService: String { localized("about.terms_of_service") }
        static var licenses: String { localized("about.licenses") }
        static var copyright: String { localized("about.copyright") }
        static var madeWithLove: String { localized("about.made_with_love") }
        static var licensesTitle: String { localized("about.licenses_title") }
        static var licensesDescription: String { localized("about.licenses_description") }
    }

    enum HelpSupport {
        static var title: String { localized("help_support.title") }
        static var contactUs: String { localized("help_support.contact_us") }
        static var faq: String { localized("help_support.faq") }
        static var reportBug: String { localized("help_support.report_bug") }
        static var communityForum: String { localized("help_support.community_forum") }
        static var greeting: String { localized("help_support.greeting") }
        static var stillNeedHelp: String { localized("help_support.still_need_help") }
        static var replyTime: String { localized("help_support.reply_time") }
        static var bugReportSubject: String { localized("help_support.bug_report_subject") }
        static var bugReportBody: String { localized("help_support.bug_report_body") }
        
        enum FAQ {
            static var q1: String { localized("help_support.faq.q1") }
            static var a1: String { localized("help_support.faq.a1") }
            static var q2: String { localized("help_support.faq.q2") }
            static var a2: String { localized("help_support.faq.a2") }
            static var q3: String { localized("help_support.faq.q3") }
            static var a3: String { localized("help_support.faq.a3") }
            static var q4: String { localized("help_support.faq.q4") }
            static var a4: String { localized("help_support.faq.a4") }
        }
    }

    enum Tutorial {
        static var learningProgressTitle: String { localized("tutorial.learning_progress.title") }
        static var learningProgressDesc: String { localized("tutorial.learning_progress.desc") }
        static var currentLessonTitle: String { localized("tutorial.current_lesson.title") }
        static var currentLessonDesc: String { localized("tutorial.current_lesson.desc") }
        static var coinsTitle: String { localized("tutorial.coins.title") }
        static var coinsDesc: String { localized("tutorial.coins.desc") }
        static var xpTitle: String { localized("tutorial.xp.title") }
        static var xpDesc: String { localized("tutorial.xp.desc") }
        static var notificationsTitle: String { localized("tutorial.notifications.title") }
        static var notificationsDesc: String { localized("tutorial.notifications.desc") }
        static var skip: String { localized("tutorial.skip") }
        static var next: String { localized("tutorial.next") }
        static var done: String { localized("tutorial.done") }
        
        static var exploreWorldsTitle: String { localized("tutorial.explore_worlds.title") }
        static var exploreWorldsDesc: String { localized("tutorial.explore_worlds.desc") }
        static var switchLanguageTitle: String { localized("tutorial.switch_language.title") }
        static var switchLanguageDesc: String { localized("tutorial.switch_language.desc") }
        
        static var gameCapturesTitle: String { localized("tutorial.game_captures.title") }
        static var gameCapturesDesc: String { localized("tutorial.game_captures.desc") }
        static var myJournalTitle: String { localized("tutorial.my_journal.title") }
        static var myJournalDesc: String { localized("tutorial.my_journal.desc") }
        
        static var voicePracticeTitle: String { localized("tutorial.voice_practice.title") }
        static var voicePracticeDesc: String { localized("tutorial.voice_practice.desc") }
        static var roleplayTitle: String { localized("tutorial.roleplay.title") }
        static var roleplayDesc: String { localized("tutorial.roleplay.desc") }
        static var mindReaderTitle: String { localized("tutorial.mind_reader.title") }
        static var mindReaderDesc: String { localized("tutorial.mind_reader.desc") }
        
        static var yourProfileTitle: String { localized("tutorial.your_profile.title") }
        static var yourProfileDesc: String { localized("tutorial.your_profile.desc") }
        static var profileStatsTitle: String { localized("tutorial.profile_stats.title") }
        static var profileStatsDesc: String { localized("tutorial.profile_stats.desc") }
        static var settingsTitle: String { localized("tutorial.settings.title") }
        static var settingsDesc: String { localized("tutorial.settings.desc") }
        static var achievementsTitle: String { localized("tutorial.achievements.title") }
        static var achievementsDesc: String { localized("tutorial.achievements.desc") }
        static var leaderboardTitle: String { localized("tutorial.leaderboard.title") }
        static var leaderboardDesc: String { localized("tutorial.leaderboard.desc") }
    }

    enum MindReader {
        static var title: String { localized("mind_reader.title") }
        static var homeTitle: String { localized("mind_reader.home_title") }
        static var subtitle: String { localized("mind_reader.subtitle") }
        static var lobbyPrompt: String { localized("mind_reader.lobby_prompt") }
        static var translationPrompt: String { localized("mind_reader.translation_prompt") }
        static var translateThisWord: String { localized("mind_reader.translate_this_word") }
        
        static var translateDialogTitle: String { localized("mind_reader.translate_dialog_title") }
        static var translateDialogMessage: String { localized("mind_reader.translate_dialog_message") }
        static var gameTitle: String { localized("mind_reader.game_title") }
        static var aiThinking: String { localized("mind_reader.ai_thinking") }
        static var enterYourWord: String { localized("mind_reader.enter_your_word") }
        static var selectCategoryTitle: String { localized("mind_reader.select_category_title") }
        static var showTranslation: String { localized("mind_reader.show_translation") }
        static var popQuizSubtitle: String { localized("mind_reader.pop_quiz_subtitle") }
        static var whatWasYourWord: String { localized("mind_reader.what_was_your_word") }
        static var wordPlaceholder: String { localized("mind_reader.word_placeholder") }
        static var victoryTitle: String { localized("mind_reader.victory_title") }
        
        // Result View
        static var legendarySkills: String { localized("mind_reader.result.legendary_skills") }
        static var stumpedLingo: String { localized("mind_reader.result.stumped_lingo") }
        static var experience: String { localized("mind_reader.result.experience") }
        static var earnings: String { localized("mind_reader.result.earnings") }
        static func earnedXP(_ amount: Int) -> String { String(format: localized("mind_reader.result.earned_xp"), amount) }
        static func earnedCoins(_ amount: Int) -> String { String(format: localized("mind_reader.result.earned_coins"), amount) }
        static var playAgain: String { localized("mind_reader.play_again") }
        static var returnToHome: String { localized("mind_reader.result.return_home") }
        
        static var bustedTitle: String { localized("mind_reader.busted.title") }
        static var bustedDefaultReason: String { localized("mind_reader.busted.default_reason") }
        static var zeroXP: String { localized("mind_reader.busted.zero_xp") }
        static var zeroCoins: String { localized("mind_reader.busted.zero_coins") }
        static var tryAgain: String { localized("mind_reader.try_again") }
        
        static var iGiveUpPrompt: String { localized("mind_reader.give_up.prompt") }
        static func categoryVocabularyTitle(_ category: String) -> String { String(format: localized("mind_reader.give_up.category_vocabulary_title"), category) }
        static var selectWord: String { localized("mind_reader.give_up.select_word") }
        static var submit: String { localized("mind_reader.submit") }
        
        static var currentCategory: String { localized("mind_reader.current_category") }
        static var startGame: String { localized("mind_reader.start_game") }
        static var change: String { localized("mind_reader.change") }
        static var confirmationQuestion: String { localized("mind_reader.confirmation_question") }
        static func makeSureFitsWorld(_ world: String) -> String { String(format: localized("mind_reader.make_sure_fits_world"), world) }
        static var notYet: String { localized("mind_reader.not_yet") }
        static var yesLetsGo: String { localized("mind_reader.yes_lets_go") }
        static var mindReaderTag: String { localized("mind_reader.tag") }
        static var playGame: String { localized("mind_reader.play_game") }
        static var thinkingHard: String { localized("mind_reader.thinking_hard") }
        static var thinkingHardSubtitle: String { localized("mind_reader.thinking_hard_subtitle") }
        static func questionProgress(current: Int, total: Int) -> String { String(format: localized("mind_reader.question_progress"), current, total) }
        static func percentComplete(_ percent: Int) -> String { String(format: localized("mind_reader.percent_complete"), percent) }
        static var translateLifeline: String { localized("mind_reader.translate_lifeline") }
        static var answerYes: String { localized("mind_reader.answer.yes") }
        static var answerNo: String { localized("mind_reader.answer.no") }
        static var answerSometimes: String { localized("mind_reader.answer.sometimes") }
        static var answerProbablyNot: String { localized("mind_reader.answer.probably_not") }
        static var answerDontKnow: String { localized("mind_reader.answer.dont_know") }
        static var guessGotIt: String { localized("mind_reader.guess.got_it") }
        static var guessWrong: String { localized("mind_reader.guess.wrong") }
        static var guessThinkIts: String { localized("mind_reader.guess.think_its") }
        static var guessNoWrong: String { localized("mind_reader.guess.no_wrong") }
        static var guessYesGotIt: String { localized("mind_reader.guess.yes_got_it") }
        static var popQuizTitle: String { localized("mind_reader.pop_quiz.title") }
        static var giveUpPrompt: String { localized("mind_reader.give_up_prompt") }
        static var bustedContradiction: String { localized("mind_reader.busted.contradiction") }
        static var bustedQuizFailed: String { localized("mind_reader.busted.quiz_failed") }
        static var bustedInvalidSelection: String { localized("mind_reader.busted.invalid_selection") }
        
        static func categoryName(for key: String) -> String {
            return localized("mind_reader.category.\(key)")
        }
        
        static var loadingTitle: String { localized("mind_reader.loading_title") }
        static var loadingSubtitle: String { localized("mind_reader.loading_subtitle") }
    }

    enum Notifications {
        static var title: String { localized("notifications.title") }
        static var emptyTitle: String { localized("notifications.empty.title") }
        static var emptySubtitle: String { localized("notifications.empty.subtitle") }
        static var clearAll: String { localized("notifications.clear_all") }
        static var delete: String { localized("notifications.delete") }
        static var deleteConfirmTitle: String { localized("notifications.delete_confirm_title") }
        static var deleteConfirmMessage: String { localized("notifications.delete_confirm_message") }
        static var deleteAllConfirmTitle: String { localized("notifications.delete_all_confirm_title") }
        static var deleteAllConfirmMessage: String { localized("notifications.delete_all_confirm_message") }
        static var markAsRead: String { localized("notifications.mark_as_read") }
        
        static var justNow: String { localized("notifications.time.just_now") }
        static func minutesAgo(_ count: Int) -> String { String(format: localized("notifications.time.minutes_ago"), count) }
        static func hoursAgo(_ count: Int) -> String { String(format: localized("notifications.time.hours_ago"), count) }
        static func daysAgo(_ count: Int) -> String { String(format: localized("notifications.time.days_ago"), count) }
    }

    private static func localized(_ key: String) -> String {
        let appLanguage = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.appLanguage) ?? "en"
        if let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        return String(localized: String.LocalizationValue(key))
    }
}
