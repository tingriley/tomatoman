extends Node2D

var hp = 10
var move_camera = false
var camera_fast = false
var camera_limits_x = []
var green_key = false

var current_stage = 0
var prev_stage = 0
const SIZE_X = 1152
const SIZE_Y = 768

func _ready():
	for i in range(0, 100):
		camera_limits_x.append(0)

	
	camera_limits_x[0] = 1
	camera_limits_x[1] = 2
	camera_limits_x[2] = 2
	camera_limits_x[3] = 2
	camera_limits_x[4] = 1
	camera_limits_x[5] = 1
	camera_limits_x[6] = 1
	camera_limits_x[7] = 1
	



