extends Node

const BG := Color(0.051, 0.059, 0.078, 0.784)
const BORDER := Color(0.8, 0.8, 0.8)


func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	_scan(get_tree().root)


func _scan(node: Node) -> void:
	for child in node.get_children():
		_on_node_added(child)
		_scan(child)


func _on_node_added(node: Node) -> void:
	if node is PanelContainer and node.name == &"TalkHintPanel":
		_style_talk_hint(node as PanelContainer)


func _style_talk_hint(panel: PanelContainer) -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = BG
	box.border_color = BORDER
	box.set_border_width_all(3)
	box.set_corner_radius_all(14)
	box.content_margin_left = 22
	box.content_margin_right = 22
	box.content_margin_top = 8
	box.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", box)
