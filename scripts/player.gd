extends Area2D

signal hit
const SPEED := 400
# o @onready faz a mesma função do método ready
@onready var screen_size = get_viewport_rect().size
@onready var animated: AnimatedSprite2D = $animated
@onready var collision: CollisionShape2D = $collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Input.get_vector("move_left", "move_rigth", "move_up", "move_down")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	
	# Ativando animação de acordo com a movimentação do player
	if velocity.x != 0:
		animated.play("move")
	elif velocity.y < 0:
		animated.play('move_down')
	elif velocity.y > 0:
		animated.play('move_up')
	else:
		animated.play('idle')
		
	if velocity.x > 0:
		animated.flip_h = false
	else:
		animated.flip_h = true
		
	# If ternário
	animated.flip_h = true if velocity.x > 0 else false
	
	position += velocity * delta
	# clamp(): impedi que o player saia fora dos limites da tela
	position = position.clamp(Vector2.ZERO, screen_size)

# Verificação da colisão do player com os bugs
func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	collision.set_deferred("disabled", true)
	
# Define a posição inicial do player
func start_position(playerPosition):
	position = playerPosition
	show()
	collision.disabled = false
