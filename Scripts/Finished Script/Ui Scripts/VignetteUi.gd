extends MarginContainer

@export var vignetteColorRect : ColorRect


func GetPlayerHealth(health : int , maxhealth : int) -> void:
	var healthPercentage : float = float(health) / maxhealth
	var vignetteShader : ShaderMaterial = vignetteColorRect.material as ShaderMaterial
	var vignetteValue : float = 1
	vignetteValue -= healthPercentage
	vignetteShader.set_shader_parameter("vignette_opacity",vignetteValue)
