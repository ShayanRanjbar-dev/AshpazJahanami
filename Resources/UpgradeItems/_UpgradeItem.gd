class_name UpgradeItem extends Resource

@export var texture: Texture2D
@export var Name : String
@export var ProsList : Dictionary [String , BaseModifiers]
@export var ConsList : Dictionary [String , BaseModifiers]
@export var Price : int 
@export var ItemAchievement : Achievement

func ApplyUpgrade():
	if ItemAchievement:
		AchievementManager.progress_achievement(ItemAchievement.id) if ItemAchievement.progressive else AchievementManager.unlock_achievement(ItemAchievement.id)
	for pros : BaseModifiers in ProsList.values():
		pros.UpdateData(pros.modifiers)
	for cons : BaseModifiers in ConsList.values():
		cons.UpdateData(cons.modifiers)
