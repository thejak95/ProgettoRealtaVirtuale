extends KinematicBody2D
class_name Player

const FLOOR_NORMAL : = Vector2(0, -1)

var gravity : = 9
var speed : = 110.0 #110.0
var velocity : = Vector2()
var target_speed : = 0.0
var jump_speed : = -225.0 #-225.0
var jumping : = false

var max_life : = 4
var life : = max_life setget _set_life
signal life_changed(value)

onready var animated_sprite : = $AnimatedSprite as AnimatedSprite
onready var animation : AnimationPlayer = $AnimationPlayer as AnimationPlayer

onready var foot : Node2D = $Foot as Node2D
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

	if velocity.x != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	if !is_on_floor():
		animated_sprite.play("jump")

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	get_inputs()
	get_enemy_raycast()
	velocity.y = velocity.y + gravity

	velocity.x = lerp(velocity.x, target_speed, .4)

	if abs(velocity.x) < 1:
		velocity.x = 0

	var snap : = Vector2.DOWN * 8 if !jumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

	if is_on_floor():
		jumping = false
	
	if life==0:
		$AnimatedSprite.modulate.a -= 0.1
		position = $Camera2D.position + Vector2(32, 278)
		$AnimatedSprite.modulate.a = 1
		life = 4

func get_inputs() -> void:
	if Input.is_action_pressed("ui_up") && !jumping:
		velocity.y = jump_speed
		jumping = true

	target_speed = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * speed
	
	if Input.is_key_pressed(32):
		$AnimatedSprite.modulate.a -= 0.1
		position = $Camera2D.position + Vector2(32, 278)
		$AnimatedSprite.modulate.a = 1
		
	if Input.is_action_just_pressed("ui_page_down"):
		life += 1
		_set_life(life)
		print(life)

func get_enemy_raycast() -> void:
	for ray in foot.get_children():
		var collider = ray.get_collider()
		if collider && collider.is_in_group("Enemy"):
			velocity.y = jump_speed * .5
			collider.damage()

func damage() ->void:
	if animation.is_playing():
		return
		
	life -= 1
	_set_life(life)
	animation.play("damage")
	print(life)

func _set_life(value):
	life = min(value, max_life)
	emit_signal("life_changed", life)
