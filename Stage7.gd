extends Node2D

onready var global = get_node("/root/Global")
onready var music = get_node("/root/Music")


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
	$Player/Camera2D.limit_right = global.camera_limits_x[7] * global.SIZE_X
	$Player/Camera2D.limit_bottom = 2 * global.SIZE_Y
	global.current_stage = 7
	$Player.flip_player_to_left()
	

func change_stage():
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.35), "timeout")
		get_tree().change_scene(right_stage)	
	if $Player.position.x <= $Player/Camera2D.limit_left and Input.is_action_pressed("ui_left"):
		yield(get_tree().create_timer(0.35), "timeout")
		get_tree().change_scene(left_stage)

	
func _process(delta):
	global.prev_stage = 7

	update_alpha()
	change_stage()
	
	if init_climb_down:
		$Player.is_climbing_down = true
	


func _on_Timer_timeout():
	init_climb_down = false
