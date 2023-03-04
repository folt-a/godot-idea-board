# Based:
# https://github.com/coppolaemilio/dialogic
# https://github.com/coppolaemilio/dialogic/blob/dialogic-1/addons/dialogic/Documentation/Nodes/DocsMarkdownParser.gd

#01. tool
@tool
#02. class_name

#03. extends
extends Node
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const heading1_font = "48"
const heading2_font = "36"
const heading3_font = "24"
const heading4_font = "18"
const heading5_font = "18"
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------

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
	pass

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
var accent_color := Color.from_string("#42ffc2",Color.WHITE)
var sub_accent_color := Color.from_string("#fd6f84",Color.WHITE)
#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
var heading1s = []
var heading2s = []
var heading3s = []
var heading4s = []
var heading5s = []
var result = ""
var bolded = []
var italics = []
var striked = []
var coded = []
var linknames = []
var links = []
var imagenames = []
var imagelinks = []
var lists = []
var underlined = []

var editor_scale := 1.0

################################################################################
##							PUBLIC FUNCTIONS 								  ##
################################################################################

#func set_accent_colors(new_accent_color : Color, new_sub_accent_color : Color) -> void:
#	accent_color = new_accent_color
#	sub_accent_color = new_sub_accent_color

### Takes a markdown string and returns it as BBCode
func parse(content : String, max_width:int = 0,  file_path:String = '', docs_path:String = ''):

	heading1s = []
	heading2s = []
	heading3s = []
	heading4s = []
	heading5s = []
	result = ""
	bolded = []
	italics = []
	striked = []
	coded = []
	linknames = []
	links = []
	imagenames = []
	imagelinks = []
	lists = []
	underlined = []

	var parsed_text = content

	var regex = RegEx.new()

	## Remove all comments
	# TODO: remove comments <!-- -->


	## Find all occurences of bold text
	regex.compile('\\*\\*(?<boldtext>(\\.|[^(\\*\\*)])*)\\*\\*')
	result = regex.search_all(content)
	if result:
		for res in result:
			parsed_text = parsed_text.replace("**"+res.get_string("boldtext")+"**","[b]"+res.get_string("boldtext")+"[/b]")

	## Find all occurences of underlined text
	regex.compile('\\_\\_(?<underlinetext>.*)\\_\\_')
	result = regex.search_all(content)
	if result:
		for res in result:
			parsed_text = parsed_text.replace("__"+res.get_string("underlinetext")+"__","[u]"+res.get_string("underlinetext")+"[/u]")

	## Find all occurences of italic text
	regex.compile("\\*(?<italictext>[^\\*]*)\\*")
	result = regex.search_all(content)
	if result:
		for res in result:
			parsed_text = parsed_text.replace("*"+res.get_string('italictext')+'*', "[i]"+res.get_string('italictext')+"[/i]")
