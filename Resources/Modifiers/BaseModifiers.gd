class_name BaseModifiers extends Resource

enum type {Positive = 1 , Negative = -1}

@export var cable : Cable
@export var modifierType : type = type.Positive

func UpdateData(_effect : String) -> void:
	pass

func CalculateValue(value : float) -> float:
	var newValue : float = value + ( 0.1 * modifierType) 
	return newValue
