# Minimap Feature Implementation Guide

## Status and purpose

This document describes the player-centred objective minimap originally implemented in commit `031c58a` (`feat: add objective minimap and improve settings menu`). That combined commit was reverted by `d94006e`; the minimap-specific code was subsequently reintroduced without the unrelated settings-menu changes. The guide records the active design, core scripts, scene wiring, objective keys, and reasoning needed to maintain or adapt the feature.

The feature was intentionally a navigational HUD rather than a geographic map. It displayed a fixed black panel in the top-right corner, kept the player represented by a cyan dot at the centre, and showed active quest objectives as yellow dots. Nearby dots moved relative to the player. Objectives beyond the visible map range were clamped to the panel edge while retaining their direction, allowing the player to navigate toward distant targets without showing the entire world.

## Architecture

The implementation separated rendering, world markers, and quest progression into three small responsibilities:

1. `Minimap.tscn` and `minimap.gd` owned the HUD panel, world-to-map conversion, drawing, and edge clamping.
2. `MinimapObjective.tscn` and `minimap_objective.gd` marked a world object as a possible point of interest and supplied a stable objective key.
3. `QuestState.is_minimap_objective_active()` decided whether a key represented a currently active, unfinished objective.

The gameplay chapter scenes only needed to instantiate the HUD once and attach marker components to relevant NPCs or interactables. This avoided placing chapter-specific progression logic inside the minimap renderer.

```text
Gameplay scene
├── Player (member of the "player" group)
├── MinimapLayer (instance of Minimap.tscn)
└── NPC / trigger / collectible
    └── MinimapObjective (member of the "minimap_objective" group)
        └── objective_key = "ch1_bridge"

Minimap
├── finds the player through the "player" group
├── finds all markers through the "minimap_objective" group
├── asks QuestState whether each marker is active
└── draws active markers relative to the player
```

## HUD scene

The reusable HUD scene was stored at `res://Scenes/ui/Minimap.tscn`:

```gdscript
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://Scripts/ui/minimap.gd" id="1_minimap"]

[node name="MinimapLayer" type="CanvasLayer"]
layer = 90

[node name="Minimap" type="Control" parent="."]
layout_mode = 3
anchors_preset = 1
anchor_left = 1.0
anchor_right = 1.0
offset_left = -196.0
offset_top = 16.0
offset_right = -16.0
offset_bottom = 156.0
grow_horizontal = 0
mouse_filter = 2
script = ExtResource("1_minimap")
```

These anchors and offsets produce a `180 × 140` panel:

- The right edge is always 16 pixels from the viewport's right edge.
- The top edge is always 16 pixels from the viewport's top edge.
- `CanvasLayer` keeps the panel in screen space instead of world space.
- Layer `90` places it above the world while leaving room for higher-priority overlays, such as the story guide at layer `100`.
- `mouse_filter = 2` is Godot's `MOUSE_FILTER_IGNORE`, so the map cannot consume clicks intended for the game or menus.

Anchoring to the right side instead of assigning a fixed absolute position prevents the map from drifting or overflowing when the window size changes.

## Minimap renderer

The complete renderer was stored at `res://Scripts/ui/minimap.gd`:

```gdscript
extends Control

@export var world_scale := 0.11
@export var background_color := Color(0.015, 0.02, 0.025, 0.92)
@export var border_color := Color(0.72, 0.78, 0.82, 0.9)
@export var player_color := Color(0.1, 0.9, 1.0, 1.0)
@export var objective_color := Color(1.0, 0.78, 0.12, 1.0)
@export var player_radius := 6.0
@export var objective_radius := 5.0
@export var border_width := 2.0
@export var edge_inset := 8.0

var _player: Node2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	_resolve_player()
	queue_redraw()


func _process(_delta: float) -> void:
	if not is_instance_valid(_player):
		_resolve_player()
	queue_redraw()


func _resolve_player() -> void:
	_player = get_tree().get_first_node_in_group("player") as Node2D


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), background_color, true)
	draw_rect(Rect2(Vector2.ZERO, size), border_color, false, border_width)
	if not is_instance_valid(_player):
		return

	var center := size * 0.5
	for marker_node in get_tree().get_nodes_in_group("minimap_objective"):
		var marker := marker_node as Node2D
		if marker == null or not marker.is_visible_in_tree():
			continue
		var key: StringName = marker.get("objective_key")
		if key.is_empty() or not QuestState.is_minimap_objective_active(key):
			continue
		var color: Color = marker.get("marker_color")
		if color == Color.WHITE:
			color = objective_color
		draw_circle(center + _map_offset(marker.global_position), objective_radius, color)

	draw_circle(center, player_radius, player_color)


func _map_offset(world_position: Vector2) -> Vector2:
	var offset := (world_position - _player.global_position) * world_scale
	var bounds := size * 0.5 - Vector2.ONE * edge_inset
	var clamp_scale := 1.0
	if absf(offset.x) > bounds.x:
		clamp_scale = minf(clamp_scale, bounds.x / absf(offset.x))
	if absf(offset.y) > bounds.y:
		clamp_scale = minf(clamp_scale, bounds.y / absf(offset.y))
	return offset * clamp_scale
```

