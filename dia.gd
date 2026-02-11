extends Control

@onready var fondo = $fondo 
@onready var carta_visual = $CenterContainer/CartaPrincipal
@onready var etiqueta_info = $ResultadoTexto 
@onready var etiqueta_desc = $DescripcionTexto 

func _ready():
	if etiqueta_desc:
		etiqueta_desc.add_theme_color_override("font_color", Color.BLACK)
		etiqueta_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	if fondo:
		await get_tree().process_frame
		fondo.pivot_offset = fondo.size / 2
	
	if carta_visual:
		carta_visual.pivot_offset = carta_visual.custom_minimum_size / 2

	var fecha = Time.get_date_dict_from_system()

	if Global.usuario_dia == 0:
		if etiqueta_desc: 
			etiqueta_desc.text = "POR FAVOR COMPLETA TUS DATOS CON PRECISIÓN PARA LA MAGIA"
		return

	# Cálculo usando la fecha actual: 6 de febrero de 2026
	var suma = Global.usuario_dia + Global.usuario_mes + fecha["day"] + fecha["month"] + fecha["year"]
	var id_arcano = _reducir(suma)
	
	_revelar_con_magia(id_arcano, fecha)

func _process(_delta):

	var pulso = 1.0 + (sin(Time.get_ticks_msec() * 0.002) * 0.04)
	
	if fondo:
		fondo.scale = Vector2(pulso, pulso)
		fondo.modulate = Color.from_hsv(sin(Time.get_ticks_msec() * 0.0005) * 0.5 + 0.5, 0.3, 1.0)
	
	if carta_visual:
		carta_visual.scale = Vector2(pulso, pulso)
		# Brillo místico en la carta
		carta_visual.self_modulate.a = 0.7 + (sin(Time.get_ticks_msec() * 0.004) * 0.3)

func _reducir(n):
	while n > 21:
		var s = 0
		for d in str(n): s += int(d)
		n = s
	return n

