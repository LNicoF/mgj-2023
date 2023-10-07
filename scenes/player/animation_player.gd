extends AnimationPlayer

func _ready():
    play( "Idle" )

func startMoving() :
    if current_animation == "Idle" :
        play( "Walk" )

func stopMoving() :
    if current_animation == "Walk" :
        play( "Idle" )