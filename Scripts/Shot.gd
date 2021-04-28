extends Area2D

var velocity
var speed = 400
var timerStarted = false
var target = null
var owner_tower = null
var sentBy # Tracks who sent the shot (ensures correct entities are getting hit)

func _physics_process(delta):
	if(Settings.paused == false):
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
	if sentBy=="player":
		$BShot.visible = true
	elif sentBy=="enemy":
		$CShot.visible = true
	elif sentBy=="copperhead":
		$BulletCopper.visible = true
	elif sentBy=="steel":
		$BulletSteel.visible = true
	elif sentBy=="moon":
		$RocketSmall.visible = true
	elif sentBy=="doubletrouble":
		$RocketSmall.visible = true
	target = weakref(new_target)


func _on_LifeTimer_timeout():
	timerStarted = false
	queue_free()
