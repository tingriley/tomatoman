extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(0, -1)
const X_OFFSET = -5
const Y_SPEED = -200

onready var global = get_node("/root/Global")

export(int) var speed = 80 # edit in the inspector
export(int) var hp = 10
export(int) var id = 1
export(int) var facing = 1 #right, left: -1
export(Vector2) var size = Vector2(1, 1)

var velocity = Vector2()
var is_dead = false
var is_damage = false


func _ready():
	scale = size
	$AnimatedSprite.play("idle")
	if facing == -1:
		$AnimatedSprite.flip_h = true


func set_global_dead_flag():
	if id==1:
		global.blue_giant1_defeated = true
	elif id==2:
		global.blue_giant2_defeated = true


func play_dead_animation():
	$AnimatedSprite.play("dead")
	$CollisionShape2D.set_deferred("disabled", true) 

	$Timer.start()
	if scale > Vector2(1, 1):
		get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)


func dead(damage):
	hp -= damage 
	is_damage = true
	
	if hp <= 0:
		is_dead = true
		set_global_dead_flag()
		play_dead_animation()


func _physics_process(delta):
	if is_dead == false:
		if is_damage:
			velocity.y = Y_SPEED
			position.x += X_OFFSET*facing
			is_damage = false
	else:
		if is_on_floor():
			velocity = Vector2(120, -400)
	velocity = move_and_slide(velocity, FLOOR)
	velocity.y += GRAVITY


func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()
