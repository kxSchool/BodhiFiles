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

    protected StringBuilder selectsb = new StringBuilder();
    protected string type_idd = "";


    protected StringBuilder selectdatatypesb = new StringBuilder();


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

            //显示我发布的 信息列表

            ShowPage(db);

        }

        else
        {




            if (Request.QueryString["param2"] == "set")
            {



                if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                {
				    db.closedb();
					 Fun.goback("","请先选择信息","返回");
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

                    if (actiontype == "movetype")
                    {
                        MoveType(db);
                    }


                }

            }  //set

            if (Request.QueryString["param2"].ToString() == "search")
            {
                string condition = Request.Form.Get("param3").ToString();
                string newstype = Request.Form.Get("newstype").ToString();
                Response.Redirect(Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search",condition,newstype,""));
            }

        }



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

        if (Request.QueryString["param4"] == null || Request.QueryString["param4"].ToString() == "")
        {
            type_idd = "";
            sqls = "select tbnews.*,tbuser.username,tbuser.dept_id,department.deptname from ((tbnews  left join tbuser  on tbnews.userno=tbuser.userno) left join department on tbuser.dept_id=department.id )  where tbnews.isdelete=0 ";

        }
        else
        {
            type_idd = Request.QueryString["param4"].ToString();
            sqls = "select tbnews.*,tbuser.username,tbuser.dept_id,department.deptname from(( tbnews left join tbuser  on tbnews.userno=tbuser.userno) left join department on tbuser.dept_id=department.id )  where tbnews.isdelete=0  and  tbnews.type_id=" + type_idd;
        }


        sqls = sqls + " order by tbnews.createtime desc";

        //填充下拉框
        DataTable typetable = db.GetTable("select * from tbnewstype", null);
        for (int i = 0; i < typetable.Rows.Count; i++)
        {
            selectsb.Append("<option value=\"");
            selectsb.Append(typetable.Rows[i]["id"].ToString() + "\"");
            if (typetable.Rows[i]["id"].ToString() == type_idd)
            {
                selectsb.Append("selected = \"selected\"");
            }

            selectsb.Append(">" + typetable.Rows[i]["typename"].ToString() + "</option>");
        }



        OdbcParameter[] param1 ={ 
                       new OdbcParameter("@userno",OdbcType.VarChar,50)  };
        param1[0].Value = Session["userno"].ToString();
        datatable = db.GetTable(sqls, param1);

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


        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" width=\"50\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" width=\"50\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["id"].ToString() + "\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" >");
			if (Convert.ToDateTime(datatable.Rows[i]["createtime"].ToString())>dt1) {
			sb.Append("<IMG src=\"/css/new.gif\">");
			}
			sb.Append("<a  href=\""+Link.url("/app_mgr/news_mgr/","news_view.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\"> &nbsp;&nbsp;" + datatable.Rows[i]["news_title"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["username"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["deptname"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["createtime"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/news_mgr/","news_edit.aspx" ,datatable.Rows[i]["id"].ToString(),"","","","")+ "\">编辑</a></td>\n");
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


        //删除原表
        string delete_sql = "update tbnews set isdelete=1  where tbnews.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);
        db.closedb();

        Response.Redirect(Link.url("/app_mgr/news_mgr/","news_manage.aspx","","","","",""));
        Response.End();


    }







    /// <summary>
    /// /////////移动类别
    /// </summary>
    /// <param name="db"></param>
    protected void MoveType(DBClass db)
    {

        string up_sql = "update tbnews set type_id=? where tbnews.id in (" + Request.Form.Get("sel").ToString() + ")";
        OdbcParameter pa = new OdbcParameter("@newtype", OdbcType.Int, 4);
        pa.Value = Request.Form.Get("newstype2").ToString();


        db.ExecuteNonQuery(up_sql, pa);
        db.closedb();

		   Fun.alert("","移动成功！",Link.url("/app_mgr/news_mgr/","news_manage.aspx","","","","","") ,"返回");
        Response.End();
    }
</script>

<html>
<head id="Head1" runat="server">
    <title>我发布的信息</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

#hanxin{
 margin: 0 auto;

text-align;center;
}
#uploadingdiv{     
    width:500px; 
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

function showupload()
{
   
     if(  document.getElementById("uploaddiv").style.display=="")
         {  
          document.getElementById("uploaddiv").style.display="none";
          }
      else
         {
           document.getElementById("uploaddiv").style.display="";
          }
}







function ChangeType(type)
{
	 url="<%=Link.url("/app_mgr/news_mgr/","news_manage.aspx","","","","type_idd","") %>";
	 url = url.replace("type_idd",type);
     window.location=url;

}

function allsearch()
{
	 url="<%=Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search","param3_idd","type_idd","") %>";
	 url = url.replace("type_idd",document.selform2.newstype.value);
	  url = url.replace("param3_idd",encodeURI(document.selform2.param3.value));
     document.selform2.action=url;
	 //alert(url);
document.selform2.submit();
}

</script>


</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
	<form action="<%=Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search","","","") %>" method="post" name="selform2" onSubmit="allsearch()">
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">全部信息</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>
                                     
								 <select name="newstype" onChange="ChangeType(this.value)"   style="height:20px;"> 
                                <option value="">信息类别选择</option>
                                <% =selectsb.ToString() %>
                                 </select> <input type="text" name="param3" style="width: 164px; height: 20px;" />
                                         <input type="button" value="查找" onClick="allsearch()" style="width: 75px; height: 21px;" /></td>
        </tr>
    </table> </td>
  </tr>
</TABLE>
</form>
  
 <div><table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >

 			
  <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <%if (Request.ServerVariables["LOCAL_ADDR"]==Request.ServerVariables["REMOTE_ADDR"]) {%><table width="100%" border="0" cellpadding="0" cellspacing="0">
                               
                                     <tr>
                                     <td align="left" valign="middle" bgcolor="#FFFFFF"  style="width: 845px; height: 26px">
									 
									 <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                       <tr>
                                         <td align="left"><a onClick="{if(confirm('此操作将删除信息至回收站！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" /></a></td>
                                       </tr>
                                     </table>
                                   </td>
                                 </tr>
                    
                                 
                           </table><%}%>

 			<form action="<%=Link.url("/app_mgr/news_mgr/","news_manage.aspx","","set","","","") %>" method="post" name="selform" >

     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
         <tr class="lvtCol">
             <td width="50" height="30" align="center">
                 序号</td>
             <td width="50" align="center" style="height: 18px;">
                 <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"></td>
             <td align="center" style="height: 18px;">
                 标 &nbsp; &nbsp; 题</td>
          
                 <td width="50" align="center">
                 发布人</td> 
                  <td align="center">
                 部门</td>
             <td align="center">发布时间</td>
                  <td align="center">
                 编辑</td>
                 
         </tr>
          
        <%=contentstring %>
         <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
             <td align="center" colspan="11" height="35" class="but1" style="width: 100%;">
                 <table width="211" border="0" align="left" cellpadding="0" cellspacing="0">
                     <tr>
                         <td width="160" align="right">
                             <select name="newstype2" style="height: 20px;">
                                 <option value="0">分类选择</option>
                                 <% =selectsb.ToString() %>
                             </select>
                         </td>
                         <td width="140" align="center">
                             <input onClick="{if(confirm('此操作将选中的信息移动到这个类别！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='movetype';document.selform.submit();return true;}return false;}"
                                 type="button" value="移动到此类别" name="action2" style="width: 93px"></td>
                     </tr>
                 </table>
                 <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
                 <input type="hidden" name="filetypeid" value="<% =type_idd %>" />
                 共
                 <%=total%>
                 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/
                 <%=maxpage%>
                 页，每页
                 <%=pagesize%>
                 个&nbsp; <a href="<%= Link.url("/app_mgr/news_mgr/","news_manage.aspx","1","","",type_idd,"") %>">
                     首页</a> <a href="<%= Link.url("/app_mgr/news_mgr/","news_manage.aspx",(nowpage-1).ToString(),"","",type_idd,"") %>">
                         上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/news_mgr/","news_manage.aspx",(nowpage+1).ToString(),"","",type_idd,"") %>">下一页</a>&nbsp;
                 <a href="<%= Link.url("/app_mgr/news_mgr/","news_manage.aspx",maxpage.ToString(),"","",type_idd,"") %>">
                     尾页</a></td>
         </tr>
     </table>   
     
      </form>
       </td>
       </tr>
       </table>
    

 </td>
</tr>
</table>
 
 <br>  
 <myfoot:myfoot ID="foot1" runat="server" />

</body>
</html>
