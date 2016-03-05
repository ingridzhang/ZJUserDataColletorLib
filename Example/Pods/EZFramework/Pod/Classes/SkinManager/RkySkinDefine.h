//
//  RkySkinDefine.h
//  EasyJie
//
//  Created by ricky on 14-8-23.
//  Copyright (c) 2014年 rickycui. All rights reserved.
//

#ifndef EasyJie_RkySkinDefine_h
#define EasyJie_RkySkinDefine_h

#import <Foundation/Foundation.h>
static NSString *const kSkinDefaultsBundleName = @"skin_default.bundle";
static NSString *const kSkinStyleConfigPlistName = @"StyleConfig";
static NSString *const kSkinNightBundleName = @"skin_night.bundle";


static NSString *const kSkinConfigKeyColorNormal = @"rgb";
static NSString *const kSkinConfigKeyColorHighlighted = @"rgb_hl";//高亮
static NSString *const kSkinConfigKeyColorDisabled = @"rgb_dis";
static NSString *const kSkinConfigKeyColorSelected = @"rgb_sel";//选中
static NSString *const kSkinConfigKeyColorShadow = @"rgb_shadow";//阴影

static NSString *const kSkinConfigKeyFontName = @"name";
static NSString *const kSkinConfigKeyFontSize = @"size";

static NSString *const kSkinStyleItemMapCacheKey = @"kSkinStyleItemMapCacheKey";

static NSString *const kSkinStyleDefaultFontName = @"MicrosoftYaHei";
static NSString *const kSkinStyleHANYIBoldFontName = @"HYLingXinJ";
static NSString *const kSkinStyleDefaultEnglishFontName = @"Arial"; //英文及数字默认字体
static NSString *const kSkinStyleDefaultEnglishBoldFontName = @"Arial-BoldMT"; //英文粗体



//界面常用
static NSString *const kCommonModule = @"CommonModule";
static NSString *const kCommonYellowColor = @"CommonYellowColor";
static NSString *const kCommonGrayColor = @"CommonGrayColor";
static NSString *const kCommonWhiteColor = @"CommonWhiteColor";
static NSString *const kViewControllerBackgroundColor = @"ViewControllerBackgroundColor";
static NSString *const kNavigationTitleText = @"NavigationTitleText";
static NSString *const kNavSeatRightButton = @"NavSeatRightButton";
static NSString *const kMySeatText = @"MySeatText";





//阅读
static NSString *const kReadingModule = @"ReadingModule";
static NSString *const kReadingHeaderBgColor = @"ReadingHeaderBgColor";
static NSString *const kReadingHeaderTitleText = @"ReadingHeaderTitleText";
static NSString *const kReadingHeaderContentText = @"ReadingHeaderContentText";
static NSString *const kReadingSummaryBgColor = @"ReadingSummaryBgColor";
static NSString *const kReadingSummaryCellColor = @"ReadingSummaryCellColor";
static NSString *const kReadingSummaryshadowColor = @"ReadingSummaryshadowColor";
static NSString *const kReadingSelectTypeText= @"ReadingSelectTypeText";
static NSString *const kReadingCellDividerLineColor = @"ReadingCellDividerLineColor";
static NSString *const kReadingClassRoundBgColor = @"ReadingClassRoundBgColor";
static NSString *const kReadingReportBgColor= @"ReadingReportBgColor";


static NSString *const kReadingTableViewBgColor = @"ReadingTableViewBgColor";
static NSString *const kReadingListTableTitle = @"ReadingListTableTitle";
static NSString *const kReadingListTableSubTitle = @"ReadingListTableSubTitle";
static NSString *const kReadingSelectTypeViewSectionBgColor = @"ReadingSelectTypeViewSectionBgColor";
static NSString *const kReadingSelectTypeViewCellBgColor = @"ReadingSelectTypeViewCellBgColor";

