extends Panel

var selected_tower

func check():
	if selected_tower:
		selected_tower.get_node("RadiusCircle").visible = false
		selected_tower = null


func toggle():
	if selected_tower:
		get_parent().get_node("TowersNode").move_child(selected_tower, 0)
		visible = true
		$RangeLabel.text = str(selected_tower.RADIUS)
		$RangeButton.text = "Range ("+str(selected_tower.range_cost)+"):"
		$SpeedLabel.text = str(selected_tower.shoot_rate)
		$SpeedButton.text = "Speed ("+str(selected_tower.speed_cost)+"):"
		$DronesDestroyed.text = str(selected_tower.enemies_destroyed)
		selected_tower.get_node("RadiusCircle").visible = true
	else:
		visible = false


func _on_RangeButton_pressed():
	if selected_tower:
		if Settings.cash >= selected_tower.range_cost:
			Settings.cash -= selected_tower.range_cost
			selected_tower.amountSpent += selected_tower.range_cost
			selected_tower.range_cost += Settings.tower_stats[selected_tower.type]['range_cost_added'] + selected_tower.range_level*Settings.tower_stats[selected_tower.type]['range_cost_added']
			selected_tower.range_level += 1
			selected_tower.RADIUS += Settings.tower_stats[selected_tower.type]['range_amt_per_level']
			selected_tower.get_node("Aggro/AggroShape").shape.radius = selected_tower.RADIUS
			var rad_scale = selected_tower.RADIUS / 100.0
			selected_tower.get_node("RadiusCircle").rect_scale = Vector2(rad_scale, rad_scale)
			$RangeLabel.text = str(selected_tower.RADIUS)
			$RangeButton.text = "Range ("+str(selected_tower.range_cost)+"):"


func _on_SpeedButton_pressed():
	if selected_tower:
		if Settings.cash >= selected_tower.speed_cost:
			Settings.cash -= selected_tower.speed_cost
			selected_tower.amountSpent += selected_tower.speed_cost
			selected_tower.speed_cost += Settings.tower_stats[selected_tower.type]['speed_cost_added'] + selected_tower.speed_level*Settings.tower_stats[selected_tower.type]['speed_cost_added']
			selected_tower.speed_level += 1
			selected_tower.shoot_rate += Settings.tower_stats[selected_tower.type]['speed_amt_per_level']
			selected_tower.get_node("ShootTimer").set_wait_time(1.0 / selected_tower.shoot_rate)
			$SpeedLabel.text = str(selected_tower.shoot_rate)
			$SpeedButton.text = "Speed ("+str(selected_tower.speed_cost)+"):"


func _on_RecycleButton_pressed():
	if selected_tower:
		get_parent().removeTower(selected_tower)
		visible = false
		selected_tower = null
