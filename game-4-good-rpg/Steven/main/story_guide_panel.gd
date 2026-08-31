extends Node2D

const CHAPTER0_ENTRIES := [
	{
		"chapter": "Chapter 0 - Origin Town",
		"title": "Learn the Path of Humanity",
		"description": "Go to the big banyan tree in the town center and talk to the Traveler to understand the meaning of the Path of Humanity.",
	},
	{
		"chapter": "Chapter 0 - Origin Town",
		"title": "Get support from family and friends",
		"description": "Go home and talk to your Family, then meet Adele at the village entrance to receive encouragement before departure.",
	},
	{
		"chapter": "Chapter 0 - Origin Town",
		"title": "Remember the core mission",
		"description": "Observe more, listen more, help more, and do not command others or act as a savior.",
	},
]

const CHAPTER_QUEST_ENTRIES := {
	1: [
	{
		"chapter": "Chapter 1 - Clear Stream Valley",
		"title": "Quest 1 - Water Source Field Survey",
		"description": "Walk along the stream to record three key problems: reduced water volume, blocked canals, and uneven water use; then talk to Maggie, Kai, and Jessica.",
	},
	{
		"chapter": "Chapter 1 - Clear Stream Valley",
		"title": "Quest 2 - Collect Viewpoints",
		"description": "Collect three perspectives from Arden (traditional wisdom), Steven (modern solution), and Aurora (children's needs).",
	},
	{
		"chapter": "Chapter 1 - Clear Stream Valley",
		"title": "Quest 3 - Prepare the Community Meeting",
		"description": "Head toward the village entrance. After Quest 2, repair the broken wooden bridge on the way (press Space at the warning icon), then notify villagers and organize both sides' viewpoints into a clear discussion board.",
	},
	{
		"chapter": "Chapter 1 - Clear Stream Valley",
		"title": "Quest 4 - Integrate the Plan",
		"description": "Support negotiation to reach an integrated plan that combines traditional and modern approaches for fair water sharing.",
	},
	{
		"chapter": "Chapter 1 - Clear Stream Valley",
		"title": "Quest 5 - Work Together to Implement",
		"description": "Cooperate with villagers to clear the canal and install water-saving devices so the plan is carried out by the whole community.",
	},
	],
	2: [
	{
		"quest_index": 0,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 1 — Beach Clean-up",
		"description": "Clean garbage on the beach and sort it into the correct bags.\n\nTalk to Jessica near the beach to begin.",
	},
	{
		"quest_index": 0,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 1 — What to Do",
		"description": "Collect 6 trash items on the beach, then drag each item into the correct sorting bag:\n\nPlastic, Recyclable, Organic, and Fishing Waste.",
	},
	{
		"quest_index": 0,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 1 — Complete When",
		"description": "You complete the quest when all beach trash is collected and sorted correctly.",
	},
	{
		"quest_index": 1,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 2 — Goal",
		"description": "Learn traditional marine knowledge from Elder Matt at the fishing wharf.",
	},
	{
		"quest_index": 1,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 2 — Complete When",
		"description": "You complete the quest when you have talked to Matt at the fishing wharf.",
	},
	{
		"quest_index": 2,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 3 — Goal",
		"description": "Understand traditional concepts and innovative solutions, then help both sides reach a consensus.\n\nTalk to Matt at the fishing wharf, visit Kai's ecological breeding test site, and help them communicate face to face.",
	},
	{
		"quest_index": 2,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 3 — What to Learn",
		"description": "From Matt: conforming to nature and respecting the sea.\n\nFrom Kai: ecological breeding, fishing moratorium systems, and low-carbon fishing.\n\nHelp both sides listen to each other and eliminate misunderstandings.",
	},
	{
		"quest_index": 2,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 3 — Complete When",
		"description": "Two generations reach the consensus of \"Protecting the Sea Together.\"\n\nTraditional experience and new methods can work together when people learn from each other.",
	},
	{
		"quest_index": 3,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 4 — Goal",
		"description": "Jointly formulate three ocean protection guidelines.\n\nCall villager representatives to the fishing village meeting room and discuss simple, practical steps everyone can follow.",
	},
	{
		"quest_index": 3,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 4 — Three Guidelines",
		"description": "1. Regular beach cleaning activities.\n2. Use fishing methods that do not harm young fish and are friendly to the ocean.\n3. Pilot ecological breeding to protect the ocean while ensuring livelihoods.",
	},
	{
		"quest_index": 3,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 4 — Complete When",
		"description": "The whole village promises to abide by the ocean protection agreement.\n\nMatt, Kai, and all villagers agree to protect the sea together.",
	},
	{
		"quest_index": 4,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 5 — Goal",
		"description": "Assemble the Protect the Blue Coast sign.",
	},
	{
		"quest_index": 4,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 5 — Ceremony",
		"description": "Organize all villagers to line up for an oath.",
	},
	{
		"quest_index": 4,
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Quest 5 — Final Results",
		"description": "Improved environment and coexistence of tradition and innovation.\n\nThe village celebrates what you helped build together at the coast.",
	},
	],
	3: [
	{
		"chapter": "Chapter 3 - Star & Moon Town",
		"title": "Quest 1 - Visit Cultural Households",
		"description": "Get the Multicultural Custom Manual, politely visit three cultural households, and record customs, foods, rituals, and wishes from Advaita, Sarina, and Aurora.",
	},
	{
		"chapter": "Chapter 3 - Star & Moon Town",
		"title": "Quest 2 - Collect Festival Needs",
		"description": "Talk to villagers in the square and residential areas, collect expectations for rituals, performances, food, and decorations, then list key differences clearly.",
	},
	{
		"chapter": "Chapter 3 - Star & Moon Town",
		"title": "Quest 3 - Coordinate Plans and Integrate Diversity",
		"description": "Invite family representatives to the council house and propose an inclusive plan: rotating rituals, shared multicultural food area, and one joint stage with harmony without uniformity.",
	},
	{
		"chapter": "Chapter 3 - Star & Moon Town",
		"title": "Quest 4 - Divide Tasks and Cooperate in Preparation",
		"description": "In the festival square, divide work for venue setup, food preparation, and performance rehearsal; coordinate materials and resolve small frictions.",
	},
	{
		"chapter": "Chapter 3 - Star & Moon Town",
		"title": "Quest 5 - Host the Harvest Festival",
		"description": "At the main venue, with stage, food, and ritual areas ready, preside over the opening and guide the event smoothly. During the Harvest Festival Parade, walk in the square, wave, and interact with villagers. Final result: successful festival, everyone happy, and the town becomes more harmonious.",
	},
	],
}

const CHAPTER_CONTEXT_ENTRIES := {
	1: [
	{
		"chapter": "Chapter 1 - Clear Stream Valley",
		"title": "Chapter Context",
		"description": "Clear Stream Valley depends on mountain stream water for fields and daily life. When flow drops, canals clog, and use feels unfair, neighbors disagree on what should change first.\n\nYour role is to observe, listen without judging, record what each household needs, and help the community combine traditional care for the stream with practical steps everyone can follow.",
	},
	],
	2: [
	{
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Core Theme",
		"description": "Ocean Protection and Sustainable Fisheries.\n\nCore themes: marine debris, ecological protection, sustainable fisheries, traditional experience, and innovative protection.",
	},
	{
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Your Role",
		"description": "You are a Junior Observer, Cleaning Volunteer, and Plan Helper.\n\nObserve carefully, take practical action, and help villagers agree on a shared plan.",
	},
	{
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Chapter Story",
		"description": "People in Seabreeze Village have lived by the sea for generations and made a living by fishing. Recently, garbage has piled up offshore, seawater quality has declined, and catches have dropped sharply — a challenge many seaside communities face.",
	},
	{
		"chapter": "Chapter 2 - Seabreeze Village",
		"title": "Your Mission",
		"description": "Elder Matt understands the laws of the sea and respects nature. Young Kai wants to use new methods to protect the sea and fish scientifically.\n\nHelp two generations cooperate so the sea and humans can thrive together.",
	},
	],
	3: [
	{
		"chapter": "Chapter 3 - Star & Moon Town",
		"title": "Chapter Context",
		"description": "Star & Moon Town is home to residents of many cultural backgrounds. With Harvest Festival approaching, everyone has different wishes: Advaita values traditional rituals, Sarina loves lively performances, and Aurora wants to share special food.\n\nYour mission is to help everyone respect differences, communicate well, and co-create an inclusive multicultural festival.",
	},
	],
}

