extends KinematicBody2D

onready var _sprite := $Skeleton2D
onready var _animation_player := $AnimationPlayer
onready var _player : Node2D = get_node( '../Player' ) ;
onready var _healthBar := $HealthBar
onready var _inffluenceBar := $InffluenceBar
onready var _inffluenceTimer := $InffluenceTimer
onready var _attackZone := $AttackRange

export( int ) var initialHealth := 100
export( int ) var speed := 100
export( int ) var damage := 10
export( int ) var attackRange := 128

onready var health := initialHealth

var velocity := Vector2()
var isSwitching := false
var isDead := false
var isAlly := false

func _ready():
	$AttackRange/CollisionShape2D.shape.radius = attackRange
	_animation_player.play( "Pela_Walk" )
	_inffluenceBar.value = 0
	_setHealth( health )

func _physics_process( delta ):
	velocity = _move()
	velocity = move_and_slide( velocity )
	if _getTarget() in _attackZone.get_overlapping_bodies() :
		_startAttack( _getTarget() )
	if not _inffluenceTimer.is_stopped() :
		_inffluenceBar.value = 100 - _inffluenceTimer.time_left * 100 / _inffluenceTimer.wait_time

func _move() -> Vector2 :
	if isSwitching or isDead or isAttacking() :
		return Vector2()
	var target := _getTarget()
	
	var dist = Vector2( 1, 1 )
	if target == null :
		target = _player
		dist *= -1
	dist *= target.position - position

	if sign( dist.x ) == sign( _sprite.scale.x ) and dist.x != 0 :
		_sprite.scale.x *= -1

	if ( dist.y < 1 and dist.y > -1 ) :
		dist.y = 0
	return Isometric.calcVec( dist.normalized() * speed )

func hit( rDamage: int, rPosition: Vector2 ) -> void :
	if isSwitching or isDead :
		return
	_setHealth( health - rDamage )
	_knockback( rPosition )

func _knockback( rPosition: Vector2 ) :
	var dist = rPosition - position
	move_and_slide( dist * -15 )

func kill() -> void :
	isDead = true
	_animation_player.play( "Pela_die" )
	$CollisionShape2D.disabled = true

func _getTarget() -> Node :
	if isAlly :
		return _getClosestEnemy()
	return _player

func _setHealth( newHealth : int ) -> void :
	if newHealth <= 0 :
		kill()
	health = newHealth
	_healthBar.value = health
	
func startInffluencing() :
	if isAlly :
		return
	_inffluenceTimer.start()

func stopInffluencing() :
	_inffluenceTimer.stop()
	if not isAlly :
		_inffluenceBar.value = 0

func _on_InffluenceTimer_timeout():
	_animation_player.play( "Pela_Meta" )
	isSwitching = true

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "Pela_Meta" :
		isSwitching = false
		isAlly = true
		_animation_player.play( "Pela_Walk" )
	elif anim_name == "Pela_die" :
		queue_free()

func _on_HurtBox_body_entered( body:Node ):
	if body == _getTarget() :
		_attack( body )

func _attack( target: Node ) :
	target.hit( damage, position )

func _startAttack( target: Node ) :
	if isDead :
		return
	if target == _getTarget() :
		_animation_player.play( "Pela_Attack" )

func isAttacking() -> bool :
	return _animation_player.current_animation == "Pela_Attack"

var _lastTarget : Node = null

func _getClosestEnemy() -> Node :
	if _lastTarget == null or _lastTarget.isDead :
		_lastTarget = _findNewEnemy()
	return _lastTarget

func _findNewEnemy() -> Node : # https://ask.godotengine.org/89680/how-get-the-node-closest-to-my-position
	var target_group = get_tree().get_nodes_in_group( 'enemies' )
	var distance_away = global_transform.origin.distance_to(target_group[1].global_transform.origin)
	var return_node = target_group[1]
	for index in target_group.size():
		var distance = global_transform.origin.distance_to(target_group[index].global_transform.origin)
		if distance < distance_away and distance != 0 and not return_node.is_queued_for_deletion() and not return_node.isAlly:
			distance_away = distance
			return_node = target_group[index]
	if return_node.isAlly :
		return null
	return return_node
