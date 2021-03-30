extends KinematicBody2D

export var RADIUS = 300
export var shoot_rate = 1
export var hp = 10
export var move_speed = 50

var instance
var shot = load("res://Scenes/Shot.tscn")
var current_target = null
var velocity

func _ready():
	$Label.text = str(hp)

func init(rad, rate):
	RADIUS = rad
	shoot_rate = rate
	$Aggro/AggroShape.shape.radius = RADIUS
	$ShootTimer.set_wait_time(1.0 / shoot_rate)
	
func _physics_process(delta):
	if current_target != null:
		velocity = ((current_target.get_global_transform().origin - position).normalized() * move_speed)
		if (position - current_target.get_global_transform().origin).length() > 50:
			velocity = move_and_slide(velocity)
		rotation = velocity.angle()
	
	
func _on_ShootTimer_timeout():
	if current_target != null:
		instance = shot.instance()
		instance.set_target(current_target)
		instance.position = self.get_global_transform().origin
		instance.sentBy = "enemy"
		get_parent().add_child(instance)


func _on_Aggro_body_entered(body):
	if body.is_in_group("Player"):
		current_target = body
		$ShootTimer.start()


func _on_Aggro_body_exited(body):
	if body.is_in_group("Player"):
		current_target = null
		$ShootTimer.stop()


func _on_HitDetector_area_entered(area):
	if area.is_in_group("shot") and area.sentBy != "enemy":
		area.queue_free()
		hp -= 1
		$Label.text = str(hp)
		if hp <= 0:
			queue_free()
