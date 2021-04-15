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

func _on_CreditsButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/Credits.tscn")

func _on_InstructionsButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/Instructions.tscn")

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
	get_tree().quit()

func _on_ResumeButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	visible = false
	Settings.paused = false
	
	get_parent().get_node("MobTimer").paused = false
	get_parent().get_node("WaveTimer").paused = false
	get_parent().get_node("TowersNode").visible = true


func _on_PlayButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/DigDug.tscn")

func _on_TDButton_pressed():
	scene = get_tree().change_scene("res://Scenes/TowerDefenseGame.tscn")

func _on_TryAgainButton_pressed():
	$MenuButtonAudio.play()
	yield($MenuButtonAudio, "finished")
	scene = get_tree().change_scene("res://Scenes/DigDug.tscn")

func _on_WinLevelButton_pressed():
	scene = get_tree().change_scene("res://Scenes/LevelComplete.tscn")
