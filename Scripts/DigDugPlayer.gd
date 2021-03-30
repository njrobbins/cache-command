extends KinematicBody2D

export var speed = 200
export var RADIUS = 200
export var shoot_rate = 2
export var hp = 100

var velocity = Vector2()

onready var joystick_move = get_parent().get_node("Joystick")

var mined = 0
var enemy_array = []
var instance
var current_target = null
var shot = load("res://Scenes/Shot.tscn")

func _ready():
	$Label.text = str(hp)
	
func _physics_process(_delta):
	if joystick_move and joystick_move.is_working:
		var vel = joystick_move.output * speed
		velocity = move_and_slide(vel)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider != null:
			if collision.collider.is_in_group("res"):
				mined += 1
				print("Mined: ",mined)
				collision.collider.free()
			elif collision.collider.is_in_group("tile"):
				collision.collider.free()
				
	if current_target == null and len(enemy_array) > 0:
		current_target = enemy_array[0]
		$ShootTimer.start()


func _on_HitDetector_area_entered(area):
	if area.is_in_group("shot") and area.sentBy != "player":
		area.queue_free()
		hp -= 1
		$Label.text = str(hp)

func _on_ShootTimer_timeout():
	if current_target != null:
		instance = shot.instance()
		instance.set_target(current_target, true)
		instance.position = self.get_global_transform().origin
		instance.sentBy = "player"
		get_parent().add_child(instance)

func _on_Aggro_body_entered(body):
	if body.is_in_group("enemy"):
		current_target = body
		enemy_array.append(body)
		$ShootTimer.start()

func _on_Aggro_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_array.erase(body)
		if current_target:
			if body == current_target:
				current_target = null
				$ShootTimer.stop()
