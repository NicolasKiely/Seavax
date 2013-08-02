/'----------------------------------------------------------------------------
 ' Manges top-level GUI for game context
 ---------------------------------------------------------------------------'/

#Include Once "Render/ServerScreen.bi"
#Include Once "Render/ChatChunk.bi"
 
Type GUIContext
	/' Cursor position in text field '/
	Dim As Integer textPos
	
	/' Menu screen gui controllers '/
	Dim As ServerScreen serverScrn
	
	/' Chat chunk manager '/
	Dim As ChatChunk chatChk
	
	/' Whether using big chat or small chat window '/
	Dim As Integer expandChat
End Type
