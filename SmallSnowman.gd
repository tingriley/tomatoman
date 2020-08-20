extends KinematicBody2D

const SNOWBALL = preload("Snowball.tscn")
const FLOOR = Vector2(0, -1)
const MAX_JUMP_HEIGHT = 64*4
onready var player = get_parent().get_node("Player")
export var hp = 40
export var direction = 1

var jump_duration = 0.45


var player_position = Vector2(0, 0)
var velocity = Vector2(0, 0)
var is_jumping = false
var is_dead = false
var start = false

var gravity = 100
var max_jump_velocity 

func _ready():
	$AnimatedSprite.play("idle")
	if direction == -1:
		flip()
	
	
	

func flip():
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	$Position2D.position.x *= -1


func dead(damage):
	if hp >= 1:
		$AnimatedSprite.play("damage")
		hp -= damage
		if hp >= 1:
			yield(get_tree().create_timer(0.7), "timeout")
			$AnimatedSprite.play("idle")
		
		
	if hp <= 0:
		if not is_dead:
			is_dead = true
			$AnimatedSprite.play("die")
			yield(get_tree().create_timer(1.5), "timeout")
			queue_free()
		


func shoot():
	var snowball = null
	snowball = SNOWBALL.instance()

	snowball.set_velocity(Vector2(direction * 15, 0))
	get_parent().get_parent().add_child(snowball)
	snowball.position = $Position2D.global_position

func _physics_process(delta):

	if not is_dead:
	
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
		
			$AnimatedSprite.play("idle")


