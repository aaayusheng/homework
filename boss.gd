extends CharacterBody2D

const SPEED := 80.0
const GRAVITY := 1200.0
var dir := 1.0

# ===== Boss 血量：改成你想要的挨打掉数 =====
var max_health := 5
var health := max_health


func _ready() -> void:
	add_to_group("enemies")        # 进 enemies 组，子弹和玩家受击框都认它


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = dir * SPEED
	move_and_slide()
	if is_on_wall():
		dir *= -1


func take_damage(amount: int = 1) -> void:
	health -= amount               # 被子弹打一下掉 1
	print("Boss 剩血：", health)
	if health <= 0:
		queue_free()               # 血打完才死
