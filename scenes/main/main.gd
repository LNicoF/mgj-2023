extends Node2D

const Enemy := preload( "res://scenes/enemy/enemy.tscn" )

onready var entitieContainer := $YSort ;

func spawn( rPosition: Vector2 ) -> void :
    var enemy := Enemy.instance()
    enemy.position = rPosition
    entitieContainer.add_child( enemy )
