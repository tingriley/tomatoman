extends Node2D

onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var down_stage
export(String, FILE, "*.tscn") var left_stage
var alpha = 0
var init_climb_up = true
var block_clear = false

func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[7] * global.SIZE_X
	global.current_stage = 7
	
	if global.prev_stage == 8:
		$Block.queue_free()
		$Block2.queue_free()
		block_clear = true
		init_climb_up = false
		$Player.position.x = 64
		$Player.position.y = 250
	
	
func _process(delta):
	update_alpha()
	if init_climb_up:
		$Player.is_climbing_up = true
	global.prev_stage = 7
	if $Player.position.x <=0:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene(left_stage)
	if $Player.position.y >= 768:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(down_stage)
	
	if $Enemies.get_num_childern() == 0:
		if not block_clear:
			block_clear = true
			$Block/AnimatedSprite.play("open")
			$Block2/AnimatedSprite.play("open")
			yield(get_tree().create_timer(1), "timeout")
			$Block.queue_free()
			$Block2.queue_free()


func _on_Timer_timeout():
	$Player.is_climbing_up = false
	init_climb_up = false
