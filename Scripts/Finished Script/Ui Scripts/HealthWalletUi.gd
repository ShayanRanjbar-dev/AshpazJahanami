extends MarginContainer

@export var healthBar : ProgressBar
@export var moneyText : Label

func GetPlayerHealth(health : int , maxhealth : int) -> void:
	var healthValue : float = (float(health) / maxhealth) * 100
	healthValue = round(healthValue)
	var healthTween : Tween = create_tween().bind_node(healthBar)
	healthTween.tween_property(healthBar,"value",healthValue,0.20)

func GetPlayerHealthDeath() -> void:
	healthBar.value = healthBar.min_value

func GetPlayerMoney(money : int) -> void:
	moneyText.text = ": $%s" % [money]
