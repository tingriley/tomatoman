extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage
export(String, FILE, "*.tscn") var down_stage
var alpha = 0
var init_climb_up = true

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[5] * global.SIZE_X
	global.current_stage = 3
	
	if 	global.prev_stage == 4:
		$Player.position.x = 32
		$Player.position.y = 607

	
func _process(delta):

	update_alpha()
	global.prev_stage = 3
	if init_climb_up:
		$Player.is_climbing_up = true

	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(right_stage)

	if $Player.position.x <= 0 and Input.is_action_pressed("ui_left"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
	
	if $Player.position.y >= $Player/Camera2D.limit_bottom:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(down_stage)


func _on_Timer_timeout():
	$Player.is_climbing_up = false
	init_climb_up = false
