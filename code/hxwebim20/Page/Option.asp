<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<%
Response.Expires = WebCachTime
Response.Charset="utf-8"
Call CheckLogin()
Call DataBegin()

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../styles/webimpage.css" type="text/css" rel="stylesheet" media="all">
<script type="text/javascript" src="../js/webimcommon.js"></script>
<script type="text/javascript" src="../js/webimpage.js"></script>
<title>选项</title>
<script type="text/javascript">
var uid = 8;
</script>
</head>
<body> 
<%
If Request.Form("btnSubmit")<>"" Then
	'ShowFocus = Request.Form("cbshowfocus")
	'If ShowFocus="" Then ShowFocus=2
	disType = Request.Form("rddistype")
	orderType = Request.Form("rdordertype")
	chatSide = Request.Form("rdchatside")
	msgSendKey = Request.Form("rdmsgsendkey")
	msgShowTime = Request.Form("rdmsgshowtime")
	oConn.Execute("update userconfig set distype="&disType&",ordertype="&orderType&",chatside="&chatSide&",msgsendkey="&msgSendKey&",msgshowtime="&msgShowTime&" where userid = "&Session("userid"))
	saveResult = "保存成功!"
	saveInfo = "部分设置需等到下次登录才能生效"
%>
<script type="text/javascript">
	parent._webIM.Config.ChatSide = parseInt("<%=chatSide%>");
	parent._webIM.Config.MsgSendKey = parseInt("<%=msgSendKey%>");
	parent._webIM.Config.MsgShowTime = parseInt("<%=msgShowTime%>");
	parent._webIM.CMD.renderMyFriend(<%=orderType%>,<%=disType%>,true);
</script>
<table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="85" align="center" style="font-size:16px;color:red"><%=saveResult%></td>
  </tr>
  <tr>
    <td height="45" align="center"><%=saveInfo%></td>
  </tr>
  <tr>
    <td height="170"></td>
  </tr>
  <tr>
    <td height="85" align="center"><input class="button1" type="button" name="btnLogin" id="btnLogin" value="关闭" onclick="winClose(event);"/></td>
  </tr>
</table>
<%
Else
	sql = "select * from userconfig where userid="&Session("userid")
	oRs.Open sql,oConn,1,1
	If Not(oRs.Bof And oRs.Eof) Then
		distype = oRs("distype")
		ordertype = oRs("ordertype")
		chatside = oRs("chatside")
		msgsendkey = oRs("msgsendkey")
		msgshowtime = oRs("msgshowtime")
		'showfocus = oRs("showfocus")
	Else
		Response.End()
	End If
%>
<form action="option.asp" method="post" name="form1" id="form1">
<table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="15" colspan="2"></td>
  </tr>
  <tr>
    <td height="25">&nbsp;好友列表：</td>
    <td><input name="rdOrderType" type="radio" id="rdOrderType1" value="1" <%If ordertype="1" Then%> checked="checked" <%End If%>/>
      <label for="rdOrderType1">状态排序</label>
      <input name="rdOrderType" type="radio" id="rdOrderType2" value="2" <%If ordertype="2" Then%> checked="checked" <%End If%>/>
      <label for="rdOrderType2">分组排序</label></td>
  </tr>
  <tr>
    <td width="70" height="25">&nbsp;好友列表：</td>
    <td><input name="rdDisType" id="rdDisType1" type="radio" value="1" <%If distype="1" Then%> checked="checked" <%End If%>/>
      <label for="rdDisType1">简要信息</label>
      <input name="rdDisType" id="rdDisType2" type="radio" value="2" <%If distype="2" Then%> checked="checked" <%End If%>/>
      <label for="rdDisType2">详细信息</label></td>
  </tr>
  <tr>
    <td height="25">&nbsp;聊天窗口：</td>
    <td><input name="rdChatSide" type="radio" id="rdChatSide1" value="1" <%If chatside="1" Then%> checked="checked" <%End If%>/>
      <label for="rdChatSide1">显示参与者图片</label>
      <input name="rdChatSide" type="radio" id="rdChatSide2" value="2" <%If chatside="2" Then%> checked="checked" <%End If%>/>
      <label for="rdChatSide2">隐藏参与者图片</label></td>
  </tr>
  <tr>
    <td height="25">&nbsp;聊天窗口：</td>
    <td><input name="rdMsgShowTime" type="radio" id="rdMsgShowTime1" value="1" <%If msgshowtime="1" Then%> checked="checked" <%End If%>/>
      <label for="rdMsgShowTime1">显示消息发送时间</label>
      <input name="rdMsgShowTime" type="radio" id="rdMsgShowTime2" value="2" <%If msgshowtime="2" Then%> checked="checked" <%End If%>/>
      <label for="rdMsgShowTime2">隐藏消息发送时间</label></td>
  </tr>
  <tr>
    <td height="25">&nbsp;聊天窗口：</td>
    <td><input name="rdMsgSendKey" type="radio" id="rdMsgSendKey1" value="1" <%If msgsendkey="1" Then%> checked="checked" <%End If%>/>
      <label for="rdMsgSendKey1">Enter发送消息</label>
      <input name="rdMsgSendKey" type="radio" id="rdMsgSendKey2" value="2" <%If msgsendkey="2" Then%> checked="checked" <%End If%>/>
      <label for="rdMsgSendKey2">Ctrl+Enter发送消息</label></td>
  </tr>
<!--   <tr>
    <td height="10" colspan="2" align="center"></td>
  </tr>
  <tr>
    <td height="25" colspan="2">
		<input type="checkbox" value="1" id="cbShowFocus" name="cbShowFocus" <%If showfocus="1" Then%> checked="checked" <%End If%>><label for="cbShowFocus">登录后显示今日焦点</label>
	</td>
  </tr> -->
  <tr>
    <td height="180" colspan="2" align="center"></td>
  </tr>
  <tr>
    <td height="35" colspan="2" align="center">
        <input class="button1" type="submit" name="btnSubmit" id="btnSubmit" value="确定"/>&nbsp;&nbsp; 
        <input class="button1" type="button" name="btnCancel" id="btnCancel" onclick="winClose(event);" value="取消" /></td>
  </tr>
</table>    
</form>
<%
	End If
	Call DataEnd()
%>
</body>
</html>