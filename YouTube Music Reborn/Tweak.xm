#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tweak.h"

BOOL wantsNoVideoAds, wantsBackgroundPlayback, wantsDoubleTapToSkip, wantsDisableHints, wantsDisableAgeRestriction, wantsDisableOverlayAutoHide, wantsAudioOnlyOptions;
BOOL wantsHideTrendingTab, wantsHideLibraryTab, wantsHideUpgradeTab;
NSString *wantsAudioOnlyGroup;
NSString *bundleIdentifier = @"net.sarahh12099.youtubemusicrebornprefs";
NSMutableDictionary *settings;

static void loadPrefs() {
	CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if(keyList) {
		settings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else {
		settings = nil;
	}
	if (!settings) {
		settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", bundleIdentifier]];
	}

	wantsNoVideoAds = [([settings objectForKey:@"NoVideoAds"] ?: @(NO)) boolValue];
	wantsBackgroundPlayback = [([settings objectForKey:@"BackgroundPlayback"] ?: @(NO)) boolValue];
    wantsDoubleTapToSkip = [([settings objectForKey:@"DoubleTapToSkip"] ?: @(NO)) boolValue];
    wantsDisableHints = [([settings objectForKey:@"DisableHints"] ?: @(NO)) boolValue];
    wantsDisableAgeRestriction = [([settings objectForKey:@"DisableAgeRestriction"] ?: @(NO)) boolValue];
    wantsDisableOverlayAutoHide = [([settings objectForKey:@"DisableOverlayAutoHide"] ?: @(NO)) boolValue];
    wantsAudioOnlyOptions = [([settings objectForKey:@"AudioOnlyOptions"] ?: @(NO)) boolValue];
    wantsHideTrendingTab = [([settings objectForKey:@"HideTrendingTab"] ?: @(NO)) boolValue];
    wantsHideLibraryTab = [([settings objectForKey:@"HideLibraryTab"] ?: @(NO)) boolValue];
    wantsHideUpgradeTab = [([settings objectForKey:@"HideUpgradeTab"] ?: @(NO)) boolValue];
    wantsAudioOnlyGroup = [settings objectForKey:@"AudioOnlyGroup"];
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  	loadPrefs();
}

%group gNoVideoAds
%hook YTVASTAd
- (BOOL)isForecastingAd {
    return 0;
}
- (void)setForecastingAd:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
- (BOOL)isSkippable {
    return 1;
}
%end
%hook YTIPlayerResponse
- (BOOL)isMonetized {
    return 0;
}
%end
%end

%group gBackgroundPlayback
%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground {
    return 1;
}
- (id)backgroundUpsell {
    return NULL;
}
%end
%hook YTSingleVideo
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTSingleVideoMediaData
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTPlaybackData
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground {
    return 1;
}
- (id)backgroundUpsell {
    return NULL;
}
%end
%hook YTIBackgroundabilityRenderer
- (id)backgroundUpsell {
    return NULL;
}
%end
%hook YTPlayerPromoController
- (BOOL)showBackgroundabilityUpsell {
    return 0;
}
- (BOOL)showBackgroundOnboardingHint {
    return 0;
}
%end
%hook YTPlaybackBackgroundTaskController
- (BOOL)isContentPlayableInBackground {
    return 1;
}
- (void)setContentPlayableInBackground:(BOOL)arg1 {
    arg1 = 1;
	%orig;
}
%end
%end

%group gDoubleTapToSkip
%hook YTMSettings
- (BOOL)doubleTapToSeekEnabled {
    return 1;
}
%end
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (void)showDoubleTapToSeekEducationView:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%end

%group gDisableHints
%hook YTMVideoOverlayViewController
- (id)maybeShowUserEducation {
    return NULL;
}
%end
%hook YTMSettings
- (BOOL)areHintsDisabled {
    return 1;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%end

%group gDisableAgeRestriction
%hook YTUserProfile
- (BOOL)hasLegalAge {
	return 1;
}
%end
%hook YTVideo
- (BOOL)isAdultContent {
    return 0;
} 
%end
%hook YTSettings
- (BOOL)isAdultContentConfirmed {
	return 1;
}
- (void)setAdultContentConfirmed:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)isAdultContentConfirmed {
	return 1;
}
- (void)setAdultContentConfirmed:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTPlayerRequestFactory
- (BOOL)adultContentConfirmed {
	return 1;
}
%end
%hook YTIdentityState
- (BOOL)isChild {
	return 0;
}
- (BOOL)isAdult {
	return 1;
}
%end
%hook YTIAccountItemRenderer
- (BOOL)isChild {
	return 0;
}
- (BOOL)isAdult {
	return 1;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isKoreanAgeVerificationRequired {
    return 0;
}
- (BOOL)isAgeCheckRequired {
    return 0;
}
- (BOOL)isContentCheckRequired {
    return 0;
}
%end
%end

%group gDisableOverlayAutoHide
%hook YTMVideoOverlayViewController
- (void)maybeAutoHideOverlay {
}
%end
%end

%group gAudioOnlyOptions
%hook YTIPlayerResponse
- (BOOL)ytm_isAudioOnlyPlayable {
    return 1;
}
- (id)ytm_audioOnlyUpsell {
    return NULL;
}
%end
%hook YTMVideoOverlayViewController
- (id)maybeShowAudioOnlyUpsell {
    return NULL;
}
- (BOOL)isAVSwitchAvailable {
    return 1;
}
- (BOOL)showAVSwitchUserEducation {
    return 0;
}
- (BOOL)isAudioOnlyAuthorized {
    return 1;
}
- (void)setAVSwitchAvailable:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTMSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return 1;
}
%end
%hook YTMWatchViewController
- (BOOL)isAudioOnlyAuthorized:(id)arg1 {
    return 1;
}
%end
%hook YTMMusicAppMetadata
- (BOOL)isAudioOnlyButtonVisible {
    return 1;
}
- (BOOL)isPremiumSubscriber {
    return 1;
}
%end
%end

%group gAudioOnlyGroup
%hook YTMSettings
- (void)setNoVideoModeEnabled:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (BOOL)noVideoModeEnabled {
    return 1;
}
%end
%end

%group gHideTrendingTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideLibraryTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideUpgradeTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
%end
%end

%hook YTUpsell
- (BOOL)isCounterfactual {
    return 1;
}
%end

%hook YTCarPlayController
- (void)setPremiumSubscriber:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (BOOL)isPremiumSubscriber {
    return 1;
}
%end

%hook YTMYPCGetOfflineUpsellEndpointCommand
- (BOOL)isPremiumSubscriber {
    return 1;
}
%end

%hook YTIPlayerResponse
- (id)offlineUpsell {
    return NULL;
}
%end

%hook YTSingleVideo
- (BOOL)isPlayableInPictureInPicture {
    return 1;
}
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInPictureInPicture {
    return 1;
}
- (id)offlineUpsell {
    return NULL;
}
%end

%hook YTMVideoOverlayViewController
- (BOOL)isContentPanAllowed {
    return 1;
}
- (BOOL)canDoubleTapForCurrentPlayerState {
    return 1;
}
%end

%hook YTMAudioCastUpsellDialogController
- (id)showAudioCastUpsellDialogWithUpsellParentResponder:(id)arg1 {
    return NULL;
}
%end

%hook YTMUpsellDialogController
- (id)showUpsellDialogWithUpsell:(id)arg1 upsellParentResponder:(id)arg2 {
    return NULL;
}
- (id)showUpsellDialogWithUpsellResponderEvent:(id)arg1 {
    return NULL;
}
- (id)showUpsellDialogWithUpsell:(id)arg1 videoID:(id)arg2 toastType:(int)arg3 upsellParentResponder:(id)arg4 {
    return NULL;
}
%end

%hook YTMSettings
- (BOOL)isAudioQualitySettingsEnabled {
    return 1;
}
- (BOOL)allowRestrictedContentFlow {
    return 1;
}
%end

%hook YTMBackgroundUpsellNotificationController
- (id)removePendingBackgroundNotifications {
    return NULL;
}
- (id)maybeScheduleBackgroundUpsellNotification {
    return NULL;
}
%end

%hook YTMNavigationDrawerPromoView
- (id)init {
    return NULL;
}
%end

%hook YTMContentViewController
- (id)showUpsellOrUserMessageForOfflineVideos:(id)arg1 offlineWatchEndpoint:(id)arg2 {
    return NULL;
}
%end

%hook YTIOfflineabilityRenderer
- (id)offlineUpsell {
    return NULL;
}
%end

%hook YTIOfflineState
- (id)offlineUpsell {
    return NULL;
}
%end

%ctor {
    @autoreleasepool {
	    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, (CFStringRef)[NSString stringWithFormat:@"%@.prefschanged", bundleIdentifier], NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
		loadPrefs();
        if(wantsNoVideoAds) %init(gNoVideoAds);
		if(wantsBackgroundPlayback) %init(gBackgroundPlayback);
        if(wantsDoubleTapToSkip) %init(gDoubleTapToSkip);
        if(wantsDisableHints) %init(gDisableHints);
        if(wantsDisableAgeRestriction) %init(gDisableAgeRestriction);
        if(wantsDisableOverlayAutoHide) %init(gDisableOverlayAutoHide);
        if(wantsAudioOnlyOptions) %init(gAudioOnlyOptions);
        if([wantsAudioOnlyGroup isEqualToString:@"defaultaudiomode"]) {
            %init(gAudioOnlyGroup);
        }
        if(wantsHideTrendingTab) %init(gHideTrendingTab);
		if(wantsHideLibraryTab) %init(gHideLibraryTab);
        if(wantsHideUpgradeTab) %init(gHideUpgradeTab);
        %init(_ungrouped);
    }
}