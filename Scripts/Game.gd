extends Node2D

var tower = load("res://Scenes/Tower.tscn")
var mob = load("res://Scenes/Drone.tscn")
var instance

var building = false

var cash = 50
var wave = 0
var mobs_left = 0
var wave_mobs = [5, 15, 30, 60, 120]

func _ready():
	$WaveTimer.start()

func _physics_process(_delta):
	$CashLabel.text = "cash: " + str(cash)

func tower_built():
	building = false
	cash -=25
	print("built tower")

func add_cash(num):
	cash += num

func _on_WaveTimer_timeout():
#	print("Wave Start")
	mobs_left = wave_mobs[wave]
	$MobTimer.start()
	$WaveTimer.stop()


func _on_MobTimer_timeout():
#	print("Spawning")
	instance = mob.instance()
	$Path2D.add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()


func _on_TextureButton_pressed():
	if !building and cash >= 25:
		print("build selected")
		instance = tower.instance()
		add_child(instance)
		building = true
