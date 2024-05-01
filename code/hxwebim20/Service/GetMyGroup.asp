<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "config.asp"-->
<!--#include file = "function.asp"-->
<!--#include file = "cmd.asp"-->
<%
	Response.Expires = WebCachTime
	Response.ContentType = "text/xml"
	Response.Charset="utf-8"
	Response.Write("<?xml version=""1.0"" encoding=""utf-8""?>")
	Response.Write("<list>")
	Call CheckLogin()
	Call DataBegin()
	sql = "select * from usergroup where userid = -1 or userid = "&Session("userid")
	oRs.Open sql,oConn,1,1
	If Not(oRs.Bof And oRs.Eof) Then
		oRs.MoveFirst
		While Not oRs.Eof
			Response.Write("<item>")
				Call OutNode("Name",oRs("groupname"))
				Call OutNode("ID",oRs("id"))
			Response.Write("</item>")
			oRs.MoveNext
		Wend
	End If
	oRs.Close()
	Set oRs = Nothing
	Call DataEnd()
	Response.Write("</list>")
%>