extends Node2D

const Tile = preload("res://Scenes/Tile.tscn")
const Res = preload("res://Scenes/Resource.tscn")

var cell_w = 16
var cell_h = 16

func _ready():
	var size_w = ProjectSettings.get_setting("display/window/size/width")
	var size_h = ProjectSettings.get_setting("display/window/size/height")
	var tiles_w = (size_w / cell_w) + 1
	var tiles_h = (size_h / cell_h) + 1
	var grid = Game.MapGen.getMap(tiles_w, tiles_h, "randomseed", 50)
	for y in range(tiles_h):
		for x in range(tiles_w):
			if grid[y][x]:
				var inst
				if randi() % 20 == 0:
					inst = Res.instance()
				else:
					inst = Tile.instance()
				inst.position = Vector2(x * cell_w, y * cell_h)
				$Map.add_child(inst)
