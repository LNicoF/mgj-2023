extends Node2D

const Enemy := preload( "res://scenes/enemy/enemy.tscn" )

export( int ) var entityCap := 20

onready var entitiesContainer := $YSort ;
onready var _enemyPrototype := $YSort/Enemy ;
onready var _player := $YSort/Player

func _spawn( rPosition: Vector2 ) -> void :
    if entitiesContainer.get_child_count() > entityCap:
        return
    var enemy = _createEnemy( rPosition )
    entitiesContainer.add_child( enemy )

func _on_Spawner_timeout( position: Vector2 ):
    _spawn( position )

func _createEnemy( rPosition: Vector2 ) -> Node :
    var enemy : Node2D = Enemy.instance()
    enemy.position = rPosition + _player.position
    print( 'player at %s' % _player.position )
    print( 'spawning at %d' % pitagoras( rPosition ) )
    enemy.scale = _enemyPrototype.scale
    return enemy

func pitagoras( oa: Vector2 ) -> float:
    return sqrt( oa.x * oa.x + oa.y * oa.y ) ;