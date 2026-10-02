extends MarginContainer

@export var menuContainer : MarginContainer
@export var progressContainer: GridContainer

const ACHIEVEMENT_DISPLAY : String = "uid://b2ygwvy3dv00a"
var unlockedAchievements : Array[String] = []
var lockedAchievements : Array[String] = []
var hiddenAchievements : Array[String] = []

func _ready() -> void:
	AchievementManager.load_achievements()
	AchievementManager.unlock_achievement("enter_first_time")
	SetAchievements()

func SetAchievements() -> void:
	for achievement in progressContainer.get_children():
		achievement.queue_free()
	unlockedAchievements.clear()
	lockedAchievements.clear()
	hiddenAchievements.clear()
	var achievementsIdList : Array = AchievementManager.achievements_list.keys()
	for achievement_id in achievementsIdList:
		var progress_data : Dictionary = AchievementManager.get_achievement(achievement_id)
		var resource_data = AchievementManager.achievements_list[achievement_id]
		if progress_data["unlocked"]:
			unlockedAchievements.append(achievement_id)
		elif resource_data.hidden:
			hiddenAchievements.append(achievement_id)
		else:
			lockedAchievements.append(achievement_id)
	var orderedList : Array[String] = unlockedAchievements + lockedAchievements + hiddenAchievements
	AddAllAchivements(orderedList)

func AddAllAchivements(achievement_ids: Array) -> void:
	AddNextAchivement(achievement_ids, 0)

func AddNextAchivement(achievement_ids: Array, index: int) -> void:
	if index >= achievement_ids.size():
		return
	var achievement_id : String = achievement_ids[index]
	var achievementDisplayNode = load(ACHIEVEMENT_DISPLAY).instantiate()
	achievementDisplayNode.achievement_id = achievement_id
	progressContainer.add_child(achievementDisplayNode)
	await get_tree().process_frame
	AddNextAchivement(achievement_ids, index + 1)

func ProgressBackButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	menuContainer.show()
	hide()

func ProgressResetButtonPressed() -> void:
	var achievements : Dictionary =  AchievementManager.get_unlocked_achievements()
	if achievements.size() > 0:
		UiSoundManager.PlayUiSound(UiSoundManager.uiResetProgressSFX)
		AchievementManager.reset_achievements()
		SetAchievements()
	else:
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
