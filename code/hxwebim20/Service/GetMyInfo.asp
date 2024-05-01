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
	sql = "select * from [user] where userid = "&Session("userid")
	oRs.Open sql,oConn,1,1
	If Not(oRs.Bof And oRs.Eof) Then
		Response.Write("<item>")
		Call OutNode("f",oRs("userface"))
		Call OutNode("id",Session("userid"))
		Call OutNode("n",Session("username"))
		Call OutNode("e",Session("useremail"))
		Call OutNode("sn",oRs("usersign"))
		Call OutNode("s",oRs("userstatus"))
		Call OutNode("g","")
		Call OutNode("b","")
		Call OutNode("cn",Session("username"))
		Call OutNode("u",oRs("usergender"))
		Response.Write("</item>")
	End If
	oRs.Close()
	Set oRs = Nothing
	Call DataEnd()
	Response.Write("</list>")
%>