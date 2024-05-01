<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>

<script runat="server">
 protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["userno"] == null || Session["userno"].ToString() == "")
        {
 
            Response.Redirect(Link.url("/", "default.aspx","","","","",""));
            Response.End();
        }
    }

</script>

<html>
<head id="Head1" runat="server">
 
<title>∷金石协同办公管理系统∷</title>  
</head>

</HEAD>



<frameset  rows="84,*" cols="*" frameborder="NO" border="0" framespacing="0">
  <frame src="<%=Link.url("/", "frmTop.aspx","","","","","")%>" name="topFrame" scrolling="NO" noresize >
  <frameset  id="attachucp"  cols="176,10,*" frameborder="NO" border="0"  framespacing="0">
    <frame name="contents" target="main" src="<%=Link.url("/", "leftframe.aspx","","","","","")%>" scrolling="No"  frameborder="no"  noresize="noresize" >
     <frame id="leftbar" scrolling="no" noresize="" name="switchFrame" src="swich.html">
     </frame>
     <frame name="main" src="<%=Link.url("/", "document.aspx","","","","","")%>"></frameset>
  </frameset>
</frameset>
<noframes></noframes>

</HTML>    
