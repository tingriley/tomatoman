extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage

func _ready():
	$Player/Camera2D.limit_right = global.camera_limits_x[3] * global.SIZE_X

	global.current_stage = 5
	
	if 	global.prev_stage == 2:
		$Player.position.x = 32
		$Player.position.y = 220
	
		
	if 	global.prev_stage == 6:
		$Player.position.x = $Player/Camera2D.limit_right-32
		$Player.position.y = 607
		$Player/AnimatedSprite.flip_h = true
	
func _process(delta):
	global.prev_stage = 5
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)
	if $Player.position.x <= 0 and Input.is_action_pressed("ui_left"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)


func _on_Timer_timeout():
	$LabGroup.animate_children()
