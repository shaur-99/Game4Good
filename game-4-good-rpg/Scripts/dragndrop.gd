extends Node2D

signal plank_placed(plank_id: int)

@export var plank_id: int = 0
@export var snap_distance: float = 52.0
@export var return_speed: float = 18.0
@export var drag_speed: float = 32.0

var selected := false
var placed := false
var start_position: Vector2
var target_position: Vector2

func _ready() -> void:
	add_to_group("bridge_plank")
	start_position = global_position
	target_position = start_position
	# Keep the sprite centred so the diamond tile lines up with the drop zone.
	var sprite := get_node_or_null("Sprite2D")
	if sprite:
		sprite.position = Vector2.ZERO
		sprite.centered = true

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if placed:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected = true
		z_index = 999

func _physics_process(delta: float) -> void:
	if placed:
		return
	if selected:
		global_position = global_position.lerp(get_global_mouse_position(), min(drag_speed * delta, 1.0))
	else:
		global_position = global_position.lerp(target_position, min(return_speed * delta, 1.0))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected:
		selected = false
		check_drop_zone()

func check_drop_zone() -> void:
	var closest_zone: Node2D = null
	var closest_distance := snap_distance

	for zone in get_tree().get_nodes_in_group("bridge_zone"):
		if not zone is Node2D:
			continue
		if not zone.can_accept(plank_id):
			continue
		var distance := global_position.distance_to(zone.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_zone = zone

	if closest_zone != null:
		global_position = closest_zone.global_position
		target_position = closest_zone.global_position
		placed = true
		# Sort by y so lower tiles draw in front, matching the isometric bridge.
		z_index = int(global_position.y)
		closest_zone.place_plank()
		emit_signal("plank_placed", plank_id)
		_disable_drag_collision()
	else:
		z_index = 50
		target_position = start_position

func _disable_drag_collision() -> void:
	var area := get_node_or_null("Area2D")
	if area:
		area.input_pickable = false
