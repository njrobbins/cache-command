extends Control

var scene

func _on_BackButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_ContinueButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/DigDug.tscn")
	# TODO

func _on_CreditsButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/Credits.tscn")

func _on_InstructionsButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/Instructions.tscn")

func _on_LoseLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/GameOver.tscn")

func _on_MainMenuButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_PauseButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/PauseMenu.tscn")

func _on_QuitGameButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	pass
	# TODO

func _on_ResumeButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	pass
	# TODO

func _on_PlayButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/DigDug.tscn")

func _on_TDButton_pressed():
	scene = get_tree().change_scene("res://Scenes/TowerDefenseGame.tscn")

func _on_TryAgainButton_pressed():
	pass
	# TODO

func _on_WinLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/LevelComplete.tscn")
