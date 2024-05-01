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
		idparam.Value=bigmenuname_id;
		string bigmenuname=db.GetTable("select parentvalue from tbsystem where id=?",idparam).Rows[0][0].ToString();
		
		
        string sql = "update tbsystem set orderbyparent=? where parentvalue=?";
        OdbcParameter[] param ={ new OdbcParameter("@newtime", OdbcType.DateTime), new OdbcParameter("@parentvalue", OdbcType.VarChar, 200) };
        param[0].Value = System.DateTime.Now.ToString();
        param[1].Value = bigmenuname;
        db.ExecuteNonQuery(sql, param);
        db.closedb();
        Response.Redirect(Link.url("/menu_mgr/","addmenu.aspx","","","","",""));
        Response.End();


    }
</script> 