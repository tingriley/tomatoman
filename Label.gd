extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x = get_parent().get_node("HealthBar").rect_position.x
	var s = get_parent().get_node("HealthBar").rect_scale.x
	rect_position.x =  x*s + 100 + s*10

