extends KinematicBody2D
export var speed = 100.0
const GRAVITY = 20
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

func _ready():
	pass



func _physics_process(delta):
	if position.y < 0:
		position.y = 1000
	position.y -= speed*delta
