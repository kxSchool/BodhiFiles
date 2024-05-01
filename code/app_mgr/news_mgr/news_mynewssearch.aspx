<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">
DateTime dt1=Convert.ToDateTime(System.DateTime.Now.AddDays(-1).ToShortDateString().ToString());
    public string contentstring;
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
    protected string condition = "";
    protected string newstype = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

            db.closedb();
			
			  Fun.alert("","你没有输入查询条件！",Link.url("/app_mgr/news_mgr/","news_mynews.aspx","","","","","") ,"返回");
            Response.End();

        }
        else
        {


            if (Request.QueryString["param2"] == "search")
            {  // 查找功能

                ShowPage(db);

            }
            else
            {
                if (Request.QueryString["param2"] == "set")
                {

                    if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                    {
					    db.closedb();
                         Fun.goback("","请先选择信息！","返回");
                         Response.End();

                    }
                    else
                    {

                        string actiontype = "";
                        if (Request.Form.Get("actiontype") != null)
                            actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别

                        if (actiontype == "delete")
                        {
                            DeleteNews(db);
                        }

                    }
                }
            }


        }



        db.closedb();


    }




    /// <summary>
    /// ////////显示结果页面
    /// </summary>
    /// <param name="db"></param>
    void ShowPage(DBClass db)
    {

        condition = Request.QueryString["param3"]==null? "":Request.QueryString["param3"].ToString().Trim();
        newstype = Request.QueryString["param4"]==null?"":Request.QueryString["param4"].ToString();




        string sqls;

        if (newstype == "")
        {

            sqls = " select tbnews.*,tbnewstype.typename from tbnews left join tbnewstype on  tbnews.type_id=tbnewstype.id where (tbnews.isdelete=0 and   tbnews.news_title like '%" + condition + "%'  ) and tbnews.userno='" + Session["userno"].ToString() + "'";
        }
        else
        {

            sqls = " select tbnews.*,tbnewstype.typename from tbnews left join tbnewstype on  tbnews.type_id=tbnewstype.id where (tbnews.isdelete=0 and   tbnews.news_title like '%" + condition + "%'  ) and tbnews.userno='" + Session["userno"].ToString() + "' and tbnews.type_id=" + newstype;
        }


        sqls = sqls + " order by tbnews.createtime desc";


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
            if (Convert.ToDateTime(datatable.Rows[i]["createtime"].ToString())>dt1) {
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["id"].ToString() + "\"/></td>\n");
			} 
			else
			{
			            sb.Append("<td height=\"24\" align=\"center\" ></td>\n");
			}
			sb.Append("<td height=\"24\" align=\"left\" >&nbsp;<a  href=\""+Link.url("/app_mgr/news_mgr/","news_view.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\">" + datatable.Rows[i]["news_title"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["typename"].ToString() + "&nbsp;</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["createtime"].ToString() + "</td>\n");
            if (Convert.ToDateTime(datatable.Rows[i]["createtime"].ToString())>dt1) {
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/news_mgr/","news_edit.aspx" ,datatable.Rows[i]["id"].ToString(),"","","","")+ "\">编辑</a></td>\n");
            } 
			else
			{
			            sb.Append("<td height=\"24\" align=\"center\" ></td>\n");
			}
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();


    }






    /// <summary>
    /// ///////////删除资料
    /// </summary>
    /// <param name="db"></param>

    protected void DeleteNews(DBClass db)
    {



        string delete_sql = "update tbnews set isdelete=1  where tbnews.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);

        db.closedb();
        Response.Redirect(Link.url("/app_mgr/news_mgr/","news_mynews.aspx","","search",condition, newstype,""));
        Response.End();


    }



</script>
<html>
<head id="Head1" runat="server">
    <title>信息查找结果</title>
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


function ConfirmDel()
{
   if(confirm("确定要删除此资料吗？"))
     return true;
   else
     return false;
}

function deleteusers()
{
     var users="";
      for(var i=0;i<document.selform.sel.length;i++)
      {
            var e=document.selform.sel[i];
            if(e.checked)
                users=users+e.value+",";
           
      }
      if(users.length==0)
             alert("对不起，您没有选择任何文件");
        else
        
          alert(users);
     
}



</script>


</head>
<body>


 

<myhead:myhead ID="Myhead1" runat="server" />

 <div><table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >
  	
 			<form action="<%=Link.url("/app_mgr/news_mgr/","news_mynewssearch.aspx","","set","","","") %>" method="post" name="selform" >
 			
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                 <tr>
                                 <td>
                                     <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
                                         <tr>
                                             <td height="32" class="small" style="width: 50px">
                                           <td class="small" nowrap>
                                                 <table>
                                                     <tr>
                                                         <td align="center" valign="middle" class="small" style="height: 16px">
                                                             我发布的信息搜索结果: <span class="txtGreen">"<%= condition %>"</span>                                                       </td>
                                                     </tr>
                                                 </table>
                                           </td>
                                         </tr>
                                     </table>
                                 
                                 </td>
                                 </tr>
                            
                                     <tr>
                                     <td align="left" valign="middle"  style="width: 845px; height: 26px">
                                    <a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a><a href="<%=Link.url("/app_mgr/news_mgr/","news_add.aspx","","","","","") %>"><img src="/images/addnews.jpg" style="border:0;" alt="" /></a><a onClick="{if(confirm('此操作将信息删除到回收站！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" /></a>
                                    </td>
                                 </tr>
                             </table>



     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">

         <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
        	<td align="center" style="height: 18px;">
                <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()" style="width: 22px"></td>
			<td align="center"  style="height: 18px; width: 38%;">
                信 息 标 题</td>
			<td align="center" style="height: 18px; width: 11%;">
                类别</td>
			<td align="center" >
                发布时间</td>
  
	    <td align="center">
                编 辑</td>

     
        
            
          </tr>
          
        <%=contentstring %>
       
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="9" height="22" class="but1" style="width:100%;">
      <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      共  <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/   <%=maxpage%>
       
            页，每页 
          <%=pagesize%>个&nbsp; <a href="<%= Link.url("/app_mgr/news_mgr/","news_mynewssearch.aspx","1","search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),newstype,"") %>">首页</a> <a href="<%= Link.url("/app_mgr/news_mgr/","news_mynewssearch.aspx",(nowpage-1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),newstype,"") %>">上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/news_mgr/","news_mynewssearch.aspx",(nowpage+1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),newstype,"") %>">下一页</a>&nbsp;
          <a href="<%= Link.url("/app_mgr/news_mgr/","news_mynewssearch.aspx",maxpage.ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),newstype,"") %>">尾页</a></td>
        
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
 
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>

