extends KinematicBody2D

const FLOOR = Vector2(0, -1)

var velocity = Vector2(0, 0)
var jump_duration = 0.5



export var delay = 1.0

func _ready():
	pass

	
func set_speed(s):
	velocity = s

func _physics_process(delta):
	velocity = move_and_slide(velocity, FLOOR)
	if is_on_wall() || is_on_floor() || is_on_ceiling():
		queue_free()



func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.dead()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	queue_free()
