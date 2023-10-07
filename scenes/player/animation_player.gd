extends AnimationPlayer

func startMoving() :
    if current_animation == "" :
        play( "move" )

func stopMoving() :
    play( "RESET" )
