extends CharacterBody2D

@export var speed := 300
var target_position: Vector2
var using_mouse := false
var is_in_dialogue := false

@onready var animsprite = $AnimatedSprite2D
@onready var direction_marker: Marker2D = $Direction
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

const SPRITES: Dictionary[String, SpriteFrames] = {
	"AfricanBoy": preload("res://Sprites/Player Sprites/DefaultSS/AfricanBoySS.tres"),
	"AfricanGirl": preload("res://Sprites/Player Sprites/DefaultSS/AfricanGirlSS.tres"),
	"ArabBoy": preload("res://Sprites/Player Sprites/DefaultSS/ArabBoySS.tres"),
	"ArabGirl": preload("res://Sprites/Player Sprites/DefaultSS/ArabGirlSS.tres"),
	"AsianBoy": preload("res://Sprites/Player Sprites/DefaultSS/AsianBoySS.tres"),
	"AsianGirl": preload("res://Sprites/Player Sprites/DefaultSS/AsianGirlSS.tres"),
	"BrownBoy": preload("res://Sprites/Player Sprites/DefaultSS/BrownBoySS.tres"),
	"BrownGirl": preload("res://Sprites/Player Sprites/DefaultSS/BrownGirlSS.tres"),
	"Default": preload("res://Sprites/Player Sprites/DefaultSS/DefSS.tres"),
	"LGBT1": preload("res://Sprites/Player Sprites/DefaultSS/LGBT1.tres"),
	"LGBT2": preload("res://Sprites/Player Sprites/DefaultSS/LGBT2.tres"),
	"WhiteBoy": preload("res://Sprites/Player Sprites/DefaultSS/WhiteBoySS.tres"),
	"WhiteGirl": preload("res://Sprites/Player Sprites/DefaultSS/WhiteGirlSS.tres")
}

const SKIN_ORDER: Array[String] = [
	"Default",
	"AfricanBoy",
	"AfricanGirl",
	"ArabBoy",
	"ArabGirl",
	"AsianBoy",
	"AsianGirl",
	"BrownBoy",
	"BrownGirl",
	"LGBT1",
	"LGBT2",
	"WhiteBoy",
	"WhiteGirl"
]

const SETTINGS_PATH := "user://settings.cfg"
const DEFAULT_SKIN_NAME := "LGBT2"

var current_skin_index := 0
var last_direction := Vector2.RIGHT

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	target_position = global_position
	add_to_group("player")
	actionable_finder.add_to_group("player_interaction_area")
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	apply_skin_from_settings()

func apply_skin_from_settings() -> void:
	current_skin_index = _load_saved_skin_index()
	set_skin(SKIN_ORDER[current_skin_index])

func save_current_skin() -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)
	config.set_value("player", "skin", current_skin_index)
	config.save(SETTINGS_PATH)

func _load_saved_skin_index() -> int:
	var default_index := SKIN_ORDER.find(DEFAULT_SKIN_NAME)
	if default_index == -1:
		default_index = 0
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return default_index
	var skin: int = int(config.get_value("player", "skin", default_index))
	if skin < 0 or skin >= SKIN_ORDER.size():
		return default_index
	return skin

func set_skin(name: String):
	if SPRITES.has(name):
		animsprite.sprite_frames = SPRITES[name]
		animsprite.play("16 Idle")
	else:
		push_warning("Skin not found: " + name)

func cycle_skin():
	current_skin_index = (current_skin_index + 1) % SKIN_ORDER.size()
	set_skin(SKIN_ORDER[current_skin_index])

func _is_input_blocked() -> bool:
	return is_in_dialogue or QuestState.is_story_guide_blocking_input()


func _unhandled_input(_event: InputEvent) -> void:
	if _is_input_blocked():
		return
	if Input.is_action_just_pressed("ui_accept"):
		var actionables := actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()


func _input(event):
	if _is_input_blocked():
		return
	if event is InputEventMouseButton and event.pressed:
		target_position = get_global_mouse_position()
		using_mouse = true


func _physics_process(delta):
	if _is_input_blocked():
		using_mouse = false
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# 🔥 Proper input action (make sure it's added in Input Map)
	if Input.is_action_just_pressed("cycle_skin"):
		cycle_skin()

	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	if input_vector != Vector2.ZERO:
		using_mouse = false
		velocity = input_vector * speed
		last_direction = input_vector
	
	elif using_mouse:
		var direction = (target_position - global_position)
		
		if direction.length() > 5:
			velocity = direction.normalized() * speed
			last_direction = direction.normalized()
		else:
			velocity = Vector2.ZERO
			using_mouse = false
	else:
		velocity = Vector2.ZERO

	# 🔥 Capture real movement
	var prev_position = global_position

	move_and_slide()

	var real_velocity = global_position - prev_position

	if last_direction.length_squared() > 0.0001:
		direction_marker.rotation = last_direction.angle() - PI / 2.0

	update_animation(real_velocity)


func _on_dialogue_started(_resource) -> void:
	is_in_dialogue = true
	using_mouse = false
	velocity = Vector2.ZERO
	animsprite.flip_h = false
	animsprite.play("16 Idle")


func _on_dialogue_ended(_resource) -> void:
	is_in_dialogue = false


func update_animation(real_velocity: Vector2):

	# If not actually moving → idle
	if real_velocity.length() < 1:
		play_idle_animation()
		return

	var angle = real_velocity.angle()
	animsprite.flip_h = false

	if angle > -PI/8 and angle <= PI/8:
		animsprite.play("Run East")

	elif angle > PI/8 and angle <= 3*PI/8:
		animsprite.play("Run SouthEast")

	elif angle > 3*PI/8 and angle <= 5*PI/8:
		animsprite.play("Run South")

	elif angle > 5*PI/8 and angle <= 7*PI/8:
		animsprite.play("Run SouthEast")
		animsprite.flip_h = true

	elif angle > 7*PI/8 or angle <= -7*PI/8:
		animsprite.play("Run East")
		animsprite.flip_h = true

	elif angle > -7*PI/8 and angle <= -5*PI/8:
		animsprite.play("Run NorthEast")
		animsprite.flip_h = true

	elif angle > -5*PI/8 and angle <= -3*PI/8:
		animsprite.play("Run North")

	elif angle > -3*PI/8 and angle <= -PI/8:
		animsprite.play("Run NorthEast")

func play_idle_animation():
	var angle = last_direction.angle()
	animsprite.flip_h = false

	if angle > -PI/8 and angle <= PI/8:
		animsprite.play("16 Idle")

	elif angle > PI/8 and angle <= 3*PI/8:
		animsprite.play("16 Idle")

	elif angle > 3*PI/8 and angle <= 5*PI/8:
		animsprite.play("16 Idle")

	elif angle > 5*PI/8 and angle <= 7*PI/8:
		animsprite.play("16 Idle")
		animsprite.flip_h = true

	elif angle > 7*PI/8 or angle <= -7*PI/8:
		animsprite.play("16 Idle")
		animsprite.flip_h = true

	elif angle > -7*PI/8 and angle <= -5*PI/8:
		animsprite.play("16 Idle")
		animsprite.flip_h = true

	elif angle > -5*PI/8 and angle <= -3*PI/8:
		animsprite.play("16 Idle")

	elif angle > -3*PI/8 and angle <= -PI/8:
		animsprite.play("16 Idle")

#This is my mark - ayden
# Leo successfuly updated the script
#This is not my work - Stevem
#This is my addition 2 - maq
