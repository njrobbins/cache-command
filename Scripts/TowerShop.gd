extends Node2D
var tower = load("res://Scenes/Tower.tscn")

func _ready():
	addTowerImage()
	$Panel/DescriptionLabel.text = "Costs " + str(Settings.tower_costs[Settings.tower_type_selected]) + " wafers. Shoots copper bullets out of 1 turret."


func _on_CopperheadTower_pressed():
	Settings.tower_type_selected = "copperhead"
	addTowerImage()
	$Panel/DescriptionLabel.text = "Costs " + str(Settings.tower_costs[Settings.tower_type_selected]) + " wafers. Shoots copper bullets out of 1 turret."


func _on_SteelTower_pressed():
	Settings.tower_type_selected = "steel"
	addTowerImage()
	$Panel/DescriptionLabel.text = "Costs " + str(Settings.tower_costs[Settings.tower_type_selected]) + " wafers. Shoots steel bullets out of 2 turrets."


func addTowerImage():
	var instance = tower.instance()
	instance.disabled = true
	$Panel/TowerPreview.add_child(instance)
	instance.init(Settings.tower_type_selected)

func _on_MoonTower_pressed():
	Settings.tower_type_selected = "moon"


func _on_DoubleTroubleTower_pressed():
	Settings.tower_type_selected = "doubletrouble"
