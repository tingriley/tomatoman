extends Node2D

const MAX_LENGTH = 2000

onready var beam = $Beam
onready var end = $End
onready var raycast = $RayCast2D

var vector = Vector2(0, 1)
var change_direction = false
var collision_point
var direction = 1
var init_point
var speed = 550
var start = false
var length = 0

func _ready():

	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()

	
	var max_cast_to = vector.normalized() * MAX_LENGTH
	raycast.cast_to = max_cast_to
	init_point = $Begin.global_position




func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if abs(position.x - player.position.x) <= 60 and player.global_position.y > $Begin.global_position.y:
		$BlueEnemy/AnimatedSprite.play("attack")
		yield(get_tree().create_timer(0.1), "timeout")
		start = true
	if start:
		$Beam.visible = true
		#if collision_point == null:
		collision_point = raycast.get_collision_point() - Vector2(0, 16)
		end.global_position.x =  collision_point.x
	
		$BlueEnemy.position = end.position
		
		length = abs($Begin.position.y - collision_point.y)
		
	
		if end.global_position.y >= collision_point.y:
			if direction == 1:
				direction = 0
				yield(get_tree().create_timer(1.5), "timeout")
				direction = -1
		if end.global_position.y < init_point.y:
			if direction == -1:
				direction = 0
				yield(get_tree().create_timer(0.5), "timeout")
				direction = 1
				start = false
	
		if direction == 1:
			speed = length*1.1
		else:
			speed = length*1.5
		
		end.global_position.y += (speed*delta*direction)
		beam.rotation = raycast.cast_to.angle()
		beam.region_rect.end.x = end.position.length()
	else:
		$Beam.visible = false
		
	
