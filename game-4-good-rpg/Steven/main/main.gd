extends Node2D

@export var player_spawn_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	var player := get_node_or_null("AsianBoy")
	if player == null:
		return

	player.global_position = player_spawn_position

	var sprite := player.get_node_or_null("Sprite2D") as Sprite2D
	if sprite:
		sprite.visible = true
