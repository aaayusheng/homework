extends Area2D

const SPEED := 600.0
var dir := 1.0

func set_direction(d: float) -> void:
	dir = d

func _ready() -> void:
	body_entered.connect(_on_body_entered)   
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position.x += dir * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):          
		body.take_damage()
	queue_free()                             
