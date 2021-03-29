extends Area2D


var target = null
var speed = 400
var velocity
var timerStarted = false

func _physics_process(delta):
	if target.get_ref():
		velocity = ((target.get_ref().get_global_transform().origin - position).normalized() * speed)
		position += velocity * delta
		rotation = velocity.angle()
	else:
		timerStarted = true
		$LifeTimer.start()
	
	if timerStarted:
		position += velocity * delta

func set_target(new_target):
	target = weakref(new_target)


func _on_LifeTimer_timeout():
	timerStarted = false
	queue_free()
