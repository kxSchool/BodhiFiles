<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<%
Response.Expires = WebCachTime
Response.Charset="utf-8"
Call CheckLogin()
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../styles/webimpage.css" type="text/css" rel="stylesheet" media="all">
<script type="text/javascript" src="../js/webimcommon.js"></script>
<script type="text/javascript" src="../js/webimpage.js"></script>
<title>添加联系人</title>
<script type="text/javascript">
var uid = 1;
function chkEmail()
{
	var email = $F("tbEmail").trim();
	if(email=="")
	{
		setTip("Email","请填写email地址","red");
		return false;
	}
	else if(!validEmail(email))
	{
		setTip("Email","错误的email地址","red");
		return false;
	}
	else if(!exsitEmail(email))
	{
		setTip("Email","不存在这样的用户","red");	
		return false;
	}
	setTip("Email","OK","gray");
	return true;
}
function chkAll()
{
	if(chkEmail())
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
<%
If Request.Form("tbEmail")<>"" Then
	email = GetSafeStr(Request.Form("tbEmail"))
	If email = Session("useremail") Then
		strResult = "<span class='red'>您不能加自己为好友!</span>"
	Else
		Call DataBegin()
		toid = GetUserIdByEmail(email)
		If oConn.ExeCute("select count(*) from [userfriend] where userid="&Session("userid")&" and friendid="&toid)(0)>0 Then
			strResult = "<span class='red'>您已经添加过这位好友!</span>"
		ElseIf  oConn.ExeCute("select count(*) from usersysmsg where fromid="&Session("userid")&" and toid="&toid)(0)>0 Then
			strResult = "<span class='red'>请耐心等待好友回复，不要重复发送!</span>"
		Else
			oConn.Execute("insert into usersysmsg (fromid,toid,msgcontent,typeid,msgaddtime) values ('"&Session("userid")&"','"&toid&"','"&Session("useremail")&"','7','"&Now()&"')")
			strResult = "发送成功，请等待验证结果!"
		End If
		Call DataEnd()
	End If
%>
<table width="200" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="70" align="center"><%=strResult%></td>
  </tr>
  <tr>
    <td height="35" align="center">
        <input class="button1" type="button" name="btnCancel" id="btnCancel" onclick="winClose(event);" value="关闭" /></td>
  </tr>
</table>
<%
Else

%>
<form action="addfriend.asp" method="post" name="form1" id="form1"> 
<table width="200" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="10"></td>
  </tr>
  <tr>
    <td height="20">即时消息地址：</td>
  </tr>
  <tr>
    <td height="25">
      <input name="tbEmail" type="text" class="input1" id="tbEmail" maxlength="50" onblur="chkEmail()"/>
    </td>
  </tr>
  <tr>
    <td height="20"><span id="spanEmail">示例：quguangyu@gmail.com</span></td>
  </tr>
  <tr>
    <td height="35" align="center">
        <input class="button1" type="button" name="btnSubmit" id="btnSubmit" value="确定" onclick="chkAll()"/>&nbsp;&nbsp; 
        <input class="button1" type="button" name="btnCancel" id="btnCancel" onclick="winClose(event);" value="取消" /></td>
  </tr>
</table>    
</form>   
<%End If%>
</body>
</html>