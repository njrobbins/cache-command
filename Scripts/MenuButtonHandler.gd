extends Control

var scene

func _on_StartButton_pressed():
	scene = get_tree().change_scene("res://Scenes/DigDugMain.tscn")

func _on_Instructions_pressed():
	scene = get_tree().change_scene("res://Scenes/Instructions.tscn")

func _on_Credits_pressed():
	scene = get_tree().change_scene("res://Scenes/Credits.tscn")


func _on_BackButton_pressed():
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_BackToMenuButton_pressed():
	scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_TDButton_pressed():
	scene = get_tree().change_scene("res://Scenes/TowerDefenseMain.tscn")
