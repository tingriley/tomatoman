extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage
var alpha = 0

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[1] * global.SIZE_X
	global.current_stage = 1
	
	if 	global.prev_stage == 2:
		$Player.position.x = $Player/Camera2D.limit_right-32
		$Player.position.y = 607
		$Player.flip_player_to_left()
	
func _process(delta):
	global.prev_stage = 1
	set_modulate(Color(1,1,1,alpha))
	if alpha < 1:
		alpha += 0.05
	
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		get_tree().change_scene(right_stage)
	if $Player.position.x <= 0 and Input.is_action_pressed("ui_left"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
