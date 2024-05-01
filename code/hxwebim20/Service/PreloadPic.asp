<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "function.asp"-->
<%
Response.Expires = 3000
Response.Charset="utf-8"
Response.Write("var aPics =[")
Set FSO = Server.CreateObject("Scripting.FileSystemObject")
pics = ""

Set Folder = FSO.GetFolder(Server.MapPath("../images/"))
Set files = Folder.Files
If Files.Count <> 0 Then
  For Each File In Files
	picExt = GetFileType(File.Name)
	If(picExt="jpg" Or picExt="jpeg" Or picExt="gif" Or picExt="png") Then
		pics = pics & "'images/" & File.Name & "',"
	End If
  Next
End If

Set Folder = FSO.GetFolder(Server.MapPath("../msnface/"))
Set files = Folder.Files
If Files.Count <> 0 Then
  For Each File In Files
	picExt = GetFileType(File.Name)
	If(picExt="jpg" Or picExt="jpeg" Or picExt="gif" Or picExt="png") Then
		pics = pics & "'msnface/"+File.Name+"',"
	End If
  Next
End If
 
Set FSO = Nothing
Response.Write(Left(pics,Len(pics)-1) & "];")
%>