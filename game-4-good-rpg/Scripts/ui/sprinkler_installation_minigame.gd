extends CanvasLayer

signal completed

## Farmland grid (5 columns x 4 rows). Sprinkler spots sit on the bottom two rows.
const GRID_COLS := 5
const GRID_ROWS := 4
const CELL_SIZE := 76
const ICON_INSET := 2
const MAX_SPRINKLERS := 3

## Dry crop tiles the community needs watered.
const DRY_CROP_CELLS: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(3, 0), Vector2i(4, 0),
	Vector2i(0, 1), Vector2i(2, 1), Vector2i(4, 1),
]

## Sprinkler spot index -> grid cell.
const SPRINKLER_SPOT_CELLS: Array[Vector2i] = [
	Vector2i(0, 2), Vector2i(2, 2), Vector2i(4, 2),
	Vector2i(0, 3), Vector2i(2, 3),
]

## Tiles each spot can water (coverage puzzle — no hidden IDs).
const SPOT_COVERAGE: Array[Array] = [
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)],
	[Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(2, 2), Vector2i(3, 2)],
	[Vector2i(3, 0), Vector2i(4, 0), Vector2i(4, 1), Vector2i(3, 1), Vector2i(4, 2), Vector2i(3, 2)],
	[Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 2), Vector2i(0, 3), Vector2i(1, 3)],
	[Vector2i(2, 1), Vector2i(2, 2), Vector2i(3, 2), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 1)],
]

const COLOR_COVERAGE := Color(0.45, 0.75, 1.0, 0.45)
const COLOR_COVERAGE_PREVIEW := Color(0.55, 0.85, 1.0, 0.55)

@onready var instruction_label: Label = $Root/Panel/Margin/MainVBox/InstructionLabel
@onready var sprinklers_count_label: Label = $Root/Panel/Margin/MainVBox/StatsRow/SprinklersCountLabel
@onready var dry_crops_label: Label = $Root/Panel/Margin/MainVBox/StatsRow/DryCropsLabel
@onready var farmland_host: Control = $Root/Panel/Margin/MainVBox/FarmlandHost
@onready var tooltip_label: Label = $Root/Panel/Margin/MainVBox/TooltipLabel
@onready var helper_label: Label = $Root/Panel/Margin/MainVBox/HelperLabel
@onready var reset_button: Button = $Root/Panel/Margin/MainVBox/ButtonRow/ResetButton
@onready var success_label: Label = $Root/Panel/Margin/MainVBox/SuccessLabel

var _cell_panels: Dictionary = {}
var _cell_backgrounds: Dictionary = {}
var _cell_icons: Dictionary = {}
var _cell_coverage: Dictionary = {}
var _spot_panels: Dictionary = {}
var _selected_spots: Dictionary = {}
var _hover_spot_id: int = -1
var _is_completed := false
var _total_dry_crops := DRY_CROP_CELLS.size()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 140
	QuestState.push_interaction_input_lock()
	instruction_label.text = "Place 3 sprinklers where they can reach the most dry crops."
	tooltip_label.text = "Choose spots that can water the most dry crops."
	success_label.visible = false
	reset_button.pressed.connect(_on_reset_pressed)
	_build_farmland_grid()
	_refresh_all_visuals()


func _exit_tree() -> void:
	QuestState.pop_interaction_input_lock()


func _build_farmland_grid() -> void:
	for child in farmland_host.get_children():
		child.queue_free()
	_cell_panels.clear()
	_cell_backgrounds.clear()
	_cell_icons.clear()
	_cell_coverage.clear()
	_spot_panels.clear()

	var grid := GridContainer.new()
	grid.columns = GRID_COLS
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	farmland_host.add_child(grid)

	for y in GRID_ROWS:
		for x in GRID_COLS:
			var pos := Vector2i(x, y)
			var panel := _create_cell_panel(pos)
			grid.add_child(panel)
			_cell_panels[pos] = panel


