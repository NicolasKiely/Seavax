#Include Once "ChatList.bi"



Constructor ChatList()
	pNode = 0
	pLast = 0
	nodeCount = 0
	
End Constructor


Destructor ChatList()
	If pNode <> 0 Then Delete pNode
	If pLast <> 0 Then Delete pLast
End Destructor


Sub ChatList.addMsg(newAuthor as String, newMsg As String)
	/' Create new node '/
	Dim As ChatNode Ptr pNew
	pNew = New ChatNode(newAuthor, newMsg)
	
	If this.pNode = 0 Then
		/' Add first Node '/
		this.pNode = pNew
		this.pLast = pNew
		
		this.nodeCount = 1
		
	Else
		/' Add to beginning of list '/
		
		/' Point to old first node '/
		pNew->pNext = this.pNode
		
		/' Set first node to new node '/
		this.pNode = pNew
		
		this.nodeCount += 1
	EndIf
End Sub



Constructor ChatNode(newAuthor As String, newMsg As String)
	this.msg = newMsg
	this.pNext = 0
	this.author = newAuthor
End Constructor


Destructor ChatNode()
	delete this.pNext
End Destructor


Function ChatNode.toString() As String
	Return this.author + ": " + this.msg
End Function
