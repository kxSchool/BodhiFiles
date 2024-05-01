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
	sql = "select a.*,b.userpower from userconfig a inner join [user] b on a.userid = b.userid where a.userid="&Session("userid")
	oRs.Open sql,oConn,1,1
	If Not(oRs.Bof And oRs.Eof) Then
		Response.Write("<item>")
		Call OutNode("DisType",oRs("distype"))
		Call OutNode("OrderType",oRs("ordertype"))
		Call OutNode("ChatSide",oRs("chatside"))
		Call OutNode("MsgSendKey",oRs("msgsendkey"))
		Call OutNode("MsgShowTime",oRs("msgshowtime"))
		Call OutNode("UserPower",oRs("userpower"))
		Response.Write("</item>")
	End If
	oRs.Close()
	Set oRs = Nothing
	Call DataEnd()
	Response.Write("</list>")
%>