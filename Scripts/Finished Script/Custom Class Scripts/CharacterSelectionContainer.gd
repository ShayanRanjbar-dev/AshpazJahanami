@tool extends SelectionContainer

@export var characterName : String : set  = UpdateName
@export var characterUiTexture : Texture2D : set = UpdateTexture
@export var charaterGameTexture : Texture2D
@export var achievement : Achievement
@export_enum("Low","Normal","High") var characterSpeed : String  : set = UpdateSpeed
@export_enum("Low","Normal","High") var characterKnockback : String : set = UpdateKnockback
@export_enum("Low","Normal","High") var characterHealth : String  : set = UpdateHealth

var playerData : PlayerData = PlayerData.new()

func UpdateName(value : String)->void :
	characterName = value
	var CharacterNameText: Label  = get_node("Character Container Vertical/Character Name Text")
	if characterName.length() < 1:
		CharacterNameText.text = "نام کاراکتر"
		return
	CharacterNameText.text = characterName

func UpdateTexture(value : Texture2D)->void:
	characterUiTexture = value
	var texture : TextureRect = get_node("Character Container Vertical/Character Texture")
	texture.texture = characterUiTexture

func UpdateSpeed(speed : String) -> void:
	characterSpeed = speed
	UpdateAbilities()

func UpdateKnockback(knockback : String) -> void:
	characterKnockback = knockback
	UpdateAbilities()

func UpdateHealth(health : String) -> void:
	characterHealth = health
	UpdateAbilities()

func UpdateAbilities()->void:
	var updateData : PlayerData = PlayerData.new()
	var speedText : String
	match characterSpeed:
		"Low" : speedText = " 50%-" ; updateData.Speed  = -0.5
		"Normal" : speedText = " 0%+"  ; updateData.Speed = 0
		"High" : speedText = " 50%+" ; updateData.Speed = 0.5
	var knockbackText : String
	match characterKnockback:
		"Low" : knockbackText = " 50%-"; updateData.Knockback = -0.5
		"Normal" : knockbackText = " 0%+" ; updateData.Knockback = 0
		"High" : knockbackText = " 50%+" ; updateData.Knockback = 0.5
	var healthText : String
	match characterHealth:
		"Low" : healthText = " 50%-" ; updateData.Health = -0.5
		"Normal" : healthText = " 0%+"  ; updateData.Health = 0
		"High" : healthText = " 50%+" ; updateData.Health += 0.5
	var characterAbility : RichTextLabel = get_node("Character Container Vertical/Character Ability Text")
	characterAbility.clear()
	characterAbility.push_color(Color.WHITE_SMOKE)
	characterAbility.push_outline_color(Color.BLACK)
	characterAbility.push_outline_size(6)
	characterAbility.push_font_size(48)
	characterAbility.push_font(mainFont)
	characterAbility.add_text("سلامت")
	characterAbility.pop()
	characterAbility.push_font(numberFont)
	characterAbility.add_text(healthText + "\n")
	characterAbility.pop()
	characterAbility.push_font(mainFont)
	characterAbility.add_text("سرعت")
	characterAbility.pop()
	characterAbility.push_font(numberFont)
	characterAbility.add_text(speedText + "\n")
	characterAbility.pop()
	characterAbility.push_font(mainFont)
	characterAbility.add_text("ناکبک")
	characterAbility.pop()
	characterAbility.push_font(numberFont)
	characterAbility.add_text(knockbackText)
	characterAbility.pop()
	characterAbility.pop()
	characterAbility.pop()
	characterAbility.pop()
	characterAbility.pop()
	playerData = updateData

func CharacterSelectionButtonPressed() -> void:
	playerData.PlayerTexture = charaterGameTexture
	var isUnlocked : bool =  HasAchivement(achievement) 
	Select() if isUnlocked else Locked()
	var characterData : Dictionary = {
		"Name" : characterName ,
		"Unlocked" : isUnlocked ,
		"PlayerData" : playerData ,
		"Achievement" : achievement ,
		"Container" : self
		}
	selector.OnCharacterSelected(characterData)
