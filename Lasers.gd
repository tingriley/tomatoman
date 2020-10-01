extends Node2D


const LASER = preload("LaserPink.tscn")
const speed = Vector2(-400, 0)
export var pos = Vector2(0, 0)
export var time = 1.0
export var delay = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = time
	$delayTimer.wait_time = delay

func shoot():
	var laser = null
	laser = LASER.instance()
	laser.set_speed(speed)
	laser.position = pos
	get_parent().add_child(laser)

func _on_Timer_timeout():
	shoot()


func _on_delayTimer_timeout():
	$Timer.start()
