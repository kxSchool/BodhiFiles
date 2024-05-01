<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "config.asp"-->
<!--#include file = "function.asp"-->
<!--#include file = "cmd.asp"-->
<!--#include file = "md5.asp"-->
<%
	Response.Expires = -1
	Response.ContentType = "text/xml"
	Response.Charset="utf-8"
	Call DataBegin()
	t = Request.QueryString("t")
	Select Case CInt(t)
		Case 0'登陆
			email = GetSafeStr(Request.Form("email"))
			pass  = GetSafeStr(Request.Form("pass"))
			us = Request.Form("us")
			num   = 0
			If (email="" Or pass="") Then
				num = 4
			Else
				Call DataBegin()
				Set oRs = Server.CreateObject("Adodb.RecordSet")
				sql = "select * from [user] where useremail = '"&email&"'"
				oRs.Open sql,oConn,1,3
				If Not(oRs.Bof Or oRs.Eof) Then
					If MD5(pass) = oRs("UserPass") Then
						Session("userid") = oRs("userid")
						Session("username") = oRs("username")
						Session("useremail") = oRs("useremail")
						Session("userpower") = oRs("userpower")
						Randomize
						ranNum = Int(90000*Rnd)+10000
						Session("syscode") = ranNum
						num = 1       '成功
						oRs("syscode") = ranNum
						oRs.Update
						Call UpdateUserOnlineTime(Session("userid"))
						Call UpdateUserProfile(oRs("userid"),"","","",us)
					Else
						num = 2    'failed
					End If
				Else
					num = 2
				End If
			End If
			Response.Write("<?xml version=""1.0"" encoding=""utf-8""?>")
			Response.Write("<result>")
			Response.Write("<num>"&num&"</num>")     
			Response.Write("<code>"&ranNum&"</code>")  
			Response.Write("</result>")
		Case 1'email是否可用
			num = oConn.ExeCute("select count(*) from [user] where useremail = '"&GetSafeStr(Request.Form("email"))&"'")(0)
			Response.Write("<?xml version=""1.0"" encoding=""utf-8""?>")
			Response.Write("<result>")
			Response.Write("<num>"&num&"</num>")
			Response.Write("</result>")
		Case 2'注销
			Call UpdateUserOnlineTime(Session("userid"))
			Call UpdateUserProfile(Session("userid"),"","","",7)
			Session("userid") = ""
			Session("username") = ""
			Session("useremail") = ""
			Session("syscode") = ""
		Case 3'发送消息
			fromid = GetSafeStr(Request.Form("from"))
			toid = GetSafeStr(Request.Form("to"))
			msgcontent = GetSafeStr(Request.Form("content"))
			typeid = GetSafeStr(Request.Form("type"))
			oConn.Execute("insert into usermsg (fromid,toid,msgcontent,typeid,msgaddtime) values ('"&fromid&"','"&toid&"','"&msgcontent&"','"&typeid&"','"&Now()&"')")
		Case 4'修改本人在线状态
			username = GetSafeStr(Request.Form("username"))
			usersign = GetSafeStr(Request.Form("usersign"))
			userface = GetSafeStr(Request.Form("userface"))
			userstatus = GetSafeStr(Request.Form("userstatus"))
			Call UpdateUserProfile(Session("userid"),username,usersign,userface,userstatus)
		Case 5'接受添加好友请求
			toid = GetSafeStr(Request.Form("to"))
			Call AddFriend(Session("userid"),toid) 
		Case 6'删除好友
			toid = GetSafeStr(Request.Form("to"))
			Call DelFriend(Session("userid"),toid)
		Case 7'屏蔽好友
			toid = GetSafeStr(Request.Form("to"))
			isblock = GetSafeStr(Request.Form("s"))
			oConn.Execute("update userfriend set isblocked = "&isblock&" where userid = "&Session("userid")&" and friendid = "&toid)
		Case 8'修改好友昵称
			toid = GetSafeStr(Request.Form("to"))
			customname = GetSafeStr(Request.Form("n"))
			oConn.Execute("update userfriend set customname = '"&customname&"' where userid = "&Session("userid")&" and friendid = "&toid)
		Case 9'创建新组
			groupname = GetSafeStr(Request.Form("n"))
			If CInt(oConn.Execute("select count(*) from usergroup where groupname='"&groupname&"' and (userid=-1 or userid="&Session("userid")&")")(0))<1 Then'是否分组
				oConn.Execute("insert into usergroup (userid,groupname) values ("&Session("userid")&",'"&groupname&"')")
			End If
		Case 10'删除组
			gid = GetSafeStr(Request.Form("id"))
			oConn.Execute("update userfriend set groupid=1 where userid = "&Session("userid")&" and groupid="&gid)
			oConn.Execute("delete from usergroup where id="&gid&" and userid="&Session("userid"))
		Case 11'修改组
			gid = GetSafeStr(Request.Form("id"))
			groupname = GetSafeStr(Request.Form("n"))
			oConn.Execute("update usergroup set groupname='"&groupname&"' where id="&gid&" and userid="&Session("userid"))
		Case 12'修改好友分组
			id = GetSafeStr(Request.Form("id"))
			gid = GetSafeStr(Request.Form("gid"))
			oConn.Execute("update userfriend set groupid="&gid&" where userid = "&Session("userid")&" and friendid="&id)
		Case Else
			Call DataEnd()
			Response.End()
	End Select
	Call DataEnd()
%>