/'----------------------------------------------------------------------------
 ' Manages the parsing of raw socket stream data into tables
 ---------------------------------------------------------------------------'/

#Include Once "Table.bi"


/'----------------------------------------------------------------------------
 ' Iteratively builds up a table from a streaming string buffer
 ' ppWork is the pointer to the working buffer reference. Managed by function
 ' ppRes is the pointer to the results reference. Null unless results ready
 ' zMark is the string ptr starting at the last left off place. Managed by function
 ' Returns updated string marker
 ---------------------------------------------------------------------------'/
Declare Function streamTable(ppWork As Table Ptr Ptr, ppRes As Table Ptr Ptr, _
										zMark As ZString Ptr, pState As Integer Ptr) As ZString Ptr

Enum TableStreamStates
	HEADER_STATE = 0,
	COLUMN_STATE = 1,
	RECORD_STATE = 2
End Enum
