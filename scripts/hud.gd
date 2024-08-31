extends CanvasLayer

# Sinal que será emitido para idicar que o jogo começou
signal start_game
@onready var record_score: Label = $Control/RecordScore
@onready var message_label: Label = $Control/MessageLabel
@onready var message_timer: Timer = $MessageTimer
@onready var start_button: Button = $Control/StartButton
var score_label: Label

func _ready() -> void:
	score_label = $Control/ScoreLabel
	score_label.hide()
	load_score()
	
	
# Exibirar a mensagem no hud passada como parâmetro
func show_message(text):
	message_label.text = text
	message_label.show()
	message_timer.start()
	
	
func show_game_over():
	show_message("Gamer Over")
	await message_timer.timeout
	
	message_label.text = "Dodge The Bugs"
	message_label.show()
	
	await get_tree().create_timer(1.0).timeout
	score_label.hide()
	start_button.show()
	record_score.show()


func updateScore(score):
	score_label.text = str(score)


func _on_start_button_pressed() -> void:
	start_button.hide()
	record_score.hide()
	start_game.emit()
	score_label.show()


func _on_message_timer_timeout() -> void:
	message_label.hide()


func save_score_record(score: int):
	# JavaScriptBridge.eval(): usado para executar um código javascript, em forma de string, na godot. 
	# No Método JavaScriptBridge.eval pode-se passar um segudo parâmetro boleano que indicará se o código será executado globalmente
	var lastRecordSalved = JavaScriptBridge.eval("localStorage.getItem('record_score');")
	print(typeof(lastRecordSalved))
	if lastRecordSalved != null and score > lastRecordSalved.to_int():
		JavaScriptBridge.eval("localStorage.setItem('record_score', %s);" % [str(score)])


func load_score() -> void:
	var scoreRecordLocalStorage = JavaScriptBridge.eval("localStorage.getItem('record_score');")
	print(scoreRecordLocalStorage)
	if  scoreRecordLocalStorage != null:
		record_score.text = "Record Score: %s" % [scoreRecordLocalStorage]
