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
    protected string timefrom = "";
    protected string timeto = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        ShowPage(db);
        db.closedb();
    }





    protected void ShowPage(DBClass db)
    {
        //页面载入显示
        timefrom = Request.QueryString["param4"].ToString().Trim();
        timeto = Request.QueryString["param5"].ToString().Trim();
        string sqls;

        DataTable usertable = new DataTable();
    OdbcParameter[] param11 ={ 
                       new OdbcParameter("@timefrom",OdbcType.DateTime),
					       new OdbcParameter("@timeto",OdbcType.DateTime)
					   
					     };
		param11[0].Value=timefrom;
		param11[1].Value=timeto;
						 

        sqls = "select  tbDataOperateLog.*  from tbDataOperateLog  where tbDataOperateLog.opt_time between ? and ?  order by tbDataOperateLog.opt_time desc";
        usertable = db.GetTable(sqls, param11);

        contentstring = "";
        total = usertable.Rows.Count;
        pagesize = 10;  //每页显示
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
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["opt_time"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["opt_username"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["opt_userdept"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_title"].ToString() + "&nbsp;</td>");
            //sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_url"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_ownername"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_ownerdept"].ToString() + "</td>");

            sb.Append("</tr>");

            id++;
        }

        contentstring = sb.ToString();
    }




</script>
<html>
<head id="Head1" runat="server">
    <title>登陆日志管理</title>
    
    
   
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
                              下载日志搜索结果 从 <span class="txtGreen">"<%= timefrom %>"</span> 到  <span class="txtGreen">"<%= timeto %>"</span>
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
 
 

   <table width="100%" border="0" cellpadding="0" cellspacing="1"   class="lvt small">
     <tr class="lvtCol">
     <td height="30" align="center"> 序号</td>
	    <td align="center"> 查看时间</td>
	         <td align="center"> 下载查看人</td>
      <td align="center"> 查看人部门</td>
      <td align="center"> 资料名称</td>
      <td align="center"> 资料所有人</td>
      <td align="center"> 所有人部门</td>
     </tr>
     <%=contentstring %>
     <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
       <td align="center" colspan="10" height="22" class="but1" style="width:100%;"> 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%= Link.url("/app_mgr/ziliao_mgr/","log_downsearchtime.aspx","1","","",timefrom,timeto) %>">首页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","log_downsearchtime.aspx",(nowpage-1).ToString(),"","",timefrom,timeto) %>">上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/ziliao_mgr/","log_downsearchtime.aspx",(nowpage+1).ToString(),"","",timefrom,timeto) %>">下一页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","log_downsearchtime.aspx",maxpage.ToString(),"","",timefrom,timeto) %>">尾页</a></td>
     </tr>
   </table>

 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
