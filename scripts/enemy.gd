extends RigidBody2D

@onready var anim: AnimatedSprite2D = $anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Pegando a lista de animações do nó anim
	var enemy_types = anim.sprite_frames.get_animation_names()
	# Rodando a animação de forma rondomica
	anim.play(enemy_types[randi() % enemy_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Chamada a cada vez que esse nó sair da tela
func _on_visible_screen_exited() -> void:
	queue_free()
