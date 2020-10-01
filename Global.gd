extends Node2D


const SIZE_X = 1152	
const SIZE_Y = 768
var HP_MAX = 5
var hp = HP_MAX
var move_camera = false
var camera_fast = false
var camera_limits_x = []
var green_key = false

var current_stage = 0
var prev_stage = 0

var double_jump = true
var drift = true


var gun_found = true
var machine_gun_found = true
var green_key_found = false
var green_lock_open = false

var blue_key_found = false
var blue_lock_open = false

var snowman_dead = false
var chilly_dead = false


var score = 0
var coin = 0


func _ready():
	hp = HP_MAX
	for i in range(0, 100):
		camera_limits_x.append(0)
	
	camera_limits_x[0] = 6
	camera_limits_x[1] = 2
	camera_limits_x[2] = 2
	camera_limits_x[3] = 2
	camera_limits_x[4] = 1
	camera_limits_x[5] = 3
	camera_limits_x[6] = 3
	camera_limits_x[7] = 2
	camera_limits_x[8] = 1
	camera_limits_x[9] = 4
	camera_limits_x[10] = 4
	camera_limits_x[11] = 2
	camera_limits_x[12] = 1
	camera_limits_x[13] = 10
	
	




