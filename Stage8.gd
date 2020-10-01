extends Node2D

onready var global = get_node("/root/Global")
onready var music = get_node("/root/Music")


export(String, FILE, "*.tscn") var right_stage
export(String, FILE, "*.tscn") var down_stage


var init_climb_down = false
var alpha = 0


func update_alpha():
	if alpha < 1:
		alpha += 0.05
	set_modulate(Color(1,1,1,alpha))

func _ready():

	$Player.is_floating = true
	set_modulate(Color(1,1,1,alpha))
	$Player/Camera2D.limit_right = global.camera_limits_x[8] * global.SIZE_X

	global.current_stage = 8
	$Player.flip_player_to_left()
	
func change_stage():
	
			
	if not $Player.is_dead and $Player.position.y >= $Player/Camera2D.limit_bottom:
		get_tree().change_scene(down_stage)
	
func _process(delta):
	update_alpha()
	change_stage()
		
	if init_climb_down:
		$Player.is_climbing_down = true
	
	global.prev_stage = 8

	
	if $Player.position.y >= 300:
		$TileMap.set_cellv(Vector2(1, 0), 4)
	
	if not $Snowman:
		get_node("Shake").screen_shake(1, 15, 100)
		for i in range(1, 2):
			$TileMap.set_cellv(Vector2(i, 11), -1)
			$Ladders/LadderTop.visible = true

	if  $Snowman:
		$Player/CanvasLayer/BossHealthBar.visible = true
		$Player/CanvasLayer/BossHealthBar._on_health_updated(int($Snowman.hp * 100.0/40), 0)
		$Player/CanvasLayer/BossHealthBar.rect_scale.x = 1
	else:
		$Player/CanvasLayer/BossHealthBar.visible = true

func _on_Timer_timeout():
	init_climb_down = false


func _on_StartTimer_timeout():
	$Player.is_floating = false
