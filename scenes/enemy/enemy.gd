extends KinematicBody2D

onready var _sprite := $Skeleton2D
onready var _animation_player := $AnimationPlayer
onready var _player : Node2D = get_node( '../Player' ) ;
onready var _healthBar := $HealthBar
onready var _inffluenceBar := $InffluenceBar
onready var _inffluenceTimer := $InffluenceTimer

export( int ) var initialHealth := 20
export( int ) var speed = 5000

onready var health := initialHealth

var velocity := Vector2()
var isSwitching := false
var isDead := false
var isAlly := false

func _ready():
	_animation_player.play( "Pela_Walk" )
	_inffluenceBar.value = 0
	_setHealth( health )

func _physics_process( delta ):
	velocity = _move() * delta
	velocity = move_and_slide( velocity )
	if not _inffluenceTimer.is_stopped() :
		_inffluenceBar.value = 100 - _inffluenceTimer.time_left * 100 / _inffluenceTimer.wait_time

func _move() -> Vector2 :
	if isSwitching or isDead :
		return Vector2()
	var target := _getTarget()
	var dist = target.position - position
	if isAlly :
		dist *= -1

	if sign( dist.x ) == sign( _sprite.scale.x ) and dist.x != 0 :
		_sprite.scale.x *= -1

	if ( dist.y < 1 and dist.y > -1 ) :
		dist.y = 0
	return Isometric.calcVec( dist.normalized() * speed )

func hit( damage: int ) -> void :
	if isSwitching or isDead :
		return
	_setHealth( health - damage )
	_knockback()

func _knockback() :
	var target := _getTarget()
	var dist = target.position - position
	move_and_slide( dist * -15 )

func kill() -> void :
	_animation_player.play( "Pela_die" )
	isDead = true

func _getTarget() -> Node2D :
	return _player

func _setHealth( newHealth : int ) -> void :
	if newHealth <= 0 :
		kill()
	health = newHealth
	_healthBar.value = health
	
func startInffluencing() :
	_inffluenceTimer.start()

func stopInffluencing() :
	_inffluenceTimer.stop()

func _on_InffluenceTimer_timeout():
	_animation_player.play( "Pela_Meta" )
	isSwitching = true

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "Pela_Meta" :
		isSwitching = false
		isAlly = true
		_animation_player.play( "Pela_Walk" )
	elif anim_name == "Pela_die" :
		queue_free()
