extends Node2D

const MAX_LENGTH = 2000

onready var beam = $Beam
onready var end = $End
onready var raycast = $RayCast2D
var r = 0
var vector = Vector2(1, 1)
var change_direction = false
var sum = 0

func _ready():

	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()

func set_rotation(rotate):
	r = rotate

func set_vector(v):
	vector = v

func change_vector():
	sum += r
	if sum >= 0.5 and not change_direction:
		r *= -1
		sum = 0
		change_direction = true
	if sum <= -0.5 and not change_direction:
		r *= -1
		sum = 0
		change_direction = true
	
	if sum == 0:
		change_direction = false
	
	vector = vector.rotated(PI * r)

func _physics_process(delta):
	var mouse_position = get_local_mouse_position()
	var max_cast_to = vector.normalized() * MAX_LENGTH
	raycast.cast_to = max_cast_to
	change_vector()


	if raycast.is_colliding():
		if "Player" in raycast.get_collider().name:
			raycast.get_collider().dead()
		end.global_position = raycast.get_collision_point()
	else:
		end.global_position = raycast.cast_to
	
	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()
	




func _on_VisibilityNotifier2D_screen_exited():
	pass