func _create_cell_panel(pos: Vector2i) -> Panel:
	var panel := Panel.new()
	panel.custom_minimum_size = Vector2(CELL_SIZE, CELL_SIZE)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var bg := ColorRect.new()
	bg.name = "Background"
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.color = Color(0.2, 0.16, 0.12, 0.35)
	panel.add_child(bg)
	_cell_backgrounds[pos] = bg

	var coverage := ColorRect.new()
	coverage.name = "Coverage"
	coverage.set_anchors_preset(Control.PRESET_FULL_RECT)
	coverage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	coverage.visible = false
	panel.add_child(coverage)
	_cell_coverage[pos] = coverage

	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	icon.offset_left = ICON_INSET
	icon.offset_top = ICON_INSET
	icon.offset_right = -ICON_INSET
	icon.offset_bottom = -ICON_INSET
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(icon)
	_cell_icons[pos] = icon

	var spot_id := _spot_id_at(pos)
	if spot_id >= 0:
		_spot_panels[spot_id] = panel
		panel.mouse_entered.connect(_on_spot_mouse_entered.bind(spot_id))
		panel.mouse_exited.connect(_on_spot_mouse_exited.bind(spot_id))
		panel.gui_input.connect(_on_spot_gui_input.bind(spot_id))

	_set_icon_for_cell(pos)
	return panel


func _set_icon_for_cell(pos: Vector2i, force_icon: int = -1) -> void:
	var icon: TextureRect = _cell_icons[pos]
	if force_icon >= 0:
		icon.texture = SprinklerIconsAtlas.get_texture(force_icon)
		return
	var spot_id := _spot_id_at(pos)
	if spot_id >= 0:
		if _selected_spots.has(spot_id):
			icon.texture = SprinklerIconsAtlas.get_texture(SprinklerIconsAtlas.Icon.SPRINKLER)
		else:
			icon.texture = SprinklerIconsAtlas.get_texture(SprinklerIconsAtlas.Icon.SPOT_MARKER)
	elif _is_dry_crop(pos):
		icon.texture = SprinklerIconsAtlas.get_texture(SprinklerIconsAtlas.Icon.DRY_CROP)
	else:
		icon.texture = SprinklerIconsAtlas.get_texture(SprinklerIconsAtlas.Icon.GROUND)


func _is_dry_crop(pos: Vector2i) -> bool:
	return DRY_CROP_CELLS.has(pos)


func _spot_id_at(pos: Vector2i) -> int:
	return SPRINKLER_SPOT_CELLS.find(pos)


func _on_spot_mouse_entered(spot_id: int) -> void:
	if _is_completed:
		return
	_hover_spot_id = spot_id
	_refresh_all_visuals()


func _on_spot_mouse_exited(_spot_id: int) -> void:
	if _is_completed:
		return
	_hover_spot_id = -1
	_refresh_all_visuals()


func _on_spot_gui_input(event: InputEvent, spot_id: int) -> void:
	if _is_completed:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_toggle_spot(spot_id)


func _toggle_spot(spot_id: int) -> void:
	if _selected_spots.has(spot_id):
		_selected_spots.erase(spot_id)
	else:
		if _selected_spots.size() >= MAX_SPRINKLERS:
			helper_label.text = "Only 3 sprinklers are needed. Tap one again to move it."
			return
		_selected_spots[spot_id] = true
	_refresh_all_visuals()
	_try_complete()


func _on_reset_pressed() -> void:
	if _is_completed:
		return
	_selected_spots.clear()
	_hover_spot_id = -1
	helper_label.text = ""
	success_label.visible = false
	_refresh_all_visuals()


func _get_selected_coverage() -> Dictionary:
	var covered: Dictionary = {}
	for spot_id in _selected_spots.keys():
		for cell in SPOT_COVERAGE[spot_id]:
			covered[cell] = true
	return covered


func _get_preview_coverage() -> Dictionary:
	if _hover_spot_id < 0 or _selected_spots.has(_hover_spot_id):
		return {}
	var covered: Dictionary = {}
	for cell in SPOT_COVERAGE[_hover_spot_id]:
		covered[cell] = true
	return covered


func _count_dry_covered(covered: Dictionary) -> int:
	var count := 0
	for dry_pos in DRY_CROP_CELLS:
		if covered.has(dry_pos):
			count += 1
	return count


func _all_dry_crops_covered(covered: Dictionary) -> bool:
	return _count_dry_covered(covered) >= _total_dry_crops


