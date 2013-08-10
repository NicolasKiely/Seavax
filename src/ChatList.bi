/'----------------------------------------------------------------------------
 ' Manages a client-side chat history
 ---------------------------------------------------------------------------'/

/' Max number of chat nodes to store '/
#Define MAX_CHAT_NODES 100

/' Max length of a chat node '/
#Define MAX_CHAT_SIZE 240


/'----------------------------------------------------------------------------
 ' Linked list node of an individual chat line
 ---------------------------------------------------------------------------'/
Type ChatNode
	Dim As String msg
	Dim As String author
	
	Dim As ChatNode Ptr pNext
	
	/' Converts to single string '/
	Declare Function toString() As String
	
	Declare Constructor(newAuthor As String, newMsg As String)
	Declare Destructor()
End Type


Type ChatList
	/' First and last chat nodes '/
	Dim As ChatNode Ptr pNode
	Dim As ChatNode Ptr pLast
	
	/' Number of nodes '/
	Dim As Integer nodeCount
	
	Declare Constructor()
	Declare Destructor()
	
	/' Adds a new chat node to begining of list '/
	Declare Sub addMsg(newAuthor As String, newMsg As String)
End Type