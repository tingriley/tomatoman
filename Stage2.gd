extends Node2D

onready var global = get_node("/root/Global")
onready var music = get_node("/root/Music")


export(String, FILE, "*.tscn") var down_stage


var init_climb_down = false
var alpha = 0

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():

	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[2] * global.SIZE_X
	$Player/Camera2D.limit_top = -2 * global.SIZE_Y
	global.current_stage = 2
	$Player.flip_player_to_left()
	

	
func _process(delta):
	update_alpha()
		
	if init_climb_down:
		$Player.is_climbing_down = true
	

	global.prev_stage = 2

	if $Player.position.y >= $Player/Camera2D.limit_bottom and not $Player.is_dead:
		get_tree().change_scene(down_stage)

	


func _on_Timer_timeout():
	init_climb_down = false
