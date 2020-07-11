extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage
export(String, FILE, "*.tscn") var left_stage2
onready var player = $Player
onready var camera = $Player/Camera2D

func _ready():
	camera.limit_right = global.camera_limits_x[2] * global.SIZE_X
	camera.limit_top = -1 * global.SIZE_Y 
	global.current_stage = 2
	
	if 	global.prev_stage == 4:
		player.position.x = 32
		player.position.y = -300
	
	if 	global.prev_stage == 3:
		player.position.x = camera.limit_right-32
		player.position.y = 607
		$Player/AnimatedSprite.flip_h = true

	
	
	
func _process(delta):
	
	global.prev_stage = 2
	if player.position.x >= camera.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)
	if player.position.x <= 0 and Input.is_action_pressed("ui_left") and player.position.y >= 600:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
	if player.position.x <= 0 and Input.is_action_pressed("ui_left") and player.position.y <= -250:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage2)
	if global.green_key:
		$GreenDoor.visible = false
		$GreenDoor/KinematicBody2D/CollisionShape2D2.set_deferred("disabled", true)
