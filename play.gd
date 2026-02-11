extends Control
@onready var filtro_borroso = $FiltroBorroso
@onready var zodiac_label = $ZodiacLabel
@onready var PreguntaContainer = $PreguntaContainer
@onready var input_pregunta = $PreguntaContainer/InputPregunta
@onready var boton_next = $PreguntaContainer/BotonNext
@onready var mazo_arco = $MazoArco
@onready var particulas = $GPUParticles2D
@onready var flash_blanco = $CapaEfectos/FlashBlanco
@onready var imagen_final = $CapaEfectos/ImagenFinal
@onready var label_descripcion = $ContenedorResultados/LabelDescripcion

var seleccionadas = []
var lectura_actual = 0
var pregunta_guardada = "" 
var esta_presentando = false 
var signo_usuario = "" 
func _ready():

	for capa in [flash_blanco, imagen_final, filtro_borroso]:
		capa.modulate.a = (1.0 if capa == filtro_borroso else 0.0)
		capa.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for hijo in capa.get_children():
			if hijo is Control:
				hijo.mouse_filter = Control.MOUSE_FILTER_IGNORE

	mazo_arco.visible = false
	label_descripcion.text = ""
	PreguntaContainer.mouse_filter = Control.MOUSE_FILTER_PASS
	input_pregunta.mouse_filter = Control.MOUSE_FILTER_STOP
	boton_next.mouse_filter = Control.MOUSE_FILTER_STOP
	
	input_pregunta.placeholder_text = "How will I do in...?"
	_mostrar_signo_zodiacal() 
	
	if not boton_next.pressed.is_connected(_on_next_pressed):
		boton_next.pressed.connect(_on_next_pressed)
		
	print("Ready: Capas perforadas. El botón y el signo deberían estar activos.")
	label_descripcion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_descripcion.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label_descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label_descripcion.custom_minimum_size = Vector2(900, 200)
func _on_next_pressed():
	
	flash_blanco.mouse_filter = Control.MOUSE_FILTER_IGNORE
	imagen_final.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	pregunta_guardada = input_pregunta.text
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(PreguntaContainer, "modulate:a", 0.0, 0.5)
	tw.tween_property(filtro_borroso, "modulate:a", 0.0, 0.5)
	
	tw.chain().tween_callback(func():
		PreguntaContainer.visible = false
		filtro_borroso.visible = false
		_generar_mazo()
	)
func _mostrar_signo_zodiacal():
	if Global.usuario_dia == 0:
		zodiac_label.text = "POR FAVOR COMPLETA TUS DATOS CON PRECISIÓN PARA LA MAGIA"
		return
	
	var signos = ["Capricorn", "Aquarius", "Pisces", "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius"]
	var fechas = [20, 19, 20, 20, 21, 21, 22, 22, 22, 23, 22, 21]
	var m = Global.usuario_mes
	var d = Global.usuario_dia
	var indice = m if d > fechas[m-1] else m-1
	zodiac_label.text = "Your Zodiac Sign: " + signos[indice % 12]


func _generar_mazo():
	PreguntaContainer.visible = false
	mazo_arco.visible = true
	mazo_arco.modulate.a = 1.0
	
	for i in range(22):
		var carta = Button.new()
		_cargar_imagen(carta, "res://mazo/reves.png") 
		carta.flat = true
		carta.expand_icon = true
		carta.custom_minimum_size = Vector2(130, 190)
		carta.pivot_offset = Vector2(65, 95) 
		
		mazo_arco.add_child(carta)
		
		var angulo = deg_to_rad(lerp(155.0, 205.0, i / 21.0))
		carta.rotation = angulo + PI
		carta.position = Vector2(sin(angulo)*700, cos(angulo)*700)
		carta.pressed.connect(_seleccionar_esta_carta.bind(carta))

