extends Area2D

const CHAPTER_1_SCENE := "res://Chapter 1/Clear Stream Valley.tscn"
const RETURN_SCENE_META := "bridge_puzzle_return_scene"
const PLAYER_INTERACTION_LAYER := 16
const DIALOGUE := preload("res://dialogue.dialogue")

@export_file("*.tscn") var puzzle_scene: String = "res://Scenes/PuzzlePrototype/bridge_repair_puzzle.tscn"

@onready var talk_hint: Control = $TalkHintLayer/TalkHintPanel
@onready var talk_hint_label: Label = $TalkHintLayer/TalkHintPanel/TalkHintLabel
@onready var passage_blocker: StaticBody2D = $PassageBlocker

var player_near := false
var _needs_repair_snap := false
var _can_repair_snap := false


func _ready() -> void:
	collision_mask = 1
	talk_hint.visible = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	_sync_passage_state()


func _process(_delta: float) -> void:
	var needs_repair := _should_be_active()
	var can_repair := needs_repair and QuestState.can_repair_chapter1_bridge()
	if needs_repair == _needs_repair_snap and can_repair == _can_repair_snap:
		return
	_needs_repair_snap = needs_repair
	_can_repair_snap = can_repair
	_sync_passage_state()
	if player_near:
		_update_talk_hint()


func _is_on_chapter1_map() -> bool:
	var scene := get_tree().current_scene
	return scene != null and scene.scene_file_path == CHAPTER_1_SCENE


func _should_be_active() -> bool:
	return _is_on_chapter1_map() and QuestState.needs_chapter1_bridge_repair()


func _sync_passage_state() -> void:
	var needs_repair := _should_be_active()
	visible = needs_repair
	if needs_repair:
		collision_layer = PLAYER_INTERACTION_LAYER
		monitoring = true
		monitorable = true
		passage_blocker.collision_layer = 1
		passage_blocker.collision_mask = 0
	else:
		collision_layer = 0
		monitoring = false
		monitorable = false
		player_near = false
		talk_hint.visible = false
		passage_blocker.collision_layer = 0


func _update_talk_hint() -> void:
	if not player_near or not _should_be_active():
		talk_hint.visible = false
		return
	talk_hint.visible = true
	if QuestState.can_repair_chapter1_bridge():
		talk_hint_label.text = "Press Space to repair the bridge"
	else:
		talk_hint_label.text = "Finish Quest 2 first (Arden, Steven, Aurora)"


func _on_area_entered(area: Area2D) -> void:
	if not _should_be_active():
		return
	if area.is_in_group("player_interaction_area"):
		player_near = true
		_update_talk_hint()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		player_near = false
		talk_hint.visible = false


func action() -> void:
	if not _should_be_active() or not player_near:
		return
	if not QuestState.can_repair_chapter1_bridge():
		_show_bridge_locked_dialogue()
		return
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player:
		get_tree().set_meta(QuestState.BRIDGE_RETURN_POSITION_META, player.global_position)
	var scene := get_tree().current_scene
	if scene and scene.scene_file_path != "":
		get_tree().set_meta(RETURN_SCENE_META, scene.scene_file_path)
	get_tree().change_scene_to_file(puzzle_scene)


func _show_bridge_locked_dialogue() -> void:
	DialogueManager.show_example_dialogue_balloon(DIALOGUE, "chapter1_locked_gather_all_views")
