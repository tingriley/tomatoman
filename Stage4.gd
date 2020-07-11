extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage
onready var player = $Player
onready var camera = $Player/Camera2D
onready var animation = $Player/AnimatedSprite

func _ready():
	camera.limit_right = global.camera_limits_x[4] * global.SIZE_X
	global.current_stage = 4

	if 	global.prev_stage ==2:
		player.position.x = camera.limit_right -32
		player.position.y = 607
		animation.flip_h = true
		
	
	
func _process(delta):

	global.prev_stage = 4
	if player.position.x >= camera.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)
	if player.position.x <= 0 and Input.is_action_pressed("ui_left"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
