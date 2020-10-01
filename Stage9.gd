extends Node2D

onready var global = get_node("/root/Global")
onready var music = get_node("/root/Music")


export(String, FILE, "*.tscn") var right_stage


var init_climb_down = false
var alpha = 0


func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():


	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[9] * global.SIZE_X

	global.current_stage = 9
	

	
func _process(delta):
	update_alpha()
	
		
	if init_climb_down:
		$Player.is_climbing_down = true
	
	global.prev_stage = 9

	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)
	



