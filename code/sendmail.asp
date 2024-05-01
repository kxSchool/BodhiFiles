<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
</head>

<body>
<%
sendUrl="http://schemas.microsoft.com/cdo/configuration/sendusing"
smtpUrl="http://schemas.microsoft.com/cdo/configuration/smtpserver"
' Set the mail server configuration
Set objConfig=CreateObject("CDO.Configuration")
objConfig.Fields.Item(sendUrl)=2 ' cdoSendUsingPort
objConfig.Fields.Item(smtpUrl)="relay-hosting.secureserver.net"
objConfig.Fields.Update
' Create and send the mail
Set objMail=CreateObject("CDO.Message")
' Use the config object created above
Set objMail.Configuration=objConfig
objMail.From="123@123.com"
objMail.To="54zaj@163.com"
objMail.BodyPart.Charset = "utf-8" 
objMail.Subject="邮件标题"
objMail.TextBody="邮件内容"
objMail.send
Set objMail = Nothing
response.write "发送成功！"
%> 
<%
mailaddress="54zaj@163.com"
mailtopic="测试标题"
body="测试内容！"
Set cm=Server.CreateObject("CDO.Message")
cm.From=mailaddress
cm.To=mailaddress
cm.Subject=mailtopic
cm.HtmlBody=body
cm.Send
Set cm=Nothing
response.write "发送成功！"
%>
</body>
</html>