func _refresh_all_visuals() -> void:
	var selected_coverage := _get_selected_coverage()
	var preview_coverage := _get_preview_coverage()
	var dry_covered := _count_dry_covered(selected_coverage)

	sprinklers_count_label.text = "Sprinklers selected: %d/%d" % [_selected_spots.size(), MAX_SPRINKLERS]
	dry_crops_label.text = "Dry crops covered: %d/%d" % [dry_covered, _total_dry_crops]

	for pos in _cell_panels.keys():
		var spot_id := _spot_id_at(pos)
		var panel: Panel = _cell_panels[pos]
		var coverage: ColorRect = _cell_coverage[pos]
		var icon: TextureRect = _cell_icons[pos]

		_set_icon_for_cell(pos)

		if spot_id >= 0:
			if _selected_spots.has(spot_id):
				icon.modulate = Color(1.05, 1.1, 1.2, 1.0)
				panel.scale = Vector2(1.04, 1.04)
			elif spot_id == _hover_spot_id:
				icon.modulate = Color(1.15, 1.12, 1.0, 1.0)
				panel.scale = Vector2(1.06, 1.06)
			else:
				icon.modulate = Color.WHITE
				panel.scale = Vector2.ONE
		elif _is_dry_crop(pos):
			if selected_coverage.has(pos):
				icon.modulate = Color(1.12, 1.08, 0.95, 1.0)
			else:
				icon.modulate = Color.WHITE
			panel.scale = Vector2.ONE
		else:
			icon.modulate = Color(0.95, 0.98, 0.95, 1.0)
			panel.scale = Vector2.ONE

		var show_coverage := selected_coverage.has(pos) or preview_coverage.has(pos)
		coverage.visible = show_coverage
		if show_coverage:
			coverage.color = COLOR_COVERAGE_PREVIEW if preview_coverage.has(pos) else COLOR_COVERAGE

	_update_helper_text(dry_covered)


func _update_helper_text(dry_covered: int) -> void:
	if _is_completed:
		return
	if _selected_spots.size() < MAX_SPRINKLERS:
		if dry_covered > 0:
			helper_label.text = "Nice! Keep choosing spots to cover more dry crops."
		else:
			helper_label.text = ""
		return
	if _all_dry_crops_covered(_get_selected_coverage()):
		helper_label.text = "Perfect! Every dry crop is covered."
	else:
		helper_label.text = "Try placing sprinklers where they can reach more dry crops."


func _try_complete() -> void:
	if _selected_spots.size() != MAX_SPRINKLERS:
		return
	if not _all_dry_crops_covered(_get_selected_coverage()):
		return
	_finish_success()


func _finish_success() -> void:
	_is_completed = true
	_hover_spot_id = -1
	reset_button.disabled = true
	helper_label.text = "Great teamwork! The sprinklers are installed."
	success_label.visible = true
	success_label.text = "Water is flowing and the crops are turning green!"

	var covered := _get_selected_coverage()
	for pos in _cell_panels.keys():
		var coverage: ColorRect = _cell_coverage[pos]
		coverage.visible = covered.has(pos) or _is_dry_crop(pos)
		if coverage.visible:
			coverage.color = Color(0.35, 0.7, 1.0, 0.65)

	await get_tree().create_timer(0.35).timeout
	if not is_inside_tree():
		return

	for dry_pos in DRY_CROP_CELLS:
		var icon: TextureRect = _cell_icons[dry_pos]
		var healthy_tex := SprinklerIconsAtlas.get_texture(SprinklerIconsAtlas.Icon.HEALTHY_CROP)
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(icon, "modulate", Color(1.25, 1.3, 1.1, 1.0), 0.55)
		tween.tween_callback(_set_icon_for_cell.bind(dry_pos, SprinklerIconsAtlas.Icon.HEALTHY_CROP)).set_delay(0.15)

	for spot_pos in SPRINKLER_SPOT_CELLS:
		if _spot_id_at(spot_pos) >= 0 and _selected_spots.has(_spot_id_at(spot_pos)):
			var spot_icon: TextureRect = _cell_icons[spot_pos]
			spot_icon.texture = SprinklerIconsAtlas.get_texture(SprinklerIconsAtlas.Icon.WATER_SPARKLE)

	await get_tree().create_timer(0.85).timeout
	if not is_inside_tree():
		return
	completed.emit()
	queue_free()