static NSString *const kReadingQuestionCategoryControllerBackgroundColor = @"QuestionCategoryControllerBackgroundColor";
static NSString *const kReadingQuestionCategoryTitle = @"QuestionCategoryTitle";
static NSString *const kReadingQuestionLikeCountTitle = @"QuestionLikeCountTitle";
static NSString *const kReadingCheckListTitle = @"CheckListTitle";
static NSString *const kReadingQuestionContentText = @"QuestionContentText";
static NSString *const kReadingQuestionFullScreenContentText = @"QuestionFullScreenContentText";
static NSString *const kReadingQuestionTipTitle = @"QuestionTipTitle";
static NSString *const kReadingQuestionContentLabel = @"QuestionContentLabel";
//static NSString *const kReadingQuestionAnswerText= @"QuestionAnswerText";

static NSString *const kReadingQuestionQuestionCheckButton = @"QuestionCheckButton";


static NSString *const kTaskFinishModule = @"TaskFinishModule";
static NSString *const kTaskFinishLabelText = @"TaskFinishLabelText";
static NSString *const kTaskFinishButtonText = @"TaskFinishButtonText";


static NSString *const kLoginModule = @"LoginModule";
static NSString *const kLoginPasswordBoxBgColor = @"LoginPasswordBoxBgColor";
static NSString *const kLoginRegisterText = @"LoginRegisterText";
static NSString *const kForgetPasswordTextFont = @"ForgetPasswordText";
static NSString *const kLoginText = @"LoginText";
static NSString *const kRegisterText = @"RegisterText";
static NSString *const kWeixinLoginText = @"WeixinLoginText";

#pragma mark 设置
static NSString *const kSettingModule = @"SettingModule";
static NSString *const kSettingBgColor = @"SettingBgColor";
static NSString *const kSettingCellText = @"SettingCellText";
static NSString *const kSettingCellColor = @"SettingCellColor";
static NSString *const kFeedBackText = @"FeedBackText";
static NSString *const kSpokenListCellTaskIdLabel = @"SpokenListCellTaskIdLabel";
static NSString *const kSpokenListCellTimeLabel = @"SpokenListCellTimeLabel";
static NSString *const kSpokenListCellMainTextLabel = @"SpokenListCellMainTextLabel";
static NSString *const kSpokenListVCBackColor = @"SpokenListVCBackColor";
static NSString *const kSpokenListCellBackColor = @"SpokenListCellBackColor";




#pragma mark 口语练习
static NSString *const kSpeakingMemoriesModule = @"SpeakingMemoriesModule";
static NSString *const kSpeakingSelectDateButton = @"SpeakingSelectDateButton";
static NSString *const kSpeakingSelectDateBGColor = @"SpeakingSelectDateBGColor";
static NSString *const kSpeakingSwitchLabelOutColor = @"SpeakingSwitchLabelOutColor";
static NSString *const kSpeakingRecordingCellTitleLabel = @"SpeakingRecordingCellTitleLabel";
static NSString *const kSpeakingRecordingCellBGColor = @"SpeakingRecordingCellBGColor";
static NSString *const kSpeakingRecordingCellTotalNumLabel = @"SpeakingRecordingCellTotalNumLabel";
static NSString *const kSpeakingRecordingCellDividerLineColor = @"SpeakingRecordingCellDividerLineColor";
static NSString *const kSpeakingRecordingGroupViewBgColor = @"SpeakingRecordingGroupViewBgColor";
static NSString *const kSpeakingUserContributionTheme = @"SpeakingUserContributionTheme";
static NSString *const kSpeakingUserContributionBtn = @"SpeakingUserContributionBtn";
static NSString *const kSpeakingUserContributionBtnDidSelect = @"SpeakingUserContributionBtnDidSelect";
static NSString *const kSpeakingUserContributionPickerTitle = @"SpeakinguserContributionPickerTitle";
static NSString *const kSpeakingUserContributionPicketBtn = @"SpeakingUserContributionPicketBtn";
static NSString *const kSpeakingUserContributionLine = @"SpeakingUserContributionLine";
static NSString *const kSpeakingUserContributionBg = @"SpeakingUserContributionBg";
static NSString *const kSpeakingUserContributionPickerBg = @"SpeakingUserContributionPickerBg";
static NSString *const kSpeakingUserContributionPickerTitleBg = @"SpeakingUserContributionPickerTitleBg";
static NSString *const kSpeakingUserContributionPickerLabel = @"SpeakingUserContributionPickerLabel";
static NSString *const kSpeakingUserContributionBtnDisabled = @"SpeakingUserContributionBtnDisabled";
static NSString *const kSpeakingUserContributionPickerSepLine = @"SpeakingUserContributionPickerSepLine";
static NSString *const kSpeakingSwitchBGColor = @"SpeakingSwitchBGColor";
static NSString *const kSpeakingVCBGColor = @"SpeakingVCBGColor";
static NSString *const kSpeakingSwitchSeperateColor = @"SpeakingSwitchSeperateColor";
static NSString *const kSpeakingSwitchBGBottomColor = @"SpeakingSwitchBGBottomColor";
static NSString *const kSpeakingRecordingCellCategoryLabel = @"SpeakingRecordingCellCategoryLabel";