func _revelar_con_magia(id, f):
	var nombres = ["The Fool", "The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lovers", "The Chariot", "Justice", "The Hermit", "Wheel of Fortune", "Strength", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World"]
	var descripciones = [
		"The Fool (0): Today, the universe gifts you a blank page to write a new story, free from the weight of past mistakes. This card represents the leap of faith your soul needs to evolve. You are invited to trust your purest instinct, the one untainted by fear of judgment. Do not seek a detailed map; the path will reveal itself beneath your feet as you move forward with courage. The energy of The Fool is absolute freedom to be who you truly are, reminding you that true wisdom sometimes looks like madness to the eyes of the mundane world.",
		"The Magician (I): You possess at this very moment all the tools necessary to transform your reality and manifest your deepest desires. The four sacred elements are aligned on your workbench: your will is fire, your intellect is air, your emotions are water, and your discipline is earth. The Magician grants you the ability to communicate effectively and use your ingenuity to solve any obstacle that seems insurmountable. There are no limits to what you can achieve if you focus your intention clearly. You are the divine alchemist of your own existence; use your magic wisely.",
		"The High Priestess (II): This is a sacred time for silence and inner listening, stepping away from the deafening noise of daily life. The High Priestess invites you to cross the threshold of the visible to explore the mysteries dwelling in the depths of your unconscious. Today, your intuition is an infallible compass guiding you toward truths that logic cannot comprehend. Do not force situations or seek external answers; remain receptive to messages arriving through dreams and hunches. An ancestral knowledge flows through your veins, reminding you that patience and observation are your greatest spiritual strengths.",
		"The Empress (III): Abundance, beauty, and overflowing creativity manifest today in every aspect of your life. This card connects you with the generating force of nature, reminding you that you have the power to nourish and give life to prosperous projects. It is a day to celebrate the fertility of your ideas and to surround yourself with environments that stimulate your senses. The Empress asks you to love yourself unconditionally and trust in the natural growth process of things. Everything you sow today with love and dedication will grow with unstoppable force, bringing harmony to your material world.",
		"The Emperor (IV): Today is a day to establish order, structure, and solid foundations in your material world. The Emperor grants you the authority and discipline necessary to lead your projects with a steady hand and clear vision. It is time to act with logic and protect what you have built with so much effort and determination. This card reminds you that true power comes from stability and the ability to organize your resources efficiently. Trust in your leadership capacity and do not be afraid to set boundaries to maintain the integrity of your kingdom.",
		"The Hierophant (V): You find yourself in a period of spiritual learning and connection with sacred traditions. This card represents the search for meaning through spiritual knowledge and the guidance of masters. The universe asks you to follow the path of ethics and share your wisdom with those who seek light in the midst of confusion. It is a time to respect established values and find comfort in belonging to a community that shares your beliefs. Open your heart to the lessons that come from experience and the wisdom transmitted through the ages.",
		"The Lovers (VI): You face a crossroad of the heart where the right choice is born from inner harmony. Today, relationships and personal values take center stage, demanding total honesty with yourself. Trust that love is the force that unites your dualities and guides you toward the path of true happiness. This card invites you to align your desires with your higher purpose and choose the path that resonates with the truth of your soul. Harmony in your connections with others reflects the peace you have cultivated within your own spirit.",
		"The Chariot (VII): Victory is within your reach if you manage to master the opposing forces pulling at you. This card symbolizes triumphant progress through willpower and emotional control. Do not stop in the face of challenges; take the reins of your destiny and direct your energy with absolute focus toward the goal you have set for yourself. Determination is your greatest ally today, allowing you to overcome obstacles with confidence and courage. The Chariot reminds you that success requires discipline and the ability to maintain your direction even in the midst of external movement.",
		"Justice (VIII): Today the cosmos asks you for balance, honesty, and an objective evaluation of your past actions. Justice reminds us that every act has a consequence and that the truth always comes to light. Seek impartiality in your decisions and trust that the universal order will restore the necessary harmony in your current life. This card invites you to act with integrity and take responsibility for your choices. By aligning yourself with the truth, you find the inner peace that comes from knowing you have acted according to the highest principles of fairness.",
		"The Hermit (IX): It is time for a necessary solitude to illuminate the dark corners of your soul with the lamp of introspection. The Hermit invites you to step away from external noise to find the wisdom that is only born in silence. Do not be in a hurry; every slow step in the darkness brings you closer to the fundamental truth of your being. This period of withdrawal allows you to re-evaluate your path and find the light that will guide your future steps. Inner guidance is your most precious treasure, revealing secrets that only become clear when you listen to your soul.",
		"Wheel of Fortune (X): The winds of destiny are changing and preparing you for an unexpected turn in your path. This card represents the constant cycles of life: what is down today will be up tomorrow. Accept changes with fluidity and understand that every movement is an opportunity to evolve toward a new level of spiritual awareness. The Wheel reminds you that nothing is permanent and that adaptability is key to moving through the ups and downs of existence. Trust that the universe is moving in your favor, even if the destination is not yet clear.",
		"Strength (XI): True strength does not lie in physical violence, but in the compassionate mastery of your most primary instincts. Today you are asked to face your fears with the softness of love and the patience of the spirit. You have the courage necessary to tame the inner lion and transform your weaknesses into an inexhaustible source of personal power. This card invites you to act with gentleness and determination, knowing that the greatest victory is the one you achieve over yourself. Inner resilience is your shield against the challenges of the world.",
		"The Hanged Man (XII): The universe asks you to take a strategic pause and observe your reality from a completely different perspective. Sometimes, the sacrifice of the ego is necessary to obtain deep enlightenment. Do not fight against apparent stagnation; let the stillness reveal new solutions that were previously invisible to your eyes. This card reminds you that by changing your point of view, you can find freedom in situations that seemed restrictive. Patience is a virtue that allows you to see the wisdom hidden in waiting and the value of letting go of control.",
		"Death (XIII): An important cycle in your life is coming to an end to allow the rebirth of something much larger and more authentic. Do not fear transformation; mystical death is only the necessary pruning for your soul to bloom again. Release what no longer serves you and let the earth prepare for new seeds. This card symbolizes a profound change that clears the way for a new phase of growth. By accepting the end of one stage, you open the door to the infinite possibilities that renewal brings to your spiritual journey.",
		"Temperance (XIV): Today is a day for emotional alchemy, mixing your opposites to find perfect balance and inner peace. Temperance guides you toward moderation and the healing of old wounds through forgiveness and patience. Flow with the waters of life without extremes, allowing divine harmony to guide each of your steps. This card invites you to find the middle ground and act with serenity in all situations. By integrating your different parts, you create a state of internal stability that allows you to face the world with calm and grace.",
		"The Devil (XV): This card invites you to confront the shadows, addictions, or mental patterns that keep you chained to fear. It is time to recognize where you have given your power away in exchange for an illusion of material security or fleeting pleasure. The chains are loose; you only need the will to see the truth to free yourself from your own prisons. The Devil reminds you that awareness is the first step toward liberation. By facing your attachments, you regain the freedom to choose a path that is truly aligned with your higher self.",
		"The Tower (XVI): Prepare for a sudden revelation that will tear down the false structures on which you have built part of your reality. Although the change may seem destructive, it is a blessing in disguise that frees you from lies. On the ruins of the old, today you have the opportunity to build an indestructible foundation based on the absolute truth of your soul. This card represents a breakthrough that shatters illusions and forces you to confront reality. The collapse of the old way of being is necessary for the birth of a more authentic existence.",
		"The Star (XVII): After the storm, eternal hope emerges under the glow of divine inspiration. This card is a balm of peace that assures you that you are on the right path and that the universe fully supports you. Trust in your own inner light and allow your creativity to flow freely, healing your spirit and those around you. The Star reminds you that even in the darkest night, there is a light that guides you toward your true purpose. Keep your faith high and let the serenity of the cosmos fill your heart with hope.",
		"The Moon (XVIII): You find yourself in a territory of shadows and illusions where things are not always what they seem at first glance. The Moon invites you to explore your deepest fears and trust your intuition over external logic. Do not fear the darkness; in it, the most powerful dreams and the truths that only the soul can perceive are gestated. This card represents the realm of the subconscious and the need to navigate the mysteries of the psyche. By following the light of your intuition, you can find your way through the confusion of the night.",
		"The Sun (XIX): Success, vitality, and radiant joy illuminate your path today in an unmistakable way. This card represents total clarity, revealed truth, and the energy necessary to achieve any purpose. Enjoy this moment of fulfillment and share your warmth with the world, for today you are a beacon of light and happiness for everyone around you. The Sun assures you that the clouds have cleared and that a period of growth and prosperity has begun. Your confidence and enthusiasm are contagious, attracting positive experiences and rewarding connections into your life.",
		"Judgement (XX): You hear the call of awakening that invites you to leave the past behind and be reborn into a higher version of yourself. Today is a day of spiritual evaluation and absolution, where you understand the purpose of every experience lived. Rise with a new awareness and embrace your true vocation with the security of having learned the lessons of destiny. This card represents a moment of significant transition where you are called to step into your power. By forgiving yourself and others, you find the freedom to move forward with clarity and purpose.",
		"The World (XXI): You have reached the end of a great journey and find yourself at the point of total fulfillment and absolute completion. This card symbolizes success on all planes and the harmonious integration of your being with the universe. Celebrate it, for today the world is at your feet and you possess the wisdom necessary to begin a new cycle from total mastery. The World represents the achievement of your goals and the realization of your dreams. You are in perfect alignment with the cosmic flow, ready to embrace the infinite possibilities of a new beginning."
	]

	if etiqueta_info:
		etiqueta_info.text = "TODAY " + str(f["day"]) + "/" + str(f["month"]) + "/" + str(f["year"]) + ": " + nombres[id]
	if etiqueta_desc and id < descripciones.size():
		etiqueta_desc.text = descripciones[id]

	var ruta = "res://cartas/" + str(id) + ".jpeg"
	if FileAccess.file_exists(ruta):
		carta_visual.texture = load(ruta)
		carta_visual.modulate.a = 0
		create_tween().tween_property(carta_visual, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenas/Historia.tscn")
