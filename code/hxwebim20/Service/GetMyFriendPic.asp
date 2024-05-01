<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "config.asp"-->
<!--#include file = "function.asp"-->
<!--#include file = "cmd.asp"-->
<%
	Response.Expires = WebCachTime
	Response.Charset="utf-8"
	Call CheckLogin()
	Response.Write("var aPics =[")
	pics = ""
	If PreloadFriendFace = True Then
		Call DataBegin()
		sql = "select a.isblocked,a.groupid as gid,a.customname as cname,b.* from userfriend a inner join [user] b on a.friendid = b.userid where a.userid = "&Session("userid")
		oRs.Open sql,oConn,1,1
		If Not(oRs.Bof And oRs.Eof) Then
			oRs.MoveFirst
			While Not oRs.Eof
				pics = pics & "'" & oRs("userface") & "',"
				oRs.MoveNext
			Wend
		End If
		oRs.Close()
		Set oRs = Nothing
		Call DataEnd()
		Response.Write(Left(pics,Len(pics)-1) & "];")
	Else
		Response.Write("];")
	End If
%>