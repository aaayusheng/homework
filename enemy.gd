extends CharacterBody2D

const SPEED := 100.0
const GRAVITY := 1200.0
var dir := 1.0

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = dir * SPEED
	move_and_slide()
	if is_on_wall():
		dir *= -1

func take_damage() -> void:
	queue_free()
