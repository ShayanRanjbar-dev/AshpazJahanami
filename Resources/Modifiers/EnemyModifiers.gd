class_name EnemyModifier extends BaseModifiers

@export_enum("SpawnTime" , "Speed" , "Health" , "Damage" ) var modifiers : String :
	set(value) :
		modifiers = value

func UpdateData(effect : String) -> void:
	var cableData : EnemyData = cable.get_value_or_default(EnemyData.new())
	var rawValue : float =  cableData.get(effect)
	var newValue : float = CalculateValue(rawValue)
	var newCableData : EnemyData = EnemyData.new()
	newCableData.set(effect , newValue)
	cable.notify(newCableData)
