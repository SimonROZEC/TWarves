extends DwarfState
signal target_reached
# Super-Etat permettant de définir un point vers lequel le nain 
# doit se déplacer

export(float) var normal_speed := 24.0

var _target: Vector2 = Vector2.INF
var velocity := Vector2.ZERO
var _current_speed := normal_speed

func physics_process(delta: float) -> void:
	pass


func enter(params := {}) -> void:
	pass


func exit() -> void:
	pass


# Indique un point vers lequel le nain va se déplacer
# Lorsque le point cible est atteint, un signal target_reached est lancé
func target(target: Vector2, speed := normal_speed) -> void:
	self._target = target
	self._current_speed = speed


# Le nain oublie le point qu'il cible et arrête de bouger
func forget_target() -> void:
	self._target = Vector2.INF


# Le nain se déplace vers son point cible à la vitesse qui lui est définie
func move_to_target(delta: float) -> void:
	if _target == Vector2.INF:
		return
	
	var diff := _target - dwarf.position
	var direction := diff.normalized()
	if diff.length() <= _current_speed * delta:
		dwarf.position = _target
		velocity = Vector2.ZERO
		emit_signal("target_reached")
		forget_target()
	else:
		velocity = direction * _current_speed
	dwarf.move_and_slide(velocity)
	dwarf.emit_signal("moved", dwarf.position)
