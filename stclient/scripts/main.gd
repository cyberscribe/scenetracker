extends Node

@onready var g: Node = get_node("/root/Global")
@onready var item:int = -1

@onready var tracker_list: ItemList = get_node("Interface/VBoxContainer/ScrollContainer/HBoxContainer/TrackerList")
@onready var server_display: RichTextLabel = get_node("Interface/VBoxContainer/ColorRect/ServerDisplay")
@onready var format_string = "Act %s Scene %s Page %s"
@onready var request_active: bool = false

func _ready() -> void:
    if len(g.labels) > 0:
        for scenes in g.labels:
            if scenes.size() == 3:
                tracker_list.add_item(format_string % [scenes[0], scenes[1], scenes[2]])
        tracker_list.select(0)
        item = 0

func _on_SettingsButton_pressed() -> void:
    pass

func _on_TrackerList_item_selected(index:int) -> void:
    item = index


func _on_GoButton_pressed() -> void:
    if item != -1 and item < len(g.labels):
        var scene = g.labels[item]
        #var label = format_string % [scene[0], scene[1], scene[2]]
        #print(str(item) + ". Executing " + label + "...")
        send_scene(scene[0], scene[1], scene[2])
        if (item + 1) < tracker_list.get_item_count():
            tracker_list.select(item + 1)
            item = item + 1
    tracker_list.grab_focus()

func send_scene(a: String, s: String, p: String) -> void:
    if request_active:
        return
    var url = g.url_base % [g.shared_secret, a, s, p]
    #print("Hitting " + url)
    $HTTPRequest.request(url)
    request_active = true

func _on_http_request_request_completed(result: int, response_code: int, __: PackedStringArray, body: PackedByteArray) -> void:
    request_active = false
    if result == OK and response_code == 200:
        var json = JSON.parse_string(body.get_string_from_utf8())
        if (json["success"]):
            #print("Success!")
            $HTTPUpdate.request(g.url_sync)
            return
    #print("Request error!")


func _on_http_update_request_completed(result: int, response_code: int, __: PackedStringArray, body: PackedByteArray) -> void:
    if result == OK and response_code == 200:
        var json = JSON.parse_string(body.get_string_from_utf8())
        var server_display_text = format_string % [json["a"], json["s"], json["p"]]
        server_display.set_text("[center]" + server_display_text)
        return
    #print("Sync error!")
