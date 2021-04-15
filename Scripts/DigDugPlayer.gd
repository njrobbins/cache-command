extends KinematicBody2D

var velocity = Vector2()
var target = position

var slow_amt = 0
var enemy_array = []
var instance
var current_target = null
var shot = load("res://Scenes/Shot.tscn")

func _ready():
	$ShootTimer.set_wait_time(1.0 / Settings.player_shoot_rate)

# TEMPORARY - just for debugging
func _process(_delta):
	$Debug/Label1.text = str(getSpeed())
	

func _physics_process(_delta):
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		target = get_global_mouse_position()
		
	velocity = (target - position).normalized() * getSpeed()
	if (target - position).length() > 5:
		$TankEngineAudio.play()
		velocity = move_and_slide(velocity)
		$PlayerWrapper.rotation = velocity.angle()
				
	if current_target != null:
		var target_position = current_target.get_global_transform().origin
		$Turret.set_rotation((target_position - position).angle()+deg2rad(90))
	if current_target == null and len(enemy_array) > 0:
		current_target = enemy_array[0]
		$ShootTimer.start()
		
func getSpeed():
	if (Settings.player_speed - slow_amt) < 50:
		return 50
	else:
		return (Settings.player_speed - slow_amt)

func _on_HitDetector_area_entered(area):
	if area.is_in_group("shot") and area.sentBy != "player":
		area.queue_free()
		slow_amt += 20
		$SlowTimer.start()

func _on_ShootTimer_timeout():
	if current_target != null:
		$PlayerShotAudio.stop()
		$PlayerShotAudio.play()
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
				$PlayerShotAudio.stop()

func _on_SlowTimer_timeout():
	slow_amt = 0


func _on_HitDetector_body_entered(body):
	if body.is_in_group("res"):
		get_parent().add_time(Settings.time_added_per_wafer)
		Settings.cash += Settings.cash_per_wafer
		get_parent().update_wafers()
		body.free()
	elif body.is_in_group("tile"):
		body.free()
