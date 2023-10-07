extends KinematicBody2D

const SPEED = 10000
var velocity := Vector2()

func plain2Iso( plainVec: Vector2 ) -> Vector2 :
    return plainVec * Vector2( 1, .75 )

func _physics_process(delta):
    velocity = _move() * delta
    velocity = move_and_slide( velocity )

func _move() -> Vector2 :
    var goRight := Input.is_physical_key_pressed( KEY_D )
    var goLeft  := Input.is_physical_key_pressed( KEY_A )
    var goUp    := Input.is_physical_key_pressed( KEY_W )
    var goDown  := Input.is_physical_key_pressed( KEY_S )
    var xDir := int( goRight ) - int( goLeft )
    var yDir := int( goDown )  - int( goUp )
    return plain2Iso( Vector2( xDir, yDir ).normalized() * SPEED )

func getRelativeZ( rPosition: Vector2 ) -> int :
    return z_index + int( sign( position.y - rPosition.y ) ) ;
