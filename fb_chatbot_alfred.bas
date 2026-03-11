
#include "vbcompat.bi"

Type ArraySet
  	ReDim Keywords(any) As String
  	ReDim Replies(Any)  As String
End Type

' uses same alphabet and key as Ada language example
Const string1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
Const string2 = "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN"

'for words switch (index 0 is unused; actual swap pairs start at index 1)
redim shared as string wordIn(0), wordOut(0)
dim shared as long wCnt

CONST punctuation = "?!,.:;<>(){}[]"

redim shared defaultReplies(any) as STRING
ReDim Shared g_Key_Reply(Any) As ArraySet
redim shared command1(any) as STRING

Randomize()

' Append an item to a dynamic string array
SUB sAppend(arr() AS string, item AS STRING)
  REDIM PRESERVE arr(LBOUND(arr) TO UBOUND(arr) + 1)
  arr(UBOUND(arr)) = item
END Sub

' Add spaces around punctuation so keywords don't interfere during matching
FUNCTION isolatePunctuation(s AS STRING) as string
  DIM as string b
  b = ""
  FOR i as integer = 1 TO LEN(s)
    IF INSTR(punctuation, MID(s, i, 1)) > 0 THEN b = b + " " + MID(s, i, 1) + " " ELSE b = b + MID(s, i, 1)
  NEXT
  return b
END FUNCTION

' Return a time-appropriate greeting based on the system clock
function alfredtime() as STRING
  var morning = timevalue( "08:00:00AM")
  var noon = timevalue( "12:00:00PM")
  var evening = timevalue( "06:00:00PM")
  var night = timevalue( "10:00:00PM")
  if timevalue(time) >= morning and timevalue(time) < noon then
    return "good morning may you have a wonderful day my friend!"
  elseif timevalue(time) >= noon and timevalue(time) < evening then
    return "good noon i hope the day is treating you well my friend!"
  elseif timevalue(time) >= evening and timevalue(time) < night then
    return "good evening i hope you had a good day my friend!"
  elseif timevalue(time) >= night then           ' maybe and timevalue(time) < morning
    return "good night it's time for sleep and bedtime i hope you'll have good dreams my friend!"
  else
    return "sweet dreams my friend and may tomorrow be a better day!"
  End If
End Function

' Reverse isolatePunctuation: rejoin punctuation to adjacent words
FUNCTION joinPunctuation(s AS STRING) as String
  DIM AS STRING b, find
  Dim place AS long
  b = s
  FOR i as integer = 1 TO LEN((punctuation))
    find = " " + MID(punctuation, i, 1) + " "
    place = INSTR(b, find)
    WHILE place > 0
      IF place = 1 THEN
        b = MID(punctuation, i, 1) + MID(b, place + 3)
      ELSE
        b = MID(b, 1, place - 1) + MID(punctuation, i, 1) + MID(b, place + 3)
      END IF
      place = INSTR(b, find)
    WEND
  NEXT
  return b
END Function