### Player resolution and lifecycle

The renderer searches for the first node in the existing `player` group instead of relying on a scene-specific node path:

```gdscript
func _resolve_player() -> void:
	_player = get_tree().get_first_node_in_group("player") as Node2D
```

That choice made the minimap reusable in all four chapter scenes even though their player nodes were not necessarily named identically. The validity check in `_process()` also allowed the minimap to recover if the player was freed and recreated:

```gdscript
if not is_instance_valid(_player):
	_resolve_player()
```

If no player exists yet, `_draw()` still draws the panel and border, then exits safely. There is no hard failure during scene setup.

### Frame-by-frame drawing

The panel calls `queue_redraw()` every frame. Godot then invokes `_draw()` and recomputes each dot from current global positions. This keeps movement smooth and avoids signals or state synchronization for ordinary character movement.

The cost is small because the map draws only rectangles and circles and iterates over a limited group of quest markers. If a future chapter contains hundreds of markers, redraws could instead be triggered by movement or quest-state changes, but that added complexity was not warranted for the current game.

`PROCESS_MODE_ALWAYS` permits the HUD to redraw while the tree is paused. It does not move the world; it simply keeps the HUD visually valid while pause/settings overlays are open.

### World-to-map scale

The relative position is calculated with:

```gdscript
var offset := (world_position - _player.global_position) * world_scale
```

Subtracting the player's global position makes the player the origin. The player dot is therefore always drawn at `size * 0.5`, while the world appears to move around it.

The initial `world_scale` was `0.11`. A 180-pixel-wide panel has about 164 usable pixels after the 8-pixel inset on both sides. At that scale, the panel spans roughly 1,490 world pixels horizontally and 1,127 world pixels vertically:

```text
visible world width  ≈ (180 - 16) / 0.11 ≈ 1491 pixels
visible world height ≈ (140 - 16) / 0.11 ≈ 1127 pixels
```

This gives a local navigational view instead of a zoomed-out overview of the entire chapter.

### Direction-preserving edge clamping

The key navigation behavior is implemented in `_map_offset()`. A naïve approach would clamp X and Y independently:

```gdscript
# Not used: this changes the direction of many points.
offset.x = clampf(offset.x, -bounds.x, bounds.x)
offset.y = clampf(offset.y, -bounds.y, bounds.y)
```

Independent clamping can distort the direction to the objective. For example, a marker far to the right and slightly upward can be pushed toward a corner even when it should remain close to the middle of the right edge.

Instead, the implementation computes one scalar and multiplies the entire vector by it:

```gdscript
var clamp_scale := 1.0
if absf(offset.x) > bounds.x:
	clamp_scale = minf(clamp_scale, bounds.x / absf(offset.x))
if absf(offset.y) > bounds.y:
	clamp_scale = minf(clamp_scale, bounds.y / absf(offset.y))
return offset * clamp_scale
```

This is a ray-to-rectangle intersection. The ray begins at the map centre and points toward the objective. Whichever panel boundary is encountered first determines the scale. Because both coordinates are multiplied by the same value, the direction and X:Y ratio remain unchanged.

For example, assume a usable half-width of 82, a usable half-height of 62, and a scaled objective offset of `(200, 50)`:

```text
X boundary scale = 82 / 200 = 0.41
Y is already within bounds, so the final scale is 0.41
clamped offset = (200, 50) × 0.41 = (82, 20.5)
```

