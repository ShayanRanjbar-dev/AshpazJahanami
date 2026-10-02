@tool extends SelectionContainer

@export var weaponData : WeaponData : set = UpdateData

func UpdateName(value : String)->void :
	var weaponNameLable : Label = get_node("Weapon  Container Vertical/Weapon Name Text")
	if value.length() < 1:
		weaponNameLable.text = "نام سلاح"
		return
	weaponNameLable.text = value

func UpdateTexture(texture : Texture2D)->void:
	var weaponTextureRect : TextureRect = get_node("Weapon  Container Vertical/Weapon Texture")
	weaponTextureRect.texture = texture

func UpdateData(data : WeaponData) -> void:
	weaponData = data
	UpdateName(data.Name)
	UpdateTexture(data.WeaponTexture)
	UpdateAbilities()

func UpdateAbilities():
	var weaponTypeText : String
	match weaponData.Type:
		"CloseRange" : weaponTypeText = "سلاح سرد"
		"LongRange" : weaponTypeText = "سلاح گرم"
	var weaponDamageText : String = str(weaponData.Damage)
	var weaponAbility : RichTextLabel = get_node("Weapon  Container Vertical/Weapon Ability Text")
	weaponAbility.text = "%s\n%s" % [weaponTypeText , weaponDamageText ]
	weaponAbility.clear()
	weaponAbility.push_color(Color.WHITE_SMOKE)
	weaponAbility.push_outline_color(Color.BLACK)
	weaponAbility.push_outline_size(6)
	weaponAbility.push_font_size(64)
	weaponAbility.push_font(mainFont)
	weaponAbility.add_text(weaponTypeText +"\n"+"آسیب ")
	weaponAbility.pop()
	weaponAbility.push_font(numberFont)
	weaponAbility.add_text(weaponDamageText)
	weaponAbility.pop()
	weaponAbility.pop()
	weaponAbility.pop()
	weaponAbility.pop()
	weaponAbility.pop()

func _on_weapon_selection_button_pressed() -> void:
	var isUnlocked : bool =  HasAchivement(weaponData.WeaponAchievement) 
	Select() if isUnlocked else Locked()
	var selectedWeapon : Dictionary = {
		"Data" : weaponData ,
		"Unlocked" : isUnlocked ,
		"Container" : self
	}
	selector.OnWeaponSelected(selectedWeapon)