' Read entire file into a string and return it
function txtfile(f AS STRING) as string
  DIM AS STRING buffer
  DIM h AS LONG = FREEFILE()
  if OPEN(f FOR BINARY access read AS #h) then
    return "file could not be opened!"
  elseif (lof(h) < 1) then
    return "file could not be read!"
  else
    buffer = SPACE(LOF(h))
    GET #h,, buffer
    CLOSE #h
    return buffer
  end if
End function

' Load and decrypt the keyword/reply database from file
SUB loadArrays(filename AS STRING)
  	DIM h AS INTEGER = FREEFILE()
  	DIM fline AS STRING
  	Dim As String alpha, key
  	dim as long temp
  	alpha = string2 : key = string1
  	Dim s As String
  	Dim p As Integer
  
  IF OPEN(filename FOR INPUT AS #h) THEN
    PRINT "ERROR: Could not open database file: " & filename
    RETURN
  END IF
  Dim As Integer IsKeyWord=0,iKeyReplyNum=-1
  WHILE NOT EOF(h)
    LINE INPUT #h, s
    For i As Integer = 0 To Len(s) - 1
      If (s[i] >= 65 AndAlso s[i] <= 90) OrElse(s[i] >= 97 AndAlso s[i] <= 122) Then
        p = Instr(alpha, Mid(s, i + 1, 1)) - 1
        s[i] = key[p]
      End If
    next i
    fline = s
    Var iPosi = InStr(fline, ":")
    'ignore the line if theres no : or if its too short or too long
    If iPosi < 2 Or iPosi > 8 Then Continue While
    Var sText = TRIM(MID(fline, iPosi + 1))
    If iPosi = 2 Then                            'check for 1 chracter entries
      Select Case fline[0]
        Case Asc("k") 'Keywords
          If IsKeyWord=0 Then
            	'if the previous entry was not a keyword add a new set entry
            	IsKeyWord=1:iKeyReplyNum += 1
            	ReDim Preserve g_Key_Reply(iKeyReplyNum)
          EndIf
          
          sAppend g_Key_Reply(iKeyReplyNum).Keywords(), " " + lcase(sText) + " "
        Case Asc("r") 'Reply
          If iKeyReplyNum < 0 Then
            	Print "ERROR: Reply without Keyword"
          EndIf
          IsKeyWord = 0 'not a Keyword
          sAppend( g_Key_Reply(iKeyReplyNum).Replies(), sText )
        case asc( "s")
          wCnt = wCnt + 1 :temp = INSTR(fline, ">")
          IF temp THEN
            sAppend wordIn(), " " + Trim(MID(fline, 3, temp - 3)) + " "
            sAppend wordOut(), " " + Trim(MID(fline, temp + 1)) + " "
          END IF
          
        case asc( "d")
          sAppend(defaultReplies(), sText)
      End select
    End if
    if iPosi = 3 then
      select case left(fline, 2)
        		Case "c1"
          sAppend(command1(), " " + sText + " ")
      End Select
    End If
    
  WEND
  CLOSE #h

  IF UBound(g_Key_Reply) < 0 THEN
    PRINT "WARNING: No keyword/reply data loaded from database"
  END IF

END Sub

' Return TRUE if any element of Array() is found in inpt
FUNCTION checkArray(Array() AS STRING, inpt AS STRING) AS BOOLEAN
  var result = 0
  dim as boolean Found = false
  for i as integer = 0 to ubound(Array)
    result = Instr(inpt, Array(i))
    if result <> 0 then
      Found = True
      exit for
    end if
  next i
  RETURN found
END Function

' Main ELIZA engine: match keywords, swap pronouns, select reply
function userQuestion(txt AS STRING) As String
  dim replies(any) as STRING
  dim result as string
  DIM as string inpt, tail, answ
  DIM as long k, kFound
  dim answ2 As String
  
  txt = isolatePunctuation(txt)
  txt = " " + lcase(txt) + " "
  
  if checkArray(command1(), txt) then
    #ifdef __fb_linux__
      shell( "xdg-open " + EXEPATH + "/database/instruction.txt")
    #else
      shell( "start " + CHR(34) + EXEPATH + "/database/instruction.txt" + CHR(34))
    #EndIf
  End If
  
  	For N As Integer = 0 To UBound(g_Key_Reply)
    		With g_Key_Reply(N)
      			FOR k = 0 TO ubound(.keywords)
        				kFound = INSTR(txt, .keywords(k))
        				if kfound > 0 then
          					tail = " " + MID(txt, kFound + LEN(.keywords(k)))
          					FOR l as Integer = 1 TO LEN(tail) 'DO NOT USE INSTR
            						FOR w as integer = 1 TO wCnt 'swap words in tail if used there
              							IF MID(tail, l, LEN(wordIn(w))) = wordIn(w) THEN 'swap words exit for
                								tail = MID(tail, 1, l - 1) + wordOut(w) + MID(tail, l + LEN(wordIn(w)))
                								EXIT FOR
              							END IF
            						NEXT w
          					NEXT l
          					EXIT FOR
        				EndIf
      			Next k
      			if checkArray(.Keywords(), txt) Then
        				result = .Replies(Int(RND*(UBOUND(.Replies)+1)))
        				if RIGHT(result, 1) <> "*" then
          					answ2 = result + " "
          					answ += answ2
          					sappend(replies(), result)
        				else
          					tail = joinPunctuation(tail)
          					answ2 = MID(result, 1, LEN(result) - 1) + tail
          					answ += answ2
          					sappend(replies(), answ2)
        				EndIf
      			end if
      			
    		End With
  	Next N
  	
  	if answ = "" then
    		Return defaultReplies(int(rnd*(ubound(defaultReplies)+1)))
  	else
    		
    		if ubound(replies) < 5 then
      			return answ
    		else
      			return replies(int(rnd*(ubound(replies)+1)))
    		end if
  	end if
End Function