The marker sits on the right edge but remains slightly below or above the horizontal centre according to its real direction. As the player approaches, the unscaled point eventually fits within both bounds and begins moving naturally inside the panel.

The `edge_inset` keeps each dot's centre away from the border. It was set to 8 pixels, which is larger than the default 5-pixel objective radius.

## Objective marker component

The reusable marker scene was deliberately minimal:

```gdscript
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://Scripts/ui/minimap_objective.gd" id="1_marker"]

[node name="MinimapObjective" type="Node2D"]
script = ExtResource("1_marker")
```

Its complete script was:

```gdscript
extends Node2D

## Stable key used by QuestState to decide whether this objective belongs on the map.
@export var objective_key: StringName
## Leave white to use the minimap's default objective colour.
@export var marker_color: Color = Color.WHITE
## Optional visual anchor relative to the objective root.
@export var position_source: NodePath

const INTERACTION_ANCHORS: Array[NodePath] = [
	^"Actionable2/CollisionShape2D",
	^"Actionable/CollisionShape2D",
	^"InteractionCollision",
	^"CollisionShape2D",
]


func _ready() -> void:
	add_to_group("minimap_objective")
	_align_with_objective()


func _align_with_objective() -> void:
	var objective_root := get_parent()
	if objective_root == null:
		return
	var anchor: Node2D
	if not position_source.is_empty():
		anchor = objective_root.get_node_or_null(position_source) as Node2D
	else:
		for candidate in INTERACTION_ANCHORS:
			anchor = objective_root.get_node_or_null(candidate) as Node2D
			if anchor != null:
				break
	if anchor != null:
		global_position = anchor.global_position
```

### Stable objective keys

The exported `StringName` linked a physical world marker to progression logic. A key such as `ch2_q3_kai` expresses chapter, quest, and target without coupling the renderer to a node name or scene path.

`StringName` was used instead of a regular `String` because Godot optimizes repeated identifier comparisons. More importantly, the stable key remains meaningful if an NPC node is renamed or moved within the scene tree.

### Optional marker colours

`Color.WHITE` was treated as a sentinel meaning “use the minimap's exported default objective colour.” A marker could override that default simply by setting `marker_color` in the inspector:

```gdscript
marker_color = Color(1.0, 0.25, 0.25, 1.0)
```

No chapter required an override in the original implementation, but the interface supported future objective categories without changing the renderer.

### Correcting slightly offset points of interest

Many NPC and trigger scenes have their root node at an organizational origin rather than at the actual interaction location. Drawing the root's `global_position` made some dots appear slightly offset.

The marker corrected this by looking for likely interaction anchors under its parent, in priority order:

```gdscript
const INTERACTION_ANCHORS: Array[NodePath] = [
	^"Actionable2/CollisionShape2D",
	^"Actionable/CollisionShape2D",
	^"InteractionCollision",
	^"CollisionShape2D",
]
```

When a matching `Node2D` was found, the marker copied that node's global position once during `_ready()`. For unusual scene structures, `position_source` provided an explicit relative path. The bridge used this override:

```gdscript
[node name="MinimapObjective" parent="BridgeRepairTrigger" instance=ExtResource("17_marker")]
objective_key = &"ch1_bridge"
position_source = NodePath("WarningIcon")
```

Keeping alignment in the marker component avoided hard-coded offsets in the shared renderer and kept each exception close to the affected scene object.

## Quest progression filter

`QuestState` was the sole authority for deciding whether a marker was active. This prevented marker scenes from duplicating quest rules and guaranteed that all markers reacted to the same completion flags already used by the game.

The method added to `res://Scripts/quest_state.gd` was:

