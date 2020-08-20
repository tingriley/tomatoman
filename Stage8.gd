extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage

var alpha = 0
var init_climb_up = true
var block_clear = false

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[8] * global.SIZE_X
	global.current_stage = 8
	
	
func _process(delta):
	update_alpha()
	if init_climb_up:
		$Player.is_climbing_up = true
	global.prev_stage = 8
	if $Player.position.x >= $Player/Camera2D.limit_right:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)



func _on_Timer_timeout():
	$Player.is_climbing_up = false
	init_climb_up = false
