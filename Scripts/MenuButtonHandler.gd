extends Control

var scene

func _on_BackButton_pressed():
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")

# func _on_ContinueButton_pressed():
	# TODO

func _on_CreditsButton_pressed():
	scene = get_tree().change_scene("res://Scenes/Credits.tscn")

func _on_InstructionsButton_pressed():
	scene = get_tree().change_scene("res://Scenes/Instructions.tscn")

func _on_LoseLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/LevelLost.tscn")

func _on_MainMenuButton_pressed():
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_PauseMenuButton_pressed():
	scene = get_tree().change_scene("res://Scenes/PauseMenu.tscn")

# func _on_QuitButton_pressed():
	# TODO

# func _on_ResumeButton_pressed():
	# TODO

func _on_StartButton_pressed():
	scene = get_tree().change_scene("res://Scenes/SiliconMiningMain.tscn")

func _on_TDButton_pressed():
	scene = get_tree().change_scene("res://Scenes/TowerDefenseMain.tscn")

# func _on_TowerShopButton_pressed():
	# TODO

# func _on_TryAgainButton_pressed():
	# TODO

func _on_WinLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/LevelWon.tscn")
