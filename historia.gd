extends Control

var indice = 0
var total_pasos = 13 
var dialogo_terminado = false
var sonido_clic = null 

@onready var bruja = %AnimatedSprite2D
@onready var sprite_dialogo = %SpriteDialogo
@onready var sfx = %AudioEfectos

func _ready():
	_sincronizar_escena()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not dialogo_terminado:
			if indice < total_pasos - 1:
				indice += 1
				_sincronizar_escena()
			else:
				_finalizar_historia()

func _sincronizar_escena():
	var anim = str(indice)
	if bruja != null: 
		bruja.play(anim)
	if sprite_dialogo != null: 
		sprite_dialogo.play(anim)

func _finalizar_historia():
	dialogo_terminado = true
	if sprite_dialogo: 
		sprite_dialogo.hide()
	
	if %BotonJugar: %BotonJugar.show()
	if %BotonTarotAnio: %BotonTarotAnio.show()
	if %BotonTarotDia: %BotonTarotDia.show()

func _on_boton_jugar_pressed():
	get_tree().change_scene_to_file("res://scenas/play.tscn")

func _on_boton_tarot_anio_pressed():
	get_tree().change_scene_to_file("res://scenas/año.tscn")

func _on_boton_tarot_dia_pressed():
	get_tree().change_scene_to_file("res://scenas/dia.tscn")
