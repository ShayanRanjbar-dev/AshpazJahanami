extends Node

@export var player : CharacterBody2D
@export var enemyScenes : Array[PackedScene]
@export var bossEnemyScenes : Array[PackedScene]
@export var enemyMaxSpawnTime : float = 3.0 : set = SetSpawnTime
@export var spawnNode : Node2D
@export var bulletHolderNode : Node2D 
@export var spawnerTimer : Timer

@export var enemyDataCable : Cable

signal EnemyCameraShake(duration : float , strength :float)
signal SpawnKillMoney(position : Vector2)

const SPAWN_LIMIT : Vector4i = Vector4i(-800,800,-350,400)
var damagedEnemies : Array[EnemyCharacterAi]
var unlockedEnemies : Array[PackedScene]

func GameWaveOver() -> void:
	spawnerTimer.stop()
	for bullet : EnemyBullet in bulletHolderNode.get_children().duplicate() :
		bullet.queue_free()
	for enemy : EnemyCharacterAi  in spawnNode.get_children().duplicate() :
		enemy.EnemyDeath()

func GameWaveStart() ->void:
	if not enemyScenes.is_empty():
		var newEnemy : PackedScene = enemyScenes.pop_front()
		unlockedEnemies.append(newEnemy)
	spawnerTimer.wait_time = randf_range(1,enemyMaxSpawnTime)
	spawnerTimer.start()

func BossFightStart() -> EnemyCharacterBossAi:
	var spawnPosition : Vector2 = Vector2.ZERO
	var bossScene : PackedScene = bossEnemyScenes.pop_front()
	bossEnemyScenes.push_back(bossScene)
	var bossNode : EnemyCharacterBossAi = bossScene.instantiate()
	bossNode.global_position = spawnPosition
	bossNode.UpdateEnemyStats(enemyDataCable.get_value_or_default(EnemyData.new()))
	bossNode.SetTarget(player)
	bossNode.GetBulletHolderNode(bulletHolderNode)
	bossNode.SetEnemyHandler(self)
	spawnNode.add_child(bossNode)
	return bossNode

func GetSpawnPosition() ->Vector2:
	var spawnPositionX = randf_range(SPAWN_LIMIT.x,SPAWN_LIMIT.y)
	var spawnPositionY = randf_range(SPAWN_LIMIT.z,SPAWN_LIMIT.w)
	var randomSpawnPosition = Vector2(spawnPositionX,spawnPositionY)
	return randomSpawnPosition

func SpawnEnemy() -> void:
	if !is_instance_valid(player):
		spawnerTimer.stop()
		return
	var randomSpawnPosition = GetSpawnPosition()
	var selectedEnemy : PackedScene = unlockedEnemies.pop_front()
	unlockedEnemies.push_back(selectedEnemy)
	var selectedEnemyNode : EnemyCharacterAi = selectedEnemy.instantiate()
	selectedEnemyNode.global_position = randomSpawnPosition
	selectedEnemyNode.UpdateEnemyStats(enemyDataCable.get_value_or_default(EnemyData.new()))
	selectedEnemyNode.SetTarget(player)
	selectedEnemyNode.SetEnemyHandler(self)
	if selectedEnemyNode is EnemyCharacterShooterAi :
		selectedEnemyNode.GetBulletHolderNode(bulletHolderNode)
	spawnNode.add_child(selectedEnemyNode)

func SetDamagedEnemy(enemy : EnemyCharacterAi) -> void:
	if enemy not in damagedEnemies:
		damagedEnemies.append(enemy)

func RemoveFromDamaged(enemy : EnemyCharacterAi) -> void:
	if enemy in damagedEnemies:
		damagedEnemies.erase(enemy)

func SetSpawnTime(value : float) -> void:
	var rawTime : float = 3
	var factor = log(2 - value) / log(2)
	enemyMaxSpawnTime = max(rawTime / factor, 0.5)

func UpdateEnemyStats(enemyData : EnemyData) -> void:
	enemyMaxSpawnTime = enemyData.SpawnTime

func _ready() -> void:
	enemyDataCable.link(UpdateEnemyStats)

func EnemySpawnerTimerTimeOut() -> void:
	var spawnCount : int = 2 if (randi_range(0, 100) <= 20) else 1
	for i in range(spawnCount):
		SpawnEnemy()
