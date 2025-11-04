extends Area2D

@export var attack_range: float = 150.0     # distância que ela pode atacar
@export var attack_damage: int = 1          # dano por ataque
@export var attack_interval: float = 1.5    # tempo entre ataques (segundos)
@export var health: int = 5                 # vida da planta

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer

var target: Node2D = null

func _ready():
	$CollisionShape2D.disabled = false
	attack_timer.wait_time = attack_interval
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start()

func _process(delta):
	# Se houver um alvo e ele sair do alcance ou morrer, esquece ele
	if target and (not is_instance_valid(target) or position.distance_to(target.position) > attack_range):
		target = null

	# Se não tiver alvo, tenta achar um novo
	if target == null:
		_find_target()

func _find_target():
	# Procura por inimigos próximos (monstros com grupo "monsters")
	var monsters = get_tree().get_nodes_in_group("monsters")
	for monster in monsters:
		if position.distance_to(monster.position) <= attack_range:
			target = monster
			break

func _on_attack_timer_timeout():
	if target and is_instance_valid(target):
		_attack_target()

func _attack_target():
	print("🌿 Planta atacou o monstro!")
	if "take_damage" in target:
		target.take_damage(attack_damage)

func take_damage(amount: int):
	health -= amount
	print("💢 Planta tomou dano! Vida:", health)
	if health <= 0:
		die()

func die():
	print("💀 Planta destruída.")
	queue_free()
