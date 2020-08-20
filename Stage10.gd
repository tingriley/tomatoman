extends Node2D

var alpha = 0
onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var left_stage

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))
	
func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[10] * global.SIZE_X
	global.current_stage = 10

func _process(delta):
	update_alpha()
	global.prev_stage = 10
	if $Player.position.x <= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(left_stage)