const CHAPTER_EDUCATIONAL_ENTRIES := {
	2: [
	{
		"chapter": "Chapter 2 Complete!",
		"title": "Seabreeze Village completed",
		"description": "You completed all Chapter 2 quests and helped villagers protect the coast through cooperation.\n\nFinal result: improved environment and coexistence of tradition and innovation.\n\nEducational value:",
	},
	{
		"chapter": "Chapter 2 — Educational Value",
		"title": "Harmony with Nature",
		"description": "Humans and nature must live in harmony.",
	},
	{
		"chapter": "Chapter 2 — Educational Value",
		"title": "Active Protection",
		"description": "Humans take from nature, but also take the initiative to protect it.",
	},
	{
		"chapter": "Chapter 2 — Educational Value",
		"title": "Learning Across Generations",
		"description": "Learn from each other and progress together between generations.",
	},
	{
		"chapter": "Chapter 2 — Educational Value",
		"title": "Small Actions Matter",
		"description": "Small actions can also bring global environmental changes.",
	},
	],
}

const CHAPTER0_COMPLETION_SUMMARY := {
	"chapter": "Chapter 0 Complete!",
	"title": "Great job, little helper!",
	"description": "You listened to the Traveler, received support from your Family and Adele, and learned your mission: observe more, listen more, and help more.\n\nDo you want to continue to Chapter 1: Clear Stream Valley?",
}

const CHAPTER1_CASTLE_GATE_SUMMARY := {
	"chapter": "Chapter 1 - Clear Stream Valley",
	"title": "One More Step Before the Road Opens",
	"description": "Oops, some problems arise in the castle, the king wants your help to solve his problem. Then, he will use his power to move you to the Sea Village directly.",
}

# =============================================================================
# STORY / CHAPTER TESTING — QUICK REFERENCE (read before toggling flags)
# -----------------------------------------------------------------------------
# Just toggle the true/false constants below (no need to comment/uncomment logic).
# After changing flags, restart the scene or delete save data if QuestState still has old flags.
#
# --- Run / skip each chapter (from menu -> start.tscn) ---
#
# | Goal                             | Flags to set |
# |----------------------------------|--------------|
# | Play full flow 0->1->2->3        | All REQUIRE_* = true, SKIP_* = false, SKIP_TO_CH3 = false |
# | Read Ch0 text only -> go to Ch1  | REQUIRE_CH0 = false, SKIP_CH1 = false |
# | Ch0 -> straight to Ch2 (skip Ch1)| REQUIRE_CH0 = false, SKIP_CH1 = true |
# | Ch0 -> straight to Ch3 (skip Ch1+Ch2) | SKIP_TO_CHAPTER_3_TEST = true (in _ready) |
# | Currently in Ch1, read Context only -> Ch2 | REQUIRE_CH1 = false (press Start Chapter on Ch1 map) |
# | Ch1 done -> straight to Ch3 (skip Ch2) | SKIP_CHAPTER_2_FROM_CHAPTER_1 = true |
# | Ch1: skip castle puzzle          | REQUIRE_CHAPTER_1_CASTLE_PUZZLE = false |
# | Ch1: skip 5 quests -> straight to castle | SKIP_CHAPTER_1_QUESTS_TO_CASTLE_TEST = true (F6 Ch1 map) |
# | Castle puzzle: simulate completion | slide_puzzle_main.gd -> simulate_puzzle_completed = true |
# | Ch1: prevent NPC square overlap  | handled automatically by _refresh_chapter1_square_assembly_visibility (Ch1 map) |
# | Ch1: wooden bridge               | after Quest 2, on the way to Quest 3 (not part of Quest 2); QuestState.needs_chapter1_bridge_repair() |
# | Currently in Ch2, read Context only -> Ch3 | REQUIRE_CH2 = false (press Start Chapter on Ch2 map) |
#
# --- Open a specific map directly (F6 / Run Current Scene) ---
#
# | Chapter | Scene | Root inspector flag |
# |---------|-------|---------------------|
# | 1       | res://Chapter 1/Clear Stream Valley.tscn | begins_on_chapter1_map = true |
# | 2       | res://Scenes/chapter_2.tscn              | begins_on_chapter2_map = true |
# | 3       | res://Steven/main/Main.tscn (temporary)  | begins_on_chapter3_map = true |
#
# Autoplay (auto presses Space + panel): uncomment the block in _ready() (~line 280).
# =============================================================================

# --- Chapter 0 (Origin Town — start.tscn) ---
# REQUIRE = true  -> must talk to Traveler, Family, and Friend before Chapter 1.
# REQUIRE = false -> once Chapter 0 guide text is closed, auto-advance to next chapter.
const REQUIRE_CHAPTER_0_COMPLETE_FOR_CHAPTER_1 := true

# --- Chapter 1 (Clear Stream Valley) ---
# SKIP = true -> after Chapter 0, do not enter Ch1 map; mark Ch1 complete -> Chapter 2.
const SKIP_CHAPTER_1_FROM_CHAPTER_0 := false
# REQUIRE = true  -> must finish all Ch1 quests before Ch2.
# REQUIRE = false -> after reading "Chapter Context" on Ch1 map -> move to Ch2 (skip Ch1 NPC flow).
const REQUIRE_CHAPTER_1_COMPLETE_FOR_CHAPTER_2 := true
# REQUIRE = true  -> after finishing Ch1 quests, must clear castle puzzle (badge puzzle_solver) to mark Ch1 complete.
const REQUIRE_CHAPTER_1_CASTLE_PUZZLE := true
# SKIP = true -> mark all 5 Ch1 quests complete, skip NPC quests, show castle panel immediately (puzzle test).
# Usage: set true -> F6 run "Chapter 1/Clear Stream Valley.tscn" (begins_on_chapter1_map = true).
# Press "Go to the Castle" -> go to CastlePuzzleTrigger -> Space. Remember to reset to false before commit.
const SKIP_CHAPTER_1_QUESTS_TO_CASTLE_TEST := false

# --- Chapter 2 (Seabreeze Village — chapter_2.tscn) ---
# SKIP = true -> when the game tries to open Chapter 2, jump straight to Chapter 3 (skip Ch2 map/interactions).
const SKIP_CHAPTER_2_FROM_CHAPTER_1 := false
# REQUIRE = true  -> must finish all Ch2 quests before Ch3.
# REQUIRE = false -> after reading "Chapter Context" on Ch2 map -> move to Ch3 (skip Ch2 NPC flow).
const REQUIRE_CHAPTER_2_COMPLETE_FOR_CHAPTER_3 := true

# --- Chapter 3 (Star & Moon Town) ---
# SKIP = true in _ready -> jump straight to Ch3, skipping 0/1/2 (quick test).
const SKIP_TO_CHAPTER_3_TEST := false

const CHAPTER_1_SCENE := "res://Chapter 1/Clear Stream Valley.tscn"
const CHAPTER_2_SCENE := "res://Scenes/chapter_2.tscn"
const CHAPTER_3_SCENE := "res://Steven/main/Main.tscn" # TODO: replace when a dedicated Ch3 scene is available
const MENU_SCENE := "res://Scenes/Menu/menu.tscn"

## F6 Ch1 map: skip Ch0 intro and open Ch1 Chapter Context.
@export var begins_on_chapter1_map: bool = false
## F6 Ch2 map: skip Ch0-Ch1 and open Ch2 Chapter Context.
@export var begins_on_chapter2_map: bool = false
## F6 Ch3 map (temporary Main.tscn): skip Ch0-Ch2 and open Ch3 Chapter Context.
@export var begins_on_chapter3_map: bool = false

enum PanelMode {
	GUIDE,
	CHAPTER_CONFIRMATION,
	QUEST_COMPLETION_CONFIRMATION,
	CHAPTER1_CASTLE_GATE,
	CHAPTER_FINAL_SUMMARY,
}