#			italics.append(res.get_string("italictext"))
#	for italic in italics:
#		content = content.replace("*"+italic+"*",)


	## Find all occurences of underlined text
	regex.compile("~~(?<strikedtext>.*)~~")
	result = regex.search_all(content)
	if result:
		for res in result:
			parsed_text = parsed_text.replace("~~"+res.get_string("strikedtext")+"~~","[s]"+res.get_string("strikedtext")+"[/s]")

	## Find all occurences of code snippets
	regex.compile("(([^`]`)|(```))(?<coded>[^`]+)(?(2)(`)|(```))")
	result = regex.search_all(content)
	if result:
		for res in result:
			if res.get_string().begins_with("```"):
				parsed_text = parsed_text.replace("```"+res.get_string("coded")+"```","[indent][code]"+res.get_string("coded")+"[/code][/indent]")
			else:
				parsed_text = parsed_text.replace("`"+res.get_string("coded")+"`","[code]"+res.get_string("coded")+"[/code]")

	## Find all occurences of list items
	regex.compile("\\n\\s*(?<symbol>[-+*])(?<element>\\s.*)")
	result = regex.search_all(parsed_text)
	if result:
		for res in result:
			var symbol = res.get_string('symbol')
			var element = res.get_string("element")
			if parsed_text.find(symbol+" "+element):
				parsed_text = parsed_text.replace(symbol+element,"[indent]" + symbol + " "+element+"[/indent]")



	## Find all occurences of images
	regex.compile("!\\[(?<imgname>.*)\\]\\((?<imglink>.*)\\)")
	result = regex.search_all(content)
	if result:
		for res in result:
			if res.get_string("imglink")!="":
				imagelinks.append(res.get_string("imglink"))
			if res.get_string("imgname")!="":
				imagenames.append(res.get_string("imgname"))

	## Find all occurences of links (that are not images)
	regex.compile("[^!]\\[(?<linkname>[^\\[]+)\\]\\((?<link>[^\\)]*\\S*?)\\)")
	result = regex.search_all(content)
	if result:
		for res in result:
			if res.get_string("link")!="":
				links.append(res.get_string("link"))
			if res.get_string("linkname")!="":
				linknames.append(res.get_string("linkname"))

	## Find all heading1s
	regex.compile("(?:\\n|^)#(?<heading>[^#\\n]+[^\\n]+)")
	result = regex.search_all(content)
	if result:
		for res in result:
			var heading = res.get_string("heading")
			heading1s.append(heading)
			parsed_text = parsed_text.replace("#"+heading, "[b][font size="+heading1_font+"]"+heading.strip_edges()+"[/font][/b]")

	## Find all heading2s
	regex.compile("(?:\\n|^)##(?<heading>[^#\\n]+[^\\n]+)")
	result = regex.search_all(content)
	if result:
		for res in result:
			var heading = res.get_string("heading")
			heading2s.append(heading)
			parsed_text = parsed_text.replace("\n##"+heading, "\n[b][font size="+heading2_font+"]"+heading.strip_edges()+"[/font][/b]")

	## Find all heading3s
	regex.compile("(?:\\n|^)###(?<heading>[^#\\n]+[^\\n]+)")
	result = regex.search_all(content)
	if result:
		for res in result:
			var heading = res.get_string("heading")
			parsed_text = parsed_text.replace("\n###"+heading,  "\n[b][font size="+heading3_font+"]"+heading.strip_edges()+"[/font][/b]")

	## Find all heading4s
	regex.compile("(?:\\n|^)####(?<heading>[^#\\n]+[^\\n]+)")
	result = regex.search_all(content)
	if result:
		for res in result:
			var heading = res.get_string("heading")
			parsed_text = parsed_text.replace("\n####"+heading, "\n[b][font size="+heading4_font+"]"+heading.strip_edges()+"[/font][/b]")


	## Find all heading5s
	regex.compile("(?:\\n|^)#####(?<heading>[^#\\n]+[^\\n]+)")
	result = regex.search_all(content)
	if result:
		for res in result:
			var heading = res.get_string("heading")
			parsed_text = parsed_text.replace("\n#####"+heading, "\n[b][font size="+heading5_font+"]"+heading.strip_edges()+"[/font][/b]")

	for i in links.size():
		parsed_text = parsed_text.replace("["+linknames[i]+"]("+links[i]+")","[color=#"+accent_color.to_html()+"][url="+links[i]+"]"+linknames[i]+"[/url][/color]")

	for i in imagenames.size():
		var imagelink_to_use = imagelinks[i]
#		if imagelink_to_use.begins_with("http"):
#			var path_parts = imagelink_to_use.split("/Documentation/")
#			if path_parts.size() > 1:
#				imagelink_to_use = docs_path +"/"+ path_parts[1]
#			else:
#				imagelink_to_use = "icon.png"
		if imagelink_to_use.begins_with(".") and file_path:
			imagelink_to_use = file_path.trim_suffix(file_path.get_file()).trim_suffix("/") + imagelink_to_use.trim_prefix(".")
		parsed_text = parsed_text.replace("!["+imagenames[i]+"]("+imagelinks[i]+")","[img="+str(max_width)+"]"+imagelink_to_use+"[/img]")

#	parsed_text += "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

	return parsed_text
