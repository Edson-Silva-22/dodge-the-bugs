extends Node2D

@export var bug_scene: PackedScene
var score

func new_game() -> void:
	$StartTimer.start()
	# Método chamado do nó player que define sua posição inicial
	$player.start_position($StartPosition.position)
	score = 0
	$HUD.updateScore(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group('bugs', "queue_free")
	$BgMusic.play()
	
# Será chamada quando o sinal hit() no nó player for disparado
func gamer_over() -> void:
	# vai parar o timer dos bugs
	$BugTimer.stop()
	# encerra o timer da pontuação
	$ScoreTimer.stop()
	$HUD.show_game_over()
	$HUD.save_score_record(score)
	$HUD.load_score()
	$GameOverSound.play()
	$BgMusic.stop()
	
# Função que conta a pontuação
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.updateScore(score)

func _on_start_timer_timeout() -> void:
	# O nó do tipo Timer executa uma derterminada ação em um intervalo de tempo
	# Nesse caso o nó BugTimer dispara o sinal timeout() a cada 0.5s, que por sua vez chama a func _on_bug_timer_timeout()
	$BugTimer.start()
	
	# Iniciando o nó ScoreTimer que tem a ação de chamar a func _on_score_timer_timeout() a caeda 0.5s
	$ScoreTimer.start()

func _on_bug_timer_timeout() -> void:
	# Iniciando uma nova cena, que no caso é uma cena de um novo enemy
	var enemy_bug_scene = bug_scene.instantiate()
	# Defenindo uma localização randomica no progress_ratio do nó BugPathLocation que é do tipo PathFollow2D
	var path_location: PathFollow2D = $BugPath/BugPathLocation
	path_location.progress_ratio = randf()
	
	# Definindo a posição da nova cena de enemy
	enemy_bug_scene.position = path_location.position
	
	# Definindo a rotação da nova cena que foi criada
	var direction = path_location.rotation + PI / 2
	# Definindo uma nova rotação randomica para a proxíma cena que será gerada na chamada seguinte da função
	direction += randf_range(-PI / 4, PI / 4)
	# Aplicando a rotação que foi definida na cena
	enemy_bug_scene.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy_bug_scene.linear_velocity = velocity.rotated(direction)
	add_child(enemy_bug_scene)
	
