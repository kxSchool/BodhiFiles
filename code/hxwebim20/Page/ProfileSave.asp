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
strOldPass  = GetSafeStr(upload.Form("tbOldPass"))
strPass  = GetSafeStr(upload.Form("tbPass"))
strNick  = GetSafeStr(upload.Form("tbNick"))
strSign  = GetSafeStr(upload.Form("tbSign"))
intGender  = upload.Form("rdGender")
strFace  = file.FileName

flag = false

If(strNick="") Then 
	modifyResult = "Sorry，修改失败!"
	modifyInfo = "由于某些神秘的原因，使得您的资料不完整!"
Else
	If(strFace="") Then 
		strFace = ""
	Else
		picExt = LCase(GetFileType(file.filename))
		If(picExt<>"jpg" And picExt<>"jpeg" And picExt<>"gif" And picExt<>"png") Then
			strFace = ""
		Else
			Randomize
			ranNum = Int(900*Rnd)+100
			strFace = Year(Now)&Month(Now)&Day(Now)&Hour(Now)&Minute(Now)&Second(Now)&ranNum&"."&picExt
			file.SaveAs Server.mappath("../userface/"&strFace)
			Set file = Nothing
		End If
	End If
	Call DataBegin()
	sql = "select * from [user] where userid = "&Session("userid")
	oRs.Open sql,oConn,1,3
	If Not(oRs.Bof And oRs.Eof) Then
		If strPass<>"" Then
			If MD5(strOldPass)=oRs("userpass") Then
				oRs("userpass") = MD5(strPass)
				modifyInfo = "您的密码已经修改，下次请使用新密码登陆!"
			Else
				modifyInfo = "您提供的原密码不正确，密码没有修改!"
			End If
		End If
		oRs("username") = strNick
		oRs("usersign") = strSign
		oRs("usergender") = intGender
		If strFace <> "" Then 
			oRs("userface") = strFace
		Else
			strFace = oRs("userface")
		End If
		oRs.Update
		modifyResult = "您的个人资料已保存!"
		Call UpdateUserProfile(Session("userid"),strNick,strSign,strFace,"")
		flag = true
	Else
		modifyResult = "Sorry，修改失败!"
		modifyInfo = "服务器内部错误!"
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
<title>编辑个人资料</title>
<script type="text/javascript">
	var uid = 10;
</script>
</head>
<body> 
<table width="330" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="85"align="center" style="font-size:16px;color:red"><%=modifyResult%></td>
  </tr>
  <tr>
    <td height="45"align="center"><%=modifyInfo%></td>
  </tr>
  <tr>
    <td height="85" align="center"><input class="button1" type="button" name="btnLogin" id="btnLogin" value="关闭" onClick="winClose(event);"/></td>
  </tr>
</table>
<%If flag = True Then%>
<script type="text/javascript">
	parent._webIM.Profile.UserName = "<%=strNick%>";
	parent._webIM.Profile.UserSign = "<%=strSign%>";
	parent._webIM.Profile.UserFace = "<%=strFace%>";
	parent._webIM.CMD.renderMyUserInfo();
</script>
<%End If%>
</body>
</html>