extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(0, -1)

var velocity = Vector2()


var is_dead = false

const LASER = preload("LaserOrange.tscn")

onready var player_vars = get_node("/root/Global")

export(Vector2) var size = Vector2(1, 1)


func _ready():
	scale = size




func _physics_process(delta):
	if not is_dead:
		velocity = move_and_slide(velocity, FLOOR)
		$AnimatedSprite.rotation_degrees-=30


func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()


