extends Node2D

var mob = load("res://Scenes/Drone.tscn")
var tower = load("res://Scenes/Tower.tscn")

# Variables used for tower placement
var cell_id
var cell_position
var cell_size
var instance
var scene
var tilemap

var current_map_num = str(Settings.level)
var current_map
var maps = {
	"1": "res://Scenes/TDLevels/TDLevel1.tscn",
	"2": "res://Scenes/TDLevels/TDLevel2.tscn",
	"3": "res://Scenes/TDLevels/TDLevel3.tscn",
}

# Variables used in tracking towers
var current_towers = []

# General Variables
var base_hp = 15 # The base hp before the base is destroyed
var wave = 0 # Indicates what wave is active (i.e what index of wave_mobs is being run)
var mobs_left_wave = 0 # Indicates how many mobs are left in the current wave
var wave_mobs = [4, 4, 4, 4, 6] # Indicates how many mobs are in each wave
var total_drones = 0 # Tracks the total number of drones destroyed

func _ready():
	Settings.paused = true
	
	if current_map != null:
		current_map.queue_free()

	current_map = load(maps[current_map_num]).instance()
	$TowersNode.add_child(current_map)
	
	tilemap = current_map.get_node("TowerPlacementTileMap")
	cell_size = tilemap.cell_size
	$BaseLabel.text = str(base_hp)
	$CashLabel.text = str(Settings.cash)
	
	get_mobs()
	# Calculates the total number of drones that need to be destroyed before the level is over
	Settings.drones_destroyed = 0
	for i in wave_mobs:
		total_drones += i
	print(total_drones)
	
	# Places any previously placed towers
	for tow in Settings.current_towers_info:
		instance = tower.instance()
		$TowersNode.add_child(instance)
		instance.recreate(tow)
		current_towers.push_back(instance)

func _process(_delta):
	if (Settings.paused == false):
		if Settings.drones_destroyed == total_drones: # Level Complete, all drones destroyed
			saveTowers()
			Settings.td_level += 1
			if Settings.td_level % 3 == 0:
				Settings.level += 1
				if Settings.level == 4:
					Settings.level = 1 
			var _scene = get_tree().change_scene("res://Scenes/UpgradeScreen.tscn")
			
	
func get_mobs():
	for _i in range(Settings.td_level - 1):
		for i in range(len(wave_mobs)):
			wave_mobs[i] += 6
	
	
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
		if Settings.tower_positions.count(tower_pos) == 0 and Settings.cash >= Settings.tower_costs[Settings.tower_type_selected]:
			Settings.cash -= Settings.tower_costs[Settings.tower_type_selected]
			Settings.tower_positions.push_back(tower_pos)
			instance = tower.instance()
			instance.init(Settings.tower_type_selected)
			$TowersNode.add_child(instance)
			instance.position = tower_pos
			current_towers.push_back(instance)
			$PlaceTowerAudio.play()

func _on_PauseButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	$PauseMenu.visible = true
	$TowersNode.visible = false
	$MobTimer.paused = true
	$WaveTimer.paused = true
	Settings.paused = true

func drone_destroyed(cash):
	Settings.cash += cash
	$CashLabel.text = str(Settings.cash)
		
# Saves the current towers information in the global current_towers_info structure
func saveTowers():
	var t = []
	for tower in current_towers:
		var d = {
			"position": tower.position,
			"radius": tower.RADIUS,
			"shootRate": tower.shoot_rate,
			"type": tower.type,
			"destroyed": tower.enemies_destroyed,
			"range_cost": tower.range_cost,
			"speed_cost": tower.speed_cost,
			"range_level": tower.range_level,
			"speed_level": tower.speed_level,
		}
		t.push_back(d)
	Settings.current_towers_info = t
		

func base_hit():
	base_hp -= 1
	$BaseLabel.text = str(base_hp)
	if base_hp == 0:
		# RESET TO ALL BASE STATS
		# Global Game Variables
		Settings.cash = 75
		Settings.level = 1
		Settings.paused = false
		# Tower Defense Variables
		Settings.drones_destroyed = 0
		Settings.td_level = 1
		Settings.tower_type_selected = "copperhead"
		Settings.tower_positions = [] # Keeps a list of all the positions currently occupied by a tower
		Settings.current_towers_info = [] # Keeps a list of dictionaries containing information about each placed tower
		Settings.tower_costs = {
			"copperhead": 25,
			"steel": 100,
			"moon": 100,
			"doubletrouble": 100,
		}
		# Dig Dug Variables
		Settings.player_speed = 200
		Settings.player_shoot_rate = 2
		Settings.time_added_per_wafer = 0.5
		Settings.cash_per_wafer = 5
		Settings.upgrade_costs = {
			"speed": 20,
			"rate": 20,
			"time": 20,
			"wafers": 20,
		}
		var _scene = get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_WaveTimer_timeout():
	# Starts a wave
	mobs_left_wave = wave_mobs[wave]
	$MobTimer.start()
	$WaveTimer.stop()

func _on_MobTimer_timeout():
	# Spawns a new mob, changes depending on how many mobs are left in wave
	instance = mob.instance()
	if mobs_left_wave % 5 == 0:
		# Every 5 mobs are bigger, slower mobs
		instance.init(100, 40, "big")
	elif mobs_left_wave % 3 == 0:
		# Every 3 mobs are smaller, faster mobs
		instance.init(140, 10, "fast")
	else:
		# Spawn normal mobs
		instance.init(100, 10, "normal")
	current_map.get_node("Path2D").add_child(instance)
	
	
	mobs_left_wave -= 1
	if mobs_left_wave <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()
			

func _on_TowerShopButton_pressed():
	$TowerShop.visible = !$TowerShop.visible
		

func _on_StartButton_pressed():
	Settings.paused = false
	$WaveTimer.start()
	$StartButton.visible = false
	$StartWaveAudio.play()
