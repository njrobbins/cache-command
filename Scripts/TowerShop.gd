extends Node2D

func _ready():
	$Panel/TowerPreviewLabel.text = "The Copperhead"
	$Panel/DescriptionLabel.text = "Costs $" + str(Settings.tower_costs[Settings.tower_type_selected]) + ". A tower that shoots copper bullets out of 1 turret(s)."


func _on_CopperheadTower_pressed():
	Settings.tower_type_selected = "copperhead"
	$Panel/TowerPreviewLabel.text = "The Copperhead"
	$Panel/DescriptionLabel.text = "Costs $" + str(Settings.tower_costs[Settings.tower_type_selected]) + " . A tower that shoots copper bullets out of 1 turret(s)."


func _on_SteelTower_pressed():
	Settings.tower_type_selected = "steel"
	$Panel/TowerPreviewLabel.text = "Steel Team 6"
	$Panel/DescriptionLabel.text = "Costs $" + str(Settings.tower_costs[Settings.tower_type_selected]) + ". A tower that shoots steel bullets out of 1 turret(s)."


func _on_MoonTower_pressed():
	Settings.tower_type_selected = "moon"


func _on_DoubleTroubleTower_pressed():
	Settings.tower_type_selected = "doubletrouble"