//分类练习
static NSString *const kSpeakingClassfiyBgColor = @"SpeakingClassfiyBgColor";
static NSString *const kSpeakingClassfiyTableCellBgColor = @"SpeakingClassfiyTableCellBgColor";
static NSString *const kSpeakingClassfiyTableCellLineColor = @"SpeakingClassfiyTableCellLineColor";
static NSString *const kSpeakingClassfiySectionPartColor = @"SpeakingClassfiySectionPartColor";
static NSString *const kSpeakingClassfiySectionViewAddSubjectColor = @"SpeakingClassfiySectionViewAddSubjectColor";
static NSString *const kSpeakingClassfiyCellTitleLabelTextColor = @"SpeakingClassfiyCellTitleLabelTextColor";
static NSString *const kSpeakingClassfiyCellAudoNumbersLabelTextColor = @"SpeakingClassfiyCellAudoNumbersLabelTextColor";

//口语详情
static NSString *const kSpeakingDetailQuestionViewBgColor = @"SpeakingDetailQuestionViewBgColor";
static NSString *const kSpeakingDetailContentViewBgColor = @"SpeakingDetailContentViewBgColor";
static NSString *const kSpeakingDetailuserCountLabelTextColor = @"SpeakingDetailuserCountLabelTextColor";
static NSString *const kSpeakingDetailuserTitleTextColor = @"SpeakingDetailuserTitleTextColor";
static NSString *const kSpeakingDetailTabBarItemButtonNormalBgColor = @"SpeakingDetailTabBarItemButtonNormalBgColor";
static NSString *const kSpeakingDetailTabBarItemButtonSelectBgColor = @"SpeakingDetailTabBarItemButtonSelectBgColor";
static NSString *const kSpeakingDetailKListViewBackgroundWhiteColor = @"SpeakingDetailKListViewBackgroundWhiteColor";
static NSString *const kSpeakingDetailAudoListViewTextColor = @"SpeakingDetailAudoListViewTextColor";
static NSString *const kSpeakingDetailTableCellSepratorColor = @"SpeakingDetailTableCellSepratorColor";


#pragma mark 词汇练习

static NSString *const kWordLearningModule = @"WordLearningModule";
static NSString *const kDayTaskBgColor= @"DayTaskBgColor";
static NSString *const kAgendaTableCellBgColor= @"AgendaTableCellBgColor";
static NSString *const kSDPieProgressViewBackColor= @"SDPieProgressViewBackColor";
static NSString *const kSDPieProgressViewBeforeColor= @"SDPieProgressViewBeforeColor";
static NSString *const kWordLearningCompleteLabelText= @"WordLearningCompleteLabelText";
static NSString *const kStudyProgressBarViewChangeColor= @"StudyProgressBarViewChangeColor";
static NSString *const kReviewLearningText= @"ReviewLearningText";
static NSString *const kWordNumberLabelText= @"WordNumberLabelText";
static NSString *const kDetailReviewPlanLabelText= @"DetailReviewPlanLabelText";
static NSString *const kCadidateWordsViewBgColor= @"CadidateWordsViewBgColor";



