extends RichTextLabel

var lines = ["Hi there!", "This is a test.", "Good luck!"]

func set_lines(lines):
	self.lines = lines
	change_text()
	$TextAdvanceTimer.start()

func change_text():
	if len(lines) > 0:
		bbcode_text = "[center]" + lines.pop_front() + "[/center]"
	else:
		$TextAdvanceTimer.stop()

func _on_TextAdvanceTimer_timeout():
	change_text()
	
