﻿<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">


DateTime dt1=Convert.ToDateTime(System.DateTime.Now.AddDays(-1).ToShortDateString().ToString());
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
    protected string news_id = "",contentstring = "",contentstring1 = "",news_titlestring = "",usernamestring = "",createtimestring="";
	protected StringBuilder selectsb = new StringBuilder();
    protected StringBuilder selectdatatypesb = new StringBuilder();
	
    protected void Page_Load(object sender, EventArgs e)
    {

string server_v1,server_v2;
server_v1=HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
server_v2=HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
if (server_v1!=null) 
{
if (server_v1.Substring(7, server_v2.Length) != server_v2 && server_v1.Substring(8, server_v2.Length) != server_v2)
{
Response.Write ("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
Response.Write ("<tr><td style='font:9pt Verdana'>");
Response.Write ("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
Response.Write ("</td></tr></table></center>");
Response.End();
}
}
else
{
Response.Write ("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
Response.Write ("<tr><td style='font:9pt Verdana'>");
Response.Write ("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
Response.Write ("</td></tr></table></center>");
Response.End();
}


if(Session["condition"]==null) {Session["condition"]="null";} 		
        DBClass db = new DBClass();
        
        news_id = Request.QueryString["param1"].ToString();
        OdbcParameter param1 = new OdbcParameter("@id",OdbcType.Int,4);
        param1.Value = news_id;
        DataTable dt = db.GetTable("select content,news_title,createtime,(select username from tbuser where userno=tbnews.userno) as username from tbnews where id=?",param1);
		news_titlestring= dt.Rows[0]["news_title"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") ;
        contentstring = dt.Rows[0]["content"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") ;
		usernamestring= dt.Rows[0]["username"].ToString();
		createtimestring= dt.Rows[0]["createtime"].ToString();
		
       
db.closedb();


    }
	
		
	/// <summary>
    /// /////////页面显示
    /// </summary>
    /// <param name="db"></param>
    protected void ShowPage(DBClass db)
    {

        //页面载入显示
        string sqls;
        StringBuilder sb = new StringBuilder();
        DataTable datatable = new DataTable();          
            sqls = "select tbnews.*,tbnewstype.id as typeid,tbnewstype.typename from tbnews left join tbnewstype on tbnews.type_id=tbnewstype.id  where tbnews.isdelete=0 and  tbnews.mobilepwd=?  ";
            sqls = sqls + " order by tbnews.createtime desc";

        OdbcParameter[] param1 ={ 
                       new OdbcParameter("@mobilepwd",OdbcType.VarChar,50)  };
        param1[0].Value = Session["phonepwd"].ToString();
        datatable = db.GetTable(sqls, param1);

        //分页页面显示
        total = int.Parse(datatable.Rows.Count.ToString()); pagesize = 10;  //每页显示
        maxpage = total / pagesize;
        if (total % pagesize > 0)
        {
            maxpage++;
        }
        if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "" || Convert.ToInt32(Request.QueryString["param1"]) < 1)
        {
            nowpage = 1;
        }
        else
        {
            nowpage = Convert.ToInt32(Request.QueryString["param1"].ToString());
        }
        if (Request.QueryString["param1"] != "" && Convert.ToInt32(Request.QueryString["param1"]) > maxpage)    //防止太大
            nowpage = maxpage;
        if (nowpage <= 0)
            nowpage = 1;  //没有这一句当记录为空是点下一页出错

        int id = (nowpage - 1) * pagesize + 1;
        int showcount;
        if (nowpage * pagesize < datatable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = datatable.Rows.Count;


        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
			sb.Append("<td height=\"24\" align=\"left\" >&nbsp;&nbsp;<a  href=\""+ Link.url("/phone/","news_view.aspx",datatable.Rows[i]["id"].ToString(),"","","","") +"\">" + datatable.Rows[i]["news_title"].ToString() + "</a></td>\n");
			sb.Append("<td height=\"24\" align=\"left\" >&nbsp;&nbsp;<a  href=\""+ Link.url("/phone/","news_edit.aspx",datatable.Rows[i]["id"].ToString(),"","","","") +"\">修改</a></td>\n");
			sb.Append("</tr>\n");

            id++;
        }

        contentstring =contentstring + "<table>" + sb.ToString() + "</table>";

    }


	
    /// <summary>
    /// ///////////删除资料
    /// </summary>
    /// <param name="db"></param>
	
</script>

<html>
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>信息阅读</title>
    
    
   <LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet">
      <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

#hanxin{
 margin: 0 auto;

text-align;center;
}
</style>
    <style type="text/css">
<!--
.style3 {FONT-SIZE: 16px; FONT-FAMILY: Arial, Helvetica, sans-serif; font-weight: bold;}
.style6 {
	font-family: "仿宋_GB2312";
	font-size: 14pt;
}
-->
    </style>
</head>
<body>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
      <tr>
        <td valign="top" bgcolor="#FFFFFF">
          <table width="100%" border="0" cellspacing="0" cellpadding="20">
            <tr>
              <td valign="top"><span class="dvHeaderText">信息标题:　<%=news_titlestring%></span><br>
			      <br>
			      <%=contentstring %></td>
            </tr>
        </table></td>
      </tr>
    </table>
    </td>
  </tr>
</table>

 
</body>
</html>

