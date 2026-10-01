extends CanvasLayer

## Quest Log UI
## A small always-on panel on the left side of the screen that shows ONLY the
## objective the player is currently working on.
##
## The objective text is derived from QuestMarkerManager._steps, which is
## already the single source of truth for "what should I do next". The same
## step that drives the floating arrow drives this panel, so the two can
## never disagree.
##
## Registered as an autoload; builds its own contents in code.

const PANEL_WIDTH := 232.0
const PANEL_MIN_HEIGHT := 74.0
const MARGIN := 12
const REFRESH_INTERVAL := 0.2

const BG_COLOR := Color(0.05, 0.06, 0.08, 0.72)
const BORDER_COLOR := Color(0.85, 0.72, 0.30, 0.85)
const TITLE_COLOR := Color(0.92, 0.86, 0.62, 1.0)
const TEXT_COLOR := Color(0.96, 0.96, 0.96, 1.0)
const DONE_COLOR := Color(0.58, 0.62, 0.66, 1.0)

## Human readable English text for every target path used by
## QuestMarkerManager. Keys are the raw target strings from _steps.
const OBJECTIVE_TEXT := {
    "Traveller": "Talk to the Traveller",
    "Family": "Talk to your Family",
    "Adele": "Talk to Adele",
    "Maggie": "Talk to Maggie",
    "Kai": "Talk to Kai",
    "Jessica": "Talk to Jessica",
    "Arden_Steven_Villagers/Arden": "Talk to Arden",
    "Arden_Steven_Villagers/Steven": "Talk to Steven",
    "Aurora": "Talk to Aurora",
    "BridgeRepairTrigger": "Repair the broken bridge",
    "Arden_Steven_Villagers/Villagers": "Gather the villagers",
    "Arden_Steven_Villagers/ArdenStevenVillagersGroup": "Meet Arden, Steven and the villagers",
    "CastlePuzzleTrigger": "Solve the castle puzzle",
    "Matt": "Talk to Matt",
    "MattKaiVillagers": "Meet Matt, Kai and the villagers",
    "BeachCleanupPuzzle": "Finish the beach cleanup",
    "Advaita": "Talk to Advaita",
    "Sarina": "Talk to Sarina",
    "StarMoonCouncilGroup": "Meet the Star Moon Council",
}

var _panel: PanelContainer
var _objective_label: Label
var _progress_label: Label
var _last_objective := ""
var _last_progress := ""
var _refresh_timer := 0.0


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    layer = 95
    _build_ui()


func _build_ui() -> void:
    _panel = PanelContainer.new()
    _panel.name = "QuestLogPanel"
    _panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _panel.anchor_left = 0.0
    _panel.anchor_top = 0.5
    _panel.anchor_right = 0.0
    _panel.anchor_bottom = 0.5
    _panel.offset_left = 16.0
    _panel.offset_top = -PANEL_MIN_HEIGHT * 0.5
    _panel.offset_right = 16.0 + PANEL_WIDTH
    _panel.offset_bottom = PANEL_MIN_HEIGHT * 0.5
    _panel.grow_vertical = Control.GROW_DIRECTION_BOTH

    var style := StyleBoxFlat.new()
    style.bg_color = BG_COLOR
    style.border_color = BORDER_COLOR
    style.border_width_left = 3
    style.border_width_top = 1
    style.border_width_right = 1
    style.border_width_bottom = 1
    style.corner_radius_top_left = 6
    style.corner_radius_top_right = 6
    style.corner_radius_bottom_right = 6
    style.corner_radius_bottom_left = 6
    style.content_margin_left = 12.0
    style.content_margin_top = 10.0
    style.content_margin_right = 12.0
    style.content_margin_bottom = 10.0
    _panel.add_theme_stylebox_override("panel", style)
    add_child(_panel)

    var vbox := VBoxContainer.new()
    vbox.name = "Content"
    vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
    vbox.add_theme_constant_override("separation", 6)
    _panel.add_child(vbox)

    var title := Label.new()
    title.name = "Title"
    title.text = "CURRENT OBJECTIVE"
    title.mouse_filter = Control.MOUSE_FILTER_IGNORE
    title.add_theme_font_size_override("font_size", 11)
    title.add_theme_color_override("font_color", TITLE_COLOR)
    vbox.add_child(title)

    var separator := HSeparator.new()
    separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
    vbox.add_child(separator)

    _objective_label = Label.new()
    _objective_label.name = "Objective"
    _objective_label.text = "..."
    _objective_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _objective_label.custom_minimum_size = Vector2(PANEL_WIDTH - MARGIN * 2, 0)
    _objective_label.add_theme_font_size_override("font_size", 14)
    _objective_label.add_theme_color_override("font_color", TEXT_COLOR)
    vbox.add_child(_objective_label)

    _progress_label = Label.new()
    _progress_label.name = "Progress"
    _progress_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _progress_label.add_theme_font_size_override("font_size", 11)
    _progress_label.add_theme_color_override("font_color", DONE_COLOR)
    _progress_label.visible = false
    vbox.add_child(_progress_label)


