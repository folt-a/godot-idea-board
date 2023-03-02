## This class exists for the sole purpose of circunventing an apparent bug on TranslationServer where translations doesn't work at all in editor plugins
## このクラスは、エディタープラグインで翻訳がまったく機能しないTranslationServerの明らかなバグを回避することを唯一の目的として存在します。
## As soon as this bug on godot is fixed (or we realize that in fact we where doing something wrong all along) this class should be discarded and all "S.tr" strings in the project should be replaced by "tr"
## godotのこのバグが修正されるとすぐに（または、実際に何か間違ったことをしていることに気づいたら）、このクラスを破棄し、プロジェクト内のすべての「S.tr」文字列を「tr」に置き換える必要があります。

extends Node

var strings_dict:Dictionary = {}

const _locale_csv_path := "res://addons/godot-idea-board/translation/translation.csv"
const _this_script_path := "res://addons/godot-idea-board/translation/translation.gd"

func load_strings()->void:
	## loads the strings dictionary from the default strings csv file
	## デフォルトの文字列csvファイルから文字列辞書をロードします
	var f:FileAccess = FileAccess.open(_locale_csv_path, FileAccess.READ)
	strings_dict = {} # replace previous dictionary
	var header = Array(f.get_csv_line())
	header[0] = "id"

	while true: # loop csv lines
		var line = f.get_csv_line()
		if line.size() < 1 or (line.size() == 1 and line[0] == ""):
			if f.eof_reached():
				break
			else:
				continue

		var count = -1
		var id = line[0]
		var subdict = {}
		strings_dict[id] = subdict
		for lang in header:
			count += 1
			if lang == "id":
				continue
			subdict[lang] = line[count].replace("\\n","\n")


func tr(id:StringName, context: StringName = StringName(""))->String:
	## shorthand for the translate method
	## mimics the behavior of Object.tr(message:String)
	## translateメソッドの省略形
	## Object.tr(message:String) の動作を模倣します
	return translate(id)


func translate(id:String)->String:
	## mimics the behavior of TranslationServer.translate(message:String)
	## TranslationServer.translate(message:String) の動作を模倣します
	if not strings_dict is Dictionary or strings_dict.size() < 1:
#		print("warning: strings not yet loaded")
		load_strings()

	if not id in strings_dict:
		print("warning: there is no id '%s' in the strings dictionary" % id)
		return id

	var translations:Dictionary = strings_dict[id]
	var locale:String = TranslationServer.get_locale()
	if not locale in translations:
#		print("warning: there is no locale '%s' for id '%s'" % [locale, id])
#		FALLBACK!
		return translations["en"]

	var trans:String = translations[locale]
#	print("id '%s' sucessfully translated on locale '%s' to '%s'" % [id, locale, trans])
	return trans


static func get_translation_singleton(node:Node, add_child_deferred:bool=true)->Node:
	var S = node.get_node_or_null("/root/S")
	if S:
		return S

	S = load(_this_script_path).new()
	S.name = "S"
	if add_child_deferred: # create a singleton to be used by the plugin
		node.get_tree().root.call_deferred('add_child', S, true)
	else:
		node.get_tree().root.add_child(S, true) # create a singleton to be used by the plugin
	return S
