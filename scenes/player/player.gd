extends KinematicBody2D

const SPEED = 10000
var velocity := Vector2()

onready var _animation_player = $AnimationpELUCAr

func _physics_process(delta):
	velocity = _move() * delta
	velocity = move_and_slide( velocity )
	_animate()

func _move() -> Vector2 :
	var goRight := Input.is_physical_key_pressed( KEY_D )
	var goLeft  := Input.is_physical_key_pressed( KEY_A )
	var goUp    := Input.is_physical_key_pressed( KEY_W )
	var goDown  := Input.is_physical_key_pressed( KEY_S )
	var xDir := int( goRight ) - int( goLeft )
	var yDir := int( goDown )  - int( goUp )
	var res = Vector2( xDir, yDir ).normalized() * SPEED
	return Isometric.calcVec( res )

func _animate() :
	if velocity == Vector2() :
		_animation_player.stopMoving()
	else :
		_animation_player.startMoving()

