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
