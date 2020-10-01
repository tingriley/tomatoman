extends KinematicBody2D

onready var global = get_node("/root/Global")
onready var anim_player = get_node("AnimatedSprite")
const FIREBALL = preload("Fireball.tscn")
const FIREBALL2 = preload("Fireball2.tscn")
const UPFIREBALL = preload("UpFireball.tscn")

const UNIT_SIZE = 64
const SPEED = 4*UNIT_SIZE
const MAX_JUMP_HEIGHT = 3.2*UNIT_SIZE
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
var is_climbing_up = false
var is_climbing_down = false
var is_tween_to_center = false
var can_climb_down = false
var is_floating = false

var change_scene = false

var jump_count = 0
var drift_count = 0
var is_drifting = false
var is_drift = false
var is_fast = false
var is_on_spike = false


func _ready():
	$AnimatedSprite.play("run")
	gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2)      # s = 1/2 at^2
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT) # v^2 = 2as
	min_jump_velocity = -sqrt(2 * gravity * MIN_JUMP_HEIGHT) # v^2 = 2as
	$AnimatedSprite/gun.visible = false

func set_is_back(b):
	is_back = b

func set_is_floating(b):
	is_floating = b

func shoot():
	if $AnimatedSprite/gun2.visible == true:
		$shoot.play()
		var fireball = null
		fireball = FIREBALL2.instance()
		fireball.set_direction(sign($Position2D.position.x))
	
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position	
	else:
		$shoot.play()
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

func dead2():
	global.hp = 0
	
	
	velocity.y = -800
	velocity.x = 0
	$CollisionShape2D.set_deferred("disabled", true) 
	is_dead = true 
	$AnimatedSprite.play("dead")

	yield(get_tree().create_timer(2.5), "timeout")

	if global.current_stage == 12:
		global.hp = global.HP_MAX
		get_tree().change_scene("res://StageBoss.tscn")
	else:
		global.hp = global.HP_MAX
		get_tree().change_scene("res://Stage" + str(global.current_stage) + ".tscn")


func dead():
	

	global.hp -= 1

	if global.hp <= 0:
		if not is_dead:
			velocity.y = -800
			velocity.x = 0
			$CollisionShape2D.set_deferred("disabled", true) 
			is_dead = true 
			$AnimatedSprite.play("dead")
	
			yield(get_tree().create_timer(2.5), "timeout")
	
			if global.current_stage == 12:
				global.hp = global.HP_MAX
				get_tree().change_scene("res://StageBoss.tscn")
			else:
				global.hp = global.HP_MAX
				get_tree().change_scene("res://Stage" + str(global.current_stage) + ".tscn")
	
	if not is_damage:
		is_damage = true
		$DamageTimer.start()

func high_jump():
	velocity.y = max_jump_velocity * 1.25


func tween_to_ladder_center():
	var pos_x = (floor(position.x/64)*64) + 32
	position.x = pos_x
	is_on_ladder = true




func move_right():
	
	if is_drifting:
		is_fast = false
		velocity.x = SPEED*1.2
	elif Input.is_action_pressed("ui_focus_next"):
		is_fast = true
		velocity.x = SPEED*1.5
	else:
		is_fast = false
		velocity.x = SPEED
	$AnimatedSprite.flip_h = false
	$AnimatedSprite/gun.flip_h = false
	$AnimatedSprite/gun2.flip_h = false
	if sign($Position2D.position.x) < 0:
		$Position2D.position.x *= -1
		$Position2D2.position.x *= -1
		$UpPosition2D.position.x *= -1
		$DownPosition2D.position.x *= -1
	
	$AnimatedSprite/gun.position = $Position2D2.position	
	$AnimatedSprite/gun2.position = $Position2D2.position	

func flip_player_to_left():
	$AnimatedSprite.flip_h = true
	$AnimatedSprite/gun.flip_h = true
	$AnimatedSprite/gun2.flip_h = true

	if sign($Position2D.position.x) > 0:
		$Position2D.position.x *= -1
		$Position2D2.position.x *= -1
		$UpPosition2D.position.x *= -1
		$DownPosition2D.position.x *= -1
	$AnimatedSprite/gun.position = $Position2D2.position	
	$AnimatedSprite/gun2.position = $Position2D2.position	

func move_left():
	if is_drifting:
		velocity.x = -SPEED*1.2
		is_fast = false
	elif Input.is_action_pressed("ui_focus_next"):
		is_fast = true
		velocity.x = -SPEED*1.5
	else:
		is_fast = false
		velocity.x = -SPEED
	$AnimatedSprite.flip_h = true
	$AnimatedSprite/gun.flip_h = true
	$AnimatedSprite/gun2.flip_h = true

	if sign($Position2D.position.x) > 0:
		$Position2D.position.x *= -1
		$Position2D2.position.x *= -1
		$UpPosition2D.position.x *= -1
		$DownPosition2D.position.x *= -1
	$AnimatedSprite/gun.position = $Position2D2.position	
	$AnimatedSprite/gun2.position = $Position2D2.position	


