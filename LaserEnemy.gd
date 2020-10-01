extends Node2D

const IDLE_DURATION = 1.0

onready var platform = $FlyingEnemy
onready var tween = $MoveTween

export var move_to = Vector2.RIGHT * 100
export var speed = 3.0 
export var hp = 10

var follow = Vector2.ZERO


func _ready():
	$LaserBeam.set_vector(Vector2(0,1))
	$FlyingEnemy/AnimatedSprite.play("idle")
	_init_tween()

func dead():
	if not $dead.playing:
		$dead.play()
	hp -= 1
	if hp < 0:
		$FlyingEnemy/AnimatedSprite.play("explode")
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
	
func _init_tween():
	var duration = move_to.length() / (4 * 50)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to,       duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to,      Vector2.ZERO,  duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION *2)
	tween.start()
	


func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)


func _process(delta):
	$LaserBeam.global_position = $FlyingEnemy/Position2D.global_position


	
func _on_Timer_timeout():
	pass

