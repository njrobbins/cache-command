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
			current_map.set_cell(x, y, 21)
			number_of_resources -= 1
	
	for y in range(tiles_h):
		for x in range(tiles_w):
			if current_map.get_cell(x, y) == -1:
				var inst = Tile.instance()
				inst.position = Vector2(x * 64, y * 64)
				$Map.add_child(inst)
			
	while(number_of_enemies != 0):
		var x = (randi() % tiles_w) + 1
		var y = (randi() % tiles_h) + 1
		
		if current_map.get_cell(x, y) == -1:
			var inst = Enemy.instance()
			inst.position = Vector2(x * 64, y * 64)
			$Map.add_child(inst)
			number_of_enemies -= 1


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
