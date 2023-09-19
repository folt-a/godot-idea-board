#01. tool
@tool
#02. class_name

#03. extends
extends VBoxContainer
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal pressed_save_button
signal pressed_group_button
signal pressed_text_document_button
signal pressed_label_button
signal color_changed_bg_color_picker_button(color)
signal changed_bg_image(texture:Texture2D)
signal color_changed_grid_color_picker_button(color)

signal pressed_lock_button
signal pressed_unlock_button

signal pressed_connect_button

signal changed_volume(float)
signal pressed_sound_play_button
signal pressed_sound_stop_button
signal toggled_sound_loop_button

signal aligned(dir:int)
signal distribute_h_aligned(dir:int)
signal distribute_v_aligned(dir:int)

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const bg_icon = preload("res://addons/godot-idea-board/icon/bg.svg")
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _graphedit

@onready var _S = preload("res://addons/godot-idea-board/translation/translation.gd").get_translation_singleton(self)
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var save_button:Button = %SaveButton
@onready var group_button:Button = %GroupButton
@onready var label_button:Button = %LabelButton
@onready var text_document_button:Button = %TextDocumentButton
@onready var bg_color_icon:Button = %BgColorIcon
@onready var bg_color_label:Label = %BgColorLabel
@onready var bg_color_picker_button:ColorPickerButton = %BgColorPickerButton
#@onready var bg_image_path_line_edit:LineEdit = %BgImagePathLineEdit
@onready var grid_color_icon:Button = %GridColorIcon
@onready var grid_color_label:Label = %GridColorLabel
@onready var grid_color_picker_button:ColorPickerButton = %GridColorPickerButton
@onready var lock_button:Button = %LockButton
@onready var unlock_button:Button = %UnlockButton
@onready var connect_button:Button = %ConnectButton

@onready var sound_label:Label = %SoundLabel
@onready var sound_h_slider:HSlider = %SoundHSlider
@onready var sound_play_button:Button = %SoundPlayButton
@onready var sound_stop_button:Button = %SoundStopButton
@onready var sound_loop_button:Button = %SoundLoopButton

@onready var left_align_button:Button = %LeftAlignButton
@onready var right_align_button:Button = %RightAlignButton
@onready var h_align_button:Button = %HAlignButton
@onready var top_align_button:Button = %TopAlignButton
@onready var bottom_align_button:Button = %BottomAlignButton
@onready var v_align_button:Button = %VAlignButton

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(graphedit):
	_graphedit = graphedit
	var header_large_font_size = _graphedit.editor_interface.get_editor_theme().get_font_size("font_size","HeaderLarge")
	var header_small_font_size = _graphedit.editor_interface.get_editor_theme().get_font_size("font_size","HeaderSmall")

	save_button.icon = _graphedit.get_icon("Save")
#	save_button.add_theme_font_override("font", _graphedit.main_font)
	save_button.add_theme_font_size_override("font_size", header_small_font_size)
	save_button.add_theme_color_override("icon_normal_color", Color.from_string("faaa24",Color.WHITE))
	save_button.add_theme_color_override("icon_pressed_color", Color.from_string("faaa24",Color.WHITE))
	save_button.add_theme_color_override("icon_hover_color", Color.from_string("faaa24",Color.WHITE))
	save_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("faaa24",Color.WHITE))
	save_button.add_theme_color_override("icon_focus_color", Color.from_string("faaa24",Color.WHITE))

	group_button.icon = _graphedit.get_icon("Viewport")
#	group_button.add_theme_font_override("font", _graphedit.main_font)
	group_button.add_theme_font_size_override("font_size", header_small_font_size)
	group_button.add_theme_color_override("icon_normal_color", Color.from_string("65b5ff",Color.WHITE))
	group_button.add_theme_color_override("icon_pressed_color", Color.from_string("65b5ff",Color.WHITE))
	group_button.add_theme_color_override("icon_hover_color", Color.from_string("65b5ff",Color.WHITE))
	group_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("65b5ff",Color.WHITE))
	group_button.add_theme_color_override("icon_focus_color", Color.from_string("65b5ff",Color.WHITE))

	label_button.icon = _graphedit.get_icon("Label")