@onready var story_guide_layer: CanvasLayer = $StoryGuideLayer
@onready var guide_panel: PanelContainer = $StoryGuideLayer/GuidePanel
@onready var chapter_label: Label = $StoryGuideLayer/GuidePanel/ContentMargin/ContentVBox/ChapterLabel
@onready var title_label: Label = $StoryGuideLayer/GuidePanel/ContentMargin/ContentVBox/TitleLabel
@onready var description_label: Label = $StoryGuideLayer/GuidePanel/ContentMargin/ContentVBox/DescriptionLabel
@onready var page_label: Label = $StoryGuideLayer/GuidePanel/ContentMargin/ContentVBox/FooterRow/PageLabel
@onready var next_button: Button = $StoryGuideLayer/GuidePanel/ContentMargin/ContentVBox/FooterRow/NextButton
@onready var alt_button: Button = $StoryGuideLayer/GuidePanel/ContentMargin/ContentVBox/FooterRow/AltButton

## Chapter 1 square - Arden / Steven / Villagers / Council Group (only on Clear Stream Valley map).
## Quest 1: hide all groups. Quest 2: Arden + Steven. Wooden bridge (puzzle): after Q2, on the way to Q3 - not part of Q2. Quest 3: + Villagers (after bridge repair). Quest 4: Council Group. Quest 5+: back to individual NPCs.
var _ch1_council_group: Node2D
var _ch1_arden_square: Node2D
var _ch1_steven_square: Node2D
var _ch1_villagers_square: Node2D
var _ch1_collision_restore: Dictionary = {}
var _ch1_square_snap_quest1: bool = false
var _ch1_square_snap_quest2: bool = false
var _ch1_square_snap_quest3: bool = false
var _ch1_square_snap_quest4: bool = false
var _ch1_square_snap_quest5: bool = false
var _ch1_square_snap_bridge_repaired: bool = false
var _ch1_last_quest2_done: bool = false

## Chapter 2 — cast theo quest (chapter_2.tscn).
## Jessica: Q1–Q5. Matt / Kai / FishingVillageResidents: Q1–Q3. MattKaiVillagers: Q4–Q5.
var _ch2_matt: Node2D
var _ch2_kai: Node2D
var _ch2_jessica: Node2D
var _ch2_fishing_villagers: Node2D
var _ch2_matt_kai_villagers: Node2D
var _ch2_snap_quest1_done: bool = false
var _ch2_snap_quest2_done: bool = false
var _ch2_snap_quest3_done: bool = false
var _ch2_snap_quest4_done: bool = false
var _ch2_snap_quest5_done: bool = false

var current_index: int = 0
var active_entries: Array = []
var is_guide_open: bool = false
var chapter0_guide_closed: bool = false
var chapter1_confirmation_shown: bool = false
var chapter2_confirmation_shown: bool = false
var chapter3_confirmation_shown: bool = false
var panel_mode: PanelMode = PanelMode.GUIDE
var active_chapter_id: int = 0
var current_chapter_quest_index: int = -1
var next_chapter_quest_to_describe: int = 0
var pending_completion_prompt_index: int = -1
var suppressed_completion_prompt_index: int = -1
## Quest index saved when the completion panel opens (used when Yes is pressed).
var _completion_prompt_quest_index: int = -1
var chapter_confirmation_target: int = 1
var final_summary_chapter_id: int = -1
var active_guide_kind: String = ""
## Open dialogue balloons block quest-completion UI if we pause mid-conversation.
var _story_dialogue_sessions: int = 0

func _ready() -> void:
	if SKIP_TO_CHAPTER_3_TEST:
		QuestState.chapter0_traveler_done = true
		QuestState.chapter0_family_done = true
		QuestState.chapter0_friend_done = true
		QuestState.quest1_maggie_done = true
		QuestState.quest1_kai_done = true
		QuestState.quest1_jessica_done = true
		QuestState.quest2_arden_done = true
		QuestState.quest2_steven_done = true
		QuestState.quest2_aurora_done = true
		QuestState.acknowledge_chapter1_quest2_completion()
		QuestState.quest3_complete = true
		QuestState.quest4_complete = true
		QuestState.quest5_complete = true
		QuestState.chapter1_description_shown = true
		QuestState.chapter1_castle_gate_shown = true
		QuestState.chapter1_summary_shown = true
		QuestState.mark_chapter1_castle_puzzle_complete()
		QuestState.chapter2_beach_cleanup_started = true
		QuestState.chapter2_beach_cleanup_done = true
		QuestState.chapter2_quest1_matt_done = true
		QuestState.chapter2_quest1_kai_done = true
		QuestState.chapter2_quest3_warehouse_done = true
		QuestState.chapter2_quest4_meeting_done = true
		QuestState.chapter2_quest5_cleanup_done = true
		QuestState.chapter2_description_shown = true
		QuestState.chapter2_summary_shown = true
		chapter0_guide_closed = true
		chapter1_confirmation_shown = true
		chapter2_confirmation_shown = true
		chapter3_confirmation_shown = false
		active_chapter_id = 3

	if SKIP_CHAPTER_1_QUESTS_TO_CASTLE_TEST and begins_on_chapter1_map:
		_apply_skip_chapter1_quests_to_castle_test()

	_resolve_chapter1_square_nodes()
	_resolve_chapter2_cast_nodes()
	if _is_on_chapter1_map():
		call_deferred("_restore_player_after_bridge_puzzle")

	# ===================== AUTOPLAY (auto-runs dialogue + panels) =====================
	# Enable when you want the bot to test-run Ch0->Ch1->Ch2 (does not replace SKIP_* above).
	# Uncomment the block below:
	#var autoplay_script := preload("res://Scripts/story_flow_autoplay.gd")
	#var autoplay = autoplay_script.new()
	#autoplay.run_on_ready = true
	#autoplay.step_delay_sec = 0.2
	#autoplay.verbose_logs = true
	#autoplay.stop_after_chapter2 = true
	#add_child(autoplay)
	# ================================================================================

	add_to_group("story_guide_panel")
	process_mode = Node.PROCESS_MODE_ALWAYS
	if story_guide_layer == null:
		push_error("StoryGuideLayer node is missing on %s" % scene_file_path)
		return
	story_guide_layer.layer = maxi(story_guide_layer.layer, 101)
	story_guide_layer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	guide_panel.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	next_button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	alt_button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	next_button.pressed.connect(_on_next_button_pressed)
	alt_button.pressed.connect(_on_alt_button_pressed)
	if not DialogueManager.dialogue_started.is_connected(_on_story_dialogue_started):
		DialogueManager.dialogue_started.connect(_on_story_dialogue_started)
	if not DialogueManager.dialogue_ended.is_connected(_on_story_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_story_dialogue_ended)
	_refresh_chapter1_square_assembly_visibility()
	_ch1_square_snap_quest1 = QuestState.is_quest1_complete()
	_ch1_last_quest2_done = QuestState.is_quest2_complete()
	_ch1_square_snap_quest2 = _chapter1_quest2_completion_snap_value()
	_ch1_square_snap_quest3 = QuestState.quest3_complete
	_ch1_square_snap_quest4 = QuestState.quest4_complete
	_ch1_square_snap_bridge_repaired = QuestState.bridge_repaired
	if _is_on_chapter2_map():
		_refresh_chapter2_cast_visibility()
		_ch2_snap_quest1_done = QuestState.is_chapter2_quest1_complete()
		_ch2_snap_quest2_done = QuestState.is_chapter2_quest2_complete()
		_ch2_snap_quest3_done = QuestState.chapter2_quest3_warehouse_done
		_ch2_snap_quest4_done = QuestState.chapter2_quest4_meeting_done
		_ch2_snap_quest5_done = QuestState.chapter2_quest5_cleanup_done
	# Scene .tscn uses placeholder "Chapter"/"Title" - hide until script assigns real content.
	story_guide_layer.visible = false
	is_guide_open = false
	if begins_on_chapter3_map:
		chapter0_guide_closed = true
		chapter1_confirmation_shown = true
		chapter2_confirmation_shown = true
		chapter3_confirmation_shown = true
		active_chapter_id = 3
		_open_chapter_context(3)
	elif begins_on_chapter2_map:
		chapter0_guide_closed = true
		chapter1_confirmation_shown = true
		chapter2_confirmation_shown = true
		active_chapter_id = 2
		_open_chapter_context(2)
	elif begins_on_chapter1_map:
		chapter0_guide_closed = true
		active_chapter_id = 1
		_open_chapter1_entry_flow()
	else:
		active_chapter_id = 0
		_open_guide(CHAPTER0_ENTRIES, "chapter0")


