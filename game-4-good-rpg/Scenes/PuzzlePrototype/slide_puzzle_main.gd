extends Area2D

# =============================================================================
# TEST — Giả hoàn thành puzzle castle (Achievement Badges)
# -----------------------------------------------------------------------------
# Scene: res://Scenes/PuzzlePrototype/slide_puzzle_main.tscn
#
# | Mục tiêu                              | Cách bật |
# |---------------------------------------|----------|
# | Coi như đã thắng ngay khi vào puzzle  | simulate_puzzle_completed = true (Inspector hoặc default dưới) |
# | Trong lúc chơi, bấm Space = thắng     | simulate_puzzle_completed = true rồi bấm Space |
# | Giải puzzle thật                      | simulate_puzzle_completed = false, xếp đủ 16 ô |
#
# Khi simulate_puzzle_completed = true: unlock badge puzzle_solver + popup ~3s + quay map Ch1 (nếu từ castle).
# Nhớ đặt lại false trước khi commit / build release.
# =============================================================================
## Bật = coi như đã hoàn thành puzzle (test). Chỉnh trên node gốc trong Inspector hoặc đổi default ở đây.
@export var simulate_puzzle_completed: bool = false
const CASTLE_RETURN_SCENE_META := "castle_puzzle_return_scene"

const TILE_SIZE := 150
const BOARD_OFFSET := Vector2(340, 60)

var tiles = []
var solved = []
var mouse = false
var _puzzle_finished := false

func _draw() -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = Color(1.0, 1.0, 1.0, 0.518)
	box.border_color = Color(0.53, 0.64, 0.46)
	box.set_border_width_all(8)
	box.set_corner_radius_all(30)
	draw_style_box(box, Rect2(-40, -40, 1080, 1080))

func _ready():
	position = BOARD_OFFSET
	scale = Vector2(0.6, 0.6)
	start_game()
	if simulate_puzzle_completed:
		call_deferred("_complete_puzzle_as_test")

func start_game():
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5, $Tile6, $Tile7, $Tile8, $Tile9, $Tile10, $Tile11, $Tile12, $Tile13, $Tile14, $Tile15, $Tile16]
	$Tile16.visible = false
	solved = tiles.duplicate()
	shuffle_tiles()

func shuffle_tiles():
	var previous = 99
	var previous_1 = 98
	for t in range(0, 1000):
		var tile = randi() % 16
		if tiles[tile] != $Tile16 and tile != previous and tile != previous_1:
			var rows = int(tiles[tile].position.y / 250)
			var cols = int(tiles[tile].position.x / 250)
			check_neighbours(rows, cols)
			previous_1 = previous
			previous = tile

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("clicked over: ", get_viewport().gui_get_hovered_control())

func _process(_delta: float) -> void:
	if simulate_puzzle_completed and Input.is_action_just_pressed("ui_accept"):
		_complete_puzzle_as_test()
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var local_mouse = to_local(mouse_copy.position)
		var rows = int(local_mouse.y / 250)
		var cols = int(local_mouse.x / 250)
		check_neighbours(rows, cols)

		if tiles == solved:
			_complete_puzzle_win()
	
func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols

	while !empty and !done:
		var new_pos = tiles[pos].position

		if rows < 3:
			new_pos.y += 250
			empty = find_empty(new_pos, pos)
			new_pos.y -= 250

		if rows > 0:
			new_pos.y -= 250
			empty = find_empty(new_pos, pos)
			new_pos.y += 250

		if cols < 3:
			new_pos.x += 250
			empty = find_empty(new_pos, pos)
			new_pos.x -= 250

		if cols > 0:
			new_pos.x -= 250
			empty = find_empty(new_pos, pos)
			new_pos.x += 250

		done = true

func find_empty(position, pos):
	var new_rows = int(position.y / 250)
	var new_cols = int(position.x / 250)
	var new_pos = new_rows * 4 + new_cols

	if tiles[new_pos] == $Tile16:
		swap_tiles(pos, new_pos)
		return true

	return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos

	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event

func _complete_puzzle_as_test() -> void:
	print("[test] Puzzle completed (simulate_puzzle_completed).")
	_complete_puzzle_win()

func _show_complete_message() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(center)

	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.05, 0.06, 0.08, 0.9)
	box.border_color = Color(0.53, 0.64, 0.46)
	box.set_border_width_all(4)
	box.set_corner_radius_all(20)
	box.set_content_margin_all(30)

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", box)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center.add_child(panel)

	var label := Label.new()
	label.text = "Puzzle Complete!"
	label.add_theme_font_size_override("font_size", 48)
	panel.add_child(label)

func _complete_puzzle_win() -> void:
	if _puzzle_finished:
		return
	_puzzle_finished = true
	if not QuestState.is_chapter1_castle_puzzle_complete():
		QuestState.mark_chapter1_castle_puzzle_complete()
	_show_complete_message()
	await get_tree().create_timer(2.0).timeout
	_return_from_castle_puzzle()

func _return_from_castle_puzzle() -> void:
	if get_tree().has_meta(CASTLE_RETURN_SCENE_META):
		var return_scene: String = get_tree().get_meta(CASTLE_RETURN_SCENE_META)
		get_tree().remove_meta(CASTLE_RETURN_SCENE_META)
		get_tree().change_scene_to_file(return_scene)
		return
	if get_parent():
		get_parent().queue_free()
