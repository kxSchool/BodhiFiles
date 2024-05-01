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
	If CheckSysCode(Session("userid"),Request.QueryString("code")) = 0 Then
		Response.Write("<item>")
		Call OutNode("From",10000)
		Call OutNode("To",Session("userid"))
		Call OutNode("Content","您被迫下线！原因：此帐号在别处登录。")
		Call OutNode("Type",8)
		Call OutNode("IsConfirm",0)
		Call OutNode("AddTime","")
		Response.Write("</item>")
	Else
		Call CheckUserStatus()
		Call UpdateUserOnlineTime(Session("userid"))'将最后活动时间设为现在
		sql = "select * from usermsg where isread = 2 and toid = "&Session("userid")&" and fromid not in (select friendid from userfriend where isblocked=1 and userid = "&Session("userid")&")" '文本消息
		oRs.Open sql,oConn,1,3
		If Not(oRs.Bof And oRs.Eof) Then
			oRs.MoveFirst
			Do While (Not oRs.Eof)
				Response.Write("<item>")
				Call OutNode("From",oRs("fromid"))
				Call OutNode("To",Session("userid"))
				Call OutNode("Content",oRs("msgcontent"))
				Call OutNode("Type",oRs("typeid"))
				Call OutNode("IsConfirm",oRs("isconfirm"))
				Call OutNode("AddTime",ParseDateTime(oRs("msgaddtime")))
				Response.Write("</item>")
				oRs("isread") = 1
				oRs.Update
				oRs.MoveNext
			Loop
		End If
		oRs.Close()
		Set oRs = Nothing
		
		oConn.Execute("delete from usersysmsg where isread = 1") '清除已经失效的系统消息
		Set oRs = Server.CreateObject("Adodb.RecordSet")
		sql = "select * from usersysmsg where isread = 2 and toid = "&Session("userid") '系统消息
		oRs.Open sql,oConn,1,3
		If Not(oRs.Bof And oRs.Eof) Then
			oRs.MoveFirst
			Do While (Not oRs.Eof)
				Response.Write("<item>")
				Call OutNode("From",oRs("fromid"))
				Call OutNode("To",Session("userid"))
				Call OutNode("Content",oRs("msgcontent"))
				Call OutNode("Type",oRs("typeid"))
				Call OutNode("IsConfirm",oRs("isconfirm"))
				Call OutNode("AddTime",oRs("msgaddtime"))
				Response.Write("</item>")
				oRs("isread") = 1
				oRs.Update
				If CInt(oRs("typeid")) = 7 Then Exit Do
				oRs.MoveNext
			Loop
		End If
		oRs.Close()
		Set oRs = Nothing
	End If
	Call DataEnd()
	Response.Write("</list>")
%>