func _physics_process(delta):
	$CanvasLayer/HealthBar._on_health_updated(int(global.hp * 10 * (10.0/global.HP_MAX)), 0)
	$CanvasLayer/Label.text = str(global.hp)
	
	
	if is_on_spike:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		$Timer.stop()
	
	if is_dead:
		velocity.x = 0
		velocity.y += gravity * delta
	
	if not is_dead:

		if is_on_floor():
			jump_count = 0	
			is_drifting = false
			is_drift = false
			$Drift.stop()
			$ProgressBar.visible = false
			
		if global.gun_found:
			$AnimatedSprite/gun.visible = true
			$AnimatedSprite/gun2.visible = false
		if global.machine_gun_found:
			$AnimatedSprite/gun.visible = false
			$AnimatedSprite/gun2.visible = true
		if not global.gun_found and not global.machine_gun_found:
			$AnimatedSprite/gun.visible = false
			$AnimatedSprite/gun2.visible = false
		var s = global.current_stage
		
		if is_floating:
			gravity = 500
		else:
			gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2) 
		
		position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right) #limit the player inside map
		if position.y >= $Camera2D.limit_bottom:
			dead2()
	
	

		if position.y <= $Camera2D.limit_top + 64 and is_drifting:
			position.y = $Camera2D.limit_top + 64

		
		if position.y >= $Camera2D.limit_bottom + 50:
			global.move_camera = false
			yield(get_tree().create_timer(1.0), "timeout")
			get_tree().change_scene("res://Stage" + str(global.current_stage) + ".tscn")
		
		
		if Input.is_action_pressed("ui_right"):
			move_right()
		elif Input.is_action_pressed("ui_left"):
			move_left()
		else:
			velocity.x = 0
		
		if Input.is_action_pressed("ui_up"):
			if is_on_ladder:
				is_climbing_up = true
				is_climbing_down = false
				
			is_up = true
		else:
			is_up = false
			
		if Input.is_action_pressed("ui_down"):
			if is_on_ladder or can_climb_down:
				is_climbing_down = true
				is_climbing_up = false
			if !is_on_floor():
				velocity.y = -max_jump_velocity
			is_down = true
		else:
			is_down = false
		
#		if Input.is_action_just_pressed("ui_accept"):
#			if global.double_jump:
#				if jump_count == 1 and not is_drift:
#					jump_count += 1
#					velocity.y = max_jump_velocity
#			if is_on_floor():
#				$jump.play()
#				jump_count += 1
#				is_jumping = true
#				velocity.y = max_jump_velocity
		
		if Input.is_action_just_pressed("ui_focus_prev"):
			if global.double_jump and not global.drift:
				if jump_count == 1 and not is_drift:
					jump_count += 1
					velocity.y = max_jump_velocity
			if is_on_floor():
				is_jumping = true
				velocity.y = max_jump_velocity
				jump_count+=1
		if Input.is_action_pressed("ui_focus_prev"):

			if velocity.y > 0:
				if global.drift:
					if jump_count == 1:
						is_jumping = true
						is_drifting = true
						is_drift = true
						jump_count = 0
						$Drift.start()
						velocity.y = min_jump_velocity
			if global.drift:
				if is_drifting:
					is_drift = true
					velocity.y = min_jump_velocity/3
					$ProgressBar._on_health_updated($Drift.time_left*(100.0/$Drift.wait_time), 0)
					$ProgressBar.visible = true
		if Input.is_action_just_released("ui_focus_prev"):
			is_drift = false


		
		
		if Input.is_action_just_pressed("ui_focus_next"):
			if global.machine_gun_found or global.gun_found:
				shoot()

			

				
		
		if Input.is_action_just_released("ui_up") && velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity
	
		if velocity.y > 0 :
			is_jumping = false
		
		if is_climbing_down:
			if(get_parent().get_node_or_null("Ladders")):
				get_parent().get_node_or_null("Ladders").disable_collision()

			if not is_tween_to_center:
				tween_to_ladder_center()
				is_tween_to_center = true
			velocity.y = 150
		
		elif is_on_ladder:
			if is_climbing_up:
				if(get_parent().get_node_or_null("Ladders")):
					get_parent().get_node_or_null("Ladders").enable_collision()
				if not is_tween_to_center:
					tween_to_ladder_center()
					is_tween_to_center = true
				velocity.y = -150
	
			elif is_climbing_down:
				if not is_tween_to_center:
					tween_to_ladder_center()
					is_tween_to_center = true
				velocity.y = 150
			else:
				velocity.y += gravity * delta
		else:
			

			if is_drift:
				velocity.y += gravity * delta * 0.05
			else:
				velocity.y += gravity * delta
			is_climbing_up = false
			is_climbing_down = false
			is_tween_to_center = false
			if(get_parent().get_node_or_null("Ladders")):
				get_parent().get_node_or_null("Ladders").enable_collision()
		
		if not is_on_ladder or is_on_floor():
			is_climbing_up = false
			is_climbing_down = false




	var snap = Vector2.DOWN * 32 if (!is_jumping && !is_damage && !is_on_ladder) else Vector2.ZERO
		
	 #stop_on_slope=false, int max_slides=4, float floor_max_angle=0.785398, bool infinite_inertia=true 
	
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR, false, 3, 0.785398, false)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			OS.window_fullscreen = false

func _on_ShootTimer_timeout():
	is_shooting = false




func _on_DamageTimer_timeout():
	is_damage = false


func _on_Drift_timeout():
	is_drifting = false
	is_drift = false
	$ProgressBar.visible = false


func _on_Timer_timeout():
	if is_on_spike:
		dead()
