<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">



    public string contentstring = "";
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();



        ShowPage(db);


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
        sqls = "select tbexcel.*,tbuser.username from tbexcel  left join tbuser on tbexcel.userno=tbuser.userno where tbexcel.isdelete='0'  order by tbexcel.uptime desc";

        datatable = db.GetTable(sqls, null);

        //分页页面显示
        contentstring = "";
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
		if (Request.QueryString["param1"] !=null & Request.QueryString["param1"]!="")
		{
        if (Request.QueryString["param1"] !=null & Request.QueryString["param1"]!="")
		{
        if (Convert.ToInt32(Request.QueryString["param1"]) > maxpage)    //防止太大
            nowpage = maxpage;
			}
			else
			{nowpage=1;}
			}
			else
			{nowpage=1;}
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


            int indexi = datatable.Rows[i]["fileurl"].ToString().LastIndexOf(".") + 1;
            string newext = datatable.Rows[i]["fileurl"].ToString().Substring(indexi).ToLower();  //得到扩展名

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" ><img src=\"/images/filetype/" + newext + ".gif\"/>&nbsp; <a href=\""+Link.url("/app_mgr/excel_mgr/","excel_form.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\"  target=_blank>" + datatable.Rows[i]["filetitle"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["uptime"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["username"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/excel_mgr/","excel_form.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\"  target=_blank>在线填报</a></td>");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();

    }

</script>


<html>
<head id="Head1" runat="server">
    <title>在线统计管理</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

#hanxin{
 margin: 0 auto;

text-align;center;
}
#uploadingdiv{     
    width:100%px; 
    height:200px; 
    background:#EDF1F8;     
    border: 2px solid #849BCA; 
    margin-top:2px; 
    margin-left:2px; 
    float:left; 
    overflow:hidden; 
    position:absolute; 
    left:0px; 
    top:0px; 
    cursor:move; 
    float:left; 
    /*filter:alpha(opacity=50);*/ 
     
} 
.content{ 
    padding:10px; 
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
<body><myhead:myhead ID="Myhead1" runat="server" />
  <div align="center">
  <TABLE width=100% border=0 align="center" cellpadding=0 cellspacing=0 class="hdrTabBg">
    <tr>
      <td height="32" class=small style="width:50px">&nbsp;</td>
      <td nowrap class=small style="width: 100px"><table>
          <tr>
            <td> <b><font color="#ffffff">在线填报</font></b></td>
          </tr>
      </table></td>
      <td align="center" nowrap class=small>&nbsp;	</td>
    </tr>
  </TABLE>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1"  class="lvt small">
     <form action="<%= Link.url("/app_mgr/excel_mgr/","excel_open_list.aspx","","set","","","") %>" method="post" name="selform" > <tr class="lvtCol">
           <td height="30" align="center">
               序号</td>
           <td align="center" style="height: 18px;">
               <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"></td>
           <td align="center" style="height: 18px; width: 38%;">
               统 计 表 名 称</td>
           <td align="center">
               发布时间</td>
            
           <td align="center">
               发布人</td>  
                   
                <td align="center">
                    在线填报</td>
            
         </tr>
            
       <%=contentstring %>
          
       <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
           <td align="center" colspan="10" height="35" class="but1" style="width: 100%;">
               <table width="211" border="0" align="left" cellpadding="0" cellspacing="0">
                   <tr>
                       <td width="160" align="right">
                            
                       </td>
                       <td width="140" align="center">
                       </td>
                   </tr>
               </table>
               
               共
               <%=total%>
               个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/
               <%=maxpage%>
               页，每页
               <%=pagesize%>
               个&nbsp; <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_open_list.aspx","1","","","","") %>">
                   首页</a> <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_open_list.aspx",(nowpage-1).ToString(),"","","","") %>">
                       上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/excel_mgr/","excel_open_list.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a>&nbsp;
               <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_open_list.aspx",maxpage.ToString(),"","","","") %>">
                   尾页</a></td>
      </tr></form>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><myfoot:myfoot ID="foot1" runat="server" /></td>
    </tr>
  </table>
    
  </div>


</body>
</html>
