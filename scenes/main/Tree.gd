extends StaticBody2D

onready var _player = get_node( '/root/Main/Player' ) ;

func _physics_process( _delta ):
    z_index = _player.getRelativeZ( position ) ;
     = _player.getRelativeZ( position ) ;
