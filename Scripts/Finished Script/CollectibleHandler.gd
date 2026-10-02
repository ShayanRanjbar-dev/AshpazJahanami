extends Node

@export var player : CharacterBody2D
@export var collectibleScenes : Array[PackedScene]
@export var collectibleSpawner : Node2D
@export var collectibleMaxSpawnTime : float = 3.0 : set = SetSpawnTime
@export var spawnerTimer : Timer

@export var collectibleDataCable : Cable

signal PlayerPickUpMoney(value : float)
signal PlayerPickUpChefHat(value : float)

const SPAWN_LIMIT : Vector4i = Vector4i(-800,800,-400,400)
const MONEY_SCENE : PackedScene = preload("uid://bwbujtevyreeq")

func GameWaveOver() -> void:
	spawnerTimer.stop()
	for collectible : BaseCollectible in collectibleSpawner.get_children().duplicate():
		if is_instance_valid(collectible):
			collectible.SetCollectAnimation() 

func GameWaveStart() ->void:
	spawnerTimer.wait_time = randf_range(2,ceil(collectibleMaxSpawnTime))
	spawnerTimer.start()

func SetSpawnTime(value : float) -> void:
	var rawTime : float = 3
	var factor = log(2 - value) / log(2)
	collectibleMaxSpawnTime = max(rawTime / factor, 0.5)

func SetCollectibleStats(modifier : CollectibleData) -> void:
	collectibleMaxSpawnTime = modifier.SpawnTime

func _ready() -> void:
	collectibleDataCable.link(SetCollectibleStats)
	GameWaveStart()
	SpawnCollectible()

func SpawnCollectible() -> void:
	if !is_instance_valid(player):
		spawnerTimer.stop()
		return
	var spawnPositionX = randf_range(SPAWN_LIMIT.x,SPAWN_LIMIT.y)
	var spawnPositionY = randf_range(SPAWN_LIMIT.z,SPAWN_LIMIT.w)
	var randomSpawnPosition = Vector2(spawnPositionX,spawnPositionY)
	var selectedCollectible : PackedScene = collectibleScenes.pop_front()
	collectibleScenes.push_back(selectedCollectible)
	var selectedCollectibleNode : BaseCollectible = selectedCollectible.instantiate()
	selectedCollectibleNode.SetCollectibleUpgrades(collectibleDataCable.get_value_or_default(CollectibleData.new()))
	selectedCollectibleNode.global_position = randomSpawnPosition
	collectibleSpawner.add_child(selectedCollectibleNode)

func CollectibleSpawnerTimeOut() -> void:
	SpawnCollectible()

func SpawnKillMoney(position: Vector2) -> void:
	for moneyCount in randi_range(1,3) :
		var moneyNode : BaseCollectible = MONEY_SCENE.instantiate()
		var randompos : float = randi_range(-32,32)
		var spawnPos : Vector2 = position + Vector2(randompos ,randompos)
		moneyNode.SetCollectibleUpgrades(collectibleDataCable.get_value_or_default(CollectibleData.new()))
		moneyNode.global_position = spawnPos
		collectibleSpawner.call_deferred("add_child", moneyNode)
