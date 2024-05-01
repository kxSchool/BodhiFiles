<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<%
Response.Expires = WebCachTime
Response.Charset="utf-8"
Call CheckLogin()
Call DataBegin()
	sql = "select * from [user] where userid="&Session("userid")
	oRs.Open sql,oConn,1,1
	If Not(oRs.Bof And oRs.Eof) Then
		username = oRs("username")
		usersign = oRs("usersign")
		usergender = oRs("usergender")
	Else
		Response.End()
	End If
Call DataEnd()
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
function chkPass()
{
	var pass = $F("tbPass").trim();
	if(pass.length==0)
	{
		return true;
	}
	else if(pass.length<6)
	{
		setTip("Pass","密码最少6位","red");
		return false;
	}
	else if(pass.length>12)
	{
		setTip("Pass","密码最多12位","red");
		return false;
	}
	setTip("Pass","OK","gray");
	return true;
}
function chkRepass()
{
	if($F("tbPass").trim().length==0)
	{
		return true;
	}
	else if($F("tbRepass").trim()!=$F("tbPass").trim())
	{
		setTip("Repass","两次密码不一致","red");
		return false;
	}
	setTip("Repass","OK","gray");
	return true;
}
function chkNick()
{
	var nick = $F("tbNick").trim();
	if(nick.length<2)
	{
		setTip("Nick","昵称最少2个字","red");
		return false;
	}
	else if(nick.length>20)
	{
		setTip("Nick","昵称最多20个字","red");
		return false;
	}
	setTip("Nick","OK","gray");
	return true;
}
function chkAll()
{
	if(chkPass()&&chkRepass()&&chkNick())
	{
		showLoading();
		document.forms[0].submit();
	}
}
function setTip(s,msg,cn)
{
	var oSpan = $("span"+s);
	oSpan.className = cn;
	Elem.Value(oSpan,msg);
}
</script>
</script>
</head>
<body> 
<form action="profilesave.asp" method="post" enctype="multipart/form-data" name="form1" id="form1">
<table width="330" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="15" colspan="3"></td>
  </tr>
  <tr>
    <td width="60" height="25" align="right">原密码：</td>
    <td width="170"><input name="tbOldPass" type="password" class="input1" id="tbOldPass" maxlength="50"/>
    </td>
    <td><span id="spanOldPass" class="gray">不修改请保持为空</span></td>
  </tr>
  <tr>
    <td height="25" align="right">新密码：</td>
    <td><input name="tbPass" type="password" class="input1" id="tbPass" maxlength="12"onblur="chkPass()"/></td>
    <td><span id= "spanPass" class="gray">6～12位</span></td>
  </tr>
  <tr>
    <td height="25" align="right">重复密码：</td>
    <td><input name="tbRepass" type="password" class="input1" id="tbRepass" maxlength="12" onblur="chkRepass()"/></td>
    <td><span id="spanRepass" class="gray"></span></td>
  </tr>
  <tr>
    <td height="25" align="right">昵称：</td>
    <td><input name="tbNick" type="text" class="input1" id="tbNick" maxlength="20" onblur="chkNick()" value="<%=username%>"/></td>
    <td><span id="spanNick" class="gray">2～20个字</span></td>
  </tr>
  <tr>
    <td height="25" align="right">个性签名：</td>
    <td><textarea name="tbSign" class="input1" id="tbSign" style="height:55px" maxlength="200"><%=usersign%></textarea></td>
    <td><span class="gray"></span></td>
  </tr>
  <tr>
    <td height="25" align="right">个人头像：</td>
    <td><input name="fileFace" type="file" class="input1" style="width:164px" size="14" id="fileFace" />
    </td>
    <td><span class="gray">Jpg|Gif|Png均可</span></td>
  </tr>
  <tr>
    <td height="25" align="right">性别：</td>
    <td><input name="rdGender" type="radio" id="rdMale" value="1" <%If usergender="1" Then%> checked="checked" <%End If%>/>
      <label for="rdMale">男</label>
      <input name="rdGender" type="radio" id="rdFemale" value="2" <%If usergender="2" Then%> checked="checked" <%End If%>/>
      <label for="rdFemale">女</label>
	</td>
    <td><span class="gray"></span></td>
  </tr>
  <tr>
    <td height="35" colspan="3" align="center">
        <input class="button1" type="button" name="btnSubmit" id="btnSubmit" value="确定" onclick="chkAll()"/>&nbsp;&nbsp; 
        <input class="button1" type="button" name="btnCancel" id="btnCancel" onclick="winClose(event);" value="取消" /></td>
  </tr>
</table>    
</form>
</body>
</html>