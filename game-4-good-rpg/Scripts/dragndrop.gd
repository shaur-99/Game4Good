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

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if event.pressed:
		if placed or selected:
			return
		if _hit_test(get_global_mouse_position()):
			selected = true
			z_index = 999
			get_viewport().set_input_as_handled()
	else:
		if selected:
			selected = false
			check_drop_zone()
			get_viewport().set_input_as_handled()

func _physics_process(delta: float) -> void:
	if placed:
		return
	if selected:
		global_position = global_position.lerp(get_global_mouse_position(), min(drag_speed * delta, 1.0))
	else:
		global_position = global_position.lerp(target_position, min(return_speed * delta, 1.0))

func _hit_test(mouse: Vector2) -> bool:
	var rect := _visual_rect()
	return rect.has_point(mouse)

func _visual_rect() -> Rect2:
	var sprite := get_node_or_null("Sprite2D") as Sprite2D
	if sprite == null or sprite.texture == null:
		return Rect2(global_position - Vector2(42, 26), Vector2(84, 52))
	var size := sprite.texture.get_size() * sprite.scale
	var center := global_position + sprite.position
	return Rect2(center - size * 0.5, size)

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
		z_index = int(global_position.y)
		closest_zone.place_plank()
		emit_signal("plank_placed", plank_id)
	else:
		z_index = 50
		target_position = start_position

func reset_plank() -> void:
	placed = false
	selected = false
	global_position = start_position
	target_position = start_position
	z_index = 50
