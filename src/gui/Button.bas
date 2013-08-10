#Include Once "Button.bi"
#Include Once "../contexts/GameContext.bi"



Sub ButtonNode.callOnClick(aGC As Any Ptr)
	If this.pOnClick <> 0 Then this.pOnClick(aGC, @This)
End Sub


Sub ButtonNode.callOnDraw(aGC As Any Ptr)
	If this.pOnDraw <> 0 Then this.pOnDraw(aGC, @This)
End Sub


Sub ButtonNode.callOnKeyPress(aGC As Any Ptr, char As String)
	If this.pOnKeyPress <> 0 Then this.pOnKeyPress(aGC, @This, char)
End Sub


Constructor ButtonNode()
	this.x = 0
	this.y = 0
	
	this.wdth = 20
	this.hght = 20
	
	this.actColor = RGB(200, 0, 200)
	this.inaColor = RGB(100, 0, 100)
	
	this.pOnClick = 0
	this.pOnDraw = @defaultDrawButton()
	
	this.text = ""
	
	this.pNext = 0
	
	this.isActive  = 0
	this.isEnabled = 0
End Constructor


Destructor ButtonNode()
	If this.pNext <> 0 Then Delete this.pNext
End Destructor


Constructor ButtonList()
	this.pButton = 0
End Constructor


Destructor ButtonList()
	If this.pButton <> 0 Then Delete this.pButton
End Destructor


Function newLabelButton(btnText As String) As ButtonNode Ptr
	Dim As ButtonNode Ptr pBtn
	
	pBtn = New ButtonNode()
	pBtn->actColor = RGB(5, 5, 5)
	pBtn->inaColor = RGB(0, 0, 0)
	pBtn->text = btnText
	pBtn->wdth = 8 + 8*Len(btnText)
	pBtn->hght = 16
	pBtn->pOnDraw = @drawTextButton()
	
	Return pBtn
End Function


Function newTextButton(colWdth As Integer) As ButtonNode Ptr
	Dim As ButtonNode Ptr pBtn
	
	pBtn = New ButtonNode()
	pBtn->actColor = RGB(20, 20, 40)
	pBtn->inaColor = RGB(15, 15, 30)
	pBtn->wdth = 6 + 8*colWdth
	pBtn->hght = 16
	pBtn->pOnDraw = @drawTextField()
	pBtn->pOnClick = @onClickTextBox()
	pBtn->pOnKeyPress = @onTextBoxType()
	
	Return pBtn
End Function


Function newGenericButton(btnText As String) As ButtonNode Ptr
	Dim As ButtonNode Ptr pBtn
	
	pBtn = New ButtonNode()
	pBtn->actColor = RGB(20, 80, 15)
	pBtn->inaColor = RGB(15, 60, 10)
	pBtn->text = btnText
	pBtn->wdth = 8 + 8*Len(btnText)
	pBtn->hght = 16
	pBtn->pOnDraw = @drawTextButton()
	
	Return pBtn
End Function


Function newMultiButton(colWdth As Integer, rowHght As Integer) As ButtonNode Ptr
	Dim As ButtonNode Ptr pBtn
	
	pBtn = New ButtonNode()
	pBtn->actColor = RGB(0, 7, 0)
	pBtn->inaColor = RGB(15, 15, 30)
	pBtn->wdth = 6 + 8*colWdth
	pBtn->hght = 6 + 10*rowHght
	
	
	Return pBtn
End Function


Sub ButtonList.addButton(pNewButton As ButtonNode Ptr)
	If this.pButton = 0 Then
		this.pButton = pNewButton
	Else
		pNewButton->pNext = this.pButton
		this.pButton = pNewButton
	EndIf
End Sub


Sub ButtonList.renderButtons(aGC As Any Ptr)
	/' Looping node '/
	Dim As ButtonNode Ptr pNode
	
	pNode = this.pButton
	While pNode <> 0
		If pNode->isEnabled <> 0 Then
			/' Attempt render '/
			pNode->callOnDraw(aGC)
		EndIf
		
		pNode = pNode->pNext
	Wend
End Sub


Sub defaultDrawButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	If pBtn->isActive Then
		Color pBtn->actColor
	Else
		Color pBtn->inaColor
	EndIf
	
	Line (pBtn->x, pBtn->y) - (pBtn->x+pBtn->wdth, pBtn->y+pBtn->hght),, BF
End Sub


Sub drawTextButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	/' Draw background '/
	defaultDrawButton(aGC, pBtn)
	
	If pBtn->text <> "" Then
		Dim As Integer tx
		Dim As Integer ty
		
		ty = pBtn->y + (pBtn->hght Shr 1)-4
		tx = pBtn->x + (pBtn->wdth Shr 1)-(4*Len(pBtn->text))
		
		Color RGB(240, 240, 190)
		Draw String (tx, ty), pBtn->text
	EndIf
End Sub


Sub onClickTextBox(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pGC->setActiveBtn(pBtn)
End Sub


Sub drawTextField(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	'defaultDrawButton(aGC, pBtn)
	If pGC->pActive = pBtn Then
		Color pBtn->actColor
	Else
		Color pBtn->inaColor
	EndIf
	
	/' Draw background '/
	Line (pBtn->x, pBtn->y) - (pBtn->x+pBtn->wdth, pBtn->y+pBtn->hght),, BF
	
	
	/' Draw cursor '/
	Color RGB(230, 230, 180)
	Dim As Integer y = pBtn->y + (pBtn->Hght Shr 1) - 4
	
	If pGC->pActive = pBtn And Int(Timer*2) Mod 2 Then
		Dim As Integer x = pBtn->x + pGC->guic.textPos*8+4
		Line (x, y + 10) - (x+7, y + 12),,BF
	EndIf
	
	/' Draw text '/
	Draw String (pBtn->x + 4, y), pBtn->text
End Sub


Sub onTextBoxType(aGC As Any Ptr, pBtn As ButtonNode Ptr, char As String)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	Dim As Integer leftLen = pGC->guic.textPos
	Dim As Integer rightLen = Len(pBtn->text) - pGC->guic.textPos
	
	If Asc(char) = 8 Then
		/' Back space '/
		If pGC->guic.textPos > 0 Then
			pGC->guic.textPos -= 1
			pBtn->text = Left(pBtn->text, leftLen-1) + Right(pBtn->text, rightLen)
		EndIf
		
	ElseIf char = Chr(255) + Chr(&h4B) Then
		/' Left arrow key '/
		If pGC->guic.textPos > 0 Then
			pGC->guic.textPos -= 1
		EndIf
		
	ElseIf char = Chr(255) + Chr(&h4D) Then
		/' Right arrow key '/
		If pGC->guic.textPos < Len(pBtn->text) Then
			pGC->guic.textPos += 1
		EndIf
	
	ElseIf char = Chr(255) + Chr(&h48) Then
		/' Up arrow key, load last message '/
		pBtn->text = pGC->guic.chatChk.lastChatEntered
		pGC->guic.textPos = Len(pBtn->text)
		
	ElseIf Asc(char) >= 32 And Asc(char) <= 126  Then
		/' Add text '/
		If len(pBtn->text)*8+8 < pBtn->wdth Then
			pBtn->text = Left(pBtn->text, leftLen) + char + Right(pBtn->text, rightLen)
		
			pGC->guic.textPos += 1
		End if
	EndIf
End Sub


Sub onClickExit(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	CPtr(GameContext Ptr, aGC)->exitGame = -1
End Sub


Sub ButtonNode.callOnEnter(aGC As Any Ptr)
	If this.pOnEnter <> 0 Then this.pOnEnter(aGC, @This)
End Sub
