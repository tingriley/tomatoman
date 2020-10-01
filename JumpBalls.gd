extends Node2D

const PINK = preload("JumpPink.tscn")
const GRAY = preload("JumpGray.tscn")
export var time = 2.0
export var delay = 1.0
var b = false

func _ready():
	$Timer.wait_time = time
	$Delay.wait_time = delay
	$Delay.start()

func add_pink():

	var enemy = PINK.instance()

	get_parent().add_child(enemy)
	enemy.position = position

func add_gray():
	
	var enemy = GRAY.instance()

	get_parent().add_child(enemy)
	enemy.position = position

func _on_Timer_timeout():
	if b:
		add_pink()
	else:
		add_gray()
	b = !b


func _on_Delay_timeout():
	$Timer.start()