```gdscript
func is_minimap_objective_active(objective_key: StringName) -> bool:
	match objective_key:
		&"ch0_traveller":
			return not chapter0_traveler_done
		&"ch0_family":
			return chapter0_traveler_done and not chapter0_family_done
		&"ch0_friend":
			return chapter0_traveler_done and not chapter0_friend_done
		&"ch1_q1_maggie":
			return not is_quest1_complete() and not quest1_maggie_done
		&"ch1_q1_kai":
			return not is_quest1_complete() and not quest1_kai_done
		&"ch1_q1_jessica":
			return not is_quest1_complete() and not quest1_jessica_done
		&"ch1_q2_arden":
			return is_quest1_complete() and not is_quest2_complete() and not quest2_arden_done
		&"ch1_q2_steven":
			return is_quest1_complete() and not is_quest2_complete() and not quest2_steven_done
		&"ch1_q2_aurora":
			return is_quest1_complete() and not is_quest2_complete() and not quest2_aurora_done
		&"ch1_bridge":
			return needs_chapter1_bridge_repair()
		&"ch1_q3_villagers":
			return is_quest2_complete() and bridge_repaired and not quest3_complete
		&"ch1_q4_council":
			return quest3_complete and not quest4_complete
		&"ch1_q5_villagers":
			return quest4_complete and not quest5_complete
		&"ch1_castle":
			return is_chapter1_complete() and not is_chapter1_castle_puzzle_complete()
		&"ch2_q1_jessica":
			return not chapter2_beach_cleanup_started and not chapter2_beach_cleanup_done
		&"ch2_q1_trash":
			return chapter2_beach_cleanup_started and not chapter2_beach_cleanup_done
		&"ch2_q2_matt":
			return is_chapter2_quest1_complete() and not is_chapter2_quest2_complete()
		&"ch2_q3_matt":
			return is_chapter2_quest2_complete() and not chapter2_quest3_warehouse_done and not chapter2_quest3_matt_done
		&"ch2_q3_kai":
			return is_chapter2_quest2_complete() and not chapter2_quest3_warehouse_done and not chapter2_quest3_kai_done
		&"ch2_q4_group":
			return chapter2_quest3_warehouse_done and not chapter2_quest4_meeting_done
		&"ch2_q5_sign":
			return chapter2_quest4_meeting_done and not chapter2_sign_assembled and not chapter2_quest5_cleanup_done
		&"ch3_q1_advaita":
			return not is_chapter3_quest1_complete() and not chapter3_quest1_advaita_done
		&"ch3_q1_sarina":
			return not is_chapter3_quest1_complete() and not chapter3_quest1_sarina_done
		&"ch3_q1_aurora":
			return not is_chapter3_quest1_complete() and not chapter3_quest1_aurora_done
		&"ch3_q2_advaita":
			return is_chapter3_quest1_complete() and not chapter3_quest2_home_visits_done and not chapter3_quest2_advaita_done
		&"ch3_q2_sarina":
			return is_chapter3_quest1_complete() and not chapter3_quest2_home_visits_done and not chapter3_quest2_sarina_done
		&"ch3_q2_aurora":
			return is_chapter3_quest1_complete() and not chapter3_quest2_home_visits_done and not chapter3_quest2_aurora_done
		&"ch3_q3_council":
			return chapter3_quest2_home_visits_done and not chapter3_quest3_festival_setup_done
		&"ch3_q4_council":
			return chapter3_quest3_festival_setup_done and not chapter3_quest4_town_dialogue_done
		&"ch3_q5_celebration":
			return chapter3_quest4_town_dialogue_done and not chapter3_quest5_celebration_done
		_:
			return false
```

Unknown or misspelled keys return `false`, which fails safely by hiding the marker. Multiple keys can return `true` simultaneously, so quests involving several NPCs or pieces of trash naturally display several dots at once.

### Objective key summary

| Chapter | Keys | Meaning |
| --- | --- | --- |
| 0 | `ch0_traveller`, `ch0_family`, `ch0_friend` | Introductory conversations, unlocked in the required sequence |
| 1 | `ch1_q1_maggie`, `ch1_q1_kai`, `ch1_q1_jessica` | First set of NPC conversations |
| 1 | `ch1_q2_arden`, `ch1_q2_steven`, `ch1_q2_aurora` | Second set of NPC conversations |
| 1 | `ch1_bridge` | Bridge repair trigger |
| 1 | `ch1_q3_villagers`, `ch1_q4_council`, `ch1_q5_villagers` | Later village and council interactions |
| 1 | `ch1_castle` | Castle puzzle trigger after chapter completion |
| 2 | `ch2_q1_jessica`, `ch2_q1_trash` | Beach-cleanup introduction and remaining trash items |
| 2 | `ch2_q2_matt`, `ch2_q3_matt`, `ch2_q3_kai` | Matt and Kai quest stages |
| 2 | `ch2_q4_group`, `ch2_q5_sign` | Group meeting and sign assembly |
| 3 | `ch3_q1_advaita`, `ch3_q1_sarina`, `ch3_q1_aurora` | First household interactions |
| 3 | `ch3_q2_advaita`, `ch3_q2_sarina`, `ch3_q2_aurora` | Follow-up home visits |
| 3 | `ch3_q3_council`, `ch3_q4_council`, `ch3_q5_celebration` | Council, preparation, and celebration stages |

