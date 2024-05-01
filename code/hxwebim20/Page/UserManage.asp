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
p = Request.QueryString("p")
If Request.QueryString("op") = "del" Then
	id = Request.QueryString("id")
	Set oRs1 = Server.CreateObject("Adodb.RecordSet")
	sql = "select userid,userpower from [user] where id = "&id
	oRs1.Open sql,oConn,1,3
	If Not(oRs1.Bof Or oRs1.Eof) Then
		userid = CInt(oRs1("userid"))
		userpower = CInt(oRs1("userpower"))
		If userpower > CInt(Session("userpower")) Then '只能删除比自己权限低的用户
			oRs1.Delete
			oRs1.Update
			oConn.Execute("delete from userfriend where (userid = "&userid&" or friendid = "&userid&" )") '删除好友
			oConn.Execute("delete from usermsg where (fromid = "&userid&" or toid = "&userid&" )") '删除文本消息
			oConn.Execute("delete from usersysmsg where (fromid = "&userid&" or toid = "&userid&" )") '删除系统消息
			oConn.Execute("delete from userconfig where userid = "&userid) '删除配置
			oConn.Execute("delete from usergroup where userid = "&userid) '删除分组
			oConn.Execute("update usernum set isok = 1 where num = "&userid) '回收号码
		End If
	End If
	oRs1.Close()
	Set oRs1 = Nothing
ElseIf Request.QueryString("op") = "chgpower" Then
	id = Request.QueryString("id")
	power = Request.QueryString("pw")
	Set oRs1 = Server.CreateObject("Adodb.RecordSet")
	sql = "select userid,userpower from [user] where id = "&id
	oRs1.Open sql,oConn,1,3
	If Not(oRs1.Bof Or oRs1.Eof) Then
		If 0 = CInt(Session("userpower")) Then '只有超级管理员有这个权限
			oRs1("userpower") = power
			oRs1.Update
			If power = "1" Then
				msg = "你已经成为管理员，下次登录你的面板将出现管理按钮！"
			Else
				msg = "你不再是管理员了！"
			End If
			oConn.Execute("insert into usermsg (fromid,toid,msgcontent,typeid,msgaddtime) values ('10000','"&oRs1("userid")&"','"&msg&"','1','"&Now()&"')")
		End If
	End If
	oRs1.Close()
	Set oRs1 = Nothing
End If
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
function goSearch()
{
	showLoading();
	location.href = "?k="+$F("txtKey").toString().escapeEx();
}
</script>
</head>
<body> 
<div style="width:540px;height:15px;text-indent:6px">
	<span class="gray">用户管理</span>&nbsp;&nbsp;<a onclick="showLoading()" href="othermanage.asp">系统信息</a>
</div>
<div style="float:left;width:100%;height:388px;overflow:auto">
<table align="center" width="98%" border="0" cellpadding="0" cellspacing="1" style="background-color:#bed6e0">
	<tr>
		<td style="background-color:#e0edff;height:21px;width:150px;text-align:center">基本信息</td>
		<td style="background-color:#e0edff;width:55px;text-align:center">头 像</td>
		<td style="background-color:#e0edff;text-align:center">管理</td>
		<td style="background-color:#e0edff;width:150px;text-align:center">基本信息</td>
		<td style="background-color:#e0edff;width:55px;text-align:center">头 像</td>
		<td style="background-color:#e0edff;text-align:center">管理</td>
	</tr>
<%
sql = "select * from [user] order by id desc"
key = Request.QueryString("k")
If Trim(key)<>"" Then sql = "select * from [user] where (userid like '%"&key&"%' or username like '%"&key&"%' or useremail like '%"&key&"%') order by id desc"
oRs.Open sql,oConn,1,1
If Not (oRs.Bof And oRs.Eof) Then
	oRs.PageSize = 14	
	If p="" Or IsNumeric(p)=False Then p = 1
	p = CInt(p)
	oRs.AbsolutePage = p
	For I = 1 To oRs.PageSize/2
	If I Mod 2 = 1 Then
		TdColor = "fff"
	Else
		TdColor = "e0edff"
	End If
%>
	<tr>
		<%
		Call OutItem()
		oRs.MoveNext
		If oRs.Eof Then 
			Response.Write("<td colspan=""3""  style=""background-color:#"&TdColor&"""></td>")
			Exit For
		End If
		Call OutItem()
		%>
	</tr>
<%
	oRs.MoveNext
	If oRs.Eof Then Exit For
	Next
Else
	Response.Write("<tr><td  style=""height:25px;background-color:#fff"" colspan=""6"">&nbsp;没有任何记录！</td></tr>")
End If
%>
</table>
</div>
<div style="float:left;padding-left:5px">
	<input type="text" style="width:120px;height:14px" id="txtKey" value="<%=key%>" />
	<input class="button1" type="button" onclick="goSearch();" value="搜索" />&nbsp;
	<input class="button1" type="button" onclick="Elem.Value('txtKey');goSearch();" value="全部" />
</div>
<%If oRs.PageCount > 0 Then%>
<div style="float:right;padding-right:5px">
	到
	<select style="font-size:11px" onchange="showLoading();location.href='?k=<%=key%>&p='+this.value" >
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
		<a onclick="showLoading();" href="?k=<%=key%>&p=1">首页</a>
		<a onclick="showLoading();" href="?k=<%=key%>&p=<%=p-1%>">上页</a>
	<%Else%>
		<span class="gray">首页</span>
		<span class="gray">上页</span>
	<%End If%>
	<%If p<>oRs.PageCount Then%>	
		<a onclick="showLoading();" href="?k=<%=key%>&p=<%=p+1%>">下页</a>
		<a onclick="showLoading();" href="?k=<%=key%>&p=<%=oRs.PageCount%>">末页</a>
	<%Else%>
		<span class="gray">下页</span>
		<span class="gray">末页</span>
	<%End If%>
</div>
<%
End If
oRs.Close()
Set oRs = Nothing
Call DataEnd()
%>
</body>
</html>
<%
Sub OutItem
%>
	<td style="background-color:#<%=TdColor%>;height:51px;text-align:center"><%=CutStr(oRs("username"),12)%>(<%=oRs("userid")%>)[<%If oRs("usergender")="1" Then%>男<%Else%>女<%End If%>]<br /><a href="mailto:<%=oRs("useremail")%>"><%=CutStr(oRs("useremail"),22)%></a></td>
	<td style="background-color:#<%=TdColor%>;text-align:center"><a target="_blank" href="../userface/<%=oRs("userface")%>"><img title="<%=oRs("username")%>" src="../userface/<%=oRs("userface")%>" style="width:50px;height:50px;border:0"/></a></td>
	<td style="background-color:#<%=TdColor%>;text-align:center"><a onclick="if(!confirm('你真的要删除“<%=oRs("username")%>”这位用户(无法还原)？'))return false;else showLoading();" href="?p=<%=p%>&op=del&id=<%=oRs("id")%>&k=<%=key%>">删除</a><br /><%If 0 = CInt(Session("userpower")) Then%><%If oRs("userpower")="1" Then%><a  onclick="showLoading();" href="?p=<%=p%>&op=chgpower&pw=2&id=<%=oRs("id")%>&k=<%=key%>">取消管理员</a><%ElseIf oRs("userpower")="2" Then%><a onclick="showLoading();" href="?p=<%=p%>&op=chgpower&pw=1&id=<%=oRs("id")%>&k=<%=key%>">设为管理员</a><%Else%>超级管理员<%End If%><%End If%></td>
<%
End Sub
%>