@tool
class_name EnemyHealthbar extends Node

@export var enemyHealthbar : ProgressBar
@export var enemyNameText : Label 
@export var enemyName : String = "اسم انمی":
	set(val) :
		enemyName = val
		SetEnemyName(val)

func SetEnemyName(enemyname : String) -> void:
	enemyNameText.text = enemyname

func SetEnemyHealthbar(enemy : EnemyCharacterAi) -> void:
	enemyHealthbar.max_value = enemy.fullHealth
	enemyHealthbar.value = enemy.fullHealth

func ChangeHealthbarValue(_current : float , _max : float ) -> void:
	var value : float = _current
	var valueTween : Tween = create_tween().bind_node(enemyHealthbar)
	valueTween.tween_property(enemyHealthbar , "value" , value , 0.15)
	await valueTween.finished
	valueTween.kill()
