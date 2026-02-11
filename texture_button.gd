extends TextureButton

func _pressed():
	if has_node("AudioStreamPlayer"):
		var grito = $AudioStreamPlayer
		if grito.stream == null:
			print("ERROR: No has arrastrado ningún archivo de audio al nodo AudioStreamPlayer")
		else:
			grito.play()
			print("Reproduciendo grito...")
	else:
		print("ERROR: No existe el nodo hijo llamado exactamente 'AudioStreamPlayer'")

	var tw = create_tween()
	tw.tween_property(self, "modulate", Color(100, 100, 100), 0.2)

	await tw.finished
	get_tree().change_scene_to_file("res://scenas/registro.tscn")
