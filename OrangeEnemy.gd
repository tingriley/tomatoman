extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(0, -1)
const LASER = preload("LaserOrange.tscn")
const SPEED = 350

var velocity = Vector2()

var direction = -1 # left

var is_dead = false

onready var player_vars = get_node("/root/Global")


export(int) var speed = 80 # edit in the inspector
export(int) var hp = 5
export(Vector2) var size = Vector2(1, 1)

var is_shooting = false
var is_stoptimer_start = false

func _ready():
	scale = size
	yield(get_tree().create_timer(2.5), "timeout")
	is_shooting = true
	$Timer.start()

	
func dead(damage):
	if not $dead.playing:
		$dead.play()
	hp -= damage 
	if hp <= 0:
		is_dead = true
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true) 
		
		if scale > Vector2(1, 1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
			

func _physics_process(delta):
	if not is_dead:
		if not is_shooting:
			$AnimatedSprite.play("idle")
		if is_shooting:
			$AnimatedSprite.play("shoot")
			
	if is_dead == false:
		velocity.x = speed * direction
			
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("walk")
	
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)


	else:
		if is_on_floor():
			velocity = Vector2(120, -400)
		velocity = move_and_slide(velocity, FLOOR)
		velocity.y += GRAVITY
		
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
		$Position2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:  # need to move the raycast
		direction *= -1
		$RayCast2D.position.x *= -1
		$Position2D.position.x *= -1


func shoot():
	var laser = null
	laser = LASER.instance()
	get_parent().add_child(laser)
	laser.set_speed(Vector2(SPEED*direction, 0))
	laser.global_position = $Position2D.global_position


func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()


func _on_Timer_timeout():
	if is_shooting:
		shoot()
		if not is_stoptimer_start:
			$StopTimer.start()
			is_stoptimer_start = true


func _on_StopTimer_timeout():
	is_shooting = false
	yield(get_tree().create_timer(2.5), "timeout")
	is_shooting = true
	is_stoptimer_start = false
