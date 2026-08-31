extends Node
## Standalone test runner:
## - Player does NOT need to move
## - Auto-advance chapter/quest description panel
## - Auto-"press Space" for NPC dialogues
## - Follows designed story flow (Chapter 0 -> 1 -> 2)
##
## How to use:
## 1) Add a temporary Node under Main scene
## 2) Attach this script
## 3) Set run_on_ready = true
## 4) Play scene

@export var run_on_ready: bool = false
@export var step_delay_sec: float = 0.2
@export var verbose_logs: bool = true
@export var stop_after_chapter2: bool = true

const NPC_PATHS := {
	"traveler": "Human",
	"family": "Family",
	"friend": "Friend",
	"maggie": "Maggie",
	"kai": "Kai",
	"jessica": "Jessica",
	"aurora": "Aurora",
	"arden": "Arden_Steven_Villagers/Arden",
	"steven": "Arden_Steven_Villagers/Steven",
	"villagers": "Arden_Steven_Villagers/Villagers",
	"council_group": "Arden_Steven_Villagers/ArdenStevenVillagersGroup",
	"matt": "Matt",
	"fishing_residents": "FishingVillageResidents",
	"matt_kai_villagers": "MattKaiVillagers",
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	if run_on_ready:
		call_deferred("_run")


func _run() -> void:
	await run_story_flow()


func run_story_flow() -> void:
	if get_tree().current_scene == null:
		_log("No current scene.")
		return

	_log("Start autoplay flow (chapter 0 -> 1 -> 2)")

	# Chapter 0 intro description pages
	await _advance_panel_until_closed()
	await _talk("traveler")
	await _talk("family")
	await _talk("friend")
	await _advance_panel_until_closed() # to Chapter 1 context + first quest

	# Chapter 1 quests
	await _talk("maggie")
	await _talk("kai")
	await _talk("jessica")
	await _advance_panel_until_closed()

	await _talk("arden")
	await _talk("steven")
	await _talk("aurora")
	await _advance_panel_until_closed()

	await _talk("villagers")
	await _advance_panel_until_closed()

	await _talk("council_group")
	await _advance_panel_until_closed()

	await _talk("villagers")
	await _advance_panel_until_closed() # chapter 1 summary -> chapter 2

	# Chapter 2 quests (current designed logic)
	await _talk("jessica")
	await _talk("matt")
	await _advance_panel_until_closed()

	await _talk("fishing_residents")
	await _advance_panel_until_closed()

	await _talk("matt")
	await _talk("kai")
	await _advance_panel_until_closed()

	await _talk("matt_kai_villagers")
	await _advance_panel_until_closed()

	await _talk("matt_kai_villagers")
	await _advance_panel_until_closed()

	if stop_after_chapter2:
		_log("Autoplay finished at chapter 2.")
		return

	_log("Autoplay finished.")


func _talk(npc_key: String) -> void:
	if not NPC_PATHS.has(npc_key):
		_log("Unknown npc key: %s" % npc_key)
		return

	var scene := get_tree().current_scene
	if scene == null:
		_log("No current scene for talk.")
		return

	var npc_path: String = NPC_PATHS[npc_key]
	if not scene.has_node(npc_path):
		_log("Missing npc node: %s" % npc_path)
		return

	var actionable_path := "%s/Actionable2" % npc_path
	if not scene.has_node(actionable_path):
		_log("Missing Actionable2: %s" % actionable_path)
		return

	var actionable := scene.get_node(actionable_path)
	_log("Talk: %s" % npc_key)

	# Requirement says auto-press Space during talks.
	# Since player doesn't move, overlap may not exist, so fallback to action().
	var pressed := await _press_space()
	if not pressed and actionable != null and actionable.has_method("action"):
		actionable.action()
	elif actionable != null and actionable.has_method("action"):
		# Keep flow reliable even if Space does nothing due to no overlap.
		actionable.action()

	await _wait_dialogue_end()
	await _sleep(step_delay_sec)


func _press_space() -> bool:
	var press := InputEventAction.new()
	press.action = "ui_accept"
	press.pressed = true
	Input.parse_input_event(press)
	await get_tree().process_frame

	var release := InputEventAction.new()
	release.action = "ui_accept"
	release.pressed = false
	Input.parse_input_event(release)
	return true


func _advance_panel_until_closed(max_presses: int = 32) -> void:
	var i := 0
	while i < max_presses:
		var scene := get_tree().current_scene
		if scene == null:
			return
		if not scene.has_method("_on_next_button_pressed"):
			return
		if not "is_guide_open" in scene:
			return
		if not scene.is_guide_open:
			return

		scene._on_next_button_pressed()
		i += 1
		await get_tree().process_frame
		await _sleep(step_delay_sec)

	var final_scene := get_tree().current_scene
	if final_scene != null and "is_guide_open" in final_scene and final_scene.is_guide_open:
		_log("Panel still open after %d presses." % i)


func _wait_dialogue_end(timeout_sec: float = 8.0) -> void:
	var dm = DialogueManager
	if dm == null or not dm.has_signal("dialogue_ended"):
		await _sleep(step_delay_sec)
		return

	var timer := get_tree().create_timer(timeout_sec, true)
	await _await_either(dm.dialogue_ended, timer.timeout)


func _await_either(sig_a: Signal, sig_b: Signal) -> void:
	var done := false
	sig_a.connect(func(_arg = null): done = true, CONNECT_ONE_SHOT)
	sig_b.connect(func(): done = true, CONNECT_ONE_SHOT)
	while not done:
		await get_tree().process_frame


func _sleep(seconds: float) -> void:
	if seconds <= 0.0:
		return
	await get_tree().create_timer(seconds, true).timeout


func _log(msg: String) -> void:
	if verbose_logs:
		print("[story_flow_autoplay] %s" % msg)
