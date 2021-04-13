extends Control

func _process(_delta):
	$Panel/SpeedLabel.text = "Speed: " + str(Settings.player_speed)
	$Panel/RateLabel.text = "Rate: " + str(Settings.player_shoot_rate)
	$Panel/TimeLabel.text = "Time Added: " + str(Settings.time_added_per_wafer)
	$Panel/CashLabel.text = "Wafers Added: " + str(Settings.cash_per_wafer)
	$Panel3/CashLabel.text = "Wafers: $" + str(Settings.cash)



func _on_SpeedButton_pressed():
	if Settings.cash >= 20:
		Settings.cash -= 20
		Settings.player_speed += 10


func _on_RateButton_pressed():
	if Settings.cash >= 20:
		Settings.cash -= 20
		Settings.player_shoot_rate += 0.5


func _on_TimeButton_pressed():
	if Settings.cash >= 20:
		Settings.cash -= 20
		Settings.time_added_per_wafer += 0.1


func _on_CashButton_pressed():
	if Settings.cash >= 20:
		Settings.cash -= 20
		Settings.cash_per_wafer += 1


func _on_ContinueButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	var _scene = get_tree().change_scene("res://Scenes/TowerDefenseGame.tscn")


func _on_InfoPanelButton_pressed():
	$InfoPanel.visible = true


func _on_CloseInfoPanelButton_pressed():
	$InfoPanel.visible = false
