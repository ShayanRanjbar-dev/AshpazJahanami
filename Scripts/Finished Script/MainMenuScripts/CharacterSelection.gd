extends PanelContainer

@export var characterInfoContainer : PanelContainer
@export var characterSelectionInfo : Label
@export var nextCharacterSelectionButton : Button
@export var achivement : Achievement
var lastCharacter : PanelContainer
var selectedCharacter : Texture2D

func OnCharacterSelected(characterData : Dictionary)->void:
	var selectedContainer : PanelContainer = characterData["Container"]
	var hasCharacter : bool = characterData["Unlocked"]
	var characterName : String = characterData["Name"]
	nextCharacterSelectionButton.disabled = not hasCharacter
	if lastCharacter and lastCharacter != selectedContainer :
		lastCharacter.UnSelect()
	lastCharacter = selectedContainer
	characterInfoContainer.show()
	if hasCharacter :
		UiSoundManager.PlayUiSound(UiSoundManager.uiSelectSFX)
		var characterModifier : PlayerData = characterData["PlayerData"]
		var gameMode : MarginContainer = get_parent()
		gameMode.UpdatePlayerData(characterModifier)
		characterSelectionInfo.text = "%s\nانتخاب شده" % [characterName]
	else :
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		var achievement : Achievement = characterData["Achievement"]
		
		characterSelectionInfo.text = "برای بازشدن\n%s" % achievement.description
		HelperScript.PlayUiErrorAnimation(characterInfoContainer)

func NextCharacterSelectionButtonPressed() -> void:
	var gameMode : MarginContainer = get_parent()
	gameMode.ChangeSelection()

func CancelCharacterSelectionButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	if lastCharacter:
		lastCharacter.UnSelect()
		characterInfoContainer.hide()
		nextCharacterSelectionButton.disabled = true
	var gameMode : MarginContainer = get_parent()
	gameMode.ChangeMenu()
