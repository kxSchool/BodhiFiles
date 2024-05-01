<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<!--#include file = "../Service/md5.asp"-->
<!--#include file = "upload.inc"-->
<%
Response.Expires = -1
Response.Charset="utf-8"
Set upload = New upload_5xsoft
Set file = upload.file("fileFace")
strEmail = GetSafeStr(upload.Form("tbEmail"))
strPass  = GetSafeStr(upload.Form("tbPass"))
strNick  = GetSafeStr(upload.Form("tbNick"))
strSign  = GetSafeStr(upload.Form("tbSign"))
intGender  = upload.Form("rdGender")
strFace  = file.FileName
If(strEmail="" Or strPass="" Or strNick="") Then 
	regResult = "Sorry，注册失败!"
	regInfo = "由于某些原因，使得您的注册信息不完整!"
Else
	If(strFace="") Then 
		strFace = "default.gif"
	Else
		picExt = LCase(GetFileType(file.filename))
		If(picExt<>"jpg" And picExt<>"jpeg" And picExt<>"gif" And picExt<>"png") Then
			strFace = "default.gif"
		Else
			Randomize
			ranNum = Int(900*Rnd)+100
			strFace = Year(Now)&Month(Now)&Day(Now)&Hour(Now)&Minute(Now)&Second(Now)&ranNum&"."&picExt
			file.SaveAs Server.mappath("../userface/"&strFace)
			Set file = Nothing
		End If
	End If
	Call DataBegin()
	sql = "select top 1 * from usernum where isok = 1 order by id"
	oRs.Open sql,oConn,1,3
	If Not(oRs.Bof And oRs.Eof) Then
		intNum = oRs("Num")
		oRs("isok") = 2
		oRs.Update
		oConn.Execute("insert into [user] (username,userpass,userid,useremail,userface,usersign,usergender,lastonlinetime) values ('"&strNick&"','"&MD5(strPass)&"','"&intNum&"','"&strEmail&"','"&strFace&"','"&strSign&"','"&intGender&"','"&Now()&"')")
		oConn.Execute("insert into userconfig (userid) values ('"&intNum&"')") '给配置表里加入一条记录
		oConn.Execute("insert into usermsg (fromid,toid,msgcontent,typeid,msgaddtime) values ('10000','"&intNum&"','管理员韩欣 欢迎你的注册，有什么问题给我发消息就可以了哦:-D！','1','"&Now()&"')")'发送一条消息
		Call AddFriend(intNum,10000) '将该帐号和系统帐号互相加为好友
		regResult = "恭喜你，注册成功!"
		regInfo = "由于暂时未开通取回密码功能，请牢记自己的帐号密码!"
	Else
		regResult = "Sorry，注册失败!"
		regInfo = "由于注册人数已到达测试服务器上限，暂时无法注册!"
	End If
	oRs.Close()
	Set oRs = Nothing
	Call DataEnd()
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../styles/webimpage.css" type="text/css" rel="stylesheet" media="all">
<script type="text/javascript" src="../js/webimcommon.js"></script>
<script type="text/javascript" src="../js/webimpage.js"></script>
<title>注册新用户</title>
<script type="text/javascript">
	var uid = 7;
</script>
</head>
<body> 
<table width="330" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="85"align="center" style="font-size:16px;color:red"><%=regResult%></td>
  </tr>
  <tr>
    <td height="45"align="center"><%=regInfo%></td>
  </tr>
  <tr>
    <td height="85" align="center"><input class="button1" type="button" name="btnLogin" id="btnLogin" value="点击此处登录" onClick="winMax(6,3);winClose(event);"/></td>
  </tr>
</table>
</body>
</html>