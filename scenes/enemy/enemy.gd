extends KinematicBody2D

onready var _player = get_node( '../Player' ) ;

var speed = 5000
var velocity := Vector2()

func _physics_process( delta ):
	velocity = _move() * delta
	velocity = move_and_slide( velocity )

func _move() -> Vector2 :
	var dist = _player.position - position
	var dir = Vector2( sign( dist.x ), sign( dist.y ) )
	dir = dir.normalized()
	return Isometric.calcVec( dir.normalized() * speed )
