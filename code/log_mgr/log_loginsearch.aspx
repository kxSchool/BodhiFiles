<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>



<script runat="server">
    public string contentstring;
    public string selectvalue = "";
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
    StringBuilder sb = new StringBuilder();
    protected string condition;

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();


            ShowPage(db);

        db.closedb();
    }





    protected void ShowPage(DBClass db)
    {
        //页面载入显示

        condition = Request.QueryString["param3"]==null?"":Request.QueryString["param3"].ToString().Trim();
        string sqls;
        DataTable usertable = new DataTable();
        sqls = "select  * from tbloginlog  where loginname like '%" + condition + "%'  order by logintime desc";
        usertable = db.GetTable(sqls, null);

        contentstring = "";
        total = usertable.Rows.Count; pagesize = 10;  //每页显示
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
        if (Request.QueryString["param1"] !=null & Request.QueryString["param1"]!="")
		{
        if (Convert.ToInt32(Request.QueryString["param1"]) > maxpage)    //防止太大
            nowpage = maxpage;
			}
			else
			{nowpage=1;}
        if (nowpage <= 0)
            nowpage = 1;  //没有这一句当记录为空是点下一页出错

        int id = (nowpage - 1) * pagesize + 1;
        int showcount;  //显示数
        if (nowpage * pagesize < total)
            showcount = nowpage * pagesize;
        else
            showcount = total;




        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["loginurl"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["loginname"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["loginuserid"].ToString() + "&nbsp;</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["logintime"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\"http://iplocal.js715.net/tool/iplocal/ip138.html?id=" + usertable.Rows[i]["ip"].ToString() + "\" target=\"_blank\"><script language=\"javascript\" type=\"text/javascript\" src=\"http://iplocal.js715.net/tool/iplocal/default.html?id=" + usertable.Rows[i]["ip"].ToString() + "\"></" + "script" + "></a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["browser"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["os"].ToString() + "</td>\n");

            //  sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  onclick=\"cca(this)\" value=\"" + usertable.Rows[i]["userno"].ToString() + "\"/></td>\n");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();
    }


</script>
<html>
<head id="Head1" runat="server">
    <title>登陆日志管理</title>
    <script language="javascript" type="text/javascript" src="/js/datepicker/WdatePicker.js"></script>
    
   <LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet">
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

#hanxin{
 margin: 0 auto;

text-align;center;
}
</style>
<LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript" src="/js/datepicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript">
function cca(s)
{//选择后边颜色
	var e=s
	while (e.tagName != "TR")
		e = e.parentElement;
	if(s.checked)
		e.style.backgroundColor="#FFFFe2";
	else
		e.style.backgroundColor="#ffffff";
}  
function cca(s)
{//选择后边颜色
	var e=s
	while (e.tagName != "TR")
		e = e.parentElement;
	if(s.checked)
		e.style.backgroundColor="#FFFFe2";
	else
		e.style.backgroundColor="#D4D0C8";
} 


</script>

</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td class=small nowrap><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="middle" class="small" style="height: 16px;">
                              登陆日志搜索结果 <span class="txtGreen">"<%= condition %>"</span>
          </td>
        </tr>
    </table> </td>
  </tr>
 
</TABLE>

   <table width="100%" border="0" cellpadding="0" cellspacing="0">

         <tr>
         <td align="left" valign="middle"  style="width: 845px; height: 26px">
        <a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a>
        </td>
     </tr>
 </table>

 

   <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
     <tr class="lvtCol">
       <td height="30" align="center" > 序号</td>
       <td align="center" > 登录来源</td>
       <td align="center" > 操作员</td>
       <td align="center" > 登陆号</td>
       <td align="center" > 登陆日期</td>
       <td align="center" > 登陆IP</td>
       <td align="center" > 浏览器</td>
       <td align="center" > 操作系统</td>
     </tr>
     <%=contentstring %>
     <tr>
       <td   bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'" align="center" colspan="10" height="22" class="but1" style="width:100%;"> 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%= Link.url("/log_mgr/","log_loginsearch.aspx","1","",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">首页</a> <a href="<%= Link.url("/log_mgr/","log_loginsearch.aspx",(nowpage-1).ToString(),"",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/log_mgr/","log_loginsearch.aspx",(nowpage+1).ToString(),"",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">下一页</a> <a href="<%= Link.url("/log_mgr/","log_loginsearch.aspx",maxpage.ToString(),"",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">尾页</a></td>
     </tr>
   </table>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
