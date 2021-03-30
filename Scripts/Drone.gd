extends PathFollow2D

export var speed = 160
export var hp = 10


func init(spd, h, big=false, fast=false):
	speed = spd
	hp = h
	if big:
		$Area2D/DroneGreen.visible = true
	elif fast:
		$Area2D/DroneOrange.visible = true
	else:
		$Area2D/DroneGray.visible = true
	
func _ready():
	$Label.text = str(hp)
	
func _physics_process(delta):
	offset += speed * delta
	if unit_offset >= 1:
		reached_end()

func reached_end():
	queue_free()
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("shot"):
		area.queue_free()
		hp -= 1
		$Label.text = str(hp)
		if hp <= 0:
			get_parent().get_parent().add_cash(5)
			queue_free()
	if area.is_in_group("TheBase"):
		queue_free()
		get_parent().get_parent().base_hit()
