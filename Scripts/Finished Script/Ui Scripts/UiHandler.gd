class_name UiHandler extends Node

@export var vignetteContainer : MarginContainer
@export var healthWalletContainer : MarginContainer
@export var settingContainer : MarginContainer
@export var gameTimeWaveContainer : MarginContainer
@export var upgradeContainer : MarginContainer 
@export var weaponShopContainer : MarginContainer
@export var gameOverContainer : MarginContainer
@export var bossBeatContainer : MarginContainer

signal EnterEndlessMode
signal ContinueGame
signal EnterSetting
signal SettingUpdated
signal GetPlayerWeapons(weaponShop : MarginContainer)
signal SellWeapon(weaponName : String)
signal BuyWeapon(weaponData : WeaponData)
signal WeaponShopEnd( money : int  )

func GetGameTime(time : float) -> void:
	gameTimeWaveContainer.GetGameTime(time)

func PlayerHealthChanged(health: int, maxhealth: int) -> void:
	vignetteContainer.GetPlayerHealth(health,maxhealth)
	healthWalletContainer.GetPlayerHealth(health,maxhealth)

func GameOver(gamewave: int) -> void:
	var wave : String = str(gamewave)
	healthWalletContainer.GetPlayerHealthDeath()
	gameOverContainer.GetGameWaveFinish(wave)

func GameWaveFinished(gamewave: int, playermoney: int) -> void:
	gameTimeWaveContainer.GetGameWave(gamewave)
	upgradeContainer.EnterUpgradeShop(playermoney)

func PlayerMoneyChanged(money: int) -> void:
	healthWalletContainer.GetPlayerMoney(money)

func UpgradeShopEnded(money : int) -> void:
	weaponShopContainer.EnterWeaponShop(money)

func PlayerBeatBoss(gamewave: int, playermoney: int) -> void:
	bossBeatContainer.GetPlayerInfo(gamewave, playermoney)
