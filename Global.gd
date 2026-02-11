extends Node
var usuario_dia : int = 0
var usuario_mes : int = 0

func registrar_datos(d: int, m: int):
	usuario_dia = d
	usuario_mes = m
	print("Datos anclados al sistema global: ", d, "/", m)
