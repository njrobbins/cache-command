extends Control

var scene

func _on_BackButton_pressed():
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_ContinueButton_pressed():
	pass
	# TODO

func _on_CreditsButton_pressed():
	scene = get_tree().change_scene("res://Scenes/Credits.tscn")

func _on_InstructionsButton_pressed():
	scene = get_tree().change_scene("res://Scenes/Instructions.tscn")

func _on_LoseLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_MainMenuButton_pressed():
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_PauseButton_pressed():
	scene = get_tree().change_scene("res://Scenes/PauseMenu.tscn")

func _on_QuitGameButton_pressed():
	pass
	# TODO

func _on_ResumeButton_pressed():
	pass
	# TODO

func _on_PlayButton_pressed():
	scene = get_tree().change_scene("res://Scenes/DigDug.tscn")

func _on_TDButton_pressed():
	scene = get_tree().change_scene("res://Scenes/Game.tscn")

func _on_TextureButton_pressed():
	print("pressed")

func _on_TowerShopButton_pressed():
	get_node("TowerShopPopupMenu").popup()
	
func _on_TryAgainButton_pressed():
	pass
	# TODO

func _on_WinLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/LevelComplete.tscn")
