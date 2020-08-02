extends KinematicBody2D

const SNOWBALL = preload("Snowball.tscn")
const ENEMY = preload("BouncingGiant.tscn")
const FLOOR = Vector2(0, -1)
const MAX_JUMP_HEIGHT = 64*4
onready var player = get_parent().get_node("Player")
export var hp = 40

var jump_duration = 0.45

var direction = -1 #left
var player_position = Vector2(0, 0)
var velocity = Vector2(0, 0)
var is_jumping = false
var is_dead = false

var gravity
var max_jump_velocity 
var count = 0

func _ready():
	$AnimatedSprite.play("idle")
	player_position = player.position
	gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2)      # s = 1/2 at^2
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT) # v^2 = 2as


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
			get_parent().get_node("Shake").screen_shake(1, 15, 100)
			$PlayerPositionTimer.queue_free()
			$WalkTimer.queue_free()
			is_dead = true
			$AnimatedSprite.play("die")
			yield(get_tree().create_timer(3), "timeout")
			get_parent().get_node("BlueKey").start()
			queue_free()
		

func add_enemy():
	var enemy = null
	enemy = ENEMY.instance()
	enemy.velocity = Vector2(750*direction, 0)
	get_parent().add_child(enemy)
	enemy.position = $Position2D.global_position
	
func shoot():
	var snowball = null
	snowball = SNOWBALL.instance()
	var dv = player_position - position
	dv.y = 0
	dv = dv.normalized()
	snowball.set_velocity(dv * 12)
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
	count += 1
	if is_dead:
		$AnimatedSprite.play("die")
	else:
		if velocity.x == 0:
			$AnimatedSprite.play("attack")
			yield(get_tree().create_timer(0.4), "timeout")
			
			
			if count%2==0:
				shoot()
				yield(get_tree().create_timer(0.2), "timeout")
				shoot()
				yield(get_tree().create_timer(0.2), "timeout")
				
				$AnimatedSprite.play("idle")
			else:
				add_enemy()
				
				$AnimatedSprite.play("idle")


func _on_PlayerPositionTimer_timeout():
	player_position = player.position


func _on_WalkTimer_timeout():
	if is_dead:
		$AnimatedSprite.play("die")
	else:
		$AnimatedSprite.play("walk")
		velocity.x = direction * 500
		yield(get_tree().create_timer(1.25), "timeout")
		velocity.x = 0
		$AnimatedSprite.play("idle")
