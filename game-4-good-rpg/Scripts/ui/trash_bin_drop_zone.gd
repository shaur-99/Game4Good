extends PanelContainer

signal item_sorted(item_id: String)
signal wrong_drop()

@export var accepted_trash_type: String = "plastic"
@export var bin_label: String = "Bin"

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var hint_label: Label = $MarginContainer/VBoxContainer/HintLabel


func setup(bin_data: Dictionary) -> void:
	accepted_trash_type = bin_data.get("bin_type", accepted_trash_type)
	bin_label = bin_data.get("label", bin_label)
	title_label.text = bin_label
	hint_label.text = "Drop %s here" % bin_label.to_lower()
	var style := StyleBoxFlat.new()
	style.bg_color = bin_data.get("color", Color(0.5, 0.5, 0.5, 0.35))
	style.border_color = Color(1, 1, 1, 0.8)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_right = 10
	style.corner_radius_bottom_left = 10
	add_theme_stylebox_override("panel", style)
	mouse_filter = Control.MOUSE_FILTER_STOP


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("trash_type") and data.has("source")


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var source: Control = data.get("source")
	if data.get("trash_type", "") == accepted_trash_type:
		item_sorted.emit(data.get("item_id", ""))
		if source:
			if source.has_method("mark_placed"):
				source.mark_placed()
			source.queue_free()
	else:
		wrong_drop.emit()
		if source and source.has_method("return_home"):
			source.call_deferred("return_home")
