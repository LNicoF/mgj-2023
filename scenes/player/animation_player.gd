extends AnimationPlayer

func _ready():
    play( "Idle" )

func startMoving() :
    if current_animation != "Walk" :
        play( "Walk" )

func stopMoving() :
    if current_animation != "Idle" :
        play( "Idle" )

func attack() :
    if current_animation != "Attack" :
        play( "Attack" )