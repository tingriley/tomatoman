extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var up_stage
export(String, FILE, "*.tscn") var up_stage2
var alpha = 0

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[6] * global.SIZE_X
	global.current_stage = 6
	
	if 	global.prev_stage == 5:
		$Player.position.x = 1039
		$Player.position.y = 31
		$Player/AnimatedSprite.flip_h = true
	
	if 	global.prev_stage == 7:
		$Player.position.x = 288
		$Player.position.y = 32
	if 	global.prev_stage == 9:
		$Player.position.x = 768
		$Player.position.y = 32

	
func _process(delta):
	update_alpha()
	global.prev_stage = 6
	if $Player.position.x >= $Player/Camera2D.limit_right and Input.is_action_pressed("ui_right"):
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)
	if $Player.position.y <= 0 and $Player.position.x <= 320:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(up_stage)
	if $Player.position.y <= 0 and $Player.position.x > 400:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(up_stage2)