static NSString *const kLearningModule = @"LearningModule";
static NSString *const kLearningMainTitle = @"MainTitleLabel";
static NSString *const kLearningSubTitle = @"SubTitleLabel";
static NSString *const kLearningLikeCountButton = @"LikeCountButton";
static NSString *const kLearningStartButton = @"StartButton";


static NSString *const kHomeModule = @"HomeModule";
static NSString *const kTaskButtonTopicText = @"TaskButtonTopicText";
static NSString *const kTaskButtonDailyProcessText = @"TaskButtonDailyProcessText";
static NSString *const kTaskButtonAchievementText = @"TaskButtonAchievementText";
static NSString *const kTaskButtonGetSeatTopicText = @"TaskButtonGetSeatTopicText";
static NSString *const kTaskButtonGetSeatNumText = @"TaskButtonGetSeatNumText";
static NSString *const kTaskButtonTPOUpdateText = @"TaskButtonTPOUpdateText";


static NSString *const kProfileModule = @"ProfileModule";
static NSString *const kTargetCompletionText = @"TargetCompletionText";
static NSString *const kCompletionStatusText = @"CompletionStatusText";
static NSString *const kDetailStatusText = @"DetailStatusText";
static NSString *const kExamTipsText = @"ExamTipsText";
static NSString *const kNicknameText = @"NicknameText";
static NSString *const kTargetChangeText = @"TargetChangeText";
static NSString *const kAchievementText = @"AchievementText";
static NSString *const kRandomTipsText = @"RandomTipsText";
static NSString *const kSeatTitleText = @"SeatTitleText";


static NSString *const kSeatModule = @"SeatModule";
static NSString *const kSeatCountLabel = @"SeatCountLabel";
static NSString *const kSeatCountTipLabel = @"SeatCountTipLabel";
static NSString *const kSeatMoreButton = @"SeatMoreButton";
static NSString *const kSeatMonthLabel = @"SeatMonthLabel";
static NSString *const kSeatDetailComputerText = @"SeatDetailComputerText";
static NSString *const kSeatDetailStateNoText = @"SeatDetailStateNoText";
static NSString *const kSeatSubsSectionTitle = @"SeatSubsSectionTitle";
static NSString *const kSeatDetailStateYesText = @"SeatDetailStateYesText";
static NSString *const kSeatDetailFollowText = @"SeatDetailFollowText";
static NSString *const kSeatDetailUnFollowText = @"SeatDetailUnFollowText";
static NSString *const kSeatDetailTitleButton = @"SeatDetailTitleButton";
static NSString *const kSeatDetailTableViewBgColor = @"SeatDetailTableViewBgColor";
static NSString *const kSeatOppsLabel = @"SeatOppsLabel";
static NSString *const kSeatOppsDetailLabel = @"SeatOppsDetailLabel";
static NSString *const kSeatCaptchaLabel = @"SeatCaptchaLabel";
static NSString *const kSeatProtocolLabel = @"SeatProtocolLabel";
static NSString *const kSeatProgressLabel = @"SeatProgressLabel";

static NSString *const kSeatSetProvinceButton = @"SeatSetProvinceButton";
static NSString *const kSeatProvinceMainTitle = @"SeatProvinceMainTitle";
static NSString *const kSeatProvinceSubTitle = @"SeatProvinceSubTitle";
static NSString *const kSeatSeatUpdateTimeLabel = @"SeatUpdateTimeLabel";

