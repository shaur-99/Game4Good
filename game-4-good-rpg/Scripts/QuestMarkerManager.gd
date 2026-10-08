extends Node

## Quest Marker Manager
## Draws a floating arrow above the NPC / object the player must reach
## for the currently active quest. Pure code drawing, no texture needed.
## Registered as an autoload; creates its own CanvasLayer on demand.

const CHAPTER_0_SCENE := "res://Scenes/game.tscn"
## start.tscn is a byte-identical copy of game.tscn kept as the menu entry point,
## so the Chapter 0 objectives are registered for both scene paths.
const CHAPTER_0_LEGACY_SCENE := "res://Scenes/start.tscn"
const CHAPTER_1_SCENE := "res://Chapter 1/Clear Stream Valley.tscn"
const CHAPTER_2_SCENE := "res://Scenes/chapter_2.tscn"
const CHAPTER_3_SCENE := "res://Scenes/chapter_3.tscn"

const MARKER_COLOR := Color(1.0, 0.85, 0.2, 1.0)
const MARKER_OUTLINE := Color(0.25, 0.15, 0.0, 1.0)
const MARKER_SIZE := 11.0
const HOVER_HEIGHT := 46.0
const BOB_AMPLITUDE := 4.0
const BOB_SPEED := 3.0

var _steps: Array = []
var _layer: CanvasLayer
var _root: Node2D
var _bob_time := 0.0
var _warned: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_steps()
	_ensure_layer()


func _build_steps() -> void:
	_steps = [
		# ---------------- Chapter 0 ----------------
		{
			"scene": CHAPTER_0_SCENE,
			"targets": ["Traveller"],
			"done": func() -> bool: return QuestState.chapter0_traveler_done,
		},
		{
			"scene": CHAPTER_0_SCENE,
			"targets": ["Family"],
			"done": func() -> bool: return QuestState.chapter0_family_done,
		},
		{
			"scene": CHAPTER_0_SCENE,
			"targets": ["Adele"],
			"done": func() -> bool: return QuestState.chapter0_friend_done,
		},

		# ---------------- Chapter 0 (legacy start.tscn entry) ----------------
		{
			"scene": CHAPTER_0_LEGACY_SCENE,
			"targets": ["Traveller"],
			"done": func() -> bool: return QuestState.chapter0_traveler_done,
		},
		{
			"scene": CHAPTER_0_LEGACY_SCENE,
			"targets": ["Family"],
			"done": func() -> bool: return QuestState.chapter0_family_done,
		},
		{
			"scene": CHAPTER_0_LEGACY_SCENE,
			"targets": ["Friend"],
			"done": func() -> bool: return QuestState.chapter0_friend_done,
		},

		# ---------------- Chapter 1 ----------------
		{
			"scene": CHAPTER_1_SCENE,
			"targets": ["Maggie", "Kai", "Jessica"],
			"done": func() -> bool: return QuestState.is_quest1_complete(),
		},
		{
			"scene": CHAPTER_1_SCENE,
			"targets": [
				"Arden_Steven_Villagers/Arden",
				"Arden_Steven_Villagers/Steven",
				"Aurora",
			],
			"done": func() -> bool: return QuestState.is_quest2_complete(),
		},
		{
			"scene": CHAPTER_1_SCENE,
			"targets": ["BridgeRepairTrigger"],
			"done": func() -> bool: return QuestState.bridge_repaired,
		},
		{
			"scene": CHAPTER_1_SCENE,
			"targets": ["Arden_Steven_Villagers/Villagers"],
			"done": func() -> bool: return QuestState.quest3_complete,
		},
		{
			"scene": CHAPTER_1_SCENE,
			"targets": ["Arden_Steven_Villagers/ArdenStevenVillagersGroup"],
			"done": func() -> bool: return QuestState.quest4_complete,
		},
		{
			"scene": CHAPTER_1_SCENE,
			"targets": ["CastlePuzzleTrigger"],
			"done": func() -> bool: return QuestState.is_chapter1_castle_puzzle_complete(),
		},

		# ---------------- Chapter 2 ----------------
		{
			"scene": CHAPTER_2_SCENE,
			"targets": ["Jessica"],
			"done": func() -> bool: return QuestState.is_chapter2_quest1_complete(),
		},
		{
			"scene": CHAPTER_2_SCENE,
			"targets": ["Matt"],
			"done": func() -> bool: return QuestState.is_chapter2_quest2_complete(),
		},
		{
			"scene": CHAPTER_2_SCENE,
			"targets": ["Kai"],
			"done": func() -> bool: return QuestState.is_chapter2_quest3_complete(),
		},
		{
			"scene": CHAPTER_2_SCENE,
			"targets": ["MattKaiVillagers"],
			"done": func() -> bool: return QuestState.chapter2_quest4_meeting_done,
		},
		{
			"scene": CHAPTER_2_SCENE,
			"targets": ["BeachCleanupPuzzle"],
			"done": func() -> bool: return QuestState.chapter2_sign_assembled,
		},

		# ---------------- Chapter 3 ----------------
		{
			"scene": CHAPTER_3_SCENE,
			"targets": ["Advaita", "Sarina", "Aurora"],
			"done": func() -> bool: return QuestState.is_chapter3_quest1_complete(),
		},
		{
			"scene": CHAPTER_3_SCENE,
			"targets": ["StarMoonCouncilGroup"],
			"done": func() -> bool: return QuestState.chapter3_quest2_home_visits_done,
		},
		{
			"scene": CHAPTER_3_SCENE,
			"targets": ["StarMoonCouncilGroup"],
			"done": func() -> bool: return QuestState.chapter3_quest3_festival_setup_done,
		},
		{
			"scene": CHAPTER_3_SCENE,
			"targets": ["MattKaiVillagers"],
			"done": func() -> bool: return QuestState.chapter3_quest4_town_dialogue_done,
		},
		{
			"scene": CHAPTER_3_SCENE,
			"targets": ["StarMoonCouncilGroup"],
			"done": func() -> bool: return QuestState.chapter3_quest5_celebration_done,
		},
	]



