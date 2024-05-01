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

  string submenuname_id = Request.QueryString["param1"]==null?"":Request.QueryString["param1"].ToString();
		OdbcParameter idparam=new OdbcParameter("@id",OdbcType.Int,4);
		idparam.Value=submenuname_id;
		string submenuname=db.GetTable("select sencondvalue from tbsystem where id=?",idparam).Rows[0][0].ToString();
		
		
		
        string sql = "update tbsystem set orderbysencond=? where sencondvalue=?";
        OdbcParameter[] param ={ new OdbcParameter("@newtime", OdbcType.DateTime), new OdbcParameter("@sencondvalue", OdbcType.VarChar, 200) };
        param[0].Value = System.DateTime.Now.ToString();
        param[1].Value = submenuname;
        db.ExecuteNonQuery(sql, param);
        Response.Redirect(Link.url("/menu_mgr/","addmenu.aspx","","","","",""));
      
        
           db.closedb();
        Response.End();

     
    }

</script>