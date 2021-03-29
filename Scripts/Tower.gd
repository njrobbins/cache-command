extends Area2D

var enemy_array = []

var shooting = false
var current_target = null
var target_position
var distance_to_t

var instance
var shot = load("res://Scenes/Shot.tscn")

export var RADIUS = 200
export var shoot_rate = 4

func init(rad, rate):
	RADIUS = rad
	shoot_rate = rate
	
	$Aggro/AggroShape.shape.radius = RADIUS
	$ShootTimer.set_wait_time(1.0/shoot_rate)
		
func _physics_process(_delta):
	if !current_target:
		distance_to_t = RADIUS + 1
		for target in enemy_array:
			if (position - target.get_global_transform().origin).length() < distance_to_t:
				current_target = weakref(target)
				target_position = target.get_global_transform().origin
				distance_to_t = (position - target.position).length()
			if current_target:
				$ShootTimer.start()
	else:
		if(!current_target.get_ref()):
			current_target = null
			$ShootTimer.stop()
		else:
			target_position = current_target.get_ref().get_global_transform().origin
			$Gun.set_rotation((target_position - position).angle())

func _on_Aggro_area_entered(area):
	if area.is_in_group("enemy"):
		enemy_array.append(area.get_parent())


func _on_Aggro_area_exited(area):
	if area.is_in_group("enemy"):
		enemy_array.erase(area.get_parent())
		if current_target:
			if area.get_parent() == current_target.get_ref():
				current_target = null
				$ShootTimer.stop()

func _on_ShootTimer_timeout():
	if current_target.get_ref():
		instance = shot.instance()
		instance.set_target(current_target.get_ref())
		instance.position = $Gun/ShotPosition.get_global_transform().origin
		get_parent().add_child(instance)
