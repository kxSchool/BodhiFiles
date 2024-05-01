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

        string sqls;
        DataTable usertable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            sqls = "select tbuser.*,department.* from tbuser left join department on tbuser.dept_id=department.id  where tbuser.isdelete=1 order by createdate desc";
            usertable = db.GetTable(sqls, null);
        }
        else
        {

            if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
            {
               db.closedb();
                    Fun.goback("","没有选择任何用户","返回");
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
                {//彻底删除  要把popedom 表中的数据也删除

                    RealDelete(db);
                }


            }

        }



        //分页页面显示
        contentstring = "";
        total = int.Parse(usertable.Rows.Count.ToString()); pagesize = 10;  //每页显示
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
            nowpage = 1;

        int id = (nowpage - 1) * pagesize + 1;
        int showcount;
        if (nowpage * pagesize < usertable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = usertable.Rows.Count;


        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {
            contentstring = contentstring + " <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">" +
             "<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n" +
             "<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["userid"].ToString() + "</td>\n" +
             "<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["username"].ToString() + "</td>\n" +
             "<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["deptname"].ToString() + "</td>\n" +
             "<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["createdate"].ToString() + "</td>\n";
            if (usertable.Rows[i]["popedomgroup"].ToString() == "")
                contentstring += "<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_popedom.aspx", usertable.Rows[i]["userno"].ToString(), "", "", "", "") + "\"><font color=\"red\">自定义权限</font></a></td>\n";
            else
                contentstring += "<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_popedom.aspx", usertable.Rows[i]["userno"].ToString(), "", "", "", "") + "\">" + usertable.Rows[i]["popedomgroup"].ToString() + "</a></td>\n";

            contentstring += "<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_infoedit.aspx", usertable.Rows[i]["userno"].ToString(), "", "", "", "") + "\">编辑信息</a></td>\n" +
              "<td height=\"24\" align=\"center\" ><a href=\""+ Link.url("/user_mgr/", "user_add.aspx","","","","","")+"\">添加新用户</a></td>\n" +
             "<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\" value=\"" + usertable.Rows[i]["userno"].ToString() + "\"/></td>\n" + "</tr>\n";

            id++;
        }



        db.closedb();
    }





    /// <summary>
    /// /////////////恢复删除
    /// </summary>
    /// <param name="db"></param>
    protected void ResumeDelete(DBClass db)
    {
        string[] sign ={ "," };
        string[] delusers = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);

        string updatesql = "update tbuser set isdelete=0 where userno in('";
        foreach (string u in delusers)
        {
            updatesql += u + "','";

        }
        updatesql += "')";
        db.ExecuteNonQuery(updatesql, null);

      Fun.alert("","恢复成功",Link.url("/user_mgr/", "user_recycle.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }





    protected void RealDelete(DBClass db)
    {
        string[] sign ={ "," };
        string[] delusers = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);

        //判读删除的用户有无资料  有就不许删除

        string checksql = "select * from tbdata where userno in('";
        foreach (string u in delusers)
        {
            checksql += u + "','";

        }
        checksql += "')";   // Response.Write(sql);

        if (db.GetTable(checksql, null).Rows.Count > 0)
        {
            db.closedb();
            Fun.goback("","对不起，您删除的用户还有未处理的资料，暂不能删除","返回");
            Response.End();
        }




        string deletesql = "delete from tbuser where userno in('";
        foreach (string u in delusers)
        {
            deletesql += u + "','";

        }
        deletesql += "')";   // Response.Write(updatesql);
        db.ExecuteNonQuery(deletesql, null);



        string deletepopedom = "delete from popedom where userno in('";
        foreach (string u in delusers)
        {
            deletepopedom += u + "','";

        }
        deletepopedom += "')";
        db.ExecuteNonQuery(deletepopedom, null);
      db.closedb();
      Fun.alert("","删除成功",Link.url("/user_mgr/", "user_recycle.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }

</script>

<html>
<head id="Head1" runat="server">
    <title>用户回收站</title>
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


function ConfirmDel()
{
   if(confirm("删除该用户后将无法再恢复\n\n真的删除吗？"))
     return true;
   else
     return false;
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
                             用户回收站
          </td>
        </tr>
    </table> </td>
  </tr>
</TABLE>
   
   
 
  <div>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >
<form action="<%= Link.url("/user_mgr/","user_recycle.aspx","","resumedel","","","")%>" method="post" name="selform" >

		
      <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                 
                                 
                                     <tr>
                                     <td align="left" valign="middle"  style="width: 845px; height: 26px">
                                    <a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a><a  onClick="{if(confirm('此操作将恢复该用户吗！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='resumedelete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/resumedata.jpg" style="border:0;" alt="恢复资料" /></a><a  onClick="{if(confirm('此操作将彻底删除该用户吗！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='realdelete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/realdelete.jpg" style="border:0;" alt="彻底删除" /></a></td>
                             </table>


     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
           <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
         
			<td align="center" >
                登录名</td>
			<td align="center">
                真实姓名</td>
                	<td align="center" >
                部门</td>
			<td align="center"  style="height: 18px; width: 16%;">
                注册日期</td>
			<td align="center" >
                权限组</td>
			<td align="center" >
                编辑信息</td>
			<td align="center" style="width: 12%; height: 18px;">
			添加用户</td>
    
            <td align="center">
            选择</td>
            
          </tr>
          
          
          <%=contentstring %>
       
            <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
<td align="center" colspan="10" height="22" class="but1">
         
         <input type="hidden" id="actiontype" name="actiontype" />
      
      共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%>
       
            页，每页 
          <%=pagesize%> 条 <a href="<%= Link.url("/user_mgr/","user_recycle.aspx","1","","","","")%>">首页</a> <a href="<%= Link.url("/user_mgr/","user_recycle.aspx",(nowpage+1).ToString(),"","","","")%>">上一页</a> &nbsp;<a href="<%= Link.url("/user_mgr/","user_recycle.aspx",(nowpage+1).ToString(),"","","","")%>">下一页</a> <a href="<%= Link.url("/user_mgr/","user_recycle.aspx",maxpage.ToString(),"","","","")%>">尾页</a> &nbsp;&nbsp;&nbsp;&nbsp;
       
      
           
           </td></tr> 
             <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
<td align="right" colspan="10" height="22" class="but1">
             <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll();"> 选择/反选　</td>
         </tr>
           
          
       </table>   
         </td>
       </tr>
       </table>
 </form>
      </td>
      </tr>
       </table>
 
 
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>

