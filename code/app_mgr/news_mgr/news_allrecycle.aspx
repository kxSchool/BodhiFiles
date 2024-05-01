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
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        DataTable datatable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            ShowPage(db);


        }
        else
        {

            if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
            {
            
                  db.closedb();
				    Fun.goback("","没有选择任何信息！","返回");
            }
            else
            {


                string actiontype = "";
                if (Request.Form.Get("actiontype") != null)
                    actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别

                if (actiontype == "resumedelete")
                {//恢复

                    ResumeDelete(db);
                }

                if (actiontype == "realdelete")
                {
                    RealDelete(db);
                }


            }

        }





        db.closedb();
    }









    protected void ShowPage(DBClass db)
    {

        string sqls;

        sqls = "select tbnews.*,tbuser.username,tbuser.dept_id,department.deptname from(( tbnews left join tbuser  on tbnews.userno=tbuser.userno ) left join department on tbuser.dept_id=department.id ) where tbnews.isdelete=1 order by tbnews.createtime desc ";

        DataTable datatable = db.GetTable(sqls, null);

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
        if (Convert.ToInt32(Request.QueryString["param1"]) > maxpage)    //防止太大
            nowpage = maxpage;
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

        StringBuilder sb = new StringBuilder();
        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {


            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["id"].ToString() + "\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" ><a  href=\""+Link.url("/app_mgr/news_mgr/", "news_view.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\"> &nbsp;&nbsp;" + datatable.Rows[i]["news_title"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["username"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["deptname"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["createtime"].ToString() + "</td>\n");


            sb.Append("</tr>\n");


            id++;
        }

        contentstring = sb.ToString();

    }




    /// <summary>
    /// /////////////恢复删除   
    /// </summary>
    /// <param name="db"></param>
    protected void ResumeDelete(DBClass db)
    {




        string delete_sql = "update tbnews set isdelete=0  where tbnews.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);
        db.closedb();

		
		   Fun.alert("","恢复信息成功！",Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx","","","","","") ,"返回");
        Response.End();
    }




    /// <summary>
    /// //////////////彻底删除
    /// </summary>
    /// <param name="db"></param>
    protected void RealDelete(DBClass db)
    {




        string delete_sql = "delete from  tbnews   where tbnews.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);
        db.closedb();

		
		   Fun.alert("","已彻底删除成功！",Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx","","","","","") ,"返回");
        Response.End();
    }
</script>
<html>
<head id="Head1" runat="server">
    <title>信息回收站</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />


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
<body>
<myhead:myhead ID="Myhead1" runat="server" />

  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td class=small nowrap><table>
      <tr>
        <td align="left" valign="middle" class="calendarNav" style="height: 16px">
            单位信息回收站
          </td>
        </tr>
    </table> </td>
  </tr>
</TABLE>

 <div><table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >
 			<form action="<%=Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx","","set","","","") %>" method="post" name="selform" >
 			
   <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                              
                            
                                     <tr>
                                     <td align="left" valign="middle" bgcolor="#FFFFFF"  style="width: 845px; height: 26px">
                                   <a  onclick="{if(confirm('此操作将恢复选中信息！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='resumedelete';document.selform.submit();return true;}return false;}" href="#">
									 <img src="/images/resumedata.jpg" style="border:0;" alt="恢复资料" />
									 </a> <%
										 if (Request.ServerVariables["LOCAL_ADDR"]==Request.ServerVariables["REMOTE_ADDR"])
										 {%>
									 
									 <a  onclick="{if(confirm('此操作将彻底删除信息！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='realdelete';document.selform.submit();return true;}return false;}" href="#">
									 <img src="/images/realdelete.jpg" style="border:0;" />
									 </a> 
                                    <%}%>	
									</td>
                                 </tr>
                           </table>



     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
       

          <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
        	<td align="center" style="height: 18px;">
                <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()" /></td>
		    <td align="center" style="height: 18px; width: 38%;">
                 标 &nbsp; &nbsp; 题</td>
          
                 <td align="center">
                 发布人</td> 
                  <td align="center">
                 部门</td>
             <td align="center">
                 发布时间</td>
                 
             </tr>
          
        <%=contentstring %>
       
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="9" height="22" class="but1" style="width:100%;">
      <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      共  <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/   <%=maxpage%>
       
            页，每页 
          <%=pagesize%>个&nbsp; <a href="<%= Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx","1","","","","") %>">首页</a> <a href="<%= Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a>&nbsp;
          <a href="<%= Link.url("/app_mgr/news_mgr/","news_allrecycle.aspx",maxpage.ToString(),"","","","") %>">尾页</a></td>
        
           </tr> 
          
       </table>   
       </td>
       </tr>
       </table>
    
 </form>

 </td>
</tr>
</table>
 
 
 
 <br>
 <br>
 <br>
 <br>
 
 <br>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>