var significados = {
	# MAJOR ARCANA (0-21)
	0: {"upright": "New beginnings, leaps of faith, and spontaneity. The universe invites you to explore without fear.", "reversed": "Reckless risks, lack of commitment, and naive decisions. Stop before falling into the void."},
	1: {"upright": "Manifesting power, unlimited resources, and mental focus. You have the ability to create your own reality.", "reversed": "Manipulation, talents hidden by fear, and lack of ethics. Beware of self-deception."},
	2: {"upright": "Intuition, mystery, and inner wisdom. Listen to the whispers of your soul before taking action.", "reversed": "Harmful secrets, spiritual disconnection, and lack of trust in your hunches. Uncomfortable revelations."},
	3: {"upright": "Fertility, creative abundance, and maternal care. Time to see your most beloved projects flourish.", "reversed": "Creative block, emotional dependency, and stagnation. You need to nurture yourself first before giving."},
	4: {"upright": "Authority, structure, and material stability. Order and discipline will bring you the success you seek.", "reversed": "Tyranny, lack of control, and excessive rigidity. A weak leader or an excess of rules."},
	5: {"upright": "Tradition, spiritual guidance, and formal learning. Seek advice from institutions or experienced mentors.", "reversed": "Rebellion, dogmatism, and questioning beliefs. It is time to create your own internal rules."},
	6: {"upright": "Love, important decisions, and harmony. A sacred union or a choice that will change your path.", "reversed": "Imbalance in relationships, indecision, and value conflicts. Choices based only on fleeting desire."},
	7: {"upright": "Victory, strong will, and control over chaos. Success comes through determination and strength.", "reversed": "Lack of direction, uncontrolled aggression, and defeat. Obstacles are leading you off the path."},
	8: {"upright": "Courage, compassion, and inner strength. Master your lower instincts with the softness of the heart.", "reversed": "Self-doubt, weakness in the face of fear, and lack of self-discipline. Anger clouds your judgment."},
	9: {"upright": "Introspection, necessary solitude, and inner guidance. Step away from the noise to find your truth.", "reversed": "Excessive isolation, rejection of help, and bitter loneliness. You are lost in your own labyrinth."},
	10: {"upright": "Unexpected changes, cycles of fortune, and destiny. The wheel turns in your favor; seize the momentum.", "reversed": "Bad luck, resistance to change, and negative repetitive cycles. Nothing stays the same; accept the turn."},
	11: {"upright": "Balance, truth, and cause-effect. Justice will arrive impartially; reap what you have sown.", "reversed": "Injustice, dishonesty, and legal complications. You are avoiding taking responsibility for your past acts."},
	12: {"upright": "Sacrifice, new perspective, and necessary pause. Look at the world from another angle to find solutions.", "reversed": "Selfishness, resistance to sacrifice, and useless effort. You cling to something that no longer works."},
	13: {"upright": "Necessary endings, deep transformation, and closure. Do not fear loss; it is the space for birth.", "reversed": "Resistance to change, stagnation, and fear of the end. Avoiding the inevitable only prolongs the pain."},
	14: {"upright": "Moderation, patience, and personal alchemy. Find the middle ground to heal and move forward with peace.", "reversed": "Excess, emotional imbalance, and lack of purpose. You are wasting energy in a thousand directions."},
	15: {"upright": "Attachments, excesses, and internal shadows. Recognize your vices to free yourself from the chains that oppress you.", "reversed": "Release, overcoming fears, and end of slavery. You are breaking old destructive patterns."},
	16: {"upright": "Sudden collapse, revelation, and fall of illusions. What lacks solid foundations must fall now.", "reversed": "Avoiding an imminent disaster or fear of crisis. Tension builds without exploding yet."},
	17: {"upright": "Hope, spiritual renewal, and divine guidance. The light shines again after the darkest storm.", "reversed": "Hopelessness, lack of faith, and pessimism. You feel the universe has abandoned you; seek light."},
	18: {"upright": "Illusion, anxiety, and vivid dreams. Things are not what they seem; trust your instinct.", "reversed": "Mental clarity, overcoming hidden fears, and revelation of deceit. The fog is finally clearing."},
	19: {"upright": "Success, radiant joy, and vitality. Everything flourishes under your presence; it is time to celebrate.", "reversed": "Shadowed happiness, arrogance, or temporary success. You need to reevaluate what truly makes you happy."},
	20: {"upright": "Rebirth, soul's calling, and forgiveness. It is time to evaluate your past and awaken.", "reversed": "Wrong judgment, internal doubt, and denial of the call. You feel stuck by unforgiven mistakes."},
	21: {"upright": "Completeness, successful journey, and the world at your feet. You have closed a cycle with wisdom.", "reversed": "Incompleteness, lack of closure, and unreached goals. Success is near but one step is missing."},

	# WANDS (22-35)
	22: {"upright": "Pure inspiration and creative potential. A passionate new project or passion is being born now.", "reversed": "Lack of direction, delays, and creative blocks. The initial spark has prematurely gone out."},
	23: {"upright": "Planning, progress, and long-term vision. You are looking toward the future with confidence.", "reversed": "Fear of the unknown, lack of planning, and limited horizons. You lack the courage to advance."},
	# WANDS (Continued: 24-35)
	24: {"upright": "Expansion, exploration, and waiting for results. Your efforts are starting to pay off on the horizon.", "reversed": "Disappointment in results, lack of foresight, and delays in travel or international projects."},
	25: {"upright": "Celebration, harmonious home, and shared joy. A moment of rest and happiness with loved ones.", "reversed": "Family conflicts, instability at home, and lack of harmony. The celebration feels forced."},
	26: {"upright": "Healthy competition, rivalry, and challenges. The struggle will help you grow and strengthen your character.", "reversed": "Destructive conflicts, lack of cooperation, and chaos. You are fighting for the wrong reasons."},
	27: {"upright": "Victory, public recognition, and success after effort. Others admire your achievements and leadership.", "reversed": "Fall from grace, lack of confidence, and betrayal. Success is fleeting or poorly received."},
	28: {"upright": "Defense, perseverance, and protecting achievements. Stand firm against opposition; you have the advantage.", "reversed": "Feeling overwhelmed, surrender, and lack of confidence. External pressure is breaking your defense."},
	29: {"upright": "Speed, fast news, and constant movement. Everything flows forward with surprising rapidity.", "reversed": "Frustrating delays, blind impulsiveness, and lack of control. News received causes confusion or panic."},
	30: {"upright": "Resilience, final test, and protection. You are tired but near the goal; don't lower your guard now.", "reversed": "Total exhaustion, paranoia, and weakness. The walls you built are closing in too much."},
	31: {"upright": "Heavy burden, excessive responsibility, and final effort. You are carrying too much weight on your shoulders.", "reversed": "Collapse under pressure, inability to delegate, and extreme stress. You need to release unnecessary burdens."},
	32: {"upright": "Youthful enthusiasm and new ideas. An exciting message or an opportunity for adventure is arriving.", "reversed": "Impatience, disappointing news, and lack of follow-through. Promises not kept due to immaturity."},
	33: {"upright": "Bold action, adventure, and impetuous spirit. You follow your passions with overwhelming and immediate energy.", "reversed": "Aggression, recklessness, and mood swings. You are acting without thinking about the consequences."},
	34: {"upright": "Confidence, warmth, and social magnetism. Your presence lights up any place and attracts positive opportunities.", "reversed": "Insecurity, jealousy, or volatile temper. An influential person acting with malice or envy."},
	35: {"upright": "Vision, inspiring leadership, and entrepreneurship. You have the charisma needed to lead great projects.", "reversed": "Cruelty, arrogance, and abuse of power. A leader who has lost contact with reality."},

	# CUPS (Emotions: 36-49)
	36: {"upright": "New love, intuition, and emotional overflow. The heart opens to new and beautiful experiences.", "reversed": "Emotional block, lack of self-love, and disappointment. You are repressing your deepest feelings."},
	37: {"upright": "Union, romance, and mutual attraction. A special connection based on respect and balance.", "reversed": "Breakup, lack of harmony in the couple, and mistrust. The connection is broken by poor communication."},
	38: {"upright": "Friendship, group celebration, and community support. Happiness multiplies when shared with others.", "reversed": "Social excesses, isolation from the group, or infidelity. The party ended badly due to lack of limits."},
	39: {"upright": "Apathy, boredom, and meditation. You are ignoring the blessings the universe is currently offering you.", "reversed": "New motivation, emotional awakening, and leaving isolation. You start to value what you once ignored."},
	40: {"upright": "Grief, loss, and regret. You focus on what is lost instead of seeing what remains.", "reversed": "Acceptance, overcoming pain, and return of hope. You are ready to heal your wounds."},
	41: {"upright": "Nostalgia, happy memories, and purity. A meeting with the past that brings comfort and joy.", "reversed": "Living in the past, stagnation, and lack of maturity. You refuse to see the present reality."},
	42: {"upright": "Fantasy, multiple options, and illusion. Be careful with castles in the air; choose realistically.", "reversed": "Mental clarity, decision-making, and end of confusion. You finally see the reality behind the mask."},
	43: {"upright": "Emotional retreat, spiritual search, and abandonment. You leave behind what no longer fills your soul.", "reversed": "Fear of letting go, wandering without aim, and lack of purpose. You stay in a hollow situation."},
	44: {"upright": "Gratification, fulfilled desires, and satisfaction. You are in a moment of personal fulfillment and happiness.", "reversed": "Excessive indulgence, materialism, and lack of real satisfaction. You have what you wanted but feel empty."},
	45: {"upright": "Family happiness, harmony, and blessings. The culmination of an emotional path full of peace and love.", "reversed": "Domestic conflicts, lack of shared values, and loneliness. The family dream is falling apart."},
	46: {"upright": "Sensitivity, affectionate news, and dreams. A young person or a message brings sweetness to your life.", "reversed": "Emotional immaturity, deceptive seduction, and fragility. Someone is playing with your feelings."},
	47: {"upright": "Romantic invitation, charm, and search for beauty. You follow your ideals with your heart in hand.", "reversed": "Emotional manipulation, pathological jealousy, and inconstancy. The knight is an illusionist without real feelings."},
	48: {"upright": "Compassion, calm, and intuitive depth. A wise and loving woman offers comfort and guidance.", "reversed": "Emotional instability, martyrdom, or dishonesty. You feel overwhelmed by others' drama."},
	49: {"upright": "Emotional maturity, balance, and affective control. You lead with the heart but with a cool head.", "reversed": "Revenge, emotional coldness, and manipulation. A man using emotions as weapons of control."},

	# SWORDS (Mind: 50-63)
	50: {"upright": "Mental clarity, logical breakthrough, and absolute truth. A sharp new idea that clears all doubts.", "reversed": "Confusion, injustice, and destructive thoughts. You are using your intellect to hurt others or yourself."},
	51: {"upright": "Duality, truce, and mental paralysis. You need to make a decision but your eyes are blindfolded.", "reversed": "Open conflict, forced clarity, and end of indecision. The tension finally explodes."},
	52: {"upright": "Pain, betrayal, and heartbrokenness. A painful truth that needs to be accepted to heal.", "reversed": "Healing, forgiveness, and overcoming grief. Pain begins to transform into wisdom and learning."},
	53: {"upright": "Rest, recovery, and mental retreat. A pause is necessary before returning to the battle.", "reversed": "Extreme exhaustion, insomnia, and lack of rest. You are forcing yourself beyond your limits."},
	54: {"upright": "Defeat, dishonor, and conflict of interest. Winning the battle but losing the war through questionable methods.", "reversed": "End of conflict, regret, and desire for peace. You are ready to leave the fights behind."},
	55: {"upright": "Transition, necessary journey, and calm after the storm. Leaving problems behind for calmer waters.", "reversed": "Difficulty moving forward, burden of the past, and canceled trip. You take your problems with you."},
	56: {"upright": "Deception, strategy, and evasion. You are trying to get away with something without facing the truth.", "reversed": "Revelation of lies, cowardice, or return of something stolen. The truth finally comes to light."},
	57: {"upright": "Restriction, helplessness, and victimhood. You feel trapped by your own limiting thoughts.", "reversed": "Release, new perspective, and end of self-deception. You are breaking the bandages off your eyes."},
	58: {"upright": "Anxiety, nightmares, and guilt. You torment yourself over situations that may only exist in your head.", "reversed": "Overcoming fear, night clarity, and end of anguish. You begin to see light after the tunnel."},
	59: {"upright": "Painful ending, betrayal, and total defeat. You have hit rock bottom; the only way now is up.", "reversed": "Slow recovery, avoiding disaster, or resistance to the end. The worst is finally over."},
	60: {"upright": "Vigilance, mental sharpness, and curiosity. A young intellectual or news requiring cold analysis.", "reversed": "Gossip, hurtful sarcasm, and lack of tact. A brilliant mind used for destruction."},
	61: {"upright": "Direct action, fierce logic, and determination. You advance toward goals without letting emotions slow you.", "reversed": "Cruelty, violent impulsiveness, and fanaticism. You are acting with a coldness that scares others."},
	62: {"upright": "Mental independence, honesty, and astuteness. A woman who values truth over emotions.", "reversed": "Bitterness, excessive coldness, and poorly handled loneliness. A sharp tongue pushing everyone away."},
	63: {"upright": "Impartial judgment, intellectual authority, and discipline. You decide with law and logic in hand.", "reversed": "Abuse of power, mental tyranny, and injustice. A man using intelligence to oppress."},

	# PENTACLES (Material: 64-77)
	64: {"upright": "Prosperity, seed of abundance, and physical health. A solid material opportunity is before you.", "reversed": "Lost opportunity, greed, or financial instability. You lack a solid base for your current projects."},
	65: {"upright": "Adaptability, financial balance, and change. You are successfully handling multiple responsibilities.", "reversed": "Imbalance, lack of organization, and financial stress. You are trying to cover more than you can."},
	66: {"upright": "Teamwork, mastery, and recognition. Your skills are valued by experts and colleagues.", "reversed": "Lack of cooperation, mediocre work, and lack of skill. You are not paying attention to details."},
	67: {"upright": "Greed, possessiveness, and fear of loss. You cling so much to the material that you block yourself.", "reversed": "Wastefulness, loss of material control, and openness. You need to release money for it to flow."},
	68: {"upright": "Economic hardship, exclusion, and loss. You feel alone in the face of material or physical adversity.", "reversed": "Financial recovery, end of a negative streak, and support. Help arrives when least expected."},
	69: {"upright": "Generosity, balance, and charity. You give and receive fairly, maintaining the flow of abundance.", "reversed": "Debt, selfishness, or charity with conditions. There is an imbalance in what you give versus get."},
	70: {"upright": "Patience, evaluation, and harvest. You are waiting for the fruits of your labor to finally ripen.", "reversed": "Impatience, lack of reward, and useless effort. You feel frustrated by the slow results."},
	71: {"upright": "Diligence, detail, and constant learning. You are perfecting your technique with dedication and discipline.", "reversed": "Extreme perfectionism, work boredom, or lack of ambition. You are wasting time on insignificant details."},
	72: {"upright": "Financial independence, luxury, and self-sufficiency. You have achieved success through your own effort.", "reversed": "Economic dependency, excessive spending, and loneliness in success. Material security is just an appearance."},
	73: {"upright": "Legacy, family wealth, and lasting stability. You have built something that will transcend your life.", "reversed": "Loss of inheritance, family money conflicts, and ruin. The base of your security is unstable."},
	74: {"upright": "New financial goals and study. A young entrepreneur or positive news about finances.", "reversed": "Lack of focus, unrealistic goals, and news of loss. You are daydreaming about easy success."},
	75: {"upright": "Hard work, routine, and loyalty. You move step by step toward objectives with admirable consistency.", "reversed": "Stagnation, laziness, and lack of progress. You have become a slave to a dead-end routine."},
	76: {"upright": "Security, comfort, and material success. A practical woman who knows how to care for her environment.", "reversed": "Neglect, excessive materialism, and lack of order. You are losing contact with what truly matters."},
	77: {"upright": "Material power, abundance, and business success. You can turn anything you touch into gold.", "reversed": "Corruption, extreme greed, and loss of empire. A man who has everything but is spiritually poor."},
}
var nombres_cartas = [
	"The Fool", "The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lovers", "The Chariot", "Strength", "The Hermit", "Wheel of Fortune", "Justice", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World",
	"Ace of Wands", "Two of Wands", "Three of Wands", "Four of Wands", "Five of Wands", "Six of Wands", "Seven of Wands", "Eight of Wands", "Nine of Wands", "Ten of Wands", "Page of Wands", "Knight of Wands", "Queen of Wands", "King of Wands",
	"Ace of Cups", "Two of Cups", "Three of Cups", "Four of Cups", "Five of Cups", "Six of Cups", "Seven of Cups", "Eight of Cups", "Nine of Cups", "Ten of Cups", "Page of Cups", "Knight of Cups", "Queen of Cups", "King of Cups",
	"Ace of Swords", "Two of Swords", "Three of Swords", "Four of Swords", "Five of Swords", "Six of Swords", "Seven of Swords", "Eight of Swords", "Nine of Swords", "Ten of Swords", "Page of Swords", "Knight of Swords", "Queen of Swords", "King of Swords",
	"Ace of Pentacles", "Two of Pentacles", "Three of Pentacles", "Four of Pentacles", "Five of Pentacles", "Six of Pentacles", "Seven of Pentacles", "Eight of Pentacles", "Nine of Pentacles", "Ten of Pentacles", "Page of Pentacles", "Knight of Pentacles", "Queen of Pentacles", "King of Pentacles"
]
func _seleccionar_esta_carta(carta_elegida):
	if esta_presentando or lectura_actual >= 3 or not is_instance_valid(carta_elegida): 
		return 
	
	esta_presentando = true
	lectura_actual += 1
	
	var origen_global = mazo_arco.global_position
	if carta_elegida.get_parent():
		carta_elegida.get_parent().remove_child(carta_elegida)
	get_tree().root.add_child(carta_elegida)
	
	carta_elegida.pivot_offset = Vector2(65, 95)
	carta_elegida.global_position = origen_global - (carta_elegida.pivot_offset * carta_elegida.scale)
	carta_elegida.rotation = 0 
	
	var id_real = randi() % 78 
	var es_invertida = randf() > 0.5 
	var escala_ideal = 2.2 
	var pos_final = (get_viewport_rect().size / 2) - (carta_elegida.pivot_offset * escala_ideal)
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(carta_elegida, "global_position", pos_final, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tw.tween_property(carta_elegida, "scale", Vector2(escala_ideal, escala_ideal), 0.8)
	tw.tween_property(carta_elegida, "rotation", 0.0, 0.6) 
	
	tw.chain().tween_callback(func():
		
		_cargar_imagen(carta_elegida, "res://cartas/" + str(id_real) + ".jpeg")
		
		if is_instance_valid(label_descripcion):
			var is_rev = randf() > 0.5
			var state_label = "Upright" if not is_rev else "Reversed"
			
			var nombre_arcano = nombres_cartas[id_real]
			var card_data = significados[id_real]
			var meaning = card_data["upright"] if not is_rev else card_data["reversed"]
			
			
			label_descripcion.text = nombre_arcano + " (" + state_label + ")\n\n" + meaning
		
		if is_instance_valid(carta_elegida) and not carta_elegida.pressed.is_connected(_limpiar_para_siguiente):
			carta_elegida.pressed.connect(_limpiar_para_siguiente.bind(carta_elegida))
	)
func _cargar_imagen(nodo, ruta):
	if is_instance_valid(nodo) and FileAccess.file_exists(ruta):
		nodo.icon = load(ruta)
	else:
		print("Error: No se encuentra " + ruta)

func _limpiar_para_siguiente(carta):
	if is_instance_valid(carta):
		var tw_out = create_tween().set_parallel(true)
		tw_out.tween_property(carta, "modulate:a", 0.0, 0.3)
		
		if is_instance_valid(label_descripcion):
			tw_out.tween_property(label_descripcion, "modulate:a", 0.0, 0.3)
		
		tw_out.chain().tween_callback(func():
			carta.queue_free()
			esta_presentando = false 
			if is_instance_valid(label_descripcion):
				label_descripcion.text = ""
				label_descripcion.modulate.a = 1.0 
			if lectura_actual >= 3:
				_ir_a_pantalla_final()
		)
	else:
		esta_presentando = false

func _ir_a_pantalla_final():
	imagen_final.mouse_filter = Control.MOUSE_FILTER_STOP
	var tw = create_tween()
	tw.tween_property(imagen_final, "modulate:a", 1.0, 1.5)
	
	tw.chain().tween_callback(func():
		print("Pantalla final activa. Esperando 1 minuto...")
		await get_tree().create_timer(60.0).timeout
		
		get_tree().change_scene_to_file("res://scenas/Historia.tscn")
	)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenas/Historia.tscn")
