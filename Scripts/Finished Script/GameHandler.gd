class_name GameHandler extends Node

@export_group("GameManagers")
@export var collectibleHandler : Node
@export var enemyHandler : Node
@export var uiHandler : UiHandler
@export var player : PlayerCharacter

@export_category("Game Handler")
@export var gameTime : float = 20
@export var gameTimer : Timer

signal GameWaveFinished(gamewave : int , playermoney : int)
signal GameOver(gamewave : int)
signal PlayerMoneyChanged(money : int)
signal PlayerBeatBoss(gamewave : int , playermoney : int)

const BossFightWaitTime : float = 3
const BossFightWave : int = 10
var gameWave : int = 1
var playerMoney : int = 0 : set = SetPlayerMoney
var gameTimeMultiplier : int = 0
var bossGameTimeMultiplier : int = 40
var isBossBeated : bool = false

func SetPlayerMoney(money : int) -> void:
	playerMoney = money
	if playerMoney >= 100 :
		AchievementManager.unlock_achievement("get_100_money")

func SetGameTime() -> void:
	if gameWave == 50 :
		AchievementManager.unlock_achievement("reach_wave_50")
	if gameWave % BossFightWave :
		collectibleHandler.GameWaveStart()
		enemyHandler.GameWaveStart()
		gameTimer.wait_time = gameTime + gameTimeMultiplier
	else:
		await  get_tree().create_timer(BossFightWaitTime).timeout
		var boss : EnemyCharacterBossAi = enemyHandler.BossFightStart()
		boss.Bossbeated.connect(PlayerBeatedBoss)
		gameTimer.wait_time = gameTime + gameTimeMultiplier + bossGameTimeMultiplier
	gameTimer.start()

func UpdateStat(itemEffects : Dictionary) -> void:
	for updatedStat in itemEffects.keys():
		var effect : String = updatedStat.Effect
		var value = updatedStat.Value
		var target = get(updatedStat.Target)
		target.set(effect , target.get(effect) + value )

func GameTimerOver() ->void:
	if gameWave % BossFightWave or isBossBeated :
		gameTimer.stop()
		enemyHandler.GameWaveOver()
		await get_tree().create_timer(1.5).timeout
		collectibleHandler.GameWaveOver()
		gameWave += 1
		gameTimeMultiplier += 5
		player.PlayerHealed(player.fullHealth)
		GameWaveFinished.emit(gameWave , playerMoney)
	else:
		PlayerBeatedBoss()

func _ready() -> void:
	SetGameTime()
	gameTimer.timeout.connect(GameTimerOver)

func _process(_delta: float) -> void:
	uiHandler.GetGameTime(gameTimer.time_left)

func PlayerBeatedBoss() -> void:
	isBossBeated = true
	AchievementManager.unlock_achievement("finish_first_time")
	gameTimer.stop()
	enemyHandler.GameWaveOver()
	await get_tree().create_timer(2).timeout
	PlayerBeatBoss.emit( gameWave, playerMoney)

func PlayerDied() -> void:
	gameTimer.stop()
	collectibleHandler.GameWaveOver()
	enemyHandler.GameWaveOver()
	GameOver.emit(gameWave)

func PlayerPickUpMoney(value: float) -> void:
	player.spriteComposition.MoneyFlash()
	var money : int = max(round((2 * value) - 1) , 1)
	playerMoney += money
	PlayerMoneyChanged.emit(playerMoney)

func EnterEndlessMode() -> void:
	player.playerGetHealth(player.fullHealth)
	gameWave += 1
	gameTimeMultiplier += 5
	GameWaveFinished.emit(gameWave , playerMoney)

func ContinueGame() -> void:
	#player.playerGetHealth(player.fullHealth)
	player.PlayerRevive()
	playerMoney += 50
	gameWave += 1
	gameTimeMultiplier += 5
	GameWaveFinished.emit(gameWave , playerMoney)


func WeaponShopEnd(money: int) -> void:
	playerMoney = money
	SetGameTime()
