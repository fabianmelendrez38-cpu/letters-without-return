extends Control

@onready var fondo = $TextureRect 
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

	var anio_presente = Time.get_date_dict_from_system()["year"]

	if Global.usuario_dia == 0:
		etiqueta_info.text = "POR FAVOR COMPLETA TUS DATOS CON PRECISIÓN PARA LA MAGIA"
		return

	var suma = Global.usuario_dia + Global.usuario_mes + anio_presente
	var id = _reducir(suma)
	_revelar_con_efectos(id, anio_presente)

func _process(delta):
	if fondo:
		fondo.rotation += 0.3 * delta 
		var pulso = 1.0 + (sin(Time.get_ticks_msec() * 0.002) * 0.05)
		fondo.scale = Vector2(pulso, pulso) 
		fondo.modulate = Color.from_hsv(sin(Time.get_ticks_msec() * 0.0005) * 0.5 + 0.5, 0.4, 1.0)

func _reducir(n):
	while n > 21:
		var s = 0
		for d in str(n): s += int(d)
		n = s
	return n

func _revelar_con_efectos(id, anio):
	var nombres = ["The Fool", "The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lovers", "The Chariot", "Strength", "The Hermit", "Wheel of Fortune", "Justice", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World"];
	var descripciones = [
	"Represents pure potential and the leap of faith. Psychologically, it is the inner child archetype that dares to be free, without fear of judgment. Practically, it signals new beginnings, travels, or spontaneous decisions that break the routine. Spiritually, it is the soul before incarnation, reminding us that detachment is true freedom. It is blind faith in the universe; the start of a journey where the path is built by walking, without a compass but with total enthusiasm. It invites you to trust the unknown and embrace the infinite possibilities that arise when you let go of certainty.",
	"Symbolizes the power of manifestation. Psychologically, it is self-confidence and the awareness of our skills. On a practical level, it indicates that you have all the necessary tools to start a project or solve a problem with ingenuity. Spiritually, it acts as a bridge between heaven and earth, reminding us that our will is sacred. He is the alchemist who transforms ideas into matter; he tells us that we are the architects of our reality and the time to act is now. It is the spark of creation that aligns mind, body, and spirit toward a goal.",
	"Embodies mystery and intuitive wisdom. Psychologically, she represents access to the subconscious and the need to listen to the inner voice. Practically, she suggests waiting, silence, and observation before acting; not everything has come to light yet. Spiritually, she is the guardian of hidden knowledge and the connection to the divine feminine. She invites us to look beyond appearances and to trust what we feel more than what we see or logically reason. It is the power of the unseen and the profound wisdom that only surfaces when the mind is quiet and the heart is open.",
	"The representation of abundance and creativity. Psychologically, it is linked to the capacity to nurture ideas and self-love. In daily life, it speaks of fertility, beauty, comfort, and sensory pleasures. From a spiritual standpoint, she is Mother Earth reminding us that life is a cycle of constant growth. She teaches us that to harvest we must care for the land and that enjoyment is a legitimate form of connection with existence and gratitude. It is the blossoming of nature and the realization that we are worthy of receiving all the riches the universe offers.",
	"Symbolizes structure and authority. Psychologically, he represents the 'father' figure or the internal order that gives us security. Practically, he indicates leadership, financial stability, and the need to set boundaries or follow an organized plan. Spiritually, he is the mastery of will over chaos, the power to protect what has been built. He reminds us that for an idea to endure, it needs solid foundations and discipline. He is the force that sustains the material world through law and reason, providing the necessary framework for expansion and long-term success in any endeavor.",
	"Represents tradition and teaching. Psychologically, it is the system of values and inherited beliefs that give us identity. Practically, he can point to mentors, institutions, weddings, or the need to conform to certain social norms. Spiritually, he acts as a bridge to the sacred through ritual and study. He teaches us that we are not alone on the path; there is collective wisdom and a lineage of knowledge that can guide us if we are willing to be students. It is the search for meaning within established structures and the transmission of sacred truths to the next generation.",
	"Deals with choice and harmony. Psychologically, it reflects the integration of internal opposites and the desire for union. In daily life, it is usually associated with romantic relationships, but also with crossroads where we must choose according to our values. Spiritually, it is the law of attraction and free will. It teaches us that every decision made out of love brings us closer to our essence, while decisions made out of fear pull us away. It is the mirror where we see who we are through the other, demanding total honesty and alignment with our heart's deepest truth.",
	"Represents triumph and direction. Psychologically, it is determination and the ego under the control of the will. Practically, it indicates success after effort, travel, or overcoming obstacles through total focus. Spiritually, it is the soul's advancement toward its destiny, managing life's opposing forces with balance. It reminds us that victory is not luck, but the result of aligning our emotions and thoughts toward a single objective, moving forward without looking back. It is the courageous warrior who understands that true power comes from internal discipline and the unwavering commitment to one's own chosen path.",
	"The mastery of animal nature through compassion. Psychologically, it represents resilience and emotional intelligence against instinct. Practically, it suggests that problems will be solved with patience and soft power, not violence. Spiritually, it is the power of love and gentleness over brute force. It teaches us that true courage is not the absence of fear or passion, but the ability to tame our internal lions with tenderness and silent bravery. It is the inner fortitude that allows us to endure challenges with grace, proving that the heart's endurance is the most potent force in the world.",
	"Symbolizes withdrawal and introspection. Psychologically, it is the search for personal truth away from social noise. In daily life, it indicates a time of necessary solitude, deep study, or seeking wise counsel. Spiritually, he represents the inner light that guides the path in the dark. He reminds us that the most important answers are not outside, but in the silence of our own being. It is the wisdom acquired through experience and the renunciation of the superfluous to reach the core of existence. By walking alone, we find the universal light that connects all living things.",
	"Represents change and inevitable cycles. Psychologically, it is our attitude toward the unexpected and the acceptance of change. Practically, it points to turns of fate, strokes of luck, or the end of a stage. Spiritually, it is the law of Karma and the understanding that everything flows. It teaches us that nothing is permanent and that being 'up' or 'down' is part of the game of life; the important thing is to find the center of the wheel, where nothing moves. It invites us to detach from outcomes and trust that every turn brings a valuable lesson for our evolution.",
	"Symbolizes balance and truth. Psychologically, it is honesty with oneself and a sense of responsibility. In everyday life, it refers to legal matters, contracts, or the need to make an objective and fair decision. Spiritually, it is the cosmic adjustment where every action has its consequence. It reminds us that we must be upright and that, sooner or later, the truth comes to light. It is the cut of the sword that separates what serves from what no longer does, teaching us that clarity and integrity are the only ways to achieve lasting peace and universal equilibrium.",
	"Represents sacrifice and a new perspective. Psychologically, it is the ability to let go of control and see things from another angle. Practically, it indicates a period of stagnation or voluntary waiting where nothing can be forced. Spiritually, it is surrender to the universe and enlightenment through a pause. It teaches us that sometimes, to win, one must know how to lose, and that inaction can be a profound form of progress if done with awareness. By suspending our ego, we allow a higher wisdom to flow through us, transforming our understanding of the world completely.",
	"Symbolizes radical transformation. Psychologically, it is the process of letting parts of our identity die that no longer function. In daily life, it indicates the end of a situation to make way for the new. Spiritually, it is rebirth; the caterpillar turning into a butterfly. It teaches us that change is the only constant and that for something to be born, something must die. It is not an end, but a transition necessary for the soul's evolution. By accepting the death of the old, we unlock the door to regeneration and the profound mystery of life's eternal, changing nature.",
	"It is alchemy and balance. Psychologically, it represents healing and the moderation of extremes. Practically, it suggests patience, diplomacy, and the blending of ideas to create something better. Spiritually, it is the angel that guides our energies to find the middle ground and inner peace. It teaches us that life is a process of constant mixing and that harmony is achieved by flowing between polarities without letting either dominate us completely. It is the calm after the storm, the steady hand that pours the water of life between vessels, creating a perfect and divine synthesis of being.",
	"Represents the shadow and attachments. Psychologically, these are our addictions, fears, and repressed desires. In everyday life, it points to obsessions, excessive materialism, or situations where we feel trapped by our own will. Spiritually, he is the teacher who shows us where we have lost our freedom in exchange for pleasure or security. He teaches us that the chains are usually loose; recognizing our darkness is the first step to freeing ourselves and reclaiming our personal power. It is an invitation to explore our limitations and break the illusions that keep us from reaching our true spiritual potential.",
	"Symbolizes the breaking of false structures. Psychologically, it is the collapse of limiting beliefs or the ego. Practically, it indicates sudden change, shock, or forced liberation from an unsustainable situation. Spiritually, it is a blessing in disguise that destroys the old so the truth can emerge. It teaches us that we cannot build on weak foundations and that, although the fall is painful, it frees us from a prison we built ourselves without realizing it. It is the lightning bolt of revelation that clears the path for a construction based on absolute truth and authentic spiritual values.",
	"Represents hope and inspiration. Psychologically, it is the recovery of faith and sense of purpose after a crisis. In daily life, it points to blessings, clarity, and moments of peace and beauty. Spiritually, it is the direct connection with divine guidance and the healing of the soul. It reminds us that there is always a light in the dark and that if we are authentic and vulnerable like the figure in the card, the universe will provide everything necessary for our renewal. It is the quiet confidence that we are being guided toward a future filled with grace and infinite possibilities.",
	"Symbolizes the subconscious and illusion. Psychologically, these are our deepest fears, dreams, and insecurities. In daily life, it warns of confusion, deception, or situations where not everything is as it seems. Spiritually, it is the journey through the dark night of the soul to purify intuition. It teaches us to walk in the dark trusting our instincts and to accept that uncertainty is part of the path; it is the reflected light that forces us to look inward. Only by facing the shadows of the night can we truly appreciate the coming of the dawn's clarity.",
	"Represents success and joy. Psychologically, it is mental clarity and radiant self-expression. Practically, it indicates happiness, vitality, achievements, and transparent, warm relationships. Spiritually, it is the awakening to truth and union with the source of life. It teaches us that simplicity and gratitude are the keys to fulfillment. It is the moment where everything is illuminated, shadows disappear, and we can celebrate our existence with the purity and enthusiasm of a child. It is the ultimate affirmation of life, success, and the realization that we are one with the light that sustains the entire cosmos.",
	"Symbolizes the calling and redemption. Psychologically, it is the moment of self-evaluation and awakening to a new consciousness. In daily life, it indicates an important decision that changes life or the resurgence of something from the past. Spiritually, it is the internal final judgment where we forgive and are forgiven to be reborn. It teaches us that there is always an opportunity to rectify and that listening to our vocational calling is essential to feel complete and at peace with our history. It is the trumpet sound that wakes the soul to its true purpose and highest destiny.",
    "Represents realization and closure. Psychologically, it is the sense of integrity and having reached a goal. Practically, it indicates total success, international travel, or the perfect end of a cycle. Spiritually, it is the cosmic dance where the individual merges with the whole. It teaches us that we are part of a larger design and that every experience has prepared us for this moment of fulfillment. It is the victory of consciousness that has completed its journey and is ready to begin again. Here, the traveler finds that the end is merely the beginning of an even greater adventure."
];
	etiqueta_info.text = "IN THE YEAR" + str(anio) + " YOUR TAROT CARD IS: " + nombres[id]
	if etiqueta_desc:
		etiqueta_desc.text = descripciones[id]
	
	var ruta = "res://cartas/" + str(id) + ".jpeg"
	if FileAccess.file_exists(ruta):
		carta_visual.texture = load(ruta)
		carta_visual.modulate.a = 0
		var tw = create_tween()
		tw.tween_property(carta_visual, "modulate:a", 1.0, 1.5) 


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenas/Historia.tscn")
