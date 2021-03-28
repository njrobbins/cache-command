extends Node2D

var tower = load("res://Scenes/Tower.tscn")
var mob = load("res://Scenes/Drone.tscn")
var instance

var cash = 50
var wave = 0
var mobs_left = 0
var wave_mobs = [5, 15, 30, 60, 120]

var tilemap
var cell_size
var cell_position
var cell_id

var occupied = []

func _ready():
	tilemap = $TileMap
	cell_size = tilemap.cell_size
	$WaveTimer.start()

func _physics_process(_delta):
	$CashLabel.text = "cash: " + str(cash)
	
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
				add_child(instance)
				instance.position =  tower_pos

func add_cash(num):
	cash += num

func _on_WaveTimer_timeout():
#	print("Wave Start")
	mobs_left = wave_mobs[wave]
	$MobTimer.start()
	$WaveTimer.stop()


func _on_MobTimer_timeout():
#	print("Spawning")
	instance = mob.instance()
	$Path2D.add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()

