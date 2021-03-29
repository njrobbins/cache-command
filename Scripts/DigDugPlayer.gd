extends KinematicBody2D

export var speed = 200

var velocity = Vector2()

onready var joystick_move = get_parent().get_node("Joystick")

var tilemap
var cell
var tile_id

var mined = 0

func _physics_process(_delta):
	if joystick_move and joystick_move.is_working:
		var vel = joystick_move.output * speed
		
		velocity = move_and_slide(vel)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		if collision.collider != null:
			if collision.collider.is_in_group("res"):
				mined += 1
				print(mined)
			print(collision.collider.name)
			
			collision.collider.free()
