extends KinematicBody2D

export var speed = 200
export var RADIUS = 200
export var shoot_rate = 2

var velocity = Vector2()

onready var joystick_move = get_parent().get_node("Joystick")

var slow_amt = 0
var enemy_array = []
var instance
var current_target = null
var shot = load("res://Scenes/Shot.tscn")

func _physics_process(_delta):
	if joystick_move and joystick_move.is_working:
		var vel = joystick_move.output * (speed - slow_amt)
		velocity = move_and_slide(vel)
		
		$PlayerWrapper.rotation = velocity.angle()
	
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider != null:
#			if collision.collider.is_in_group("res"):
#				get_parent().add_time(0.5)
#				Settings.cash += 5
#				get_parent().update_wafers()
#				collision.collider.free()
#			elif collision.collider.is_in_group("tile"):
#				collision.collider.free()
				
	if current_target != null:
		var target_position = current_target.get_global_transform().origin
		$Turret.set_rotation((target_position - position).angle()+deg2rad(90))
	if current_target == null and len(enemy_array) > 0:
		current_target = enemy_array[0]
		$ShootTimer.start()


func _on_HitDetector_area_entered(area):
	if area.is_in_group("shot") and area.sentBy != "player":
		area.queue_free()
		slow_amt += 20
		$SlowTimer.start()

func _on_ShootTimer_timeout():
	if current_target != null:
		instance = shot.instance()
		instance.set_target(current_target, true)
		instance.position = $Turret/ShotPosition.get_global_transform().origin
		instance.sentBy = "player"
		get_parent().add_child(instance)

func _on_Aggro_body_entered(body):
	if body.is_in_group("enemy"):
		current_target = body
		enemy_array.append(body)
		$ShootTimer.start()

func _on_Aggro_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_array.erase(body)
		if current_target:
			if body == current_target:
				current_target = null
				$ShootTimer.stop()

func _on_SlowTimer_timeout():
	slow_amt = 0


func _on_HitDetector_body_entered(body):
	if body.is_in_group("res"):
		get_parent().add_time(0.5)
		Settings.cash += 5
		get_parent().update_wafers()
		body.free()
	elif body.is_in_group("tile"):
		body.free()
