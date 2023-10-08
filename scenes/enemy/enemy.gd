extends KinematicBody2D

onready var _player : Node2D = get_node( '../Player' ) ;
onready var _healthBar := $HealthBar

export( int ) var initialHealth := 20
export( int ) var speed = 5000

onready var health := initialHealth

var velocity := Vector2()

func _ready():
	_setHealth( health )

func _physics_process( delta ):
	velocity = _move() * delta
	velocity = move_and_slide( velocity )

func _move() -> Vector2 :
	var target := _getTarget()
	var dist = target.position - position
	if ( dist.y < 1 and dist.y > -1 ) :
		dist.y = 0
	return Isometric.calcVec( dist.normalized() * speed )

func hit( damage: int ) -> void :
	_setHealth( health - damage )

func kill() -> void :
	queue_free()

func _getTarget() -> Node2D :
	return _player

func _setHealth( newHealth : int ) -> void :
	if newHealth <= 0 :
		kill()
	health = newHealth
	_healthBar.value = health
	
