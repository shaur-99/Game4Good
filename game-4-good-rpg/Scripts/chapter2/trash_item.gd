extends Area2D

signal collected(item_id: String)

const PLAYER_INTERACTION_LAYER := 16

@export var item_id: String = ""
@export var display_name: String = "Trash"
@export var trash_type: String = "plastic"
@onready var talk_hint: Control = $TalkHintLayer/TalkHintPanel
@onready var talk_hint_label: Label = $TalkHintLayer/TalkHintPanel/TalkHintLabel
@onready var icon_texture: TextureRect = $Visual/IconTexture
@onready var name_label: Label = $Visual/NameLabel
@onready var visual_panel: Panel = $Visual

var player_near := false


func _ready() -> void:
	add_to_group("beach_trash_item")
	collision_mask = 1
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	icon_texture.texture = BeachTrashAtlas.get_texture(item_id)
	name_label.text = display_name
	_apply_neutral_visual_style()
	refresh_state()


func _apply_neutral_visual_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.12, 0.14, 0.75)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.75, 0.78, 0.82, 1)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	visual_panel.add_theme_stylebox_override("panel", style)


func refresh_state() -> void:
	var active := (
		QuestState.chapter2_beach_cleanup_started
		and not QuestState.chapter2_beach_cleanup_done
		and not QuestState.is_beach_trash_collected(item_id)
	)
	visible = active
	monitoring = active
	monitorable = active
	collision_layer = PLAYER_INTERACTION_LAYER if active else 0
	if not active:
		player_near = false
		talk_hint.visible = false


func action() -> void:
	if not player_near or QuestState.is_beach_trash_collected(item_id):
		return
	if not QuestState.chapter2_beach_cleanup_started or QuestState.chapter2_beach_cleanup_done:
		return
	QuestState.collect_beach_trash_item(item_id)
	collected.emit(item_id)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not visible:
		return
	if area.is_in_group("player_interaction_area"):
		player_near = true
		talk_hint.visible = true
		talk_hint_label.text = "Press Space to collect %s" % display_name


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		player_near = false
		talk_hint.visible = false