func _process(_delta: float) -> void:
	_ch1_poll_quest2_completion_panel()
	_ch1_poll_quest_flags_for_square_visibility()
	_ch2_poll_quest_flags_for_cast_visibility()
	if _story_dialogue_sessions == 0:
		if _try_show_pending_quest_completion():
			return
		if _handle_quest_completion_flow():
			return
		if _handle_final_summary_flow():
			return
	else:
		_handle_quest_completion_flow()
	_reconcile_stray_pause()
	if not chapter0_guide_closed:
		return
	if is_guide_open:
		return

	if QuestState.is_chapter0_complete() and not QuestState.chapter1_description_shown and not chapter1_confirmation_shown:
		_open_chapter_confirmation(1)
		return

	if QuestState.chapter1_summary_shown and not QuestState.chapter2_description_shown and not chapter2_confirmation_shown:
		_open_chapter_confirmation(2)
		return

	if QuestState.chapter2_summary_shown and not QuestState.chapter3_description_shown and not chapter3_confirmation_shown:
		_open_chapter_confirmation(3)
		return


func _on_next_button_pressed() -> void:
	if panel_mode == PanelMode.CHAPTER_CONFIRMATION:
		_start_chapter_flow(_resolve_chapter_flow_target(chapter_confirmation_target))
		return

	if panel_mode == PanelMode.QUEST_COMPLETION_CONFIRMATION:
		_sync_active_chapter_from_scene()
		var completed_idx := _completion_prompt_quest_index
		if completed_idx < 0:
			completed_idx = pending_completion_prompt_index
		if completed_idx < 0:
			completed_idx = current_chapter_quest_index
		if completed_idx == _quest_count(active_chapter_id) - 1:
			suppressed_completion_prompt_index = -1
			pending_completion_prompt_index = -1
			_completion_prompt_quest_index = -1
			_close_guide_panel()
			if _should_show_chapter1_castle_gate():
				_open_chapter1_castle_gate()
			else:
				_open_chapter_final_summary(active_chapter_id)
			return
		_advance_after_quest_completion(completed_idx)
		return

	if panel_mode == PanelMode.CHAPTER1_CASTLE_GATE:
		_dismiss_chapter1_castle_gate_panel()
		return

	if panel_mode == PanelMode.CHAPTER_FINAL_SUMMARY:
		if final_summary_chapter_id == 1 and _should_show_chapter1_castle_gate():
			_close_guide_panel()
			_open_chapter1_castle_gate()
			return
		if active_guide_kind == "chapter_educational" and current_index < active_entries.size() - 1:
			current_index += 1
			_show_entry(current_index)
			return
		_mark_chapter_summary_shown(final_summary_chapter_id)
		if final_summary_chapter_id == 2:
			_return_to_main_menu()
			return
		if final_summary_chapter_id < 3:
			_start_chapter_flow(_resolve_chapter_flow_target(final_summary_chapter_id + 1))
		else:
			_close_guide_panel()
		return

	if panel_mode == PanelMode.GUIDE and active_guide_kind == "chapter_context":
		if active_chapter_id == 1 and not REQUIRE_CHAPTER_1_COMPLETE_FOR_CHAPTER_2:
			_set_chapter_description_shown(1)
			_close_guide_panel()
			_mark_chapter_1_complete_for_skip()
			_start_chapter_flow(_resolve_chapter_flow_target(2))
			return
		if active_chapter_id == 2 and not REQUIRE_CHAPTER_2_COMPLETE_FOR_CHAPTER_3:
			_set_chapter_description_shown(2)
			_close_guide_panel()
			_mark_chapter_2_complete_for_skip()
			_start_chapter_flow(_resolve_chapter_flow_target(3))
			return
		_set_chapter_description_shown(active_chapter_id)
		_close_guide_panel()
		_open_next_chapter_quest_description()
		return

	if panel_mode == PanelMode.GUIDE and active_guide_kind == "quest":
		if _has_more_quest_guide_pages(current_index):
			current_index += 1
			_show_entry(current_index)
			return
		var started_quest_index := _entry_quest_index(active_entries[current_index], current_index)
		current_chapter_quest_index = started_quest_index
		next_chapter_quest_to_describe = started_quest_index + 1
		_acknowledge_quest_guide_started(started_quest_index)
		_close_guide_panel()
		return

	current_index += 1
	if current_index >= active_entries.size():
		_close_guide_panel()
		return

	_show_entry(current_index)


func _on_alt_button_pressed() -> void:
	if panel_mode == PanelMode.QUEST_COMPLETION_CONFIRMATION:
		var completed_idx := _completion_prompt_quest_index
		if completed_idx < 0:
			completed_idx = pending_completion_prompt_index
		if completed_idx < 0:
			completed_idx = current_chapter_quest_index
		suppressed_completion_prompt_index = completed_idx
		pending_completion_prompt_index = -1
		_completion_prompt_quest_index = -1
		_close_guide_panel()
		if active_chapter_id == 2:
			_refresh_chapter2_cast_visibility()
		return

	if panel_mode == PanelMode.CHAPTER_CONFIRMATION:
		_set_chapter_confirmation_shown(chapter_confirmation_target)
		_close_guide_panel()


func _show_entry(index: int) -> void:
	var entry: Dictionary = active_entries[index]
	chapter_label.text = entry["chapter"]
	title_label.text = entry["title"]
	description_label.text = entry["description"]
	page_label.text = "%d/%d" % [index + 1, active_entries.size()] if active_entries.size() > 1 else ""
	alt_button.visible = false

	if active_guide_kind == "quest":
		next_button.text = "Start Quest" if not _has_more_quest_guide_pages(index) else "Next"
		return
	if active_guide_kind == "chapter_educational":
		next_button.text = "Finish all the journey" if index == active_entries.size() - 1 else "Next"
		return
	if active_guide_kind == "chapter_context":
		next_button.text = "Start Chapter"
		return

	next_button.text = "Start" if index == active_entries.size() - 1 else "Next"


func _close_guide_panel() -> void:
	if active_guide_kind == "chapter0":
		chapter0_guide_closed = true

	var bypass_chapter_0_for_chapter_1 := (
		active_guide_kind == "chapter0" and not REQUIRE_CHAPTER_0_COMPLETE_FOR_CHAPTER_1
	)

	story_guide_layer.visible = false
	is_guide_open = false
	panel_mode = PanelMode.GUIDE
	active_guide_kind = ""
	get_tree().paused = false

	if bypass_chapter_0_for_chapter_1:
		QuestState.chapter0_traveler_done = true
		QuestState.chapter0_family_done = true
		QuestState.chapter0_friend_done = true
		_start_chapter_flow(_resolve_chapter_flow_target(1))


func _open_guide(entries: Array, guide_kind: String) -> void:
	panel_mode = PanelMode.GUIDE
	active_guide_kind = guide_kind
	active_entries = entries.duplicate(true)
	current_index = 0
	story_guide_layer.visible = true
	is_guide_open = true
	_show_entry(current_index)
	get_tree().paused = true


func _open_chapter_confirmation(chapter_id: int) -> void:
	panel_mode = PanelMode.CHAPTER_CONFIRMATION
	chapter_confirmation_target = chapter_id
	active_entries.clear()
	story_guide_layer.visible = true
	is_guide_open = true

	if chapter_id == 1:
		chapter_label.text = CHAPTER0_COMPLETION_SUMMARY["chapter"]
		title_label.text = CHAPTER0_COMPLETION_SUMMARY["title"]
		description_label.text = CHAPTER0_COMPLETION_SUMMARY["description"]
	elif chapter_id == 2:
		chapter_label.text = "Chapter 1 Complete!"
		title_label.text = "Ready for Seabreeze Village?"
		description_label.text = "You helped Clear Stream Valley create a fair water plan and earned the Pathfinder Badge at the valley castle.\n\nContinue to Chapter 2 to support marine protection and shared livelihood in Seabreeze Village."
	elif chapter_id == 3:
		chapter_label.text = "Chapter 2 Complete!"
		title_label.text = "Ready for Star & Moon Town?"
		description_label.text = "You helped Seabreeze Village protect the coast through cooperation.\n\nContinue to Chapter 3 to support inclusion and multicultural collaboration."

	page_label.text = ""
	next_button.text = "Continue to Chapter %d" % chapter_id
	alt_button.text = "Not now"
	alt_button.visible = true
	get_tree().paused = true


