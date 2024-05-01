<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file = "../Service/config.asp"-->
<!--#include file = "../Service/function.asp"-->
<!--#include file = "../Service/cmd.asp"-->
<%
Response.Expires = WebCachTime
Response.Charset="utf-8"
Call CheckLogin()
id = Request.QueryString("id")
If id="" Or IsNumeric(id)=False Then id = -1
id = CInt(id)
p = Request.QueryString("p")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../styles/webimpage.css" type="text/css" rel="stylesheet" media="all">
<script type="text/javascript" src="../js/webimcommon.js"></script>
<script type="text/javascript" src="../js/webimpage.js"></script>
<title>聊天记录</title>
<script type="text/javascript">
var uid = 9;
</script>
</head>
<body> 
<div style="width:548px;height:23px">
	<div style="text-indent:5px;float:left">
		范围：<select onchange="showLoading();location.href='?id='+this.value">
			<option value="-1">全部</option>
			<%
				sql = "select a.friendid,b.username from userfriend a inner join [user] b on a.friendid = b.userid where a.userid = "&Session("userid")
				Call DataBegin()
				oRs.Open sql,oConn,1,1
				If Not(oRs.Bof And oRs.Eof) Then
					oRs.MoveFirst
					While Not oRs.Eof
						Response.Write("<option value="""&oRs("friendid")&"""")
						If CInt(oRs("friendid"))=id Then Response.Write(" selected=""selected"" ")
						Response.Write(">"&GetCustomNameById(Session("userid"),oRs("friendid"))&"</option>")
						oRs.MoveNext
					Wend
				End If
				oRs.Close()
				Set oRs = Nothing
			%>
		</select>
	</div>
<%
	Set oRs = Server.CreateObject("Adodb.RecordSet")
	sql = "select * from usermsg where (fromid = "&Session("userid")&" and toid = "&id&") or (toid = "&Session("userid")&" and fromid = "&id&") order by id"
	If id = -1 Then sql = "select * from usermsg where fromid = "&Session("userid")&" or toid = "&Session("userid")&" order by id"
	oRs.Open sql,oConn,1,1
	If Not (oRs.Bof And oRs.Eof) Then
		oRs.PageSize = 17	
		If p="" Or IsNumeric(p)=False Then p = oRs.PageCount
		p = CInt(p)
		oRs.AbsolutePage = p
%>
	<div style="float:right;padding-right:5px">
		<a href="messagetxt.asp?id=<%=id%>" target="_blank">下载到本地</a>&nbsp;
		到
		<select onchange="showLoading();location.href='?id=<%=id%>&p='+this.value" >
		<%
			For Q = 1 To oRs.PageCount
				Response.Write("<option value="""&Q&"""")
				If p=Q Then Response.Write(" selected=""selected"" ")
				Response.Write(">"&Q&"</option>")
			Next
		%>
		</select>
		页&nbsp;
		共<%=p%>/<%=oRs.PageCount%>页
		<%If p<>1 Then%>
			<a onclick="showLoading();" href="?p=1&id=<%=id%>">首页</a>
			<a onclick="showLoading();" href="?p=<%=p-1%>&id=<%=id%>">上页</a>
		<%Else%>
			<span class="gray">首页</span>
			<span class="gray">上页</span>
		<%End If%>
		<%If p<>oRs.PageCount Then%>	
			<a onclick="showLoading();" href="?p=<%=p+1%>&id=<%=id%>">下页</a>
			<a onclick="showLoading();" href="?p=<%=oRs.PageCount%>&id=<%=id%>">末页</a>
		<%Else%>
			<span class="gray">下页</span>
			<span class="gray">末页</span>
		<%End If%>
	</div>
</div>
<div style="width:548px;height:400px;overflow:auto">
<table align="center" width="98%" border="0" cellpadding="0" cellspacing="1" style="background-color:#bed6e0">
	<tr>
		<td style="background-color:#e0edff;height:21px;width:90px;text-align:center">发 送</td>
		<td style="background-color:#e0edff;width:90px;text-align:center">接 收</td>
		<td style="background-color:#e0edff;width:120px;text-align:center">时 间</td>
		<td style="background-color:#e0edff;text-align:center">内 容</td>
	</tr>
<%
	For I = 1 To oRs.PageSize
	If I Mod 2 = 1 Then
		TdColor = "fff"
	Else
		TdColor = "e0edff"
	End If

	If CInt(oRs("typeid"))= 2 Then
		If Trim(oRs("msgcontent")) = "FLASH" Then
			msgContent = "<span class='gray'>闪屏振动</span>"
		End If
	Else
		msgContent = Server.HtmlEncode(Replace(oRs("msgcontent"),"{br}",""))
	End If
%>
	<tr>
		<td style="background-color:#<%=TdColor%>;height:21px;text-align:center"><%=GetCustomNameById(Session("userid"),oRs("fromid"))%></td>
		<td style="background-color:#<%=TdColor%>;text-align:center"><%=GetCustomNameById(Session("userid"),oRs("toid"))%></td>
		<td style="background-color:#<%=TdColor%>;text-align:center"><%=oRs("msgaddtime")%></td>
		<td style="background-color:#<%=TdColor%>;text-indent:5px"><%=msgContent%></td>
	</tr>
<%
	oRs.MoveNext
	If oRs.Eof Then Exit For
	Next
%>
</table>
</div>
<%
	Else
		Response.Write("</div><div style=""padding:20px"">没有找到任何记录!</div>")
	End If
%>

<%
	Call DataEnd()
%>
</body>
</html>