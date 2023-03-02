#01. tool
@tool
#02. class_name

#03. extends
extends "res://addons/godot-idea-board/context_menu/menu_base.gd"
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal copied
signal pasted
signal deleted()

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const INDEX_COPY:int = 0
const INDEX_PASTE:int = 1
const INDEX_DELETE:int = 2

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
@onready var _S = preload("res://addons/godot-idea-board/translation/translation.gd").get_translation_singleton(self)
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func _ready():
	super()

func init():
	_parent = get_parent()
	add_icon_item(_parent.get_icon("Duplicate"), _S.tr("Copy"), INDEX_COPY)
	add_icon_item(_parent.get_icon("ActionPaste"), _S.tr("Paste"), INDEX_PASTE)
	add_icon_item(_parent.get_icon("Remove"), _S.tr("Delete"), INDEX_DELETE)

func _on_index_pressed(index:int):
	match index:
		INDEX_COPY:
			copied.emit()
		INDEX_PASTE:
			pasted.emit()
		INDEX_DELETE:
			deleted.emit([])
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

