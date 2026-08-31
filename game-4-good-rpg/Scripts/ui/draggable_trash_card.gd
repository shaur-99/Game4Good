extends PanelContainer

signal sorted(item_id: String)

var item_id: String = ""
var display_name: String = ""
var trash_type: String = ""
var home_position: Vector2 = Vector2.ZERO
var _placed := false

@onready var icon_texture: TextureRect = $MarginContainer/VBoxContainer/IconTexture
@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_apply_neutral_card_style()


func _apply_neutral_card_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.14, 0.16, 0.9)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.7, 0.74, 0.78, 1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	add_theme_stylebox_override("panel", style)


func setup(item: Dictionary) -> void:
	item_id = item.get("item_id", "")
	display_name = item.get("display_name", "Trash")
	trash_type = item.get("trash_type", "")
	icon_texture.texture = BeachTrashAtlas.get_texture(item_id)
	name_label.text = display_name


func mark_placed() -> void:
	_placed = true


func remember_home_position() -> void:
	home_position = position


func return_home() -> void:
	position = home_position


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := duplicate()
	preview.modulate.a = 0.75
	set_drag_preview(preview)
	return {
		"item_id": item_id,
		"trash_type": trash_type,
		"source": self,
	}


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END and is_inside_tree() and not is_queued_for_deletion() and not _placed:
		return_home()
