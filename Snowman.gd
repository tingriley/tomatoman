extends KinematicBody2D

onready var global = get_node("/root/Global")

const SNOWBALL = preload("Snowball.tscn")
const ENEMY = preload("BouncingGiant.tscn")
const BALL = preload("YellowBall.tscn")
const GUN = preload("MachineGun.tscn")
const HEART = preload("heart.tscn")

const FLOOR = Vector2(0, -1)
const MAX_JUMP_HEIGHT = 64*4
onready var player = get_parent().get_node("Player")
export var hp = 40

var jump_duration = 0.45

var direction = 1 #right
var player_position = Vector2(0, 0)
var velocity = Vector2(0, 0)
var is_jumping = false
var is_dead = false


var gravity = 500
var max_jump_velocity 
var b = true
	
func _ready():
	$AnimatedSprite.play("idle")
	player_position = player.position
	yield(get_tree().create_timer(2), "timeout")
	$WalkTimer.start()
	$Timer.start()


func add_enemy():
	var enemy = null
	enemy = ENEMY.instance()
	enemy.velocity = Vector2(950*direction, 0)
	get_parent().add_child(enemy)
	enemy.position = $Position2D.global_position

func add_machine_gun():
	var gun = null
	gun = GUN.instance()
	get_parent().add_child(gun)
	gun.global_position = global_position + Vector2(0, -128)
	
	
func add_ball():
	var ball = null
	ball = BALL.instance()
	get_parent().add_child(ball)
	var v = player_position - position
	v = v.normalized()
	ball.set_speed(Vector2(v.x*100, 500))
	ball.global_position = global_position
	

func flip():
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	$Position2D.position.x *= -1
	direction*=-1

func dead(damage):
	if hp >= 1:
		$AnimatedSprite.play("damage")
		hp -= damage
		if hp >= 1:
			yield(get_tree().create_timer(0.7), "timeout")
			$AnimatedSprite.play("idle")
		
		
	if hp <= 0:
		if not is_dead:
			global.snowman_dead = true
			$PlayerPositionTimer.queue_free()
			$WalkTimer.queue_free()
			is_dead = true
			$AnimatedSprite.play("die")
			yield(get_tree().create_timer(2), "timeout")
			add_machine_gun()
			queue_free()
		
func add_heart():
	var heart = null
	heart = HEART.instance()
	get_parent().add_child(heart)
	heart.global_position = $Position2D.global_position - Vector2(0, 64)
	

func shoot():
	var snowball = null
	snowball = SNOWBALL.instance()
	var dv = player_position - position
	dv.y = 0
	dv = dv.normalized()
	snowball.set_velocity(dv * 15)
	get_parent().add_child(snowball)
	snowball.position = $Position2D.global_position

func _physics_process(delta):


	if not is_dead:
		if velocity.x == 0:
			if player_position.x > position.x and direction == -1:
				flip()
			if player_position.x < position.x and direction == 1:
				flip()
		
	
		if velocity.y > 0:
			is_jumping = false
			
		velocity.y += gravity*delta
		velocity = move_and_slide(velocity, FLOOR)
	else:
		$AnimatedSprite.play("die")
	
func _on_Timer_timeout():
	if is_dead:
		$AnimatedSprite.play("die")
	else:
		if velocity.x == 0:
			$AnimatedSprite.play("attack")
			if b:
				yield(get_tree().create_timer(0.4), "timeout")
				
				shoot()
				yield(get_tree().create_timer(0.2), "timeout")
				shoot()
				yield(get_tree().create_timer(0.2), "timeout")
				b = !b
			else:
				yield(get_tree().create_timer(0.4), "timeout")
				add_enemy()
				b = !b
			
			$AnimatedSprite.play("idle")


func _on_PlayerPositionTimer_timeout():
	player_position = player.position


func _on_WalkTimer_timeout():
	if is_dead:
		$AnimatedSprite.play("die")
	else:
		velocity.x = direction * 400
		yield(get_tree().create_timer(1.25), "timeout")
		velocity.x = 0


func _on_JumpTimer_timeout():
	if not is_dead:
		if rand_range(0, 1.0) >= 0.65:
			add_heart()



func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.dead()
