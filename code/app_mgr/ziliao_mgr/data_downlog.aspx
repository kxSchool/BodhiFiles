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


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();


        string actiontype = "";
        if (Request.Form.Get("actiontype") == null)
        {
            ShowPage(db);
        }
        else
        {


            actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别
            if (actiontype == "namesearch")
            {

                string condition = Request.Form.Get("usercondition").ToString();
                Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","log_downsearch.aspx","","", condition,"",""));

            }
            if (actiontype == "timesearch")
            {
                string timefrom = Request.Form.Get("param4").ToString();
                string timeto = Request.Form.Get("param5").ToString();
                if (timeto == "")
                    timeto = DateTime.Now.ToString();
                if (timefrom == "")
                {
                     db.closedb();
		    Fun.goback("","请输入起始日期！","返回");
                    Response.End();
                }
                Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","log_downsearchtime.aspx","","","",timefrom ,timeto));
            }

        }

        db.closedb();
    }




    protected void ShowPage(DBClass db)
    {
        //页面载入显示
        string sqls;
        DataTable usertable = new DataTable();
        sqls = "select  tbDataOperateLog.* from tbDataOperateLog   order by tbDataOperateLog.opt_time desc";
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
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>");
			sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["opt_time"].ToString() + "</td>");
			sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["opt_username"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["opt_userdept"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_title"].ToString() + "</td>");
            //sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_url"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_ownername"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["data_ownerdept"].ToString() + "&nbsp;</td>");
                        


          
            sb.Append("</tr>");

            id++;
        }

        contentstring = sb.ToString();

    }
</script>
<html>
<head id="Head1" runat="server">
    <title>下载日志管理</title>
    
    
   
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

function SelectAll() {
try {
if (document.selform.sel.length>1)
{
	for (var i=0;i<document.selform.sel.length;i++) {
		var e=document.selform.sel[i];
		e.checked=!e.checked;
		cca(e);	}
		}
		else
		{
		var e=document.selform.sel;
		e.checked=!e.checked;
		cca(e);	
		}
}
catch (e) {}
}


</script>


</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
 
 <form action="data_downlog.aspx" method="post" name="selform2" >
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
      <tr>
        <td align="left" valign="middle" class="calendarNav" style="height: 16px"> 下载日志 </td>
      </tr>
    </table></td>
    <td align="center" nowrap class=small><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>
          <input type="hidden" id="actiontype" name="actiontype" style="width: 31px" />
&nbsp; 按查看人
<input type="text" name="usercondition" style="width: 122px; height: 20px;" />
      <input name="button" type="button" style="width: 75px; height: 21px;" onClick="document.getElementById('actiontype').value='namesearch';document.selform2.submit()" value="查找" />
</td>
      <td class=small>按日期查&nbsp; 从
        <input type="text" 
 name="param4" style="width: 109px" onFocus="new WdatePicker(this)"/>
到
<input type="text" name="param5" style="width: 109px"  onFocus="new WdatePicker(this)"  />
<input name="button2" type="button" style="width: 75px; height: 21px;" onClick="document.getElementById('actiontype').value='timesearch';document.selform2.submit()" value="查找" /></td>
      </tr>
    </table> </td>
  </tr>
</TABLE>

<div id="hanxin">
  <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
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
      <td align="center" colspan="10" height="22" class="but1" style="width:100%;"> 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_downlog.aspx","1","","","","") %>">首页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_downlog.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_downlog.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_downlog.aspx",maxpage.ToString(),"","","","") %>">尾页</a></td>
    </tr>
  </table>
  </div>
</form>
 

 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
