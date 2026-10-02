extends MarginContainer

@export var moneyText : Label

func GetPlayerInfo(wave : int , money : int) -> void :
	get_parent().show()
	moneyText.text = "شما در %d موج %d پول جمع آوری کردید!" % [wave , money]

func ContinueButtonPressed() -> void:
	get_parent().hide()
	owner.EnterEndlessMode.emit()

func ExitButtonPressed() -> void:
	Loading.load_scene(HelperScript.SceneList.MainMenu  , true)
