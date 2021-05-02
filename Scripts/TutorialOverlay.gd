extends Node2D


export var towerDefenseTutorial = true
export var digDugTutorial = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if towerDefenseTutorial:
		get_parent().get_node("UpgradePanelDetached").visible = true
		get_parent().get_node("TowerShop").visible = true
		$TDText.visible = true
	elif digDugTutorial:
		$DDText.visible = true
	else:
		visible = false



func _on_Button_pressed():
	visible = false
	if towerDefenseTutorial:
		get_parent().get_node("UpgradePanelDetached").visible = false
		get_parent().get_node("TowerShop").visible = false
		Settings.tutorial = false
	elif digDugTutorial:
		visible = false
		Settings.dd_tutorial = false
		get_parent().startLevel()
