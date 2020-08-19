extends KinematicBody2D

const FLOOR = Vector2(0, -1)
var velocity = Vector2(0, -200)

func _ready():
	pass

func _physics_process(delta):
	velocity = move_and_slide(velocity, FLOOR)
	velocity.y += 20
	if is_on_floor():
		queue_free()
	


func _on_Area2D_body_entered(body):
	if "Player"  in body.name:
		body.dead()
