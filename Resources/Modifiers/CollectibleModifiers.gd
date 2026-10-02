class_name CollectibleModifiers extends BaseModifiers

@export_enum("SpawnTime" , "ChefHatValue" , "MoneyValue" ) var modifiers : String :
	set(value) :
		modifiers = value

func UpdateData(effect : String) -> void:
	var cableData : CollectibleData = cable.get_value_or_default(CollectibleData.new())
	var rawValue : float =  cableData.get(effect)
	var newValue : float = CalculateValue(rawValue)
	var newCableData : CollectibleData = CollectibleData.new()
	newCableData.set(effect , newValue)
	cable.notify(newCableData)
