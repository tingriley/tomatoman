extends Node2D


const LAB = preload("Lab.tscn")
export var delay = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")


func shoot():
	var lab = null
	lab = LAB.instance()

	get_parent().add_child(lab)
	lab.position = $Position2D.global_position


func animate_and_fire():
	$AnimatedSprite.play("fire")
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimatedSprite.play("idle")
	shoot()


