extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var down_stage
export(String, FILE, "*.tscn") var right_stage
var alpha = 0
var init_climb_up = true
var block_clear = false

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[5] * global.SIZE_X
	global.current_stage = 9
	

	
	
func _process(delta):
	if $Giants.get_num_childern() == 0:
		if not block_clear:
			block_clear = true
			$Block/AnimatedSprite.play("open")
			$Block2/AnimatedSprite.play("open")
			yield(get_tree().create_timer(1), "timeout")
			$Block.queue_free()
			$Block2.queue_free()
			
	update_alpha()
	if init_climb_up:
		$Player.is_climbing_up = true
	global.prev_stage = 9
	if $Player.position.y >= 768:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(down_stage)
	
	if $Player.position.x >= 1152:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(right_stage)
	


func _on_Timer_timeout():
	$Player.is_climbing_up = false
	init_climb_up = false
