extends Control

func _process(_delta):
	$Panel/SpeedLabel.text = "Speed: " + str(Settings.player_speed)
	$Panel/RateLabel.text = "Rate: " + str(Settings.player_shoot_rate)
	$Panel/TimeLabel.text = "Time Added: " + str(Settings.time_added_per_wafer)
	$Panel/CashLabel.text = "Wafers Added: " + str(Settings.cash_per_wafer)
	$Panel3/CashLabel.text = "Wafers: $" + str(Settings.cash)
	$Panel2/CashButton.text = "Wafers $" + str(Settings.upgrade_costs["wafers"])
	$Panel2/RateButton.text = "Rate $" + str(Settings.upgrade_costs["rate"])
	$Panel2/SpeedButton.text = "Speed $" + str(Settings.upgrade_costs["speed"])
	$Panel2/TimeButton.text = "Time $" + str(Settings.upgrade_costs["time"])



func _on_SpeedButton_pressed():
	if Settings.cash >= Settings.upgrade_costs["speed"]:
		Settings.cash -= Settings.upgrade_costs["speed"]
		Settings.upgrade_costs["speed"] += 5
		Settings.player_speed += 10


func _on_RateButton_pressed():
	if Settings.cash >= Settings.upgrade_costs["rate"]:
		Settings.cash -= Settings.upgrade_costs["rate"]
		Settings.upgrade_costs["rate"] += 15
		Settings.player_shoot_rate += 0.5


func _on_TimeButton_pressed():
	if Settings.cash >= Settings.upgrade_costs["time"]:
		Settings.cash -= Settings.upgrade_costs["time"]
		Settings.upgrade_costs["time"] += 10
		Settings.time_added_per_wafer += 0.1


func _on_CashButton_pressed():
	if Settings.cash >= Settings.upgrade_costs["wafers"]:
		Settings.cash -= Settings.upgrade_costs["wafers"]
		Settings.upgrade_costs["wafers"] += 20
		Settings.cash_per_wafer += 1


func _on_ContinueButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	var _scene = get_tree().change_scene("res://Scenes/TowerDefenseGame.tscn")


func _on_InfoPanelButton_pressed():
	$InfoPanel.visible = true


func _on_CloseInfoPanelButton_pressed():
	$InfoPanel.visible = false