## Scene integration

Each gameplay chapter imported the two reusable scenes:

```gdscript
[ext_resource type="PackedScene" path="res://Scenes/ui/Minimap.tscn" id="18_minimap"]
[ext_resource type="PackedScene" path="res://Scenes/ui/MinimapObjective.tscn" id="19_marker"]
```

The HUD itself was instantiated once under the chapter root:

```gdscript
[node name="MinimapLayer" parent="." instance=ExtResource("18_minimap")]
```

A marker was then added as a child of each relevant world object:

```gdscript
[node name="MinimapObjective" parent="Jessica" instance=ExtResource("19_marker")]
objective_key = &"ch2_q1_jessica"
```

An NPC used by more than one quest stage received more than one marker. Quest filtering ensured that only the correct stage appeared:

```gdscript
[node name="Quest2MinimapObjective" parent="Matt" instance=ExtResource("19_marker")]
objective_key = &"ch2_q2_matt"

[node name="Quest3MinimapObjective" parent="Matt" instance=ExtResource("19_marker")]
objective_key = &"ch2_q3_matt"
```

Reusable dynamically spawned content carried its own marker. Every beach trash instance therefore became discoverable without manually editing the chapter scene:

```gdscript
# Inside TrashItem.tscn
[ext_resource type="PackedScene" path="res://Scenes/ui/MinimapObjective.tscn" id="2_marker"]

[node name="MinimapObjective" parent="." instance=ExtResource("2_marker")]
objective_key = &"ch2_q1_trash"
```

The sign assembly interactable used the same pattern:

```gdscript
# Inside SignAssemblyInteractable.tscn
[ext_resource type="PackedScene" path="res://Scenes/ui/MinimapObjective.tscn" id="2_marker"]

[node name="MinimapObjective" parent="." instance=ExtResource("2_marker")]
objective_key = &"ch2_q5_sign"
```

No minimap was added to menus or standalone puzzle scenes. The feature only existed in the four playable chapter maps:

- `res://Scenes/start.tscn`
- `res://Chapter 1/Clear Stream Valley.tscn`
- `res://Scenes/chapter_2.tscn`
- `res://Steven/main/Main.tscn`

## Visibility, completion, and freed nodes

The renderer applied three filters before drawing a point:

```gdscript
if marker == null or not marker.is_visible_in_tree():
	continue

var key: StringName = marker.get("objective_key")
if key.is_empty() or not QuestState.is_minimap_objective_active(key):
	continue
```

- Hidden objectives are not drawn because `is_visible_in_tree()` accounts for the marker and all hidden ancestors.
- Completed objectives disappear immediately because the quest-state function begins returning `false` on the next frame.
- Freed objectives disappear automatically because freed nodes are removed from the scene group.
- Dynamically spawned objectives appear automatically after their marker's `_ready()` method adds it to the group.

This group-based discovery eliminated the need for the minimap to maintain a separate marker registry.

## Exported tuning controls

The renderer exposed all visual and scale values in the Godot inspector:

| Property | Original value | Purpose |
| --- | ---: | --- |
| `world_scale` | `0.11` | Converts world pixels to minimap pixels |
| `background_color` | Near-black at 92% opacity | Panel fill |
| `border_color` | Light grey-blue at 90% opacity | Panel outline |
| `player_color` | Cyan | Player dot |
| `objective_color` | Yellow | Default objective dot |
| `player_radius` | `6.0` | Player dot radius |
| `objective_radius` | `5.0` | Objective dot radius |
| `border_width` | `2.0` | Panel outline thickness |
| `edge_inset` | `8.0` | Keeps edge-clamped dots inside the border |

To zoom in, reduce `world_scale`; to zoom out, increase it. For example:

```gdscript
# More local detail; objectives reach the edge sooner.
world_scale = 0.08

# Wider view; more distant objectives fit inside the panel.
world_scale = 0.14
```

