extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage


func _ready():
	global.current_stage = 0
	if 	global.prev_stage == 1:
		$Player.position.x = 1152-32
		$Player.position.y = 612
		$Player/AnimatedSprite.flip_h = true

func _process(delta):
	global.prev_stage = 0
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)
