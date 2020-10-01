extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(-1, 0)
const LASER = preload("Ball.tscn")
const HEART = preload("heart.tscn")
const SPEED = 350
const SCORE = 100

var velocity = Vector2()

var direction = -1 # left

var is_dead = false

onready var global = get_node("/root/Global")


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

func shoot():
	var laser = null
	laser = LASER.instance()
	get_parent().add_child(laser)
	laser.set_speed(Vector2(SPEED*direction, -SPEED*direction))
	laser.global_position = $Position2D.global_position
	
		
	laser = LASER.instance()
	get_parent().add_child(laser)
	laser.set_speed(Vector2(-SPEED*direction, SPEED*direction))
	laser.global_position = $Position2D.global_position
	
			
	laser = LASER.instance()
	get_parent().add_child(laser)
	laser.set_speed(Vector2(SPEED*direction, SPEED*direction))
	laser.global_position = $Position2D.global_position			
	
	laser = LASER.instance()
	get_parent().add_child(laser)
	laser.set_speed(Vector2(-SPEED*direction, -SPEED*direction))
	laser.global_position = $Position2D.global_position


func add_heart():
	var heart = null
	heart = HEART.instance()
	get_parent().add_child(heart)
	heart.global_position = $Position2D.global_position - Vector2(0, 64)
	
	
func dead(damage):
	if not $dead.playing:
		$dead.play()
	hp -= damage 
	$Label.visible = true
	$Label.text = str(hp)
	$TextTimer.start()
	if hp <= 0:
		if not is_dead:
			is_dead = true
			if rand_range(0, 1.0) >= 0.5:
				add_heart()
			global.score += SCORE
			$Timer2.start()
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
		velocity.y = speed * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)

	else:
		if is_on_floor():
			velocity = Vector2(120, -400)
		velocity = move_and_slide(velocity, FLOOR)
		velocity.y += GRAVITY
		
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.y *= -1

	
	if $RayCast2D.is_colliding() == false:  # need to move the raycast
		direction *= -1
		$RayCast2D.position.y *= -1

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


func _on_TextTimer_timeout():
	$Label.visible = false


func _on_Timer2_timeout():
	queue_free()
