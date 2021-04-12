extends Control



func _on_NormalType_pressed():
	Settings.tower_type_selected = "normal"
	print("Normal tower selected")


func _on_TowerType2_pressed():
	Settings.tower_type_selected = "type2"
	print("Type 2 tower selected")
