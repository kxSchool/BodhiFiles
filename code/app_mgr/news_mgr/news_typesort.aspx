<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "")
        {
			 Fun.goback("","参数错误！","返回");
            Response.End();
        }
        string id = Request.QueryString["param1"].ToString();
        DBClass db = new DBClass();
        OdbcParameter[] param ={ 
        
         new OdbcParameter("@nowtime",OdbcType.DateTime),
            new OdbcParameter("@id",OdbcType.Int,4)
        };
        param[0].Value = DateTime.Now;
        param[1].Value = Convert.ToInt32(id);
        db.ExecuteNonQuery("update tbnewstype set createtime=? where id=?",param);
        db.closedb();
        Response.Redirect(Link.url("/app_mgr/news_mgr/","news_typemanage.aspx","","","","",""));
        
    }
</script>

