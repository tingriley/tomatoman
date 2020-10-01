extends Node2D

const IDLE_DURATION = 1.0

onready var platform = $Platform
onready var tween = $MoveTween

export var move_to = Vector2.RIGHT * 100
export var speed = 3.0 

var follow = Vector2.ZERO
var pos 
func _ready():
	$Platform/AnimatedSprite.play("idle")
	_init_tween()
	pos = $Platform.position

		
	
func _init_tween():
	var duration = move_to.length() / (4 * 50 * speed) 
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to,       duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to,      Vector2.ZERO,  duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION *2)
	tween.start()
	


func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
	print (platform.position.x)
	if $Platform.position.x > pos.x:
		$Platform/AnimatedSprite.flip_h = true
	else:
		$Platform/AnimatedSprite.flip_h = false
	pos = platform.position
