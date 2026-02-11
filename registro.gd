extends Control
@onready var dia = find_child("DiaInput")
@onready var mes = find_child("MesInput")
@onready var anio = find_child("AnioInput")
@onready var boton_revelar = find_child("RevealDestiny")

func _ready():
	self.modulate = Color(10, 10, 10)
	var tw_entrada = create_tween()
	tw_entrada.tween_property(self, "modulate", Color(1, 1, 1), 1.2)
	if dia and mes and anio:
		dia.max_length = 2
		dia.alignment = HORIZONTAL_ALIGNMENT_CENTER
		mes.max_length = 2
		mes.alignment = HORIZONTAL_ALIGNMENT_CENTER
		anio.max_length = 4
		anio.alignment = HORIZONTAL_ALIGNMENT_CENTER
		dia.text_changed.connect(func(t): _validar_y_saltar(dia, t, 2, mes))
		mes.text_changed.connect(func(t): _validar_y_saltar(mes, t, 2, anio))
		anio.text_changed.connect(func(t): _validar_y_saltar(anio, t, 4, null))
	if boton_revelar:
		boton_revelar.pressed.connect(_on_boton_confirmar_pressed)
	self.modulate = Color(10, 10, 10)
	var tw = create_tween()
	tw.tween_property(self, "modulate", Color(1, 1, 1), 1.2)
	if boton_revelar:
		boton_revelar.pressed.connect(_on_boton_confirmar_pressed)
		
func _validar_y_saltar(nodo, texto, limite, siguiente):
	var regex = RegEx.new()
	regex.compile("[^0-9]")
	var solo_numeros = regex.sub(texto, "", true)
	nodo.text = solo_numeros
	nodo.caret_column = solo_numeros.length()
	if solo_numeros.length() == limite and siguiente != null:
		siguiente.grab_focus()

func _on_boton_confirmar_pressed() -> void:
	print("Señal recibida: El ritual comienza...")
	if dia.text == "" or mes.text == "" or anio.text.length() < 4:
		print("Error: Fecha incompleta")
		return
	var error = get_tree().change_scene_to_file("res://scenas/Historia.tscn")
	if error != OK:
		print("La bruja no encuentra el camino a: res://Nombre_De_Tu_Escena.tscn")
	if dia and mes and dia.text != "" and mes.text != "":
		Global.usuario_dia = int(dia.text)
		Global.usuario_mes = int(mes.text)
		print("Datos vinculados correctamente para la predicción")
	else:
		print("POR FAVOR COMPLETA TUS DATOS CON PRECISIÓN PARA LA MAGIA")
