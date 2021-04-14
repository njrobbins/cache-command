extends Control

func _ready():
	$Panel/NormalType.text = "Normal " + str(Settings.tower_costs["normal"])
	$Panel/TowerType2.text = "Type 2 " + str(Settings.tower_costs["type2"])

func _on_NormalType_pressed():
	Settings.tower_type_selected = "normal"
	print("Normal tower selected")


func _on_TowerType2_pressed():
	Settings.tower_type_selected = "type2"
	print("Type 2 tower selected")
