<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<script runat="server">


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        string bigmenuname_id = Request.QueryString["param1"]==null?"":Request.QueryString["param1"].ToString();
		OdbcParameter idparam=new OdbcParameter("@id",OdbcType.Int,4);
		
        string sql = "update department set createtime=? where id=?";
        OdbcParameter[] param ={ new OdbcParameter("@createtime", OdbcType.DateTime), new OdbcParameter("@id", OdbcType.Int, 4) };
        param[0].Value = System.DateTime.Now.ToString();
        param[1].Value = bigmenuname_id;
        db.ExecuteNonQuery(sql, param);
        db.closedb();
		Response.Redirect(Link.url("/dept_mgr/","dept_manage.aspx","","","","",""));

        Response.End();


    }
</script> 