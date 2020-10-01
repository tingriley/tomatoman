extends KinematicBody2D

const IDLE_DURATION = 1.0
const FLOOR = Vector2(0, -1)
var velocity = Vector2(0, -100)

export var move_to = Vector2.RIGHT * 100
export var speed = 3.0 

var follow = Vector2.ZERO

func _ready():
	pass

		

	


func _physics_process(delta):
	velocity = move_and_slide(velocity, FLOOR)
	

