extends KinematicBody2D

# onready var _player = get_node( '../Player' ) ;

var velocity := Vector2()

func _physics_process( delta ):
    velocity = _move() * delta
    velocity = move_and_slide( velocity )

func _move() -> Vector2 :
    return Vector2()
