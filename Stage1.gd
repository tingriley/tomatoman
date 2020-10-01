extends Node2D

onready var global = get_node("/root/Global")
onready var music = get_node("/root/Music")


export(String, FILE, "*.tscn") var up_stage
export(String, FILE, "*.tscn") var left_stage
export(String, FILE, "*.tscn") var right_stage


var init_climb_down = false
var alpha = 0

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
		
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[1] * global.SIZE_X
	global.current_stage = 1
	
	if global.prev_stage == 2:
		$Player.position = Vector2(1504, 32)
	elif global.prev_stage == 3:
		$Player.position.x = $Player/Camera2D.limit_left + 32
		$Player.position.y = $Player/Camera2D.limit_bottom - 64
	else:
		$Player.flip_player_to_left()
	

	
func _process(delta):
	update_alpha()
		
	if init_climb_down:
		$Player.is_climbing_down = true
	

	global.prev_stage = 1

	if $Player.position.y <= $Player/Camera2D.limit_top:
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().change_scene(up_stage)
	
	if $Player.position.x <= $Player/Camera2D.limit_left and Input.is_action_pressed("ui_left") :
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().change_scene(left_stage)
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right") :
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().change_scene(right_stage)

func _on_Timer_timeout():
	init_climb_down = false
