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
        DataTable depttable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            sqls = "select * from department   order by createtime";
            depttable = db.GetTable(sqls, null);
        }
        else
        {
            if (Request.QueryString["param2"] == "add")
            {

                AddDepartment(db);

            }
            if (Request.QueryString["param2"] == "del")
            {
                DeleteDept(db);

            }


        }



        //分页页面显示
        contentstring = "";
        total = int.Parse(depttable.Rows.Count.ToString()); 
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
        if (Request.QueryString["param1"] != "" && Convert.ToInt32(Request.QueryString["param1"]) > maxpage)    //防止太大
            nowpage = maxpage;
			}
			else
			{nowpage=1;}
        if (nowpage <= 0)
            nowpage = 1;

        int id = (nowpage - 1) * pagesize + 1;
        int showcount;
        if (nowpage * pagesize < depttable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = depttable.Rows.Count;


        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            contentstring = contentstring + " <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">" +
    "<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n" +
	"<td height=\"24\" align=\"center\" ><a href=\""+ Link.url("/dept_mgr/","dept_order.aspx", depttable.Rows[i]["id"].ToString(),"","","","") + "\">沉于最底</a></td>\n" +
    "<td height=\"24\" align=\"center\" >" + depttable.Rows[i]["deptname"].ToString() + "</td>\n" +
      "<td height=\"24\" align=\"center\" ><a href=\""+ Link.url("/dept_mgr/","dept_edit.aspx",depttable.Rows[i]["id"].ToString(),"","","","") + "\">编辑</a></td>\n" +
     "<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + depttable.Rows[i]["id"].ToString() + "\"/></td>\n" + "</tr>\n" + "\n";

            id++;
        }

        db.closedb();
    }



    /// <summary>
    /// ///////////////添加部门
    /// </summary>
    /// <param name="db"></param>
    protected void AddDepartment(DBClass db)
    {

        //检测不能有同名  
        string checksql = "select * from department where deptname=?";
        OdbcParameter checkparam = new OdbcParameter("newdeptname", OdbcType.VarChar, 100);
        checkparam.Value = Request.Form.Get("departmentname").ToString().Trim();
        int checkresult = db.GetTable(checksql, checkparam).Rows.Count;
        if (checkresult > 0)
        {
		
	      	  Fun.alert("","对不起，此部门已存在！",Link.url("/dept_mgr/","dept_manage.aspx","","","","","") ,"返回");
        
			Response.End();

        }

        OdbcParameter[] param ={ 
            new OdbcParameter("@deptname", OdbcType.VarChar),
            new OdbcParameter("@createtime",OdbcType.DateTime)
          };
        param[0].Value = Request.Form["departmentname"].ToString().Trim();
        param[1].Value = DateTime.Now;
        db.ExecuteNonQuery("insert into department(deptname,createtime)values(?,?)", param);
        db.closedb();
	
		 	  Fun.alert("","添加成功！",Link.url("/dept_mgr/","dept_manage.aspx","","","","","") ,"返回");

  
	    Response.End();
    }




    /// <summary>
    /// ///////////删除
    /// </summary>
    /// <param name="db"></param>
    protected void DeleteDept(DBClass db)
    {

        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {
				  Fun.alert("","没有选择任何记录！",Link.url("/dept_mgr/","dept_manage.aspx","","","","","") ,"返回");
        }
        else
        {

            string deletesql = "delete from department where id in(" + Request.Form.Get("sel").ToString() + ")";
            db.ExecuteNonQuery(deletesql, null);


            //2 . tbuser 
            string update_dept = "update tbuser set dept_id=0 where tbuser.dept_id in(" + Request.Form.Get("sel").ToString() + ")";
            db.ExecuteNonQuery(update_dept, null);
            db.closedb();
			
		 	  Fun.alert("","删除成功！",Link.url("/dept_mgr/","dept_manage.aspx","","","","","") ,"返回");
            Response.End();



        }

    }



</script>

<html>
<head id="Head1" runat="server">
    <title>权限组管理</title>
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
// <!CDATA[

 function form_check(){
   if(document.form1.departmentname.value==""){window.alert("部门名称不能为空！");document.form1.departmentname.focus();return (false);}
 
      }

function ConfirmDel()
{
   if(confirm("确定要删除此权限组吗？"))
     return true;
   else
     return false;
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


// ]]>
</script>

  <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />

<style type="text/css">

 BODY {
	FONT-SIZE: 9pt
}

</style>
</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />

    <form name="form1" method="post" action="<%= Link.url("/dept_mgr/","dept_manage.aspx","","add","","","")%>" onsubmit ="return form_check();">
       <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">部门管理</font></b></td>
        </tr>
    </table></td>
    <td class=small nowrap><table border="0" cellpadding="0" cellspacing="0">
      <tr>
                <td class="small">
                    部门名称：</td>
                <td style="width: 134px">
                <input type="text" name="departmentname" style="width: 163px" /></td>

                <td><input type="submit" value="添加" style="width: 61px; height: 22px" /></td>
          </tr>
      
        </table> </td>
  </tr>
</TABLE>
</form>

 

                 <form action="<%= Link.url("/dept_mgr/","dept_manage.aspx","","del","","","")%>" method="post" name="selform" >
                 <div id="Div1">
  <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
    <tr class="lvtCol">
                             <td height="30" align="center">序 号</td>
                             <td align="center">部门排序</td>
                             <td align="center">部门名称</td>
                             <td align="center">编辑名称</td>
                             <td align="center">删 除</td>
      </tr>
                           <%=contentstring %>
                           <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
                             <td align="center" colspan="11" height="22" class="but1" style="width:100%;"> 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%= Link.url("/dept_mgr/","dept_manage.aspx","1","","","","") %>">首页</a> <a href="<%= Link.url("/dept_mgr/","dept_manage.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/dept_mgr/","dept_manage.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a> <a href="<%= Link.url("/dept_mgr/","dept_manage.aspx",maxpage.ToString(),"","","","") %>">尾页</a> &nbsp;&nbsp;&nbsp;&nbsp;
                                 <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()">
                      选择/反选
                      <input onClick="{if(confirm('此操作将删除该部门吗！\n\n确定要执行此项操作吗？')){document.selform.submit();return true;}return false;}" type="submit" value="删除" name="action2">
                             </td>
                           </tr>
                   </table>
 </div>
</form>
 
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
