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
<title>今日焦点</title>
<script type="text/javascript">
var uid = 2;
</script>
</head>
<body> 
<div style="float:left;width:99%;height:350px;padding:3px;line-height:150%;overflow:auto">
<table width="95%" border="0">
	<tr>
		<td valign="top" style="width:10px">Q:</td>
		<td style="font-weight:bold">这个WebIM谁写的？用了多久？</td>
	</tr>
	<tr>
		<td valign="top">A:</td>
		<td>韩欣写的啊。从7.17暑假开始开工，到全部完工经历了40多天。中间看奥运会耽误了一些时间，现在也在断断续续的修改部分bug。</td>
	</tr>
	<tr>
		<td valign="top">Q:</td>
		<td style="font-weight:bold">后台是什么写的？能移植到**平台可以吗？</td>
	</tr>
	<tr>
		<td valign="top">A:</td>
		<td>asp写的，当初选asp主要是我做asp的网站多了，比较熟悉。不过由于大部分数据是用xml传输的，移植相对还是算简单的。</td>
	</tr>
	<tr>
		<td valign="top">Q:</td>
		<td style="font-weight:bold">能把源代码给我一份么？</td>
	</tr>
	<tr>
		<td valign="top">A:</td>
		<td>暂时只能提供UI部分的代码，<a href="http://www.baidu.com" target="_blank">见这里</a>。具体原因在51js那个帖子已经说明。以后可能会整理出一个带数据库的完整版本，请多多留意<a href="" target="_blank"></a>或我的<a href="#" target="_blank">blog</a>。<img src="../msnface/wink_smile.gif" /></td>
	</tr>
	<tr>
		<td valign="top">Q:</td>
		<td style="font-weight:bold">为什么在我这里**功能不能用呢？</td>
	</tr>
	<tr>
		<td valign="top">A:</td>
		<td>很可能你遇上了传说中的bug。麻烦你告诉我一声：<a href="http://www.baidu.com" target="_blank">点击这里</a>或<a href="" target="_blank">这里</a>。谢谢~</td>
	</tr>
	<tr>
		<td valign="top">Q:</td>
		<td style="font-weight:bold">还有别的问题？</td>
	</tr>
	<tr>
		<td valign="top">A:</td>
		<td>欢迎加我的IM：hanxin1987216@hotmail.com(MSN),565268510(QQ)。</td>
	</tr>
</table>
</div>
<div style="width:100%;text-align:center">
	<input class="button1" type="button" name="btnLogin" id="btnLogin" value="关闭" onclick="winClose(event);"/>
</div>
</body>
</html>