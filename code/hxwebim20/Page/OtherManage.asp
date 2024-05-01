<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<%
Response.Expires = WebCachTime
Response.Charset="utf-8"
Call CheckLogin()
If CInt(Session("userpower"))>1 Then Response.End
Call DataBegin()
Set FSO = Server.CreateObject("Scripting.FileSystemObject")
Set file = FSO.GetFile(Server.MapPath("../database/#data.mdb"))
DbSize = CInt(file.Size/1024)
Set Folder = FSO.GetFolder(Server.MapPath("../userface/"))
Set files = Folder.Files
FaceSize = 0
FaceCount = 0
If Files.Count <> 0 Then
  For Each File In Files
	 FaceSize = FaceSize + File.Size
	 FaceCount = FaceCount + 1
  Next
End If
FaceSize = CInt(FaceSize/1024)
Set FSO = Nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../styles/webimpage.css" type="text/css" rel="stylesheet" media="all">
<script type="text/javascript" src="../js/webimcommon.js"></script>
<script type="text/javascript" src="../js/webimpage.js"></script>
<title>管理</title>
<script type="text/javascript">
var uid = 12;
</script>
</head>
<body> 
<div style="width:540px;height:15px;text-indent:6px">
	<a onclick="showLoading()" href="usermanage.asp">用户管理</a>&nbsp;&nbsp;<span class="gray">系统信息</span>
</div>
<div style="float:left;width:100%;height:388px;overflow:auto;padding-top:10px">
<ul style="line-height:150%;font-size:13px">
	<li>总注册人数：<%=oConn.Execute("select count(*) from [user]")(0)%>人</li>
	<li>剩余帐号数：<%=oConn.Execute("select count(*) from usernum where isok=1")(0)%>人</li>
	<li>超级管理员：<%=oConn.Execute("select count(*) from [user] where userpower=0")(0)%>人</li>
	<li>一般管理员：<%=oConn.Execute("select count(*) from [user] where userpower=1")(0)%>人</li>
	<li>文本消息数：<%=oConn.Execute("select count(*) from usermsg")(0)%>条</li>
	<li>系统消息数：<%=oConn.Execute("select count(*) from usersysmsg")(0)%>条</li>
	<li>数据库大小：<%=DbSize%>KB</li>
	<li>自定义头像：<%=FaceCount%>个，<%=FaceSize%>KB</li>
</ul>
</div>
</body>
</html>
<%
Call DataEnd()
%>