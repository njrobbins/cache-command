extends Node2D

var tower = load("res://Scenes/Tower.tscn")
var mob = load("res://Scenes/Drone.tscn")
var instance

var cash = 500
var base_hp = 5
var wave = 0
var mobs_left = 0
var mobs_total
var wave_mobs = [5, 5, 15, 15, 15]

var tilemap
var cell_size
var cell_position
var cell_id

var occupied = []

var scene

func _ready():
	tilemap = $TowerPlacementTileMap
	cell_size = tilemap.cell_size
	$WaveTimer.start()
	
	mobs_total = 0
	for w in wave_mobs:
		mobs_total += w

func _physics_process(_delta):
	$CashLabel.text = "Cash: " + str(cash)
	$BaseLabel.text = "Base Health: " + str(base_hp)
#	$MobsLabel.text = "Mobs Left: " + str(mobs_left)
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var m_position = get_global_mouse_position()
		cell_position = Vector2(floor(m_position.x / cell_size.x), floor(m_position.y / cell_size.y))
		cell_id = tilemap.get_cellv(cell_position)
		if cell_id != -1:
#			var tile_name = tilemap.tile_set.tile_get_name(cell_id)
			var tower_pos = Vector2(cell_position.x * cell_size.x , cell_position.y * cell_size.y)
			if occupied.count(tower_pos) == 0 and cash >= 25:
				cash -= 25
				occupied.push_back(tower_pos)
				instance = tower.instance()
				instance.init(210,4)
				add_child(instance)
				instance.position = tower_pos

func _on_PauseButton_pressed():
	scene = get_tree().change_scene("res://Scenes/PauseMenu.tscn")

func add_cash(num):
	cash += num
	mobs_total -= 1
	if mobs_total == 0:
		var scene = get_tree().change_scene("res://Scenes/LevelWon.tscn")
	
func base_hit():
	base_hp -= 1
	if base_hp == 0:
		var scene = get_tree().change_scene("res://Scenes/LevelLost.tscn")

func _on_WaveTimer_timeout():
#	print("Wave Start")
	mobs_left = wave_mobs[wave]
	$MobTimer.start()
	$WaveTimer.stop()


func _on_MobTimer_timeout():
#	print("Spawning")
	instance = mob.instance()
	if mobs_left % 5 == 0:
		# every 5 mobs are bigger slower mobs
		
		instance.init(120, 20, true)
	elif mobs_left % 3 == 0:
		# every 3 mobs are smaller faster mobs
		instance.init(200, 5, false, true)
	else:
		# Spawn normal mobs
		instance.init(160, 10)
	$Path2D.add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()

