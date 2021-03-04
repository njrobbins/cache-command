extends PathFollow2D

export var speed = 40
export var hp = 10

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
		if hp <= 0:
			get_parent().get_parent().add_cash(5)
			queue_free()
