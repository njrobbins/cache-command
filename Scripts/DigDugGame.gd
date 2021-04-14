extends Node2D

const Tile = preload("res://Scenes/DigDugTile.tscn")
const Res = preload("res://Scenes/DigDugResource.tscn")
const Enemy = preload("res://Scenes/DigDugEnemy.tscn")

var scene
var number_of_enemies = 8
var number_of_resources = 25

var current_map_num = str(Settings.level)
var current_map
var maps = {
	"1": "res://Scenes/DDLevels/ObstaclesTileMap.tscn",
	"2": "res://Scenes/DDLevels/ObstaclesTileMap2.tscn",
	"3": "res://Scenes/DDLevels/ObstaclesTileMap3.tscn",
}

func _ready():
	var background_maps = {
		"1": $Map/BackgroundTileMap,
		"2": $Map/BackgroundTileMap2,
		"3": $Map/BackgroundTileMap3,
	}

	if current_map != null:
		current_map.queue_free()

	current_map = load(maps[current_map_num]).instance()
	background_maps[current_map_num].visible = true
	$Map.add_child(current_map)
	
	randomize()
	var size_w = ProjectSettings.get_setting("display/window/size/width")
	var size_h = ProjectSettings.get_setting("display/window/size/height")
	var tiles_w = (size_w / 64) - 2
	var tiles_h = (size_h / 64) - 2
	
	while(number_of_resources != 0):
		var x = (randi() % tiles_w) + 1
		var y = (randi() % tiles_h) + 1
		
		if current_map.get_cell(x, y) == -1:
			var inst = Res.instance()
			inst.position = Vector2(x * 64, y * 64)
			$Map.add_child(inst)
			number_of_resources -= 1
			
	while(number_of_enemies != 0):
		var x = (randi() % tiles_w) + 1
		var y = (randi() % tiles_h) + 1
		
		if current_map.get_cell(x, y) == -1:
			var inst = Enemy.instance()
			inst.position = Vector2(x * 64, y * 64)
			$Map.add_child(inst)
			number_of_enemies -= 1
	
	
#	rng.randomize()
#	var size_w = ProjectSettings.get_setting("display/window/size/width")
#	var size_h = ProjectSettings.get_setting("display/window/size/height")
#	var tiles_w = (size_w / cell_w) + 1
#	var tiles_h = (size_h / cell_h) + 1
#	var random_seed = rng.randf_range(-99999.0, 99999.0)
#	var grid = Game.MapGen.getMap(tiles_w, tiles_h, random_seed, 47)
#	var inst
#	for y in range(tiles_h):
#		for x in range(tiles_w):
#			if grid[y][x]:
#				if randi() % 20 == 0:
#					inst = Res.instance()
#				else:
#					inst = Tile.instance()
#				inst.position = Vector2(x * cell_w, y * cell_h)
#				$Map.add_child(inst)
#			else:
#				if !(x >= 0 && x < 3) && !(y >= 0 && y < 3) :
#					if randi() % 8 == 0 and number_of_enemies > 0:
#						inst = Enemy.instance()
#						inst.position = Vector2(x * cell_w, y * cell_h)
#						$Map.add_child(inst)
#						number_of_enemies -= 1


func _process(_delta):
	$UI/TimeLabel.text = str(stepify($GameTimer.time_left,0.001))

func add_time(var amt):
	$GameTimer.start($GameTimer.time_left + amt)

func update_wafers():
	$UI/WafersCollectedLabel.text = str("Wafers: " + str(Settings.cash))

func _on_GameTimer_timeout():
	var _scene = get_tree().change_scene("res://Scenes/UpgradeScreen.tscn")

func _on_PauseButton_pressed():
	scene = get_tree().change_scene("res://Scenes/PauseMenu.tscn")
