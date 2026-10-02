class_name CompleteModifier extends BaseModifiers

@export var cableList : Dictionary [String , Cable]

var modifiers : String = ""

func UpdateData(_effect : String) -> void:
	for cableData : String in cableList.keys():
		var newData : Resource = cableList[cableData].current_value
		newData.SetPositiveData() if modifierType == type.Positive else newData.SetNegativeData()
		cableList[cableData].notify(newData)