#	label_button.add_theme_font_override("font", _graphedit.main_font)
	label_button.add_theme_font_size_override("font_size", header_small_font_size)
	label_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	label_button.add_theme_color_override("icon_pressed_color", Color.from_string("8eef97",Color.WHITE))
	label_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))
	label_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("8eef97",Color.WHITE))
	label_button.add_theme_color_override("icon_focus_color", Color.from_string("8eef97",Color.WHITE))

	text_document_button.icon = _graphedit.get_icon("Edit")
#	text_document_button.add_theme_font_override("font", _graphedit.main_font)
	text_document_button.add_theme_font_size_override("font_size", header_small_font_size)
	text_document_button.add_theme_color_override("icon_normal_color", Color.from_string("e589a4",Color.WHITE))
	text_document_button.add_theme_color_override("icon_pressed_color", Color.from_string("e589a4",Color.WHITE))
	text_document_button.add_theme_color_override("icon_hover_color", Color.from_string("e589a4",Color.WHITE))
	text_document_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("e589a4",Color.WHITE))
	text_document_button.add_theme_color_override("icon_focus_color", Color.from_string("e589a4",Color.WHITE))

	bg_color_icon.icon = bg_icon
	bg_color_icon.add_theme_color_override("icon_normal_color", Color.WHITE)
	bg_color_icon.add_theme_color_override("icon_pressed_color", Color.WHITE)
	bg_color_icon.add_theme_color_override("icon_hover_color", Color.WHITE)
	bg_color_icon.add_theme_color_override("icon_hover_pressed_color", Color.WHITE)
	bg_color_icon.add_theme_color_override("icon_focus_color", Color.WHITE)

#
	grid_color_icon.icon = _graphedit.get_icon("Grid")
	grid_color_icon.add_theme_color_override("icon_normal_color", grid_color_picker_button.color)
	grid_color_icon.add_theme_color_override("icon_pressed_color", grid_color_picker_button.color)
	grid_color_icon.add_theme_color_override("icon_hover_color", grid_color_picker_button.color)
	grid_color_icon.add_theme_color_override("icon_hover_pressed_color", grid_color_picker_button.color)
	grid_color_icon.add_theme_color_override("icon_focus_color", grid_color_picker_button.color)

	lock_button.icon = _graphedit.get_icon("Lock")
	lock_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	lock_button.add_theme_color_override("icon_pressed_color", Color.from_string("fada79",Color.WHITE))
	lock_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))
	lock_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("fada79",Color.WHITE))
	lock_button.add_theme_color_override("icon_focus_color", Color.from_string("fada79",Color.WHITE))

	unlock_button.icon = _graphedit.get_icon("Unlock")
	unlock_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	unlock_button.add_theme_color_override("icon_pressed_color", Color.from_string("fada79",Color.WHITE))
	unlock_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))
	unlock_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("fada79",Color.WHITE))
	unlock_button.add_theme_color_override("icon_focus_color", Color.from_string("fada79",Color.WHITE))


	connect_button.icon = _graphedit.get_icon("Curve2D")
	connect_button.add_theme_color_override("icon_normal_color", Color.from_string("e57cd8",Color.WHITE))
	connect_button.add_theme_color_override("icon_pressed_color", Color.from_string("e57cd8",Color.WHITE))
	connect_button.add_theme_color_override("icon_hover_color", Color.from_string("e57cd8",Color.WHITE))
	connect_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("e57cd8",Color.WHITE))
	connect_button.add_theme_color_override("icon_focus_color", Color.from_string("e57cd8",Color.WHITE))

	left_align_button.icon = _graphedit.get_icon("ControlAlignLeftWide")
	left_align_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	left_align_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))

	right_align_button.icon = _graphedit.get_icon("ControlAlignRightWide")
	right_align_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	right_align_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))

	top_align_button.icon = _graphedit.get_icon("ControlAlignTopWide")
	top_align_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	top_align_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))

	bottom_align_button.icon = _graphedit.get_icon("ControlAlignBottomWide")
	bottom_align_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	bottom_align_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))

	v_align_button.icon = _graphedit.get_icon("GuiTabMenuHl")
	v_align_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	v_align_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))

	var image:Image = _graphedit.get_icon("GuiTabMenuHl").get_image()
	image.rotate_90(CLOCKWISE)
	var image_texture = ImageTexture.create_from_image(image)
	h_align_button.icon = image_texture
	h_align_button.add_theme_color_override("icon_normal_color", Color.from_string("8eef97",Color.WHITE))
	h_align_button.add_theme_color_override("icon_hover_color", Color.from_string("8eef97",Color.WHITE))

	sound_play_button.icon = _graphedit.get_icon("Play")
	sound_play_button.add_theme_color_override("icon_normal_color", Color.from_string("1e86ff",Color.WHITE))
	sound_play_button.add_theme_color_override("icon_hover_color", Color.from_string("1e86ff",Color.WHITE))
	sound_stop_button.icon = _graphedit.get_icon("Stop")
	sound_stop_button.add_theme_color_override("icon_normal_color", Color.from_string("8e8677",Color.WHITE))
	sound_stop_button.add_theme_color_override("icon_hover_color", Color.from_string("8e8677",Color.WHITE))
	sound_loop_button.icon = _graphedit.get_icon("Loop")
	sound_loop_button.add_theme_color_override("icon_normal_color", Color.from_string("8e8677",Color.WHITE))
	sound_loop_button.add_theme_color_override("icon_hover_color", Color.from_string("8e8677",Color.WHITE))

