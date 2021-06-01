extends KinematicBody2D

class_name Entity


const UP = Vector2(0, -1);
const GRAVITY = 40
const MAXFALLSPEED = 1000
const MAXSPEED = 320
const DEFJUMPACCEL = 100
const JUMPACCELFADE = 8;

const ACCEL = 60

var motion : Vector2 = Vector2()
var facing_right = true
var is_jumping = false
var grounded : bool = false

var _visibility = null

var _jump_accel = DEFJUMPACCEL

var _start_cords = [-700,-500]

var _is_dead : bool = true
#var _collision = null

func respawn():
	set_process(true)
	_is_dead = false
	self.set_position(Vector2(_start_cords[0], _start_cords[1]))
	if(!facing_right):
		self.scale.x *= -1
	facing_right = true
	is_jumping = false
	grounded = false
	_jump_accel = DEFJUMPACCEL
	motion.x = 0
	motion.y = MAXFALLSPEED
#	_collision = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass
	
func go_left():
	motion.x -= ACCEL
	if(facing_right):
		self.scale.x *= -1
	facing_right = false
	if (is_on_floor() and !is_jumping):
		$AnimationPlayer.play("Run")
func go_right():
	motion.x += ACCEL
	if(!facing_right):
		self.scale.x *= -1
	facing_right = true
	if (is_on_floor() and !is_jumping):
		$AnimationPlayer.play("Run")
func do_idle():
	motion.x= lerp(motion.x, 0, 0.2) # Ensures that motion stops gradulaly
	if (is_on_floor() and !is_jumping):
		$AnimationPlayer.play("Idle")
func do_jump():
	if(is_on_floor()):
		is_jumping = true
		motion.y -= _jump_accel
		$AnimationPlayer.play("Jump")

		
func go_down():
	if(is_jumping):
		_jump_accel-=JUMPACCELFADE*4
		motion.y -= _jump_accel
		
# Gets called 60 times/sec
func _physics_process(delta):
	motion.y += GRAVITY
	if(motion.y > MAXFALLSPEED):
		motion.y = MAXFALLSPEED
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED) # Ensures that motion.x is always between these values

	motion = move_and_slide(motion, Vector2.UP)

	if(!is_on_floor() and !is_jumping):
		$AnimationPlayer.play("Falling")

	if(is_jumping and is_on_floor()): # When max jump power reached
		_jump_accel = DEFJUMPACCEL
		is_jumping=false
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

