#Include Once "WindowChunk.bi"
#Include Once "Render/Button.bi"
#Include Once "GameContext.bi"
#Include Once "ChatList.bi"

Constructor WindowChunk(newW As Integer, newH As Integer, newO As Integer)
	this.wdth = newW
	this.hght = newH
	this.yOffset = newO
	
	/' Create buffer '/
	this.pBuf = ImageCreate(this.wdth, this.hght)
End Constructor



Sub WindowChunk.renderToScreen()
	Put (0, this.yOffset), this.pBuf, PSet
End Sub


Sub WindowChunk.cleanBuffer()
	/' Render black square over entire buffer '/
	Line this.pBuf, (0, 0) - (this.wdth-1, this.hght-1), RGB(0, 0, 0), BF
End Sub


Sub renderChunks(pMenu As WindowChunk Ptr, pMain As WindowChunk Ptr, _
                         pSChat As WindowChunk Ptr, pBChat As WindowChunk Ptr, _
                         aGC As Any Ptr)
	
	pMenu->cleanBuffer()
	pMain->cleanBuffer()
	pSchat->cleanBuffer()
	pBChat->cleanBuffer()
	
	renderMenuChunk(pMenu)
	renderMainChunk(pMain, aGC)
	renderSmallChatChunk(pSChat)
	renderBigChatChunk(pBChat, pSChat, @CPtr(GameContext Ptr, aGC)->chat)
End Sub


Sub renderMenuChunk(pMenu As WindowChunk Ptr)
	/' Background '/
	Line pMenu->pBuf, (0, 0) - (pMenu->wdth-1, pMenu->hght-1), RGB(100, 30, 10), BF
End Sub


Sub renderMainChunk(pMain As WindowChunk Ptr, aGC As Any Ptr)
	'Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	'If pGC->tabState = TabStates.serverState Then
	'	pGC->guic.serverScrn.buttons.renderButtons(aGC)
	'EndIf
End Sub


Sub renderSmallChatChunk(pSChat As WindowChunk Ptr)
	/' Background '/
	Line pSChat->pBuf, (0, 0) - (pSChat->wdth-1, pSChat->hght-1), RGB(30,100,30), BF
End Sub


Sub renderBigChatChunk(pBChat As WindowChunk Ptr, pSChat As WindowChunk Ptr, pChat As ChatList Ptr)
	/' Small chat background '/
	Dim As Integer y = pSChat->yOffset - pBChat->yOffset
	Line pBChat->pBuf, (0, y) - (pBChat->wdth-1, pBChat->hght-1), RGB(30, 100, 30), BF
	
	Dim As Integer bx = pBChat->wdth*0.76
	Dim As Integer by = pBChat->hght-1
	
	/' Tall chat background '/
	Line pBChat->pBuf, (0, 0) - (bx, by), RGB(30, 100, 30), BF
	
	/' Chat area '/
	Line pBChat->pBuf, (5, 5) - (pBChat->wdth*0.75, y-1), RGB(0, 7, 0), BF
	
	
	/' Chat '/
	/' Incrementing y level of chat lines '/
	Dim As Integer cy = 6
	/' Max width in characters of a line '/
	Dim As Integer mx = (pBChat->wdth*0.68)/8
	/' For tracking position in string '/
	Dim As Integer ix = 1
	/' Chat nodes '/
	Dim As ChatNode ptr pNode = pChat->pNode
	
	Color RGB(180, 220, 170)
	While cy+9 < y AND pNode <> 0
		Dim As String lineMsg
		/' Length of message '/
		Dim As Integer l = Len(pNode->toString())
		
		If mx >= l-ix Then
			/' Rest of message fits in chat line '/
			lineMsg = Right(pNode->toString(), l-ix+1)
			
			/' Reset counter and move to next message '/
			ix = 1
			pNode = pNode->pNext
			cy += 3
			Line pBChat->pBuf, (7, cy+9) - (mx*8, cy+9)
		
		Else
			/' Rest of message does not fit in chat line '/
			lineMsg = Mid(pNode->toString(), ix, mx)
			ix += mx
			
		EndIf
		
		If lineMsg = "" Then
			lineMsg = "..."
		EndIf
		Draw String pBChat->pBuf, (8, cy), lineMsg
		
		
		/' Next Line '/
		cy += 10
	Wend
