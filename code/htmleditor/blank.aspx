<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>



<script runat="server">
protected string contentstring="";
    protected void Page_Load(object sender, EventArgs e)
    {
	if (Request.QueryString["param1"]!=null)
	{
		 DBClass db = new DBClass();
        string sql = "select content  from tbnews where tbnews.id=?";
        OdbcParameter param = new OdbcParameter("@id", OdbcType.Int, 4);
        param.Value =Request.QueryString["param1"].ToString();

        DataTable dt = db.GetTable(sql, param);

       contentstring=dt.Rows[0]["content"].ToString();
	   //contentstring=contentstring.Replace("\n","<br>");
	   

        db.closedb();
    }
	}

</script>
<html>
<head>
<title></title>
</head>
<body>
<%Response.Write(contentstring);%>
</body>
</html>


