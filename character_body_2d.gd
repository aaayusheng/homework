extends CharacterBody2D

# ===== 移动手感 =====
const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 1200.0

# ===== 二段跳 =====
const MAX_JUMPS := 2
var jumps_left := 0

# ===== 冲刺 =====
const DASH_SPEED := 800.0
const DASH_TIME := 0.15
const DASH_COOLDOWN := 0.6
var dash_time_left := 0.0
var dash_cd_left := 0.0
var facing_dir := 1.0

# ===== 射击 =====
const bullet_scene := preload("res://Bullet.tscn")
const SHOOT_COOLDOWN := 0.4
var shoot_cd := 0.0

# ===== 血量 =====
var max_health := 3
var health := max_health
var invulnerable := false

@onready var hurtbox: Area2D = $Hurtbox
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound


func _ready() -> void:
	hurtbox.body_entered.connect(_on_hurtbox_entered)
	update_hud()
	add_to_group("player")


func _physics_process(delta: float) -> void:
	if health <= 0:
		return

	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0:
		facing_dir = dir

	if dash_cd_left > 0:
		dash_cd_left -= delta
	if shoot_cd > 0:
		shoot_cd -= delta

	if Input.is_action_just_pressed("dash") and dash_cd_left <= 0:
		dash_time_left = DASH_TIME
		dash_cd_left = DASH_COOLDOWN

	if dash_time_left > 0:
		dash_time_left -= delta
		velocity = Vector2(facing_dir * DASH_SPEED, 0)
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		jumps_left = MAX_JUMPS

	velocity.x = dir * SPEED

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif jumps_left > 0:
			jumps_left -= 1
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("shoot") and shoot_cd <= 0:
		shoot_cd = SHOOT_COOLDOWN
		var b := bullet_scene.instantiate()
		get_parent().add_child(b)
		b.global_position = global_position
		b.set_direction(facing_dir)

	move_and_slide()


func _on_hurtbox_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not invulnerable:
		take_damage(1)


func take_damage(amount: int) -> void:
	health -= amount
	invulnerable = true
	update_hud()
	hurt_sound.play()               # 受伤音效
	if health <= 0:
		die()
		return
	await get_tree().create_timer(1.0).timeout
	invulnerable = false


func die() -> void:
	set_physics_process(false)
	var lbl := get_tree().get_first_node_in_group("death_label")
	if lbl:
		lbl.visible = true


func update_hud() -> void:
	var lbl := get_tree().get_first_node_in_group("hud_label")
	if lbl:
		lbl.text = "HP: %d" % health
