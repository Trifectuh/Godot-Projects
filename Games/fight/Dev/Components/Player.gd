extends KinematicBody2D

export var PLAYER_ID := 1
export var PLAYER_SIDE := 1

# movement
export var MOVE_SPEED := 500
export var JUMP_X_MOMENTUM := 2
const JUMP_FORCE := 1000
const GRAVITY := 50
const MAX_FALL_SPEED := 1000

var y_velo := 0
var move_dir := 0
var momentum := 1

var dpad_input := 5
var btn_input := 0

var busy := false
var halt := false

# animation
onready var anim_player := $AnimationPlayer

# properties
export var PLAYER_HEALTH := 150
var stun := 0

# state
var upd_func = "move"
var upd_obj = null

func _physics_process(delta):
	update_dpad()	
	update_btn()

	if upd_obj != null:
		call(upd_func, upd_obj)
	else:
		call(upd_func)
		
	if busy:
		move_dir = 0

	move_and_slide(Vector2(move_dir * MOVE_SPEED * momentum, y_velo), Vector2(0, -1))
	
func move():
	if busy == false:
		var grounded = is_on_floor()
	
		if grounded:
			move_dir = 0
			momentum = 1
		
			if dpad_input == 6 || dpad_input == 9:
				move_dir += 1
			elif dpad_input == 4 || dpad_input == 7:
				move_dir -= 1
	
		y_velo += GRAVITY
		if grounded && (dpad_input == 7 || dpad_input == 8 || dpad_input == 9):
			y_velo = -JUMP_FORCE
			momentum = JUMP_X_MOMENTUM
		
		if grounded and y_velo >= 0:
			y_velo = 5
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED
	
func get_hit(attack):
	if (attack != self):
		PLAYER_HEALTH -= attack.DAMAGE
		print(PLAYER_HEALTH)
		stun = attack.HITSTUN
		upd_obj = attack
		upd_func = "stun"

func stun(attack):
	if stun > 0:
		move_dir = 0
		move_dir -= attack.PUSHBACK_OPP * PLAYER_SIDE * stun / 5
		stun -= 1
	else:
		upd_obj = null
		upd_func = "move"

func update_dpad():
	if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_left"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			dpad_input = 7
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
			dpad_input = 1
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_right"):
			dpad_input = 5
		else:
			dpad_input = 4
	elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_right"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			dpad_input = 9
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
			dpad_input = 3
		else:
			dpad_input = 6
	elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
			dpad_input = 5
		else:
			dpad_input = 8
	elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
			dpad_input = 2
	else:
			dpad_input = 5	

func update_btn():
	if Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn1"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn2"):
			btn_input = 12
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn3"):
			btn_input = 13
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn4"):
			btn_input = 14
		else:
			btn_input = 1
	elif Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn2"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn3"):
			btn_input = 23
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn4"):
			btn_input = 24
		else:
			btn_input = 2
	elif Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn3"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn4"):
			btn_input = 34
		else:
			btn_input = 3
	elif Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn4"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			btn_input = 4
	else:
		btn_input = 0

