<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<%
Response.Expires = WebCachTime
Response.Charset="utf-8"
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
function chkEmail()
{
	var email = $F("tbEmail").trim();
	if(email=="")
	{
		setTip("Email","不能为空","red");
		return false;
	}
	else if(!validEmail(email))
	{
		setTip("Email","错误的email地址","red");
		return false;
	}
	else if(exsitEmail(email))
	{
		setTip("Email","已经使用的email","red");	
		return false;
	}
	setTip("Email","OK","gray");
	return true;
}
function chkPass()
{
	var pass = $F("tbPass").trim();
	if(pass.length<6)
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
	if($F("tbRepass").trim()!=$F("tbPass").trim())
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
	if(chkEmail()&&chkPass()&&chkRepass()&&chkNick())
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
function validEmail(email)
{
    var regex = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
    return regex.test(email);
}
function exsitEmail(email)
{
	var ajax = new Ajax();
	ajax.send("../Service/service.asp?t=1","email="+email,null,"POST",false);
	return parseInt(Xml.First($T(ajax.req.responseXML,"result").item(0),"num"))!=0;
}
</script>
</head>
<body> 
<form action="regresult.asp" method="post" enctype="multipart/form-data" name="form1" id="form1">
<table width="330" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="15" colspan="3"></td>
  </tr>
  <tr>
    <td width="60" height="25" align="right">电子邮件：</td>
    <td width="170"><input name="tbEmail" type="text" class="input1" id="tbEmail" maxlength="50" onblur="chkEmail()"/>
    </td>
    <td><span id="spanEmail" class="gray">注册后不能修改</span></td>
  </tr>
  <tr>
    <td height="25" align="right">密码：</td>
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
    <td><input name="tbNick" type="text" class="input1" id="tbNick" maxlength="20" onblur="chkNick()" /></td>
    <td><span id="spanNick" class="gray">2～20个字</span></td>
  </tr>
  <tr>
    <td height="25" align="right">个性签名：</td>
    <td><textarea name="tbSign" class="input1" id="tbSign" style="height:55px" maxlength="200"></textarea></td>
    <td><span class="gray">建议填写</span></td>
  </tr>
  <tr>
    <td height="25" align="right">个人头像：</td>
    <td><input name="fileFace" type="file" class="input1" style="width:164px" size="14" id="fileFace" />
    </td>
    <td><span class="gray">Jpg|Gif|Png均可</span></td>
  </tr>
  <tr>
    <td height="25" align="right">性别：</td>
    <td><input name="rdGender" type="radio" id="rdMale" value="1" checked="checked" />
      <label for="rdMale">男</label>
      <input name="rdGender" type="radio" id="rdFemale" value="2" />
      <label for="rdFemale">女</label>
	</td>
    <td><span class="gray"></span></td>
  </tr>
  <tr>
    <td height="35" colspan="3" align="center">
        <input class="button1" type="button" name="btnSubmit" id="btnSubmit" value="填好了" onclick="chkAll()"/>&nbsp;&nbsp; 
        <input class="button1" type="button" name="btnCancel" id="btnCancel" onclick="winMax(6,3);winClose(event);" value="不注册了" /></td>
  </tr>
</table>    
</form>   
</body>
</html>