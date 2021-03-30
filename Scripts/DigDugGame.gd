extends Node2D

const Tile = preload("res://Scenes/DigDugTile.tscn")
const Res = preload("res://Scenes/DigDugResource.tscn")
const Enemy = preload("res://Scenes/DigDugEnemy.tscn")

var cell_w = 16
var cell_h = 16
var number_of_enemies = 8
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var size_w = ProjectSettings.get_setting("display/window/size/width")
	var size_h = ProjectSettings.get_setting("display/window/size/height")
	var tiles_w = (size_w / cell_w) + 1
	var tiles_h = (size_h / cell_h) + 1
	var random_seed = rng.randf_range(-99999.0, 99999.0)
	var grid = Game.MapGen.getMap(tiles_w, tiles_h, random_seed, 47)
	var inst
	for y in range(tiles_h):
		for x in range(tiles_w):
			if grid[y][x]:
				if randi() % 20 == 0:
					inst = Res.instance()
				else:
					inst = Tile.instance()
				inst.position = Vector2(x * cell_w, y * cell_h)
				$Map.add_child(inst)
			else:
				if !(x >= 0 && x < 3) && !(y >= 0 && y < 3) :
					if randi() % 27 == 0 and number_of_enemies > 0:
						inst = Enemy.instance()
						inst.position = Vector2(x * cell_w, y * cell_h)
						$Map.add_child(inst)
						number_of_enemies -= 1
func _process(delta):
	$TimeLabel.text = str($GameTimer.time_left)
	
func add_time(var amt):
	$GameTimer.start($GameTimer.time_left + amt)

func _on_GameTimer_timeout():
	var _scene = get_tree().change_scene("res://Scenes/TowerDefenseGame.tscn")
