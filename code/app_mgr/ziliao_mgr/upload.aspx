<%@ Page Language="C#" AutoEventWireup="true" CodeFile="upload.aspx.cs" Inherits="upload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>上传</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="scripts/jquery.js"></script>
    <style type="text/css">
        *{ margin:0; padding:0; }
        
    </style>
    <script type="text/javascript">
        
	    var uploadSelect = function(el){
		    el.fadeOut("show");		
		    parent.uploading(document.getElementById("<%=file1.ClientID %>").value,'<%=itemID %>');
		    $("#<%=frmUpload.ClientID %>").submit();
	    };
 	    
    </script>
</head>
<body>
    <form runat="server" id="frmUpload" method="post" enctype="multipart/form-data">
        <input type="file" runat="server" id="file1" size="40" onchange="uploadSelect($(this));" />	    
    </form>
</body>
</html>
