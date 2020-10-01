extends KinematicBody2D

const GRAVITY = 30
const FLOOR = Vector2(0, -1)

export var velocity = Vector2(0, -1500)

var direction = -1 # left

var is_dead = false

onready var player_vars = get_node("/root/Global")

export(int) var hp = 1
export(Vector2) var size = Vector2(1, 1)


func _ready():
	$AnimatedSprite.play("idle")




func _physics_process(delta):
	
	if not is_dead:
		velocity = move_and_slide(velocity, FLOOR)
		velocity.y += GRAVITY
	if position.y >= 800:
		queue_free()


func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()


func _on_Timer_timeout():
	queue_free()
