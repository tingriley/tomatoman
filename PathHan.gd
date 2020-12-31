extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var direction = -1 # left

var is_dead = false

const LASER = preload("LaserYellow.tscn")

onready var player_vars = get_node("/root/Global")

export(int) var speed = 80 # edit in the inspector
export(int) var hp = 5
export(Vector2) var size = Vector2(1, 1)


func _ready():
	scale = size


func dead(damage):
	hp -= damage 
	$Label.visible = true
	$Label.text = str(hp)
	$TextTimer.start()

	
	if hp <= 0:
		is_dead = true
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true) 
		$Timer.start()
		



func _physics_process(delta):
	if not is_dead:
		velocity = move_and_slide(velocity, FLOOR)


func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()


func _on_TextTimer_timeout():
	$Label.visible = false

func shoot():

	var degrees = get_parent().rotation_degrees + 180
	var laser = null
	laser = LASER.instance()
	get_parent().get_parent().get_parent().add_child(laser)
	print(degrees)
	laser.set_speed(Vector2(0,600))
		

		
	laser.global_position = $Position2D.global_position


func _on_Shoot_timeout():
	shoot()
