extends Node2D

signal timeout( position )

onready var _positionNode := $Position2D

func _ready() :
    rotation = rand_range( 0, 360 )

func _on_Timer_timeout():
    emit_signal( "timeout", _positionNode.position.rotated( rotation ) ) ;
