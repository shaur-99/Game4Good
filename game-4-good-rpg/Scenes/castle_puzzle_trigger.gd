extends Area2D

const RETURN_SCENE_META := "castle_puzzle_return_scene"
const PLAYER_INTERACTION_LAYER := 16

@export_file("*.tscn") var puzzle_scene: String = "res://Scenes/PuzzlePrototype/slide_puzzle_main.tscn"
@onready var talk_hint: Control = $TalkHintLayer/TalkHintPanel

var player_near := false
var _chapter1_quests_complete_snap := false

func _ready() -> void:
	collision_mask = 1

	talk_hint.visible = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	_chapter1_quests_complete_snap = QuestState.is_chapter1_complete()
	_apply_chapter1_unlock_state(_chapter1_quests_complete_snap)


func _process(_delta: float) -> void:
	var quests_complete := QuestState.is_chapter1_complete()
	if quests_complete == _chapter1_quests_complete_snap:
		return
	_chapter1_quests_complete_snap = quests_complete
	_apply_chapter1_unlock_state(quests_complete)


func _apply_chapter1_unlock_state(unlocked: bool) -> void:
	visible = unlocked
	if unlocked:
		# Detectable by the Player's ActionableFinder (collision_mask = 16).
		collision_layer = PLAYER_INTERACTION_LAYER
		monitoring = true
		monitorable = true
	else:
		collision_layer = 0
		monitoring = false
		monitorable = false
		player_near = false
		talk_hint.visible = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		player_near = true
		talk_hint.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		player_near = false
		talk_hint.visible = false

func action() -> void:
	# Called by PlayerScript.gd when Space / ui_accept is pressed
	# while ActionableFinder overlaps this Area2D.
	if not QuestState.is_chapter1_complete():
		return
	if player_near:
		var scene := get_tree().current_scene
		if scene and scene.scene_file_path != "":
			get_tree().set_meta(RETURN_SCENE_META, scene.scene_file_path)
		get_tree().change_scene_to_file(puzzle_scene)
