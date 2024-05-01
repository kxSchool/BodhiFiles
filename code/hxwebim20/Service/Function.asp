<%
Dim oConn,oRs
Sub OutNode(name,value)
	Response.Write("<"&name&">")
	If Trim(value)<>"" Then
		Response.Write(Server.HtmlEncode(value))
	End If
	Response.Write("</"&name&">")
End Sub

Sub DataBegin
	If IsObject(oConn) = True Then Exit Sub
	Set oConn = Server.CreateObject("Adodb.Connection")
	oConn.Open "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" & Server.MapPath("../database/#data.mdb")
	Set oRs = Server.CreateObject("Adodb.RecordSet")
End Sub

Sub DataEnd
	oConn.Close()
	Set oConn = Nothing
End Sub

Function GetSafeStr(str)
	GetSafeStr = Replace(Replace(Replace(Trim(str), "'", ""), Chr(34), ""), ";", "")
End Function

Function GetFileType(path)
	m=split(path,"/")
	n=split(m(ubound(m)),".")
	GetFileType=trim(n(ubound(n)))
End Function

Function GetUserIdByEmail(email)
	GetUserIdByEmail = oConn.Execute("select userid from [user] where useremail = '"&email&"'")(0)
End Function

Function GetCustomNameById(fromid,toid)
	username = oConn.Execute("select username from [user] where userid = "&toid)(0)
	customname = ""
	If CInt(oConn.Execute("select count(*) from userfriend where friendid = "&toid&" and userid = "&fromid)(0)>0) Then
		customname = oConn.Execute("select customname from userfriend where friendid = "&toid&" and userid = "&fromid)(0)
	End If
	If Trim(customname)<>"" Then
		GetCustomNameById = customname
	Else
		GetCustomNameById = username
	End If
End Function

Function ParseDateTime(str)
	d = CDate(str)
	ParseDateTime = Year(d)&"/"&Month(d)&"/"&Day(d)&" "&Hour(d)&":"&Minute(d)
End Function

Function CutStr(str,n)
	If Len(str)>n Then
		CutStr = Left(str,n-3)&"..."
	Else
		CutStr = str
	End If
End Function
%>