extends Node2D

onready var global = get_node("/root/Global")
onready var player = $Player
onready var camera = $Player/Camera2D

export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var left_stage
export(String, FILE, "*.tscn") var up_stage


var alpha = 0

func _ready():
	set_modulate(Color(1,1,1,alpha))
	camera.limit_right = global.camera_limits_x[2] * global.SIZE_X
	global.current_stage = 2
	

	
	if 	global.prev_stage == 3:
		player.position.x = camera.limit_right-32
		player.position.y = 607
		player.flip_player_to_left()

	
	if global.blue_giant1_defeated:
		$BlueGiant.queue_free()
	
	if global.green_lock_open:
		$GreenLock.queue_free()


func _process(delta):
	set_modulate(Color(1,1,1,alpha))
	if alpha < 1:
		alpha += 0.05
		
	global.prev_stage = 2
	if player.position.x >= camera.limit_right and Input.is_action_pressed("ui_right") and player.position.y >= 600:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(right_stage)

	
	if player.position.x <= 0 and Input.is_action_pressed("ui_left") and player.position.y >= 600:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
	
	if player.position.y <= 0:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(up_stage)


