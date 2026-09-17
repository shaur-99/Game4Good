extends Control

@export var world_scale := 0.11
@export var background_color := Color(0.015, 0.02, 0.025, 0.92)
@export var border_color := Color(0.72, 0.78, 0.82, 0.9)
@export var player_color := Color(0.1, 0.9, 1.0, 1.0)
@export var objective_color := Color(1.0, 0.78, 0.12, 1.0)
@export var player_radius := 6.0
@export var objective_radius := 5.0
@export var border_width := 2.0
@export var edge_inset := 8.0

var _player: Node2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	_resolve_player()
	queue_redraw()


func _process(_delta: float) -> void:
	if not is_instance_valid(_player):
		_resolve_player()
	queue_redraw()


func _resolve_player() -> void:
	_player = get_tree().get_first_node_in_group("player") as Node2D


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), background_color, true)
	draw_rect(Rect2(Vector2.ZERO, size), border_color, false, border_width)
	if not is_instance_valid(_player):
		return

	var center := size * 0.5
	for marker_node in get_tree().get_nodes_in_group("minimap_objective"):
		var marker := marker_node as Node2D
		if marker == null or not marker.is_visible_in_tree():
			continue
		var key: StringName = marker.get("objective_key")
		if key.is_empty() or not QuestState.is_minimap_objective_active(key):
			continue
		var color: Color = marker.get("marker_color")
		if color == Color.WHITE:
			color = objective_color
		draw_circle(center + _map_offset(marker.global_position), objective_radius, color)

	draw_circle(center, player_radius, player_color)


func _map_offset(world_position: Vector2) -> Vector2:
	var offset := (world_position - _player.global_position) * world_scale
	var bounds := size * 0.5 - Vector2.ONE * edge_inset
	var clamp_scale := 1.0
	if absf(offset.x) > bounds.x:
		clamp_scale = minf(clamp_scale, bounds.x / absf(offset.x))
	if absf(offset.y) > bounds.y:
		clamp_scale = minf(clamp_scale, bounds.y / absf(offset.y))
	return offset * clamp_scale
