extends KinematicBody2D

const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var jump_duration = 0.5

var is_jumping = false
var gravity = 300
var pos

export var delay = 1.0

func _ready():
	visible = false
	pos = position
	$DelayTimer.wait_time = delay
	$DelayTimer.start()

func _physics_process(delta):
	
	if visible:
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_floor():
		visible = false
		position = pos
		$Timer.start()
		

func _on_Timer_timeout():
	visible = true


func _on_DelayTimer_timeout():
	visible = true
	$AnimatedSprite.play("idle")


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.dead()