func _entry_quest_index(entry: Dictionary, fallback_index: int) -> int:
	return int(entry.get("quest_index", fallback_index))


func _has_more_quest_guide_pages(index: int) -> bool:
	if active_guide_kind != "quest":
		return false
	if index < 0 or index >= active_entries.size() - 1:
		return false
	var current_entry: Dictionary = active_entries[index]
	var next_entry: Dictionary = active_entries[index + 1]
	return _entry_quest_index(current_entry, index) == _entry_quest_index(next_entry, index + 1)


func _first_quest_guide_index(chapter_id: int, quest_index: int) -> int:
	var chapter_entries: Array = CHAPTER_QUEST_ENTRIES.get(chapter_id, [])
	for i in chapter_entries.size():
		var entry: Dictionary = chapter_entries[i]
		if _entry_quest_index(entry, i) == quest_index:
			return i
	return -1


func _quest_count(chapter_id: int) -> int:
	var chapter_entries: Array = CHAPTER_QUEST_ENTRIES.get(chapter_id, [])
	if chapter_entries.is_empty():
		return 0
	var max_quest_index := 0
	for i in chapter_entries.size():
		var entry: Dictionary = chapter_entries[i]
		max_quest_index = maxi(max_quest_index, _entry_quest_index(entry, i) + 1)
	return max_quest_index


func _sync_active_chapter_from_scene() -> void:
	if _is_on_chapter1_map():
		active_chapter_id = 1
	elif _is_on_chapter2_map():
		active_chapter_id = 2
	elif begins_on_chapter3_map:
		active_chapter_id = 3


func _open_next_chapter_quest_description(quest_index: int = -1) -> void:
	_sync_active_chapter_from_scene()
	var target_quest := quest_index if quest_index >= 0 else next_chapter_quest_to_describe
	next_chapter_quest_to_describe = target_quest
	_open_guide_for_quest(active_chapter_id, target_quest)


func _open_guide_for_quest(chapter_id: int, quest_index: int) -> void:
	var chapter_entries: Array = CHAPTER_QUEST_ENTRIES.get(chapter_id, [])
	if chapter_entries.is_empty():
		push_warning("story_guide: no quest guide entries for chapter %d" % chapter_id)
		return

	var quest_entries: Array = []
	for i in chapter_entries.size():
		var entry: Dictionary = chapter_entries[i]
		if _entry_quest_index(entry, i) == quest_index:
			quest_entries.append(entry)

	if quest_entries.is_empty():
		push_warning("story_guide: no guide pages for chapter %d quest %d" % [chapter_id, quest_index + 1])
		return

	_open_guide(quest_entries, "quest")


func _open_chapter_context(chapter_id: int) -> void:
	var context_entries: Array = CHAPTER_CONTEXT_ENTRIES.get(chapter_id, [])
	if context_entries.is_empty():
		_open_next_chapter_quest_description()
		return
	_open_guide(context_entries, "chapter_context")


func _restore_player_after_bridge_puzzle() -> void:
	if not get_tree().has_meta(QuestState.BRIDGE_RETURN_POSITION_META):
		return
	var saved_pos: Variant = get_tree().get_meta(QuestState.BRIDGE_RETURN_POSITION_META)
	get_tree().remove_meta(QuestState.BRIDGE_RETURN_POSITION_META)
	if saved_pos is not Vector2:
		return
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	player.global_position = saved_pos
	if player.get("target_position") != null:
		player.target_position = saved_pos


func _resolve_chapter1_square_nodes() -> void:
	_ch1_council_group = get_node_or_null("Arden_Steven_Villagers/ArdenStevenVillagersGroup") as Node2D
	_ch1_arden_square = get_node_or_null("Arden_Steven_Villagers/Arden") as Node2D
	_ch1_steven_square = get_node_or_null("Arden_Steven_Villagers/Steven") as Node2D
	_ch1_villagers_square = get_node_or_null("Arden_Steven_Villagers/Villagers") as Node2D


## Prevent Arden / Steven / Villagers / Council Group overlap per quest (restored from commit 80fc0ce).
func _refresh_chapter1_square_assembly_visibility() -> void:
	if not is_instance_valid(_ch1_arden_square):
		return

	var quest4_active := QuestState.quest3_complete and not QuestState.quest4_complete
	var show_council_group := quest4_active
	var show_arden_steven := QuestState.is_quest1_complete() and not quest4_active
	var show_villagers := (
		QuestState.is_quest2_complete()
		and QuestState.bridge_repaired
		and not quest4_active
	)

	if is_instance_valid(_ch1_council_group):
		_ch1_council_group.visible = show_council_group
		_ch1_set_branch_physics_enabled(_ch1_council_group, show_council_group)
	if is_instance_valid(_ch1_arden_square):
		_ch1_arden_square.visible = show_arden_steven
		_ch1_set_branch_physics_enabled(_ch1_arden_square, show_arden_steven)
	if is_instance_valid(_ch1_steven_square):
		_ch1_steven_square.visible = show_arden_steven
		_ch1_set_branch_physics_enabled(_ch1_steven_square, show_arden_steven)
	if is_instance_valid(_ch1_villagers_square):
		_ch1_villagers_square.visible = show_villagers
		_ch1_set_branch_physics_enabled(_ch1_villagers_square, show_villagers)


func _ch1_set_branch_physics_enabled(root: Node, enabled: bool) -> void:
	if root is CollisionObject2D:
		_ch1_set_one_collision_object(root as CollisionObject2D, enabled)
	for child in root.get_children():
		_ch1_set_branch_physics_enabled(child, enabled)


func _ch1_set_one_collision_object(co: CollisionObject2D, enabled: bool) -> void:
	var id := co.get_instance_id()
	if enabled:
		if not _ch1_collision_restore.has(id):
			return
		var saved: Dictionary = _ch1_collision_restore[id]
		co.collision_layer = saved["layer"]
		co.collision_mask = saved["mask"]
		if co is Area2D:
			var area := co as Area2D
			area.monitoring = saved["monitoring"]
			area.monitorable = saved["monitorable"]
	else:
		if not _ch1_collision_restore.has(id):
			var snap := {"layer": co.collision_layer, "mask": co.collision_mask}
			if co is Area2D:
				var area_snap := co as Area2D
				snap["monitoring"] = area_snap.monitoring
				snap["monitorable"] = area_snap.monitorable
			_ch1_collision_restore[id] = snap
		co.collision_layer = 0
		co.collision_mask = 0
		if co is Area2D:
			var area_off := co as Area2D
			area_off.monitoring = false
			area_off.monitorable = false


func _chapter1_quest2_completion_snap_value() -> bool:
	return (
		QuestState.is_quest2_complete()
		and QuestState.chapter1_quest2_completion_acknowledged
	)


func _ch1_poll_quest2_completion_panel() -> void:
	if not _is_on_chapter1_map() or not QuestState.chapter1_description_shown:
		return
	var quest2_done := QuestState.is_quest2_complete()
	if quest2_done and not _ch1_last_quest2_done:
		_queue_chapter1_quest2_completion_panel()
	elif not quest2_done:
		_ch1_last_quest2_done = false


func _queue_chapter1_quest2_completion_panel() -> void:
	if QuestState.chapter1_quest2_completion_acknowledged or not QuestState.is_quest2_complete():
		return
	_sync_active_chapter_from_scene()
	if active_chapter_id != 1:
		return
	_arm_quest_completion_prompt(1)
	pending_completion_prompt_index = 1
	current_chapter_quest_index = 1
	_ch1_last_quest2_done = true
	call_deferred("_flush_pending_story_flow_checks")


