extends Control
onready var global = get_node("/root/Global")
onready var heath_bar = $HealthBar
onready var update_tween = $UpdateTween

func _ready():
	pass # Replace with function body.

func _on_health_updated(health, amount):
	heath_bar.value = health
	update_tween.interpolate_property(heath_bar, "value", heath_bar.value, health, 0.4, Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	update_tween.start()
	rect_scale.x = 0.5*(global.HP_MAX)/5

func _on_max_health_updated(max_health):
	heath_bar.max_value = max_health

