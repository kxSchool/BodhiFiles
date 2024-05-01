<%
'检查是否登陆
Sub CheckLogin
	If Session("userid") = "" Then
		Response.End
	End If
End Sub

'将用户最后登陆时间设置为当前时间
Sub UpdateUserOnlineTime(id)
	oConn.Execute("update [user] set lastonlinetime='"&Now()&"' where userid = "&id)
End Sub

'更改用户信息，并向该用户在线好友广播此消息
Sub UpdateUserProfile(id,username,usersign,userface,userstatus)
	sql = "update [user] set userid = "&id
	If userstatus<>"" Then sql = sql&" ,userstatus='"&userstatus&"'"
	If username<>""   Then sql = sql&" ,username='"&username&"' "
	If usersign<>""   Then sql = sql&" ,usersign='"&usersign&"' "
	If userface<>""   Then sql = sql&" ,userface='"&userface&"' "
	sql = sql&" where userid = "&id
	oConn.Execute(sql)
	sql = "select a.*,b.userid as uid,b.userstatus from userfriend a inner join [user] b on a.friendid = b.userid where a.userid = "&id&"" '所有的好友
	Set oRs_1 = Server.CreateObject("Adodb.RecordSet")
	oRs_1.Open sql,oConn,1,1
	If Not(oRs_1.Bof And oRs_1.Eof) Then
		oRs_1.MoveFirst
		While Not oRs_1.Eof
			If CInt(oRs_1("userstatus"))<>7 Then'不是下线
				If CInt(oConn.Execute("select count(*) from usersysmsg where (fromid="&id&" and toid="&oRs_1("uid")&" and typeid=5)")(0))<1 Then'是否已经存在此广播
					oConn.Execute("insert into usersysmsg (fromid,toid,msgcontent,typeid,msgaddtime) values ('"&id&"','"&oRs_1("uid")&"','','5','"&Now()&"')")
				End If
			End If
			oRs_1.MoveNext
		Wend
	End If 
	oRs_1.Close
	Set oRs_1 = Nothing
End Sub

'将最后登陆时间在1分钟之前的用户状态设置为下线
Sub CheckUserStatus()
	sql = "select * from [user] where userstatus <> 7 " '所有的非下线用户
	Set oRs_2 = Server.CreateObject("Adodb.RecordSet")
	oRs_2.Open sql,oConn,1,1
	If Not(oRs_2.Bof And oRs_2.Eof) Then
		oRs_2.MoveFirst
		While Not oRs_2.Eof
			If(DateDiff("n",CDate(oRs_2("lastonlinetime")),Now)>1) Then
				Call UpdateUserProfile(oRs_2("userid"),"","","",7)
			End If
			oRs_2.MoveNext
		Wend
	End If 
	oRs_2.Close
	Set oRs_2 = Nothing	
End Sub

'发送好友改变消息
Sub ChangeFriendList(fromid,toid,t)'t:3添加4删除
	If CInt(oConn.Execute("select userstatus from [user] where userid="&toid)(0))<7 Then
		oConn.Execute("insert into usersysmsg (fromid,toid,msgcontent,typeid,msgaddtime) values ('"&fromid&"','"&toid&"','','"&t&"','"&Now()&"')")
	End If
End Sub

'添加好友操作
Sub AddFriend(fromid,toid)
	If CInt(oConn.Execute("select count(*) from userfriend where userid ="&fromid&" and friendid ="&toid)(0))<1 Then
		oConn.Execute("insert into userfriend (userid,friendid) values ('"&fromid&"','"&toid&"')")
		oConn.Execute("insert into userfriend (userid,friendid) values ('"&toid&"','"&fromid&"')")
		Call ChangeFriendList(fromid,toid,3) '给对方发送消息提示
	End If
End Sub

'删除好友操作
Sub DelFriend(fromid,toid)
	If CInt(oConn.Execute("select count(*) from userfriend where userid ="&fromid&" and friendid ="&toid)(0))>0 Then
		oConn.Execute("delete from userfriend where userid ="&fromid&" and friendid = "&toid)
		oConn.Execute("delete from userfriend where userid ="&toid&" and friendid = "&fromid)
		Call ChangeFriendList(fromid,toid,4) '给对方发送消息提示
	End If
End Sub

'检测是否登陆检验码
Function CheckSysCode(uid,code)
	sql = "select * from [user] where userid = "&uid
	Set oRs_3 = Server.CreateObject("Adodb.RecordSet")
	oRs_3.Open sql,oConn,1,1
	If Not(oRs_3.Bof And oRs_3.Eof) Then
		oRs_3.MoveFirst
		If CStr(code)<>CStr(oRs_3("syscode")) Then
			CheckSysCode = 0
		Else
			CheckSysCode = 1
		End If
	Else
		CheckSysCode = 0
	End If 
	oRs_3.Close
	Set oRs_3 = Nothing	
End Function
%>