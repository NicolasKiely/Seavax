/'----------------------------------------------------------------------------
 ' Manages hi-level rendering of window parts
 ' Window chunks are stacked vertically on each other
 ---------------------------------------------------------------------------'/

#Include Once "../ChatList.bi"

/' Screen Dimensions '/
#Define SCRN_WDTH 640
#Define SCRN_HGHT 480 
 
 /' GUI chunk sizes '/
#Define MENU_CHUNK_HEIGHT  (20)
#Define SCHAT_CHUNK_HEIGHT (26)
#Define BCHAT_CHUNK_HEIGHT (150)
#Define MAIN_CHUNK_HEIGHT  (SCRN_HGHT - (MENU_CHUNK_HEIGHT + SCHAT_CHUNK_HEIGHT))


/' GUI button sizes '/



Type WindowChunk
	/' Buffer to render to '/
	Dim As UInteger Ptr pBuf
	
	/' Height of buffer '/
	Dim As Integer hght
	
	/' Width of buffer (screen width) '/
	Dim As Integer wdth
	
	/' y Offset of buffer '/
	Dim As Integer yOffset
	
	/' Initializes window chunk and buffer '/
	Declare Constructor(newW As Integer, newH As Integer, newO As Integer)
	
	/' Renders buffer to screen '/
	Declare Sub renderToScreen()
	
	/' Cleans buffer '/
	Declare Sub cleanBuffer()
End Type


/'----------------------------------------------------------------------------
 ' Main rendering function
 ' Calls menu render fnc, main render fnc, and chat render fnc
 ---------------------------------------------------------------------------'/
Declare Sub renderChunks(pMenu As WindowChunk Ptr, pMain As WindowChunk Ptr, _
                         pSChat As WindowChunk Ptr, pBChat As WindowChunk Ptr, _
                         aGC As Any Ptr)


/'----------------------------------------------------------------------------
 ' Renders the top menu
 ---------------------------------------------------------------------------'/
Declare Sub renderMenuChunk(pMenu As WindowChunk Ptr)


/'----------------------------------------------------------------------------
 ' Renders the main chunk of the screen
 ---------------------------------------------------------------------------'/
Declare Sub renderMainChunk(pMain As WindowChunk Ptr, aGC As Any Ptr)


/'----------------------------------------------------------------------------
 ' Renders the small version of the chat bar
 ---------------------------------------------------------------------------'/
Declare Sub renderSmallChatChunk(pSChat As WindowChunk Ptr)


/'----------------------------------------------------------------------------
 ' Renders the big version of the chat bar
 ---------------------------------------------------------------------------'/
Declare Sub renderBigChatChunk(pBChat As WindowChunk Ptr, _
										 pSChat As WindowChunk Ptr, _
										 pChat As ChatList ptr)


/'----------------------------------------------------------------------------
 ' Initializes buttons
 ---------------------------------------------------------------------------'/
Declare Sub initializeButtons(aGC As Any Ptr, pMenu As WindowChunk Ptr, _
										pMain As WindowChunk Ptr, pSChat As WindowChunk Ptr, _
										pBChat As WindowChunk Ptr)