func _process(delta: float) -> void:
    _refresh_timer += delta
    if _refresh_timer < REFRESH_INTERVAL:
        return
    _refresh_timer = 0.0
    _refresh()


func _refresh() -> void:
    if _objective_label == null:
        return

    var step := _current_step()
    if step.is_empty():
        _panel.visible = false
        _last_objective = ""
        _last_progress = ""
        return

    _panel.visible = true

    var targets: Array = step.get("targets", [])
    var objective := _objective_for(targets)
    var progress := _progress_for(targets)

    if objective != _last_objective:
        _objective_label.text = objective
        _last_objective = objective
    if progress != _last_progress:
        _progress_label.text = progress
        _progress_label.visible = not progress.is_empty()
        _last_progress = progress


## Mirrors QuestMarkerManager._current_targets(): the first unfinished step
## belonging to the scene that is currently loaded.
func _current_step() -> Dictionary:
    var scene := get_tree().current_scene
    if scene == null:
        return {}
    var scene_path := scene.scene_file_path
    if scene_path.is_empty():
        return {}

    var manager := get_node_or_null("/root/QuestMarkerManager")
    if manager == null:
        return {}
    var steps = manager.get("_steps")
    if steps == null:
        return {}

    for step in steps:
        if not (step is Dictionary):
            continue
        if String(step.get("scene", "")) != scene_path:
            continue
        var done_callable = step.get("done")
        if done_callable is Callable and (done_callable as Callable).is_valid():
            if (done_callable as Callable).call():
                continue
        return step
    return {}


## Builds the objective line. A multi-target step lists every remaining
## target on its own line, e.g.
##     Talk to Maggie
##     Talk to Kai
func _objective_for(targets: Array) -> String:
    var lines: Array = []
    for target in targets:
        var key := String(target)
        if OBJECTIVE_TEXT.has(key):
            lines.append(OBJECTIVE_TEXT[key])
        else:
            lines.append(key)
    if lines.is_empty():
        return "Explore the area"
    return "\n".join(PackedStringArray(lines))


## For multi-target steps, show how many are already handled, e.g. "1 / 3 done".
func _progress_for(targets: Array) -> String:
    if targets.size() <= 1:
        return ""
    var remaining := 0
    for target in targets:
        if not _target_resolved(String(target)):
            remaining += 1
    if remaining == 0:
        return ""
    var finished := targets.size() - remaining
    return "%d / %d done" % [finished, targets.size()]


## A target counts as resolved when its node is gone or hidden, which is how
## the existing quest scripts mark "this NPC has been dealt with".
func _target_resolved(target_path: String) -> bool:
    var scene := get_tree().current_scene
    if scene == null:
        return false
    var node := scene.get_node_or_null(NodePath(target_path))
    if node == null:
        return true
    if node is CanvasItem and not (node as CanvasItem).is_visible_in_tree():
        return true
    return false
