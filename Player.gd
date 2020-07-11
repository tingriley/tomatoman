extends KinematicBody2D

onready var global = get_node("/root/Global")
onready var anim_player = get_node("AnimatedSprite")
const FIREBALL = preload("Fireball.tscn")
const UPFIREBALL = preload("UpFireball.tscn")

const UNIT_SIZE = 64
const SPEED = 4*UNIT_SIZE
const MAX_JUMP_HEIGHT = 3.5*UNIT_SIZE
const MIN_JUMP_HEIGHT = 1*UNIT_SIZE
const FLOOR = Vector2(0, -1)

var jump_duration = 0.5
var max_jump_velocity
var min_jump_velocity
var direction = 1
var velocity = Vector2()
var is_jumping = false
var gravity
var is_change = false
var is_damage = false
var is_enter_right_stage = false
var is_enter_left_stage = false
var is_on_ladder = false
var is_dead = false
var is_back = false
var is_up = false
var is_down = false
var is_shooting = false
var is_powerup = false

var state = "NONE"

var change_scene = false

func _ready():
	$AnimatedSprite.play("run")
	gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2)      # s = 1/2 at^2
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT) # v^2 = 2as
	min_jump_velocity = -sqrt(2 * gravity * MIN_JUMP_HEIGHT) # v^2 = 2as

func shoot():
	var fireball = null
	fireball = FIREBALL.instance()
	fireball.set_direction(sign($Position2D.position.x))

	get_parent().add_child(fireball)
	fireball.position = $Position2D.global_position
	
func shoot_up():
	var fireball = null
	fireball = UPFIREBALL.instance()

	get_parent().add_child(fireball)
	fireball.position = $UpPosition2D.global_position

func shoot_down():
	var fireball = null
	fireball = UPFIREBALL.instance()
	fireball.set_direction(1)
	get_parent().add_child(fireball)
	fireball.position = $DownPosition2D.global_position
	
func dead():

	if not is_damage:
		global.hp -= 1
		$CanvasLayer/HealthBar._on_health_updated(global.hp*10, 0)
		$CanvasLayer/Label.text = str(global.hp)
		is_damage = true
		yield(get_tree().create_timer(1), "timeout")
		is_damage = false
	if global.hp <= 0:
		is_dead = true 
		$dead.play()
		$AnimatedSprite.play("dead")
		yield(get_tree().create_timer(2.5), "timeout")
		get_tree().change_scene("res://Stage" + str(global.current_stage) + ".tscn")
		global.hp = 10

func high_jump():
	velocity.y = max_jump_velocity * 1.25



func move_right():
	if not is_damage and not is_powerup:
		$AnimatedSprite.play("run")
	velocity.x = SPEED
	$AnimatedSprite.flip_h = false
	if sign($Position2D.position.x) < 0:
		$Position2D.position.x *= -1
		$UpPosition2D.position.x *= -1
		$DownPosition2D.position.x *= -1

func move_left():
	if not is_damage and not is_powerup:
		$AnimatedSprite.play("run")
	velocity.x = -SPEED
	$AnimatedSprite.flip_h = true
	if sign($Position2D.position.x) > 0:
		$Position2D.position.x *= -1
		$UpPosition2D.position.x *= -1
		$DownPosition2D.position.x *= -1


func _physics_process(delta):
	$CanvasLayer/HealthBar._on_health_updated(global.hp*10, 0)
	$CanvasLayer/Label.text = str(global.hp)
	
	if not is_dead:
		
		var s = global.current_stage
		
		position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right) #limit the player inside map
		position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
		
		if is_damage:
			$AnimatedSprite.play("damage")
		elif is_powerup:
			$AnimatedSprite.play("powerup")

			

		if position.y <= 0:
			if global.move_camera == false:
				global.move_camera = true
				global.camera_fast = true
		
		if position.y >= $Camera2D.limit_bottom + 50:
			global.move_camera = false
			yield(get_tree().create_timer(1.0), "timeout")
			get_tree().change_scene("res://Stage" + str(global.current_stage) + ".tscn")
		
		
		if Input.is_action_pressed("ui_right"):
			move_right()
		elif Input.is_action_pressed("ui_left"):
			move_left()
		else:
			if not is_damage:
				$AnimatedSprite.play("idle")
			velocity.x = 0
		
		if Input.is_action_pressed("ui_up"):
			is_up = true
		else:
			is_up = false
			
		if Input.is_action_pressed("ui_down"):
			is_down = true
		else:
			is_down = false
		
		if Input.is_action_pressed("ui_accept"):
			if is_on_floor():
				is_jumping = true
				velocity.y = max_jump_velocity
		
		if Input.is_action_just_pressed("ui_focus_next"):
			if state != "NONE":
				if is_up:
					shoot_up()
				elif is_down:
					shoot_down()
				else:
					shoot()
				
		
		if Input.is_action_just_released("ui_up") && velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity
	
		if velocity.y > 0 :
			is_jumping = false
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, FLOOR)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			OS.window_fullscreen = false

func _on_ShootTimer_timeout():
	is_shooting = false


func _on_Timer_timeout():
	is_damage = false
