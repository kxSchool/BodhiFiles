<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<%
	Response.Expires = WebCachTime
	Response.ContentType = "application/octet-stream"   
	Response.AddHeader "Content-Disposition","attachment;filename=Message.txt"  
	Response.Charset="utf-8"
	br = Chr(13)&Chr(10)
	Call CheckLogin()
	id = Request.QueryString("id")
	If id="" Or IsNumeric(id)=False Then id = -1
	id = CInt(id)
	Call DataBegin()
	If id = -1 Then
		Response.Write("//聊天对象：全部"&br)
	Else
		Response.Write("//聊天对象："&GetCustomNameById(Session("userid"),id)&br)
	End If
		Response.Write("//时间:"&Now()&br)
		Response.Write("//由HX IM生成"&br&br)
	Set oRs = Server.CreateObject("Adodb.RecordSet")
	sql = "select * from usermsg where (fromid = "&Session("userid")&" and toid = "&id&") or (toid = "&Session("userid")&" and fromid = "&id&") order by id "
	If id = -1 Then sql = "select * from usermsg where fromid = "&Session("userid")&" or toid = "&Session("userid")&" order by id "
	oRs.Open sql,oConn,1,1
	If Not (oRs.Bof And oRs.Eof) Then
		While Not(oRs.Eof)
			Response.Write(oRs("msgaddtime")&" "&GetCustomNameById(Session("userid"),oRs("fromid"))&" 说："&br)
			If CInt(oRs("typeid"))= 2 Then
				If Trim(oRs("msgcontent")) = "FLASH" Then
					msgContent = "闪屏振动"
				End If
			Else
				msgContent = Replace(oRs("msgcontent"),"{br}",br)
			End If
			Response.Write(msgContent&br&br)
		oRs.MoveNext
		Wend
	Else
		Response.Write("记录为空!")
	End If
	Call DataEnd()
%>