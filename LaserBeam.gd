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

func _ready():

	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()

	
	var max_cast_to = vector.normalized() * MAX_LENGTH
	raycast.cast_to = max_cast_to
	init_point = end.global_position



func _physics_process(delta):


	if collision_point == null:
		collision_point = raycast.get_collision_point() - Vector2(0, 16)
	end.global_position.x =  collision_point.x

	$BlueEnemy.position = end.position

	if end.global_position.y >= collision_point.y:
		if direction == 1:
			direction = 0
			yield(get_tree().create_timer(1), "timeout")
			direction = -1
	if end.global_position.y < init_point.y:
		if direction == -1:
			direction = 0
			yield(get_tree().create_timer(2), "timeout")
			direction = 1

	if direction == 1:
		speed += 10
	else:
		speed = 400
	
	end.global_position.y += (speed*delta*direction)
	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()
	




func _on_VisibilityNotifier2D_screen_exited():
	pass