func _ch1_poll_quest_flags_for_square_visibility() -> void:
	if not is_instance_valid(_ch1_arden_square):
		return
	var quest1_done := QuestState.is_quest1_complete()
	var quest2_done := QuestState.is_quest2_complete()
	var quest2_snap := _chapter1_quest2_completion_snap_value()
	var quest3_done := QuestState.quest3_complete
	var quest4_done := QuestState.quest4_complete
	var quest5_done := QuestState.quest5_complete
	var bridge_repaired := QuestState.bridge_repaired
	if (
		quest1_done == _ch1_square_snap_quest1
		and quest2_snap == _ch1_square_snap_quest2
		and quest3_done == _ch1_square_snap_quest3
		and quest4_done == _ch1_square_snap_quest4
		and quest5_done == _ch1_square_snap_quest5
		and bridge_repaired == _ch1_square_snap_bridge_repaired
	):
		return
	if quest1_done and not _ch1_square_snap_quest1:
		_arm_quest_completion_prompt(0)
	if quest3_done and not _ch1_square_snap_quest3:
		_arm_quest_completion_prompt(2)
	if quest4_done and not _ch1_square_snap_quest4:
		_arm_quest_completion_prompt(3)
	if QuestState.quest5_complete and not _ch1_square_snap_quest5:
		_arm_quest_completion_prompt(4)
	_ch1_square_snap_quest1 = quest1_done
	_ch1_square_snap_quest2 = quest2_snap
	_ch1_square_snap_quest3 = quest3_done
	_ch1_square_snap_quest4 = quest4_done
	_ch1_square_snap_quest5 = quest5_done
	_ch1_square_snap_bridge_repaired = bridge_repaired
	_refresh_chapter1_square_assembly_visibility()


func _is_on_chapter2_map() -> bool:
	var scene := get_tree().current_scene
	if scene != null and scene.scene_file_path == CHAPTER_2_SCENE:
		return true
	return begins_on_chapter2_map


func _resolve_chapter2_cast_nodes() -> void:
	if not _is_on_chapter2_map():
		return
	_ch2_matt = get_node_or_null("Matt") as Node2D
	_ch2_kai = get_node_or_null("Kai") as Node2D
	_ch2_jessica = get_node_or_null("Jessica") as Node2D
	_ch2_fishing_villagers = get_node_or_null("FishingVillageResidents") as Node2D
	_ch2_matt_kai_villagers = get_node_or_null("MattKaiVillagers") as Node2D


func _refresh_chapter2_cast_visibility() -> void:
	if not _is_on_chapter2_map():
		return
	if not is_instance_valid(_ch2_matt) and not is_instance_valid(_ch2_matt_kai_villagers):
		_resolve_chapter2_cast_nodes()
	if not is_instance_valid(_ch2_matt) and not is_instance_valid(_ch2_matt_kai_villagers):
		return

	var quest5_done := QuestState.chapter2_quest5_cleanup_done
	var hide_quest1_to_3_cast := _ch2_should_hide_quest1_to_3_cast()

	var show_quests_1_to_3_cast := not hide_quest1_to_3_cast
	var show_quests_4_to_5_cast := hide_quest1_to_3_cast and not quest5_done
	var show_jessica := not quest5_done

	if is_instance_valid(_ch2_matt):
		_ch2_matt.visible = show_quests_1_to_3_cast
		_ch1_set_branch_physics_enabled(_ch2_matt, _ch2_matt.visible)
	if is_instance_valid(_ch2_kai):
		_ch2_kai.visible = show_quests_1_to_3_cast
		_ch1_set_branch_physics_enabled(_ch2_kai, _ch2_kai.visible)
	if is_instance_valid(_ch2_jessica):
		_ch2_jessica.visible = show_jessica
		_ch1_set_branch_physics_enabled(_ch2_jessica, _ch2_jessica.visible)
	if is_instance_valid(_ch2_fishing_villagers):
		_ch2_fishing_villagers.visible = show_quests_1_to_3_cast
		_ch1_set_branch_physics_enabled(_ch2_fishing_villagers, show_quests_1_to_3_cast)
	if is_instance_valid(_ch2_matt_kai_villagers):
		_ch2_matt_kai_villagers.visible = show_quests_4_to_5_cast
		_ch1_set_branch_physics_enabled(_ch2_matt_kai_villagers, show_quests_4_to_5_cast)


func _ch2_should_hide_quest1_to_3_cast() -> bool:
	if not QuestState.chapter2_quest3_warehouse_done:
		return false
	if _is_story_dialogue_active():
		return false
	if current_chapter_quest_index >= 3:
		return true
	if suppressed_completion_prompt_index >= 2:
		return true
	if pending_completion_prompt_index == 2:
		return false
	if current_chapter_quest_index == 2:
		return false
	return true


func _ch2_poll_quest_flags_for_cast_visibility() -> void:
	if not _is_on_chapter2_map():
		return
	if not is_instance_valid(_ch2_matt):
		return
	var quest1_done := QuestState.is_chapter2_quest1_complete()
	var quest2_done := QuestState.is_chapter2_quest2_complete()
	var quest3_done := QuestState.chapter2_quest3_warehouse_done
	var quest4_done := QuestState.chapter2_quest4_meeting_done
	var quest5_done := QuestState.chapter2_quest5_cleanup_done
	if (
		quest1_done == _ch2_snap_quest1_done
		and quest2_done == _ch2_snap_quest2_done
		and quest3_done == _ch2_snap_quest3_done
		and quest4_done == _ch2_snap_quest4_done
		and quest5_done == _ch2_snap_quest5_done
	):
		return
	if quest1_done and not _ch2_snap_quest1_done:
		_arm_quest_completion_prompt(0)
		if current_chapter_quest_index < 1:
			current_chapter_quest_index = 0
	if quest2_done and not _ch2_snap_quest2_done:
		_arm_quest_completion_prompt(1)
		if current_chapter_quest_index < 2:
			current_chapter_quest_index = 1
	if quest3_done and not _ch2_snap_quest3_done:
		_arm_quest_completion_prompt(2)
		if current_chapter_quest_index < 3:
			current_chapter_quest_index = 2
	if QuestState.chapter2_quest4_meeting_done and not _ch2_snap_quest4_done:
		_arm_quest_completion_prompt(3)
	if quest5_done and not _ch2_snap_quest5_done:
		_arm_quest_completion_prompt(4)
	_resolve_chapter2_cast_nodes()
	_ch2_snap_quest1_done = quest1_done
	_ch2_snap_quest2_done = quest2_done
	_ch2_snap_quest3_done = quest3_done
	_ch2_snap_quest4_done = quest4_done
	_ch2_snap_quest5_done = quest5_done
	_refresh_chapter2_cast_visibility()


func _open_chapter1_entry_flow() -> void:
	if not QuestState.chapter1_description_shown:
		_open_chapter_context(1)
		return
	if _should_defer_chapter1_auto_panel():
		return


func _should_defer_chapter1_auto_panel() -> bool:
	if QuestState.chapter1_summary_shown:
		return true
	if _should_show_chapter1_castle_gate():
		return true
	if QuestState.is_chapter1_complete() and _is_chapter1_castle_puzzle_complete():
		return true
	return false


# --- Quest completion vs dialogue (keep this block once; do not duplicate below) ---

func _on_story_dialogue_started(_resource: DialogueResource) -> void:
	_story_dialogue_sessions += 1


func _on_story_dialogue_ended(_resource: DialogueResource) -> void:
	_story_dialogue_sessions = maxi(0, _story_dialogue_sessions - 1)
	if _story_dialogue_sessions == 0:
		call_deferred("_flush_pending_story_flow_checks")


func _is_story_dialogue_active() -> bool:
	return _story_dialogue_sessions > 0


func _try_show_pending_quest_completion() -> bool:
	if is_guide_open or _is_story_dialogue_active():
		return false
	if pending_completion_prompt_index < 0:
		_recover_stuck_pause_without_guide()
		return false

	_sync_active_chapter_from_scene()
	var quest_index := pending_completion_prompt_index
	if active_chapter_id < 1:
		return false
	if not _is_chapter_quest_complete(active_chapter_id, quest_index):
		pending_completion_prompt_index = -1
		_recover_stuck_pause_without_guide()
		return false
	_arm_quest_completion_prompt(quest_index)
	if quest_index <= suppressed_completion_prompt_index:
		return false

	pending_completion_prompt_index = -1
	_open_quest_completion_confirmation(quest_index)
	return true


