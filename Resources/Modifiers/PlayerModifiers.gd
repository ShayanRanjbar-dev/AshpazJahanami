class_name PlayerModifiers extends BaseModifiers

@export_enum("Speed" , "Health" , "Knockback" ,
						 "CloseRotation" , "CloseDamage" ,
						"LongDamage" , "LongSpeed" ) var modifiers : String :
							set(value) :
								modifiers = value

func UpdateData(effect : String) -> void:
	var cableData : PlayerData = cable.get_value_or_default(PlayerData.new())
	var rawValue : float =  cableData.get(effect)
	var newValue : float = CalculateValue(rawValue)
	var newCableData : PlayerData = PlayerData.new()
	newCableData.set(effect , newValue)
	cable.notify(newCableData)
