class_name SelectionContainer extends PanelContainer

@export var selector : PanelContainer

@export_category("Themes") 
@export var unselected : StyleBox
@export var selected : StyleBox
@export var locked : StyleBox
@export var mainFont : Font
@export var numberFont : Font

func SetStyleBox(style : StyleBox) -> void:
	remove_theme_stylebox_override("panel")
	add_theme_stylebox_override("panel" , style )

func UnSelect() -> void:
	SetStyleBox(unselected)

func Select() -> void:
	SetStyleBox(selected)

func Locked() -> void:
	SetStyleBox(locked)

func HasAchivement(unlockAchivement : Achievement ) -> bool:
	if unlockAchivement :
		var achivementData : Dictionary = AchievementManager.get_achievement(unlockAchivement.id)
		return achivementData["unlocked"]
	else :
		return true
