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

var _player_pos = null;

var _timer = null
var _visibility = null

var _jump_accel = DEFJUMPACCEL

var _respawn_y = -700

var _overlapping_entities = []

#var _collision = null

func respawn():
	self.set_position(Vector2(0, _respawn_y))
	if(!facing_right):
		self.scale.x *= -1
	facing_right = true
	is_jumping = false
	grounded = false
	_player_pos = null;
	_timer = null
	_jump_accel = DEFJUMPACCEL
	motion.x -= 0
	motion.y -= 0
#	_collision = null



# Called when the node enters the scene tree for the first time.
func _ready():
	respawn()
	
	
	
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Gets called 60 times/sec

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

func _physics_process(delta):
	_player_pos = self.get_position()
	motion.y += GRAVITY
	if(motion.y > MAXFALLSPEED):
		motion.y = MAXFALLSPEED
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED) # Ensures that motion.x is always between these values

	

	motion = move_and_slide(motion, Vector2.UP)

#	print(motion)
#	_collision = move_and_collide(motion * delta)
#	if _collision:
#		motion = motion.slide(_collision.normal)

	if(!is_on_floor() and !is_jumping):
		$AnimationPlayer.play("Falling")
	
	
		
	



	if(is_jumping and is_on_floor()): # When max jump power reached
		_jump_accel = DEFJUMPACCEL
		is_jumping=false
		


		
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
		

	
#	motion.y += GRAVITY
#

#	if Input.is_action_pressed("right"):
#		vel.x = MAXSPEED
#	elif Input.is_action_pressed("left"):
#		vel.x = -MAXSPEED
#	else:
#		vel.x = 0


#	print(_visibility.is_on_screen())