static NSString *const kListeningDetailModule = @"ListenDetailModule";
static NSString *const kListeningDetailModuleStartAnswerButton = @"StartAnswerButton";
static NSString *const kListeningDetailModuleAudioDurationTitle = @"AudioDurationTitle";
static NSString *const kListeningDetailModuleMainTitle = @"MainTitle";
static NSString *const kListeningDetailModuleSubTitle = @"SubTitle";

static NSString *const kSpeakingExpModule = @"SpeakingExpModule";
static NSString *const kTASKCNNAMEText = @"TASKCNNameText";
static NSString *const kTaskFollowNumText = @"TASKFollowNumText";
static NSString *const kTASKNUMText = @"TASKNumText";

static NSString *const kDetailTaskNum = @"DetailTaskNum";
static NSString *const kDetailUpTime = @"DetailUpTime";
static NSString *const kDetailNumberOfFollow = @"DetailUpTime";
static NSString *const kDetailTitle = @"DetailTitle";
static NSString *const kDetailText = @"DetailText";






static NSString *const kClassifiesModule = @"ClassifiesModule";
static NSString *const kTPOText = @"TPOText";
static NSString *const kClassifyText = @"ClassifyText";
static NSString *const kClassifyItemText = @"ClassifyItemText";
static NSString *const kReadingTitleText = @"ReadingTitleText";
static NSString *const kListeningTitleText = @"ListeningTitleText";
static NSString *const kNewTPOText = @"NewTPOText";
static NSString *const kNewListeningTitleText = @"NewListeningTitleText";



static NSString *const kRankListModule = @"RankListModule";
static NSString *const kTPOSegSelectColor = @"TPOSegSelectColor";
static NSString *const kTPOSegFont = @"TPOSegFont";
static NSString *const kTPOSegOutsideColor = @"TPOSegOutsideColor";

static NSString *const kTPOPublishTimeLabel = @"TPOPublishTimeLabel";
static NSString *const kTPOTitleLabel = @"TPOTitleLabel";
static NSString *const kTPOListHistoryExamTimeLabel = @"TPOListHistoryExamTimeLabel";
static NSString *const kTPOListHistoryExamTPOTitleLabel = @"TPOListHistoryExamTPOTitleLabel";
static NSString *const kTPOListHistoryScoreTitleLabel = @"TPOListHistoryScoreTitleLabel";
static NSString *const kTPOListHistoryDownloadLabel = @"TPOListHistoryDownloadLabel";
static NSString *const kTPOListHistoryDownCountLabel = @"TPOListHistoryDownCountLabel";

static NSString *const kRanklistRanksName = @"RanklistRanksName";
static NSString *const kRanklistCelltext = @"RanklistCelltext";
static NSString *const kRanklistCellscro = @"RanklistCellscro";
static NSString *const kRanklistCelldate = @"RanklistCelldate";
static NSString *const kRanklistCellname = @"RanklistCellname";
static NSString *const kRanklistCellnumber = @"RanklistCellnumber";
static NSString *const kRankListCellEnumber = @"RankListCellEnumber";



static NSString *const kAnswerlistRanksName = @"AnswerlistRanksName";
static NSString *const kAnswerBackground = @"AnswerBackground";


//答案解析
static NSString *const kAnswerParaseModule = @"AnswerParaseModule";
static NSString *const kAnswerParaseBottomAnswerViewBoderColor = @"AnswerParaseBottomAnswerViewBoderColor";


// 皮肤类型
typedef NS_ENUM (NSUInteger, RkySkinStyle) {
    RkySkinStyleDefault,
    RkySkinStyleNight
};

// 颜色类型
typedef NS_ENUM (NSUInteger, RkyColorType)
{
    RkyColorTypeNormal = 0,
    RkyColorTypeSelected,
    RkyColorTypeDisabled,
    RkyColorTypeHighlighted,
    RkyColorTypeShadow,
};
#endif /* ifndef EasyJie_RkySkinDefine_h */
