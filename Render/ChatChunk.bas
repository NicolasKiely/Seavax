#Include Once "ChatChunk.bi"
#Include Once "GameContext.bi"
#Include Once "Button.bi"


Sub ChatChunk.setUpChunk(aGC As Any Ptr, pSChunk As WindowChunk Ptr, pBChunk As WindowChunk Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pSChat = pSChunk
	pBChat = pBChunk
	
	/' Set up chat text field '/
	this.pChatBtn = New ButtonNode()
	this.pChatBtn->x = pSChat->wdth*0.01
	this.pChatBtn->y = pSChat->yOffset + pSChat->hght*0.1
	this.pChatBtn->wdth = pSChat->wdth*0.74
	this.pChatBtn->hght = pSChat->hght*0.80 - 1
	this.pChatBtn->actColor = RGB(20, 20, 40)
	this.pChatBtn->inaColor = RGB(15, 15, 30)
	this.pChatBtn->isEnabled = -1
	this.pChatBtn->text = ""
	this.pChatBtn->pOnClick = @onClickTextBox()
	this.pChatBtn->pOnDraw = @drawTextField()
	this.pChatBtn->pOnKeyPress = @onTextBoxType()
	this.pChatBtn->pOnEnter = @onEnterChat()
	pGC->buttons.addButton(this.pChatBtn)
	
	
	/' Set up enter button '/
	pEnterBtn = New ButtonNode()
	pEnterBtn->x = pSChat->wdth*0.77
	pEnterBtn->y = pSChat->yOffset + pSChat->hght*0.1
	pEnterBtn->wdth = pSChat->wdth*0.05
	pEnterBtn->hght = pSChat->hght*0.80 - 1
	pEnterBtn->actColor = RGB(210, 210, 60)
	pEnterBtn->inaColor = RGB(180, 180, 40)
	pEnterBtn->isEnabled = -1
	pEnterBtn->pOnDraw = @drawEnterButton()
	pEnterBtn->pOnClick = @onEnterChat()
	pGC->buttons.addButton(pEnterBtn)
	
	
	/' Expand button '/
	pExpandBtn = New ButtonNode()
	pExpandBtn->x = pSChat->wdth*0.85
	pExpandBtn->y = pSChat->yOffset + pSChat->hght*0.1
	pExpandBtn->wdth = pSChat->wdth*0.05
	pExpandBtn->hght = pSChat->hght*0.80-1
	pExpandBtn->actColor = RGB(210, 210, 60)
	pExpandBtn->inaColor = RGB(180, 180, 40)
	pExpandBtn->isEnabled = -1
	pExpandBtn->pOnDraw = @drawExpandButton()
	pExpandBtn->pOnClick = @onClickExpandButton()
	pGC->buttons.addButton(pExpandBtn)
End Sub


Sub drawExpandButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	defaultDrawButton(aGC, pBtn)
	
	Color RGB(50, 20, 20)
	/' Vertical bar '/
	Line  (pBtn->x + pBtn->wdth*0.46, pBtn->y + pBtn->hght*0.15) - _
			(pBtn->x + pBtn->wdth*0.54, pBtn->y + pBtn->hght*0.85),,BF
	
	/' Top horizontal bar '/
	Line  (pBtn->x + pBtn->wdth*0.20, pBtn->y + pBtn->hght*0.15) - _
			(pBtn->x + pBtn->wdth*0.80, pBtn->y + pBtn->hght*0.25),,BF
			
	/' Left flank '/
	Line  (pBtn->x + pBtn->wdth*0.20, pBtn->y + pBtn->hght*0.15) - _
			(pBtn->x + pBtn->wdth*0.26, pBtn->y + pBtn->hght*0.50),,BF
	
	/' Right flank '/
	Line  (pBtn->x + pBtn->wdth*0.74, pBtn->y + pBtn->hght*0.15) - _
			(pBtn->x + pBtn->wdth*0.80, pBtn->y + pBtn->hght*0.50),,BF
End Sub


Sub onClickExpandButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pGC->guic.expandChat = Not(pGC->guic.expandChat)
End Sub


Sub drawEnterButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	defaultDrawButton(aGC, pBtn)
	
	Color RGB(50, 20, 20)
	/' Horizontal bar '/
	Line  (pBtn->x + pBtn->wdth*0.20, pBtn->y + pBtn->hght*0.45) - _
			(pBtn->x + pBtn->wdth*0.80, pBtn->y + pBtn->hght*0.55),,BF
			
	/' Vertical bar '/
	Line  (pBtn->x + pBtn->wdth*0.46, pBtn->y + pBtn->hght*0.15) - _
			(pBtn->x + pBtn->wdth*0.54, pBtn->y + pBtn->hght*0.85),,BF
End Sub


Sub onEnterChat(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	Dim As ButtonNode Ptr pChatBtn = pGC->guic.chatChk.pChatBtn
	
	/' Add Message '/
	If pChatBtn->text <> "" Then
		pGC->addMsg("Me", pChatBtn->text)
		pGC->sendRaw("con|" + pChatBtn->text + ";")
		
		/' Add to history '/
		pGC->guic.chatChk.lastChatEntered = pChatBtn->text
	EndIf
	
	/' Reset text '/
	pChatBtn->text = ""
	
	/' Reset active button information '/
	pGC->setActiveBtn(pChatBtn)
End Sub
