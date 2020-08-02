extends KinematicBody2D

const SNOWBALL = preload("Snowball.tscn")
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
var start = false

var gravity = 100
var max_jump_velocity 
	
func _ready():
	$AnimatedSprite.play("idle")
	player_position = player.position

	

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

			$PlayerPositionTimer.queue_free()
			$WalkTimer.queue_free()
			is_dead = true
			$AnimatedSprite.play("die")
			yield(get_tree().create_timer(3), "timeout")
			get_parent().get_node("BlueKey").start()
			queue_free()
		


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
	if not start:
		start = true
		$WalkTimer.start()
		$Timer.start()

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
			yield(get_tree().create_timer(0.4), "timeout")
			
			shoot()
			yield(get_tree().create_timer(0.2), "timeout")
			shoot()
			yield(get_tree().create_timer(0.2), "timeout")
			
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