The panel dimensions are controlled by the offsets in `Minimap.tscn`, not by the script.

## Technical choices and challenges

### Keeping the implementation simple

The minimap deliberately did not use a second camera, viewport, map texture, navigation mesh, or duplicated world geometry. Those approaches are appropriate for a geographic minimap, but they add rendering overhead and scene-maintenance work. Directly drawing primitive shapes was enough for objective navigation.

### Keeping the player centred

The HUD never moves the player dot. Instead, every objective position is calculated relative to the current player position. This avoids camera synchronization problems and works even if the gameplay camera has smoothing, zoom, or screen shake.

### Sharing progression rules

It was important not to infer active objectives from whether an NPC happened to be visible. Some NPCs participate in several quest phases, and some targets become relevant only after other flags change. Centralizing the rules in `QuestState` kept progression behavior explicit and testable.

### Supporting repeated and dynamic objectives

Group lookup allowed multiple active markers with the same key. All uncollected trash items could therefore use `ch2_q1_trash`, and each visible instance would be drawn. It also allowed a single NPC to carry multiple keys for different quest stages.

### Aligning dots with interaction locations

NPC scene roots were not always located at the collision or interaction point players perceive as the target. The marker's anchor search and `position_source` override addressed this without placing one-off coordinate corrections in the renderer.

### Scene transitions and missing players

During transitions, the player may temporarily be missing or replaced. Retrying `_resolve_player()` whenever the cached node becomes invalid allowed the component to recover without knowing anything about the transition system.

### Paused menus

Because the minimap is a HUD and uses `PROCESS_MODE_ALWAYS`, it can still redraw behind a paused settings or story panel. Input remains unaffected because the minimap ignores mouse events. If the desired design is to hide it during menus, that should be done by toggling the `MinimapLayer` visibility when the overlay opens rather than changing world-map logic.

## Restoring the feature from history

If the active files are ever removed again, the historical implementation can be restored selectively from commit `031c58a`. Do not cherry-pick the entire commit without review because that commit also contained settings-menu changes and predates later collaborative changes on `main`.

A safe manual restoration sequence is:

1. Restore the four minimap files from `031c58a`:
   - `game-4-good-rpg/Scenes/ui/Minimap.tscn`
   - `game-4-good-rpg/Scenes/ui/MinimapObjective.tscn`
   - `game-4-good-rpg/Scripts/ui/minimap.gd`
   - `game-4-good-rpg/Scripts/ui/minimap_objective.gd`
2. Restore or recreate their `.uid` files if the current Godot workflow requires stable resource UIDs.
3. Add `is_minimap_objective_active()` to the current `QuestState`, reconciling it with any newer quest flags.
4. Add the minimap instance and objective markers to the current versions of the four gameplay scenes.
5. Add markers to the reusable trash and sign scenes.
6. Open the project in the team's supported Godot version so imports and UIDs are refreshed.
7. Validate each objective against current quest progression before committing.

To inspect a historical file without changing the working tree:

```bash
git show 031c58a:game-4-good-rpg/Scripts/ui/minimap.gd
```

To restore one historical file into the working tree for review:

```bash
git restore --source=031c58a -- game-4-good-rpg/Scripts/ui/minimap.gd
```

## Verification checklist

After restoring or modifying the feature, verify the following in every playable chapter:

- The black panel remains 16 pixels from the top-right corner at multiple viewport sizes.
- The player dot remains centred while walking.
- Nearby objective dots move smoothly in the correct relative direction.
- A distant objective clings to the correct edge or corner without changing direction.
- The objective moves from the edge into the panel naturally as the player approaches.
- Simultaneous objectives all appear, including multiple trash items.
- Completed dialogue, bridge, trash, sign, and council objectives disappear immediately.
- The next objective appears when its progression condition becomes true.
- Hidden or freed world objects do not leave stale dots behind.
- Dynamically spawned markers appear without manual registration.
- Settings, pause, and story overlays remain clickable and are not blocked by the map.
- Scene transitions do not produce null-player errors.
- The map is absent from menus and standalone puzzle screens.

Run Godot's project validation using the same engine version used by the team. Any errors in unrelated scripts, autoloads, or tile resources should be recorded separately so they are not confused with minimap regressions.
