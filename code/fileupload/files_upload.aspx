<%@ Page Language="VB"  aspcompat=true Debug="True"  ResponseEncoding="utf-8" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web.HttpPostedFile" %>
<%@ Import Namespace="System.Web.UI.HtmlControls.HtmlInputFile" %>
<%@ import namespace="system.drawing" %>  
<%@ import namespace="system.drawing.imaging" %>  
<%@ import namespace="system.drawing.drawing2d" %>  
<%@ Import Namespace="System.Data.sqlclient"%>
<%@ Import Namespace="System.Data"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>文件上传</title>
</head>

<body>
<script language="VB" runat="server">
Sub page_load()


'######## COM 密码读取.......
Dim val,uid, server1,database,picpath,pwd

'#####################
    Dim Files As HttpPostedFile
	    Files = Request.Files.item("Filedata")
Dim gg1,gg2,gg3  as string
gg1=Files.FileName
gg1=gg1.Substring(gg1.LastIndexOf("\") + 1)
gg2 = gg1.Substring(0, gg1.Length - gg1.Substring(gg1.LastIndexOf(".")).Length)
if request.form("picpath")="" then
 gg3=gg2
 else
 gg3=request.form("picpath")
 end if
	 dim  d1 as DateTime = DateTime.Now
    dim c,datetimes
    datetimes=format(d1,"yyyyMMddHHmmss")
    Dim MyValue As Integer
	Randomize
    MyValue = CInt(Int((100000000 * Rnd()) + 1))
    c=datetimes & MyValue
    Dim FileName as String="photo" &  c & right(Files.FileName,4)
	
	If (Files.ContentLength = 0 or Files.ContentLength > 80485760) then
		response.write("default.html")		
	Else
	
		if (ucase(right(Files.FileName,4))=".TXT" or ucase(right(Files.FileName,4))=".JPG" or  ucase(right(Files.FileName,4))=".WMV" or ucase(right(Files.FileName,4))=".WMA" or ucase(right(Files.FileName,4))=".SWF" or ucase(right(Files.FileName,4))=".MDB" or ucase(right(Files.FileName,4))=".AVI" or ucase(right(Files.FileName,4))=".MPG" or ucase(right(Files.FileName,4))=".DOC" or ucase(right(Files.FileName,4))=".XLS" or ucase(right(Files.FileName,4))=".PPS"  or ucase(right(Files.FileName,4))=".PPT" or ucase(right(Files.FileName,4))=".EXE" or ucase(right(Files.FileName,4))=".RAR" or ucase(right(Files.FileName,4))=".ZIP")  then
			'response.Write(request.form("fileNames"))
			 'response.Write(Files.ContentType)
	         'response.Write(FileName)
	         'response.Write(Files.ContentLength)
	         ' response.End()     
	 dim types,p
			types=Files.ContentType
			Dim piclib As String = picpath
			
			dim filepath as string = Server.MapPath("sfile")  & "\" & FileName
			
			Files.SaveAs(filepath)
			
			response.write("ok")
		else
		response.write("error")
		end if
	End If
End Sub
</script>
</body>
</html>
