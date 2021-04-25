extends Area2D

export var RADIUS = 200
export var shoot_rate = 4

var instance
var distance_to_t
var target_position
var current_target = null
var enemy_array = []
var shot = load("res://Scenes/Shot.tscn")
var placed = false
var type
var enemies_destroyed = 0
var speed_cost = 10
var range_cost = 10
var range_level = 0
var speed_level = 0

# rad is the range of the tower for shooting, and rate is how fast it shoots
func init(t_type,rad=210, rate=3):
	if t_type == "copperhead":
		RADIUS = rad
		shoot_rate = rate
		type = "copperhead"
	elif t_type == "steel" and rad==210:
		RADIUS = 350
		shoot_rate = 8
		type = "steel"
	elif t_type == "steel":
		RADIUS = rad
		shoot_rate = rate
		type = "steel"
	
	$Aggro/AggroShape.shape.radius = RADIUS
	var rad_scale = RADIUS / 100.0
	$RadiusCircle.rect_scale = Vector2(rad_scale, rad_scale)
	$ShootTimer.set_wait_time(1.0 / shoot_rate)
	$UpgradePanel/RangeLabel.text = str(RADIUS)
	$UpgradePanel/SpeedLabel.text = str(shoot_rate)
	$UpgradePanel/DronesDestroyed.text = "Destroyed: " + str(enemies_destroyed)


# Used whenever you need to place a previously placed tower
func recreate(var t):
	position = t["position"] 
	RADIUS = t["radius"]
	shoot_rate = t["shootRate"]
	type = t["type"]
	enemies_destroyed = t["destroyed"]
	speed_cost = t["speed_cost"]
	range_cost = t["range_cost"]
	speed_level = t["speed_level"]
	range_level = t["range_level"]
	placed = true
	
	init(type, RADIUS, shoot_rate)


func _physics_process(_delta):
	if Settings.paused == true:
		$SmallShotAudio.stop()
		$ShootTimer.paused = true
	else:
		if $ShootTimer.paused == true:
			$ShootTimer.paused = false
		
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
		if !current_target.get_ref():
			current_target = null
			$ShootTimer.stop()
			$SmallShotAudio.stop()
		else:
			target_position = current_target.get_ref().get_global_transform().origin
			$Gun.set_rotation((target_position - position).angle() + 30)


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
				$SmallShotAudio.stop()


func _on_ShootTimer_timeout():
	if current_target.get_ref():
		$SmallShotAudio.stop()
		$SmallShotAudio.play()
		instance = shot.instance()
		instance.sentBy = type
		instance.set_target(current_target.get_ref())
		instance.owner_tower = self
		instance.position = $Gun/ShotPosition.get_global_transform().origin
		get_parent().add_child(instance)


func updateDronesDestroyed():
	enemies_destroyed += 1
	$UpgradePanel/DronesDestroyed.text = "Destroyed: " + str(enemies_destroyed)


#### Stats and Upgrade Screen Functions ####
func _on_TowerButton_pressed():
	if placed:
		$RadiusCircle.visible = !$RadiusCircle.visible
		$UpgradePanel.visible = !$UpgradePanel.visible
		$UpgradePanel/RangeButton.text = "Range $"+str(range_cost)
		$UpgradePanel/SpeedButton.text = "Speed $"+str(speed_cost)
	else:
		placed = true


func _on_RangeButton_pressed():
	if Settings.cash >= range_cost:
		Settings.cash -= range_cost
		range_cost += 5 + range_level*5
		range_level += 1
		RADIUS += 25
		$Aggro/AggroShape.shape.radius = RADIUS
		var rad_scale = RADIUS / 100.0
		$RadiusCircle.rect_scale = Vector2(rad_scale, rad_scale)
		$UpgradePanel/RangeLabel.text = str(RADIUS)
		$UpgradePanel/RangeButton.text = "Range $"+str(range_cost)


func _on_SpeedButton_pressed():
	if Settings.cash >= speed_cost:
		Settings.cash -= speed_cost
		speed_cost += 5 + speed_level*5
		speed_level += 1
		shoot_rate += 1
		$ShootTimer.set_wait_time(1.0 / shoot_rate)
		$UpgradePanel/SpeedLabel.text = str(shoot_rate)
		$UpgradePanel/SpeedButton.text = "Speed $"+str(speed_cost)


func _on_SmallShotAudio_finished():
	$SmallShotAudio.stop()