End Sub


Sub initializeButtons(aGC As Any Ptr, pMenu As WindowChunk Ptr, pMain As WindowChunk Ptr, _
							 pSChat As WindowChunk Ptr, pBChat As WindowChunk Ptr)
	/' Cast '/
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	/' For use in creating memory for button nodes'/
	Dim As ButtonNode Ptr pButton = 0
	
	/' Add menu buttons '/
	/' Server button '/
	pButton = New ButtonNode()
	pButton->x = pMenu->wdth*0.02
	pButton->y = pMenu->yOffset + pMenu->hght*0.1
	pButton->wdth = pMenu->wdth*0.10
	pButton->hght = pMenu->hght*0.80 - 1
	pButton->actColor = RGB(210, 160, 90)
	pButton->inaColor = RGB(180, 140, 70)
	pButton->isEnabled = -1
	pButton->pOnDraw = @drawTextButton()
	pButton->text="Server"
	pGC->buttons.addButton(pButton)
	
	/' Game button '/
	pButton = New ButtonNode()
	pButton->x = pMenu->wdth*0.14
	pButton->y = pMenu->yOffset + pMenu->hght*0.1
	pButton->wdth = pMenu->wdth*0.10
	pButton->hght = pMenu->hght*0.80 - 1
	pButton->actColor = RGB(210, 160, 90)
	pButton->inaColor = RGB(180, 140, 70)
	pButton->isEnabled = 0
	pButton->pOnDraw = @drawTextButton()
	pButton->text = "Game"
	pGC->buttons.addButton(pButton)
	
	/' Chat button '/
	pButton = New ButtonNode()
	pButton->x = pMenu->wdth*0.26
	pButton->y = pMenu->yOffset + pMenu->hght*0.1
	pButton->wdth = pMenu->wdth*0.10
	pButton->hght = pMenu->hght*0.80 - 1
	pButton->actColor = RGB(210, 160, 90)
	pButton->inaColor = RGB(180, 140, 70)
	pButton->isEnabled = 0
	pButton->pOnDraw = @drawTextButton()
	pButton->text = "Chat"
	pGC->buttons.addButton(pButton)
	
	/' Team button '/
	pButton = New ButtonNode()
	pButton->x = pMenu->wdth*0.38
	pButton->y = pMenu->yOffset + pMenu->hght*0.1
	pButton->wdth = pMenu->wdth*0.10
	pButton->hght = pMenu->hght*0.80 - 1
	pButton->actColor = RGB(210, 160, 90)
	pButton->inaColor = RGB(180, 140, 70)
	pButton->isEnabled = 0
	pButton->pOnDraw = @drawTextButton()
	pButton->text = "Team"
	pGC->buttons.addButton(pButton)
	
	/' Options button '/
	pButton = New ButtonNode()
	pButton->x = pMenu->wdth*0.50
	pButton->y = pMenu->yOffset + pMenu->hght*0.1
	pButton->wdth = pMenu->wdth*0.10
	pButton->hght = pMenu->hght*0.80 - 1
	pButton->actColor = RGB(210, 160, 90)
	pButton->inaColor = RGB(180, 140, 70)
	pButton->isEnabled = -1
	pButton->pOnDraw = @drawTextButton()
	pButton->text = "Options"
	pGC->buttons.addButton(pButton)
	
	/' Exit button '/
	pButton = New ButtonNode()
	pButton->x = pMenu->wdth*0.62
	pButton->y = pMenu->yOffset + pMenu->hght*0.1
	pButton->wdth = pMenu->wdth*0.10
	pButton->hght = pMenu->hght*0.80 - 1
	pButton->actColor = RGB(210, 160, 90)
	pButton->inaColor = RGB(180, 140, 70)
	pButton->isEnabled = -1
	pButton->pOnDraw = @drawTextButton()
	pButton->pOnClick = @onClickExit()
	pButton->text = "Exit"
	pGC->buttons.addButton(pButton)
	
End Sub