func _flush_pending_story_flow_checks() -> void:
	if _story_dialogue_sessions > 0:
		return
	if _try_show_pending_quest_completion():
		return
	if _handle_quest_completion_flow():
		return
	_handle_final_summary_flow()


func _is_ingame_settings_menu_open() -> bool:
	for path in ["CanvasLayer/SettingsMenu", "IngameSettings/SettingsMenu"]:
		var menu := get_node_or_null(path) as Control
		if menu != null and menu.visible:
			return true
	return false


func _recover_stuck_pause_without_guide() -> void:
	if not get_tree().paused:
		return
	if is_guide_open or _is_story_dialogue_active():
		return
	if _is_ingame_settings_menu_open():
		return
	get_tree().paused = false


func _reconcile_stray_pause() -> void:
	if is_guide_open or story_guide_layer.visible:
		return
	if _story_dialogue_sessions > 0:
		return
	if _is_ingame_settings_menu_open():
		return
	if get_tree().paused:
		get_tree().paused = false


func _handle_quest_completion_flow() -> bool:
	if active_chapter_id == 1 and not QuestState.chapter1_description_shown:
		return false
	if active_chapter_id == 2 and not QuestState.chapter2_description_shown:
		return false
	if active_chapter_id == 3 and not QuestState.chapter3_description_shown:
		return false
	if active_chapter_id == 1 and QuestState.is_chapter1_complete():
		if QuestState.chapter1_castle_gate_shown and not _is_chapter1_castle_puzzle_complete():
			return false
		if _should_show_chapter1_castle_gate() and not QuestState.chapter1_castle_gate_shown:
			return false
	if is_guide_open:
		return false

	var quest_index := _resolve_quest_index_for_completion_prompt()
	if quest_index < 0:
		return false
	if not _is_chapter_quest_complete(active_chapter_id, quest_index):
		return false
	if (
		active_chapter_id == 1
		and quest_index == 1
		and QuestState.chapter1_quest2_completion_acknowledged
	):
		return false
	if active_chapter_id == 1 and quest_index == 1 and pending_completion_prompt_index != 1:
		return false
	if quest_index <= suppressed_completion_prompt_index:
		return false

	pending_completion_prompt_index = quest_index
	current_chapter_quest_index = quest_index
	if _is_story_dialogue_active():
		return false
	_open_quest_completion_confirmation(quest_index)
	return true


func _acknowledge_quest_guide_started(quest_index: int) -> void:
	if quest_index < 0:
		return
	suppressed_completion_prompt_index = maxi(suppressed_completion_prompt_index, quest_index)


func _arm_quest_completion_prompt(quest_index: int) -> void:
	if quest_index < 0:
		return
	if suppressed_completion_prompt_index >= quest_index:
		suppressed_completion_prompt_index = quest_index - 1


func _resolve_quest_index_for_completion_prompt() -> int:
	if (
		current_chapter_quest_index >= 0
		and _is_chapter_quest_complete(active_chapter_id, current_chapter_quest_index)
	):
		return current_chapter_quest_index
	return _latest_completed_quest_index(active_chapter_id)


func _latest_completed_quest_index(chapter_id: int) -> int:
	var last_complete := -1
	var quest_total := _quest_count(chapter_id)
	for i in quest_total:
		if _is_chapter_quest_complete(chapter_id, i):
			last_complete = i
	return last_complete


func _handle_final_summary_flow() -> bool:
	if _is_chapter_summary_shown(active_chapter_id):
		return false
	if is_guide_open:
		return false
	if not _is_chapter_quest_complete(active_chapter_id, 4):
		return false
	if (
		next_chapter_quest_to_describe < _quest_count(active_chapter_id)
		and not _is_entire_chapter_complete(active_chapter_id)
	):
		return false

	if _should_show_chapter1_castle_gate():
		if QuestState.chapter1_castle_gate_shown:
			return false
		if not is_guide_open:
			_open_chapter1_castle_gate()
		return true

	_open_chapter_final_summary(active_chapter_id)
	return true


func _open_quest_completion_confirmation(quest_index: int) -> void:
	_sync_active_chapter_from_scene()
	_completion_prompt_quest_index = quest_index
	panel_mode = PanelMode.QUEST_COMPLETION_CONFIRMATION
	active_entries.clear()
	story_guide_layer.visible = true
	is_guide_open = true
	chapter_label.text = "Chapter %d - Quest Complete" % active_chapter_id
	title_label.text = "Quest %d finished!" % [quest_index + 1]
	if quest_index == _quest_count(active_chapter_id) - 1:
		description_label.text = "You completed the final quest in this chapter."
	else:
		description_label.text = "You completed Quest %d in this chapter.\n\nDo you want to move to the next quest?" % [quest_index + 1]
	page_label.text = ""
	if quest_index == _quest_count(active_chapter_id) - 1:
		next_button.text = "OK"
		alt_button.visible = false
	else:
		next_button.text = "Yes, next quest"
		alt_button.text = "Not now"
		alt_button.visible = true
	get_tree().paused = true


func _advance_after_quest_completion(completed_quest_index: int) -> void:
	if completed_quest_index < 0:
		return

	_sync_active_chapter_from_scene()
	if active_chapter_id == 1 and completed_quest_index == 1:
		QuestState.acknowledge_chapter1_quest2_completion()
		_ch1_square_snap_quest2 = _chapter1_quest2_completion_snap_value()
	suppressed_completion_prompt_index = completed_quest_index
	pending_completion_prompt_index = -1
	_completion_prompt_quest_index = -1

	var next_quest_index := completed_quest_index + 1
	if next_quest_index >= _quest_count(active_chapter_id):
		_close_guide_panel()
		return

	next_chapter_quest_to_describe = next_quest_index
	current_chapter_quest_index = next_quest_index

	if active_chapter_id == 2:
		_resolve_chapter2_cast_nodes()
		_refresh_chapter2_cast_visibility()

	_close_guide_panel()
	call_deferred("_open_guide_for_quest", active_chapter_id, next_quest_index)


func _open_chapter1_castle_gate() -> void:
	panel_mode = PanelMode.CHAPTER1_CASTLE_GATE
	active_guide_kind = ""
	final_summary_chapter_id = 1
	active_entries.clear()
	suppressed_completion_prompt_index = _quest_count(1) - 1
	pending_completion_prompt_index = -1
	story_guide_layer.visible = true
	is_guide_open = true
	chapter_label.text = CHAPTER1_CASTLE_GATE_SUMMARY["chapter"]
	title_label.text = CHAPTER1_CASTLE_GATE_SUMMARY["title"]
	description_label.text = CHAPTER1_CASTLE_GATE_SUMMARY["description"]
	page_label.text = ""
	next_button.text = "Go to the Castle"
	alt_button.visible = false
	get_tree().paused = true


func _dismiss_chapter1_castle_gate_panel() -> void:
	QuestState.chapter1_castle_gate_shown = true
	suppressed_completion_prompt_index = _quest_count(1) - 1
	pending_completion_prompt_index = -1
	story_guide_layer.visible = false
	is_guide_open = false
	panel_mode = PanelMode.GUIDE
	active_guide_kind = ""
	get_tree().paused = false
	if _is_chapter1_castle_puzzle_complete():
		call_deferred("_open_chapter_final_summary", 1)


func _is_on_chapter1_map() -> bool:
	var scene := get_tree().current_scene
	if scene != null and scene.scene_file_path == CHAPTER_1_SCENE:
		return true
	return begins_on_chapter1_map


func _should_show_chapter1_castle_gate() -> bool:
	return (
		active_chapter_id == 1
		and _is_on_chapter1_map()
		and REQUIRE_CHAPTER_1_CASTLE_PUZZLE
		and QuestState.is_chapter1_complete()
		and not _is_chapter1_castle_puzzle_complete()
	)


func _is_chapter1_castle_puzzle_complete() -> bool:
	return QuestState.is_chapter1_castle_puzzle_complete()


