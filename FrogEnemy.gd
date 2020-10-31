extends KinematicBody2D

onready var player_vars = get_node("/root/Global")
const ENEMY = preload("BouncingGiant.tscn")

const GRAVITY = 20
const FLOOR = Vector2(0, -1)
const HEART = preload("heart.tscn")

var velocity = Vector2()
var direction = -1 # left
var is_dead = false

export(int) var speed = 200 # edit in the inspector
export(int) var hp = 10
export(Vector2) var size = Vector2(1, 1)


func _ready():
	scale = size
		
		
	pass # Replace with function body.

func add_heart():
	var heart = null
	heart = HEART.instance()
	get_parent().add_child(heart)
	heart.global_position = global_position + Vector2(0, 64)
	

func add_enemy():
	var enemy = null
	enemy = ENEMY.instance()
	enemy.velocity = Vector2(400*direction, 0)
	get_parent().add_child(enemy)
	enemy.position = global_position -Vector2(0, 50)
	enemy.scale = Vector2(0.75, 0.75)

func dead(damage):
	hp -= damage 
	$Label.visible = true
	$Label.text = str(hp)
	$TextTimer.start()
	if hp <= 0:
		is_dead = true
		if rand_range(0, 1.0) >= 0.2:
			add_heart()
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true) 

		$Timer.start()
		
		if scale > Vector2(1, 1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
			

func _physics_process(delta):
	if is_dead == false:
		velocity.x = speed * direction
			
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("idle")
	
		if Input.is_action_just_pressed("ui_focus_prev"):
			if abs((get_parent().get_node("Player").position.x - position.x)) <= 400:
				velocity.y = -600
				if rand_range(0, 1.0) >= 0.5:
					add_enemy()
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)


	else:
		velocity = move_and_slide(velocity, FLOOR)
		velocity.y += GRAVITY
		
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:  # need to move the raycast
		direction *= -1
		$RayCast2D.position.x *= -1

	
	
					
func _on_Timer_timeout():
	queue_free()



func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()


func _on_TextTimer_timeout():
	$Label.visible = false




func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Fire_timeout():
	pass
	#add_enemy()
