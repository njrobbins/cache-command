extends Node2D

var cell_id
var cell_position
var cell_size
var instance
var scene
var tilemap

var current_towers = []
var base_hp = 5
var mob = load("res://Scenes/Drone.tscn")
var mobs_left = 0
var tower = load("res://Scenes/Tower.tscn")
var wave = 0
var wave_mobs = [5, 5, 5, 5, 5]
var total_drones = 0

func _ready():
	tilemap = $TowerPlacementTileMap
	cell_size = tilemap.cell_size
	$BaseLabel.text = str(base_hp)
	$CashLabel.text = str(Settings.cash)
	$WaveTimer.start()
	Settings.drones_destroyed = 0
	for i in wave_mobs:
		total_drones += i
	
	for tow in Settings.current_towers_info:
		instance = tower.instance()
		add_child(instance)
		instance.recreate(tow)
		current_towers.push_back(instance)
	
func _input(event):
	$CashLabel.text = str(Settings.cash)
	if event is InputEventMouseButton and event.pressed:
		var m_position = get_global_mouse_position()
		placeTower(m_position)

func placeTower(var pos):
	cell_position = Vector2(floor(pos.x / cell_size.x), floor(pos.y / cell_size.y))
	cell_id = tilemap.get_cellv(cell_position)
	if cell_id != -1:
		var tower_pos = Vector2(cell_position.x * cell_size.x , cell_position.y * cell_size.y)
		if Settings.tower_positions.count(tower_pos) == 0 and Settings.cash >= 25:
			Settings.cash -= 25
			Settings.tower_positions.push_back(tower_pos)
			instance = tower.instance()
			instance.init()
			add_child(instance)
			instance.position = tower_pos
			current_towers.push_back(instance)
				

func _on_PauseButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/PauseMenu.tscn")

func drone_destroyed(cash):
	Settings.cash += cash
	$CashLabel.text = str(Settings.cash)
	if Settings.drones_destroyed == total_drones:
		saveTowers()
		var _scene = get_tree().change_scene("res://Scenes/LevelComplete.tscn")
		
func saveTowers():
	var t = []
	for tower in current_towers:
		var d = {
			"position": tower.position,
			"radius": tower.RADIUS,
			"shootRate": tower.shoot_rate,
			"type": tower.type,
			"destroyed": tower.enemies_destroyed,
		}
		t.push_back(d)
	Settings.current_towers_info = t
		

func base_hit():
	base_hp -= 1
	$BaseLabel.text = str(base_hp)
	if base_hp == 0:
		var _scene = get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_WaveTimer_timeout():
#	print("Wave Start")
	mobs_left = wave_mobs[wave]
	$MobTimer.start()
	$WaveTimer.stop()

func _on_MobTimer_timeout():
#	print("Spawning")
	instance = mob.instance()
	if mobs_left % 5 == 0:
		# Every 5 mobs are bigger, slower mobs
		instance.init(80, 20, true)
	elif mobs_left % 3 == 0:
		# Every 3 mobs are smaller, faster mobs
		instance.init(120, 5, false, true)
	else:
		# Spawn normal mobs
		instance.init(100, 10)
	$Path2D.add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()
			

func _on_TowerShopButton_pressed():
	$TowerShop.visible = !$TowerShop.visible
		