func _open_chapter_final_summary(chapter_id: int) -> void:
	if chapter_id == 1 and _should_show_chapter1_castle_gate():
		_open_chapter1_castle_gate()
		return

	panel_mode = PanelMode.CHAPTER_FINAL_SUMMARY
	final_summary_chapter_id = chapter_id
	var educational_entries: Array = CHAPTER_EDUCATIONAL_ENTRIES.get(chapter_id, [])
	if not educational_entries.is_empty():
		_open_guide(educational_entries, "chapter_educational")
		return

	active_entries.clear()
	story_guide_layer.visible = true
	is_guide_open = true
	if chapter_id == 1:
		chapter_label.text = "Chapter 1 Complete!"
		title_label.text = "Clear Stream Valley completed"
		description_label.text = "You finished all Chapter 1 quests and helped the village reach a shared water solution.\n\nLearning points: fair sharing, listening to different viewpoints, and collaboration between traditional wisdom and modern solutions."
	elif chapter_id == 2:
		chapter_label.text = "Chapter 2 Complete!"
		title_label.text = "Seabreeze Village completed"
		description_label.text = "You completed all Chapter 2 quests and helped villagers set up signs, take oaths, and consolidate ocean protection results.\n\nFinal result: improved environment and coexistence of tradition and innovation."
	else:
		chapter_label.text = "Chapter 3 Complete!"
		title_label.text = "Star & Moon Town completed"
		description_label.text = "You completed all Chapter 3 quests and supported inclusive collaboration across cultures.\n\nLearning points: respect differences, listen deeply, and build unity through dialogue."
	page_label.text = ""
	next_button.text = "Continue Journey"
	alt_button.visible = false
	get_tree().paused = true


func _is_entire_chapter_complete(chapter_id: int) -> bool:
	match chapter_id:
		1:
			return QuestState.is_chapter1_complete()
		2:
			return QuestState.is_chapter2_complete()
		3:
			return QuestState.is_chapter3_complete()
		_:
			return false


func _is_chapter_quest_complete(chapter_id: int, quest_index: int) -> bool:
	if chapter_id == 1:
		match quest_index:
			0:
				return QuestState.is_quest1_complete()
			1:
				return QuestState.is_quest2_complete()
			2:
				return QuestState.quest3_complete
			3:
				return QuestState.quest4_complete
			4:
				return QuestState.quest5_complete
			_:
				return false
	if chapter_id == 2:
		match quest_index:
			0:
				return QuestState.is_chapter2_quest1_complete()
			1:
				return QuestState.is_chapter2_quest2_complete()
			2:
				return QuestState.chapter2_quest3_warehouse_done
			3:
				return QuestState.chapter2_quest4_meeting_done
			4:
				return QuestState.chapter2_quest5_cleanup_done
			_:
				return false
	match quest_index:
		0:
			return QuestState.is_chapter3_quest1_complete()
		1:
			return QuestState.chapter3_quest2_home_visits_done
		2:
			return QuestState.chapter3_quest3_festival_setup_done
		3:
			return QuestState.chapter3_quest4_town_dialogue_done
		4:
			return QuestState.chapter3_quest5_celebration_done
		_:
			return false


func _set_chapter_confirmation_shown(chapter_id: int) -> void:
	if chapter_id == 1:
		chapter1_confirmation_shown = true
	elif chapter_id == 2:
		chapter2_confirmation_shown = true
	else:
		chapter3_confirmation_shown = true


func _set_chapter_description_shown(chapter_id: int) -> void:
	if chapter_id == 1:
		QuestState.chapter1_description_shown = true
	elif chapter_id == 2:
		QuestState.chapter2_description_shown = true
	else:
		QuestState.chapter3_description_shown = true


func _mark_chapter_summary_shown(chapter_id: int) -> void:
	if chapter_id == 1:
		QuestState.chapter1_summary_shown = true
	elif chapter_id == 2:
		QuestState.chapter2_summary_shown = true
	elif chapter_id == 3:
		QuestState.chapter3_summary_shown = true


func _is_chapter_summary_shown(chapter_id: int) -> bool:
	if chapter_id == 1:
		return QuestState.chapter1_summary_shown
	if chapter_id == 2:
		return QuestState.chapter2_summary_shown
	return QuestState.chapter3_summary_shown


func _resolve_chapter_flow_target(chapter_id: int) -> int:
	var target := chapter_id
	if target == 1 and SKIP_CHAPTER_1_FROM_CHAPTER_0:
		_mark_chapter_1_complete_for_skip()
		target = 2
	if target == 2 and SKIP_CHAPTER_2_FROM_CHAPTER_1:
		_mark_chapter_2_complete_for_skip()
		target = 3
	return target


## Quick test: skip 5 Ch1 quests and keep only the castle-panel -> puzzle flow (see SKIP_CHAPTER_1_QUESTS_TO_CASTLE_TEST).
func _apply_skip_chapter1_quests_to_castle_test() -> void:
	QuestState.quest1_maggie_done = true
	QuestState.quest1_kai_done = true
	QuestState.quest1_jessica_done = true
	QuestState.quest2_arden_done = true
	QuestState.quest2_steven_done = true
	QuestState.quest2_aurora_done = true
	QuestState.acknowledge_chapter1_quest2_completion()
	QuestState.quest3_complete = true
	QuestState.quest4_complete = true
	QuestState.quest5_complete = true
	QuestState.chapter1_description_shown = true
	QuestState.chapter1_castle_gate_shown = false
	QuestState.chapter1_summary_shown = false
	chapter0_guide_closed = true
	chapter1_confirmation_shown = true
	active_chapter_id = 1
	next_chapter_quest_to_describe = _quest_count(1)
	suppressed_completion_prompt_index = _quest_count(1) - 1
	current_chapter_quest_index = -1
	pending_completion_prompt_index = -1
	_refresh_chapter1_square_assembly_visibility()
	_ch1_square_snap_quest1 = QuestState.is_quest1_complete()
	_ch1_last_quest2_done = QuestState.is_quest2_complete()
	_ch1_square_snap_quest2 = _chapter1_quest2_completion_snap_value()
	_ch1_square_snap_quest3 = QuestState.quest3_complete
	_ch1_square_snap_quest4 = QuestState.quest4_complete


func _mark_chapter_1_complete_for_skip() -> void:
	QuestState.quest1_maggie_done = true
	QuestState.quest1_kai_done = true
	QuestState.quest1_jessica_done = true
	QuestState.quest2_arden_done = true
	QuestState.quest2_steven_done = true
	QuestState.quest2_aurora_done = true
	QuestState.acknowledge_chapter1_quest2_completion()
	QuestState.quest3_complete = true
	QuestState.quest4_complete = true
	QuestState.quest5_complete = true
	QuestState.chapter1_description_shown = true
	QuestState.chapter1_castle_gate_shown = true
	QuestState.chapter1_summary_shown = true
	QuestState.mark_chapter1_castle_puzzle_complete()
	chapter1_confirmation_shown = true


func _mark_chapter_2_complete_for_skip() -> void:
	QuestState.chapter2_beach_cleanup_started = true
	QuestState.chapter2_beach_cleanup_done = true
	QuestState.chapter2_quest1_matt_done = true
	QuestState.chapter2_quest1_kai_done = true
	QuestState.chapter2_quest3_warehouse_done = true
	QuestState.chapter2_quest4_meeting_done = true
	QuestState.chapter2_sign_assembled = true
	QuestState.chapter2_quest5_cleanup_done = true
	QuestState.chapter2_description_shown = true
	QuestState.chapter2_summary_shown = true
	chapter2_confirmation_shown = true


func _return_to_main_menu() -> void:
	story_guide_layer.visible = false
	is_guide_open = false
	panel_mode = PanelMode.GUIDE
	active_guide_kind = ""
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU_SCENE)


func _start_chapter_flow(chapter_id: int) -> void:
	_set_chapter_confirmation_shown(chapter_id)
	active_chapter_id = chapter_id
	next_chapter_quest_to_describe = 0
	get_tree().paused = false
	if chapter_id == 1:
		get_tree().change_scene_to_file(CHAPTER_1_SCENE)
		return
	if chapter_id == 2:
		get_tree().change_scene_to_file(CHAPTER_2_SCENE)
		return
	if chapter_id == 3:
		get_tree().change_scene_to_file(CHAPTER_3_SCENE)
		return
	_open_chapter_context(chapter_id)
