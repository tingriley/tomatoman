extends KinematicBody2D
const UNIT_SIZE = 64
const SPEED = 4*UNIT_SIZE
const MAX_JUMP_HEIGHT = 2.5*UNIT_SIZE
const MIN_JUMP_HEIGHT = 1*UNIT_SIZE
const FLOOR = Vector2(0, -1)
export var hp = 1
export var limit_top = 0
export var limit_down = 0

var start_shooting = false
var jump_duration = 0.5
var max_jump_velocity
var direction = -1
var velocity = Vector2()
var gravity
var init_pos

var speed = 500
var is_damage = false
var is_shooting = false
var is_down = false
var is_dead = false

onready var global = get_node("/root/Global")
const BALL = preload("Ball.tscn")

func dead(damage):
	hp -= 1
	if hp <=0:
		is_dead = true
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true) 
		yield(get_tree().create_timer(1), "timeout")
		queue_free()

func _ready():
	init_pos = position
	$AnimatedSprite.play("idle")
	gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2)      # s = 1/2 at^2
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT) # v^2 = 2as


func shoot():
	var ball = null
	ball = BALL.instance()
	ball.delay = 0
	get_parent().add_child(ball)
	ball.global_position = $Position2D.global_position
	ball.set_speed(Vector2(direction * speed, 0))


	
func _physics_process(delta):
	if abs(get_parent().get_parent().get_node("Player").position.x - position.x) <= 600:
		if not start_shooting:
			$Timer.start()
			start_shooting = true
	
	if is_dead and is_on_floor():
		velocity.y = -300
		velocity.x = 100

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, FLOOR)

func throw():
	yield(get_tree().create_timer(0.05), "timeout")
	$AnimatedSprite.play("throw")
	if not is_shooting:
		$ShootTimer.start()
		is_shooting = true
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimatedSprite.play("idle")
	is_shooting = false
	$ShootTimer.stop()


func _on_Timer_timeout():
	throw()


func _on_ShootTimer_timeout():
	shoot()
