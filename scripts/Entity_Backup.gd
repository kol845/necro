extends KinematicBody2D

class_name Entity_Backup


const UP = Vector2(0, -1);
const GRAVITY = 40
const MAXFALLSPEED = 1000
const MAXSPEED = 320
const DEFJUMPACCEL = 100
const JUMPACCELFADE = 8;

const ACCEL = 60

var motion : Vector2 = Vector2()
var facing_right = true

var grounded : bool = false

var _visibility = null

var _jump_accel = DEFJUMPACCEL

var _start_cords = [-700,-500]

var _is_dead : bool = true
#var _collision = null

#var is_attacking = false
#var is_running = false
#var is_jumping = false
#var is_falling = false
#var is_idle = false
var actions = {"is_attacking": false, "is_running": false, "is_jumping": false, "is_falling": false, "is_idle": false}
func resetActions():
	for action in actions:
		actions[action] = false
		

func respawn():
	set_process(true)
	_is_dead = false
	self.set_position(Vector2(_start_cords[0], _start_cords[1]))
	if(!facing_right):
		self.scale.x *= -1
	facing_right = true
	actions.is_jumping = false
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
	if (is_on_floor() and !actions.is_jumping):
		actions.is_running=true
func go_right():
	motion.x += ACCEL
	if(!facing_right):
		self.scale.x *= -1
	facing_right = true
	if (is_on_floor() and !actions.is_jumping):
		actions.is_running=true
func do_idle():
	motion.x= lerp(motion.x, 0, 0.2) # Ensures that motion stops gradulaly
	if (is_on_floor() and !actions.is_jumping):
		actions.is_idle = true
func do_jump():
	if(is_on_floor()):
		actions.is_jumping = true
		motion.y -= _jump_accel

		
func go_down():
	if(actions.is_jumping):
		_jump_accel-=JUMPACCELFADE*4
		motion.y -= _jump_accel
func do_attack():
	actions.is_attacking = true;
		
# Gets called 60 times/sec
func _physics_process(delta):
	if(is_on_floor()): # When max jump power reached
		_jump_accel = DEFJUMPACCEL
		resetActions()
	else:
		resetActions()
		actions.is_jumping = true

	motion.y += GRAVITY
	if(motion.y > MAXFALLSPEED):
		motion.y = MAXFALLSPEED
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED) # Ensures that motion.x is always between these values

	motion = move_and_slide(motion, Vector2.UP)

	if(!is_on_floor() and not actions.is_jumping):
		actions.is_falling = true
		
	actions.is_idle = true # Make sure is_idle is triggered if no other action is active
	for action in actions:
		if(actions[action] == true):
			actions.is_idle = false

	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	animationLoop()


func animationLoop():
	if(actions.is_attacking):
		if(actions.is_idle):
			$AnimationPlayer.play("StandingAttack")
		else:
			$AnimationPlayer.play("RunningAttack")
	elif(actions.is_jumping):
		$AnimationPlayer.play("Jump")
	elif(actions.is_running):
		$AnimationPlayer.play("Run")
	elif(actions.is_falling):
		$AnimationPlayer.play("Falling")
	elif(actions.is_idle):
		$AnimationPlayer.play("Idle")
	

