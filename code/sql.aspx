<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        DBClass db = new DBClass();
        db.ExecuteNonQuery("select * from tbuser", null);
        
		
		string sql = "select * from tbcustom where (userno=?) and (id between 450000 and 450010)";
		
		OdbcParameter[] useridparam ={
         new OdbcParameter("@userno",OdbcType.VarChar,20)

        };
        useridparam[0].Value = "32235";
        DataTable dt = new DataTable();
        dt = db.GetTable(sql, useridparam);

        if (dt.Rows.Count == 0)
        {
            Response.Write("没有该用户");
        }
		else
		{
		    Response.Write(dt.Rows.Count);
		}
		db.closedb();
		
		

    }

 </script>