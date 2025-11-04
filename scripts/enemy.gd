extends CharacterBody2D

@export var speed: float = 100.0
@export var player_path: NodePath

var player: Node2D

func _ready():
	if player_path != null:
		player = get_node(player_path)

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