func _warn_missing(scene_path, target_path) -> void:
	var key = scene_path + target_path
	if _warned.has(key): return
	_warned[key] = true
	push_warning("QuestMarkerManager: missing target node -> " + scene_path + " / " + target_path)

func _ensure_layer() -> void:
	if is_instance_valid(_layer):
		return
	_layer = CanvasLayer.new()
	_layer.name = "QuestMarkerLayer"
	_layer.layer = 90
	_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_layer)

	_root = Node2D.new()
	_root.name = "Markers"
	_root.draw.connect(_on_draw)
	_layer.add_child(_root)


func _process(delta: float) -> void:
	_ensure_layer()
	_bob_time += delta
	if _root == null:
		return
	# Nothing to mark here: skip the redraw entirely.
	if _current_targets().is_empty():
		return
	_root.queue_redraw()


## start.tscn and game.tscn are the same Chapter 0 map, so a step registered for
## one must also fire on the other.
func _scene_matches(step_scene: String, scene_path: String) -> bool:
	if step_scene == scene_path:
		return true
	if step_scene == CHAPTER_0_SCENE and scene_path == CHAPTER_0_LEGACY_SCENE:
		return true
	return false


## Returns the node paths that should currently be marked.
func _current_targets() -> Array:
	var result: Array = []
	var scene := get_tree().current_scene
	if scene == null:
		return result
	var scene_path := scene.scene_file_path
	if scene_path.is_empty():
		return result

	for step in _steps:
		if not _scene_matches(String(step["scene"]), scene_path):
			continue
		var done_callable: Callable = step["done"]
		if done_callable.is_valid() and done_callable.call():
			continue
		# First unfinished step for this scene wins.
		for target_path in step["targets"]:
			result.append(String(target_path))
		return result
	return result



func _on_draw() -> void:
	if _root == null:
		return
	var scene := get_tree().current_scene
	if scene == null:
		return

	for target_path in _current_targets():
		var target := scene.get_node_or_null(NodePath(target_path))
		if target == null:
			# A missing node means the path went stale (renamed/moved).
			# Warn once per path instead of failing silently.
			_warn_missing(scene.scene_file_path, target_path)
			continue
		if target is CanvasItem and not (target as CanvasItem).is_visible_in_tree():
			continue
		if not (target is Node2D):
			continue
		# _root lives inside a CanvasLayer, whose space is the screen,
		# NOT the world. Every camera here follows the player, so the
		# world position must go through the canvas transform or the
		# arrow drifts by exactly the camera offset.
		var world_pos: Vector2 = (target as Node2D).global_position
		var screen_pos: Vector2 = get_viewport().get_canvas_transform() * world_pos
		var bob := sin(_bob_time * BOB_SPEED) * BOB_AMPLITUDE
		_draw_arrow(screen_pos + Vector2(0.0, -HOVER_HEIGHT + bob))


func _draw_arrow(center: Vector2) -> void:
	var tip := center + Vector2(0.0, MARKER_SIZE)
	var left := center + Vector2(-MARKER_SIZE, -MARKER_SIZE)
	var right := center + Vector2(MARKER_SIZE, -MARKER_SIZE)

	# Outline (slightly larger triangle behind the fill).
	var o := 2.0
	var o_tip := center + Vector2(0.0, MARKER_SIZE + o)
	var o_left := center + Vector2(-MARKER_SIZE - o, -MARKER_SIZE - o)
	var o_right := center + Vector2(MARKER_SIZE + o, -MARKER_SIZE - o)
	_root.draw_colored_polygon(
		PackedVector2Array([o_tip, o_left, o_right]), MARKER_OUTLINE
	)
	_root.draw_colored_polygon(
		PackedVector2Array([tip, left, right]), MARKER_COLOR
	)

