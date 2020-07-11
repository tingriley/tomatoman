extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage
var alpha = 0

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[5] * global.SIZE_X
	$Player/Camera2D.limit_bottom = 2 * global.SIZE_Y
	global.current_stage = 5
	
	if 	global.prev_stage == 3:
		$Player.position.x = 32
		$Player.position.y = 607
	
	if 	global.prev_stage == 6:
		$Player.position.x = 1039
		$Player.position.y = 607
		$Player/AnimatedSprite.flip_h = true
	
func _process(delta):

	update_alpha()
	global.prev_stage = 5
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(right_stage)
	if $Player.position.x <= 0 and Input.is_action_pressed("ui_left"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
