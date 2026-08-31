extends Marker2D

@export var zone_id: int = 0
@export var show_debug_marker: bool = true

var occupied := false

const BLOCK_W := 78.0
const BLOCK_H := 39.0

func _ready() -> void:
	add_to_group("zone")
	add_to_group("bridge_zone")	
	queue_redraw()

func _draw() -> void:
	if show_debug_marker:
		_draw_ghost_plank(Vector2.ZERO)

func _draw_ghost_plank(pos: Vector2) -> void:
	var top := PackedVector2Array([
		pos + Vector2(0, -BLOCK_H / 2.0),
		pos + Vector2(BLOCK_W / 2.0, 0),
		pos + Vector2(0, BLOCK_H / 2.0),
		pos + Vector2(-BLOCK_W / 2.0, 0)
	])
	draw_colored_polygon(top, Color(1.0, 0.86, 0.24, 0.18))
	draw_polyline(PackedVector2Array([top[0], top[1], top[2], top[3], top[0]]), Color(1, 1, 1, 0.75), 1.5)

# Any wooden square can fill any empty square in the bridge gap.
func can_accept(_plank_id: int) -> bool:
	return not occupied

func place_plank() -> void:
	occupied = true
	show_debug_marker = false
	queue_redraw()

func reset_zone() -> void:
	occupied = false
	show_debug_marker = true
	queue_redraw()
