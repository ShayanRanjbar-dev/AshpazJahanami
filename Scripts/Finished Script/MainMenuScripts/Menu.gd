extends MarginContainer

@export var gamemodePanel : PanelContainer
@export var settingContainer : MarginContainer
@export var progressContainer : MarginContainer
@export var gamemodeContainer : MarginContainer

var socialFollow : Dictionary [String , bool]= {
	"Instagram" : false ,
	"Telegram" : false
}

func changeMenu(menu : MarginContainer) -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	menu.show()
	gamemodePanel.hide()
	hide()

func GameModeSelected() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiSelectSFX)
	gamemodeContainer.show()
	gamemodePanel.hide()
	hide()

func RewardAd( rewarded : bool) -> void:
	if rewarded:
		AchievementManager.progress_achievement("watch_ads")

func CheckHasFollow(social : String) -> void:
	if not socialFollow[social] :
		socialFollow[social] = true
		if false not in socialFollow.values():
			AchievementManager.unlock_achievement("follow_social_media")

func StartButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	GameModeSelected()

func SettingButtonPressed() -> void:
	changeMenu(settingContainer)

func ProgressButtonPressed() -> void:
	changeMenu(progressContainer)

func GameIconAchoevementButtonPressed() -> void:
	AchievementManager.progress_achievement("click_on_logo",1)

func NormalGameModeButtonPressed() -> void:
	GameModeSelected()

func HardCoreGameModeButtonPressed() -> void:
	GameModeSelected()

func CustomGameModeButtonPressed() -> void:
	GameModeSelected()

func GameModeCancelButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	if gamemodePanel.is_visible_in_tree():
		HelperScript.PlayUiPopUpAnimation(gamemodePanel , true)

func WatchAdButtonPressed() -> void:
	HelperScript.PlayAds(RewardAd)

func InstagramLinkPressed() -> void:
	CheckHasFollow("Instagram")

func TelegramLinkPressed() -> void:
	CheckHasFollow("Telegram")
