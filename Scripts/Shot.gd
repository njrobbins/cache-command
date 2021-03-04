extends Area2D


var target = null
var speed = 200
var velocity

func _physics_process(delta):
	if target.get_ref():
		velocity = ((target.get_ref().get_global_transform().origin - position).normalized() * speed)
		position += velocity * delta
		rotation = velocity.angle()
	else:
		queue_free()

func set_target(new_target):
	target = weakref(new_target)