func _ready():
	save_button.pressed.connect(func():self.pressed_save_button.emit())
	group_button.pressed.connect(func():self.pressed_group_button.emit())
	label_button.pressed.connect(func():self.pressed_label_button.emit())
	text_document_button.pressed.connect(func():self.pressed_text_document_button.emit())
	bg_color_picker_button.color_changed.connect(_on_color_changed_bg_color_picker_button)
	grid_color_picker_button.color_changed.connect(_on_color_changed_grid_color_picker_button)
#	bg_image_path_line_edit.text_changed.connect(_on_text_changed_bg_image_path_line_edit)

	lock_button.pressed.connect(func():self.pressed_lock_button.emit())
	unlock_button.pressed.connect(func():self.pressed_unlock_button.emit())

	connect_button.pressed.connect(func():self.pressed_connect_button.emit())

	left_align_button.pressed.connect(_on_pressed_aligned_button.bind("4"))
	right_align_button.pressed.connect(_on_pressed_aligned_button.bind("6"))
	top_align_button.pressed.connect(_on_pressed_aligned_button.bind("8"))
	bottom_align_button.pressed.connect(_on_pressed_aligned_button.bind("2"))
	h_align_button.pressed.connect(func():self.distribute_h_aligned.emit())
	v_align_button.pressed.connect(func():self.distribute_v_aligned.emit())
	sound_h_slider.value_changed.connect(func(value):self.changed_volume.emit(value))

	sound_play_button.pressed.connect(func():self.pressed_sound_play_button.emit())
	sound_stop_button.pressed.connect(func():self.pressed_sound_stop_button.emit())
	sound_loop_button.toggled.connect(func(button_press):self.toggled_sound_loop_button.emit(button_press))

	_translate()

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

func _on_color_changed_bg_color_picker_button(color:Color):
	bg_color_icon.add_theme_color_override("icon_normal_color", color)
	bg_color_icon.add_theme_color_override("icon_hover_color", color)
	self.color_changed_bg_color_picker_button.emit(color)

func _on_color_changed_grid_color_picker_button(color:Color):
	grid_color_icon.add_theme_color_override("icon_normal_color", color)
	grid_color_icon.add_theme_color_override("icon_hover_color", color)
	self.color_changed_grid_color_picker_button.emit(color)

#func _on_text_changed_bg_image_path_line_edit(new_text:String):
#	if !FileAccess.file_exists(new_text): return
#	var texture = load(new_text)
#	if texture is Texture2D:
#		changed_bg_image.emit(texture)

func _on_pressed_aligned_button(dir:String):
	aligned.emit(dir)

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func get_data() -> Dictionary:
	var data = {
		"bg_color" = bg_color_picker_button.color.to_html(true),
		"grid_color" = grid_color_picker_button.color.to_html(true),
		"sound_volume" = sound_h_slider.value,
	}
	return data
#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

#
# 翻訳
#
func _translate():
	save_button.text = _S.tr("canvas_menu_save_button")
	group_button.text = _S.tr("canvas_menu_group_button")
	label_button.text = _S.tr("canvas_menu_label_button")
	text_document_button.text = _S.tr("canvas_menu_text_document_button")
	bg_color_label.text = _S.tr("canvas_menu_bg_color_label")
	lock_button.text = _S.tr("canvas_menu_lock_button")
	unlock_button.text = _S.tr("canvas_menu_unlock_button")
	connect_button.text = _S.tr("canvas_menu_connect_button")
	sound_label.text = _S.tr("canvas_menu_sound_label")
