<%@ Page Language="C#"  ValidateRequest="false" %>
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
	protected StringBuilder sb = new StringBuilder();
    protected StringBuilder selecttype = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {
	DBClass db = new DBClass();
	DataTable typetable = db.GetTable("select * from tbnewstype order by createtime desc", null);
            for (int i = 0; i < typetable.Rows.Count; i++)
            {
				selecttype.Append("<option value=\"");
                selecttype.Append(typetable.Rows[i]["id"].ToString() + "\"");
                selecttype.Append(">" + typetable.Rows[i]["typename"].ToString() + "</option>");
			}
	
	if (Request.Form.Get("newsaction")!=null && Request.Form.Get("newsaction")=="addnew") {
                 OdbcParameter[] param ={ 
                   new OdbcParameter("@news_title",OdbcType.VarChar),
                    new OdbcParameter("@content",OdbcType.Text),
                    new OdbcParameter("@type_id",OdbcType.Int),
                    new OdbcParameter("@createtime",OdbcType.DateTime),
                    new OdbcParameter("@userno",OdbcType.VarChar),
                     new OdbcParameter("@isdelete",OdbcType.Int),
					 new OdbcParameter("@mobilepwd",OdbcType.VarChar)
                };
                param[0].Value = Request.Form["news_title"];
			    sb.Append(Request.Form["newscontent"]);
                param[1].Value = sb.ToString();
                param[2].Value = Convert.ToInt32(Request.Form.Get("newstype").ToString());
                param[3].Value = DateTime.Now;
                param[4].Value = Request.Form.Get("userno").ToString();
                param[5].Value = 0;
				param[6].Value = Session["phonepwd"].ToString();
                db.ExecuteNonQuery("insert into tbnews (news_title,content,type_id,createtime,userno,isdelete,mobilepwd)values(?,?,?,?,?,?,?)", param);
                db.closedb();
			    Fun.alert("","添加成功！",Link.url("/phone/", "news_pwd.aspx","","","","","") ,"返回");
				 Response.End();
				} 
				
				
				

    }
	
	
	
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
              <td valign="top"><span class="dvHeaderText">信息标题:　</span>
<form name="form1" method="post" action="<%=Link.url("/phone/","news_add.aspx","","","","","")%>">
				   <input type="hidden" name="newsaction" value="addnew">
				   <input type="hidden" name="userno" value="<%=Session["userno"]%>">
				   <br>
				   <select name="newstype" style="height:18pt;width:120pt;">
                     <option>选择信息投送的类别</option>
                     <% =selecttype.ToString() %>
                   </select>
				   <br>
				   <input type="text" name="news_title" value="" style="height:18pt;width:120pt;">
				  <br>
                  <textarea name="newscontent" style="height:50pt;width:120pt;"></textarea>
                  <br>
                  <input type="submit" name="Submit" value="添加记录">
</form>                            
		        </td>
            </tr>
        </table></td>
      </tr>
    </table>
    </td>
  </tr>
</table>

 
</body>
</html>

