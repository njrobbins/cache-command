extends Area2D

var building = true
var can_build = false
var colliding = false

var enemy_array = []

var tilemap
var cell_size
var cell_position
var cell_id
var current_tile

var shooting = false
var current_target = null
var target_position
var distance_to_t = 1000

var instance
var shot = load("res://Scenes/Shot.tscn")

const RADIUS = 200

func _ready():
		tilemap = get_parent().get_node("TileMap")
		cell_size = tilemap.cell_size
		
func _physics_process(_delta):
	if building:
		_follow_mouse()
		if can_build:
			pass
		if Input.is_action_just_pressed("click") and can_build:
			building = false
			get_parent().tower_built()
	else:
		if !current_target:
			distance_to_t = RADIUS + 1
			for target in enemy_array:
				if (position - target.get_global_transform().origin).length() < distance_to_t:
					current_target = weakref(target)
					target_position = target.get_global_transform().origin
					distance_to_t = (position - target.position).length()
				if current_target:
					$ShootTimer.start()
					print("shooting")
		else:
			if(!current_target.get_ref()):
				current_target = null
				$ShootTimer.stop()
			else:
				target_position = current_target.get_ref().get_global_transform().origin
				$Gun.set_rotation((target_position - position).angle())
				
func _follow_mouse():
	position = get_global_mouse_position()
	cell_position = Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))
	cell_id = tilemap.get_cellv(cell_position)
	if cell_id != -1 && !colliding:
		current_tile = tilemap.tile_set.tile_get_name(cell_id)
		if current_tile == "tower_base":
			can_build = true
			position = Vector2(cell_position.x * cell_size.x + cell_size.x /2, cell_position.y * cell_size.y + cell_size.y/2)
	else:
		can_build = false

func _on_Aggro_area_entered(area):
	
	if area.is_in_group("enemy"):
		print("enemy entered")
		enemy_array.append(area.get_parent())


func _on_Aggro_area_exited(area):
	print("enemy left")
	if area.is_in_group("enemy"):
		enemy_array.erase(area.get_parent())
		if current_target:
			if area.get_parent() == current_target.get_ref():
				current_target = null
				$ShootTimer.stop()


func _on_Tower_area_entered(area):
	if area.is_in_group("tower"):
		colliding = true


func _on_Tower_area_exited(area):
	if area.is_in_group("tower"):
		colliding = false


func _on_ShootTimer_timeout():
	if current_target.get_ref():
		instance = shot.instance()
		instance.set_target(current_target.get_ref())
		instance.position = $Gun/ShotPosition.get_global_transform().origin
		get_parent().add_child(instance)
		print("shot")
