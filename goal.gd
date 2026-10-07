extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):          # 玩家走进来
		var lbl := get_tree().get_first_node_in_group("win_label")
		if lbl:
			lbl.visible = true              # 显示 You win
