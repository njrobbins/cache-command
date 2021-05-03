extends Area2D

var RADIUS = 200
var shoot_rate = 6
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
var disabled
var rocketLeft = true
var amountSpent = 0

# rad is the range of the tower for shooting, and rate is how fast it shoots
func init(t_type):
	if disabled:
		z_as_relative = true
	type = t_type
	RADIUS = Settings.tower_stats[t_type]['base_range']
	shoot_rate = Settings.tower_stats[t_type]['base_rate']
	speed_cost = Settings.tower_stats[t_type]['speed_upgrade_base_cost']
	range_cost = Settings.tower_stats[t_type]['range_upgrade_base_cost']
	amountSpent = Settings.tower_stats[t_type]["cost"]
	if type == "copperhead":
		$Gun.texture = load("res://Assets/tower_gun_1_copper.png")
	if type == "moon":
		$Rocket1.visible = true
		$Gun.visible = false
	if type == "doubletrouble":
		$Rocket2.visible = true
		$Gun.visible = false
	$Aggro/AggroShape.shape.radius = RADIUS
	var rad_scale = RADIUS / 100.0
	$RadiusCircle.rect_scale = Vector2(rad_scale, rad_scale)
	$ShootTimer.set_wait_time(1.0 / shoot_rate)
	$UpgradePanelAttached/RangeLabel.text = str(RADIUS)
	$UpgradePanelAttached/SpeedLabel.text = str(shoot_rate)
	$UpgradePanelAttached/DronesDestroyed.text = str(enemies_destroyed)


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
	if type == "copperhead":
		$Gun.texture = load("res://Assets/tower_gun_1_copper.png")
	if type == "moon":
		$Rocket1.visible = true
		$Gun.visible = false
	if type == "doubletrouble":
		$Rocket2.visible = true
		$Gun.visible = false
	$Aggro/AggroShape.shape.radius = RADIUS
	var rad_scale = RADIUS / 100.0
	$RadiusCircle.rect_scale = Vector2(rad_scale, rad_scale)
	$ShootTimer.set_wait_time(1.0 / shoot_rate)
	$UpgradePanelAttached/RangeLabel.text = str(RADIUS)
	$UpgradePanelAttached/SpeedLabel.text = str(shoot_rate)
	$UpgradePanelAttached/DronesDestroyed.text = str(enemies_destroyed)


func _physics_process(_delta):
	if not disabled:
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
				$Rocket1.set_rotation((target_position - position).angle() + 30)
				$Rocket2.set_rotation((target_position - position).angle() + 30)


func _on_Aggro_area_entered(area):
	if area.is_in_group("enemy") and not disabled:
		enemy_array.append(area.get_parent())


func _on_Aggro_area_exited(area):
	if area.is_in_group("enemy") and not disabled:
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
		if type == "moon":
			instance.position = $Rocket1/ShotPosition1.get_global_transform().origin
		elif type == "doubletrouble":
			if rocketLeft:
				instance.position = $Rocket2/ShotPosition1.get_global_transform().origin
			else:
				instance.position = $Rocket2/ShotPosition2.get_global_transform().origin
			rocketLeft = !rocketLeft
		else:
			instance.position = $Gun/ShotPosition.get_global_transform().origin
		get_parent().add_child(instance)


func updateDronesDestroyed():
	enemies_destroyed += 1
	if not Settings.upgrade_panel_attached:
		var upgrade_panel = get_parent().get_parent().get_node("UpgradePanelDetached")
		if upgrade_panel.selected_tower == self:
			upgrade_panel.get_node("DronesDestroyed").text = str(enemies_destroyed)
	else:
		$UpgradePanelAttached/DronesDestroyed.text = str(enemies_destroyed)


#### Stats and Upgrade Screen Functions ####
func _on_TowerButton_pressed():
	if not disabled:
		if placed:
			if not Settings.upgrade_panel_attached:
				var upgrade_panel = get_parent().get_parent().get_node("UpgradePanelDetached")
				if upgrade_panel.selected_tower == self:
					upgrade_panel.check()
					upgrade_panel.toggle()
				else:
					upgrade_panel.check()
					upgrade_panel.selected_tower = self
					upgrade_panel.toggle()
			else:
				$RadiusCircle.visible = !$RadiusCircle.visible
				$UpgradePanelAttached.visible = !$UpgradePanelAttached.visible
				$UpgradePanelAttached/RangeButton.text = "Range ("+str(range_cost)+"):"
				$UpgradePanelAttached/SpeedButton.text = "Speed ("+str(speed_cost)+"):"
		else:
			placed = true


func _on_RangeButton_pressed():
	if not disabled:
		if Settings.cash >= range_cost:
			Settings.cash -= range_cost
			amountSpent += range_cost
			range_cost += Settings.tower_stats[type]['range_cost_added'] + range_level*Settings.tower_stats[type]['range_cost_added']
			range_level += 1
			RADIUS += Settings.tower_stats[type]['range_amt_per_level']
			$Aggro/AggroShape.shape.radius = RADIUS
			var rad_scale = RADIUS / 100.0
			$RadiusCircle.rect_scale = Vector2(rad_scale, rad_scale)
			$UpgradePanelAttached/RangeLabel.text = str(RADIUS)
			$UpgradePanelAttached/RangeButton.text = "Range ("+str(range_cost)+"):"


func _on_SpeedButton_pressed():
	if not disabled:
		if Settings.cash >= speed_cost:
			Settings.cash -= speed_cost
			amountSpent += speed_cost
			speed_cost += Settings.tower_stats[type]['speed_cost_added'] + speed_level*Settings.tower_stats[type]['speed_cost_added']
			speed_level += 1
			shoot_rate += Settings.tower_stats[type]['speed_amt_per_level']
			$ShootTimer.set_wait_time(1.0 / shoot_rate)
			$UpgradePanelAttached/SpeedLabel.text = str(shoot_rate)
			$UpgradePanelAttached/SpeedButton.text = "Speed ("+str(speed_cost)+"):"


func _on_SmallShotAudio_finished():
	$SmallShotAudio.stop()
