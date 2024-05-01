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
    protected string condition = "";
    protected StringBuilder sb = new StringBuilder();
    protected string department="";

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        //页面载入显示

        DataTable usertable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            db.closedb();
                    Fun.goback("","没有输入查询条件","返回");

        }
        else
        {

            if (Request.QueryString["param2"] == "search")
            {  // 查找功能

                usertable = SearchPerson(db);
            }
            else
            {

                if (Request.QueryString["param2"] == "set")
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

                        if (actiontype == "movegroup")
                        {      //将选择用户放到 指定组   1.将选中用户的权限清空  2. 将选中用户的权限  根据要放入的权限组的权限设定  3. 将用户的权限组名改为新的
                            //测试完全正确
                            Movegroup(db);
                        }

                        if (actiontype == "delete")
                        {

                            DeleteUser(db);

                        }


                    }

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
            nowpage = 1;  //没有这一句当记录为空是点下一页出错

        int id = (nowpage - 1) * pagesize + 1;
        int showcount;
        if (nowpage * pagesize < usertable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = usertable.Rows.Count;


        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {
            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["userid"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["username"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["deptname"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["createdate"].ToString() + "</td>\n");
            if (usertable.Rows[i]["popedomgroup"].ToString() == "")
                sb.Append("<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_popedom.aspx", usertable.Rows[i]["userno"].ToString(), "", "", "", "") + "\"><font color=\"red\">自定义权限</font></a></td>\n");
            else
                sb.Append("<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_popedom.aspx", usertable.Rows[i]["userno"].ToString(), "", "", "", "") + "\">" + usertable.Rows[i]["popedomgroup"].ToString() + "</a></td>\n");

            sb.Append("<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_infoedit.aspx", usertable.Rows[i]["userno"].ToString(), "", "", "", "") + "\">编辑信息</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/user_mgr/", "user_add.aspx", "", "", "", "", "") + "\">添加新用户</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + usertable.Rows[i]["userno"].ToString() + "\"/></td>\n");
            sb.Append("</tr>\n");

            id++;
        }
        contentstring = sb.ToString();
        db.closedb();
    }






    /// <summary>
    /// ////////////////////////// 查找函数 
    /// </summary>
    /// <param name="db"></param>
    /// <returns></returns>
    protected DataTable SearchPerson(DBClass db)
    {

        if (Request.Form.Get("param3") != null)
            condition = Request.Form.Get("param3").ToString();
        else
            if (Request.QueryString["param3"] != null)
                condition = Request.QueryString["param3"].ToString();

        if (Request.Form.Get("department") != null)
            department = Request.Form.Get("department").ToString();
        else
            if (Request.QueryString["param4"] != null)
                department = Request.QueryString["param4"].ToString();

        string sqls;
        if (department == "")
        {
            //查找全部
            sqls = "select tbuser.*,department.*  from tbuser left join department on tbuser.dept_id=department.id  where isdelete=0  and (userid like '%" +
           condition + "%' or username like '%" + condition + "%' or popedomgroup like '%" +
           condition + "%' or usergrade like '%" + condition + "%' ) order by createdate desc";

        }
        else
        {
            sqls = "select tbuser.*,department.*  from tbuser left join department on tbuser.dept_id=department.id  where tbuser.isdelete=0  and (tbuser.userid like '%" +
          condition + "%' or tbuser.username like '%" + condition + "%' or tbuser.popedomgroup like '%" +
          condition + "%' or tbuser.usergrade like '%" + condition + "%' ) and tbuser.dept_id=" + department + " order by createdate desc";

        }




        DataTable usertable = db.GetTable(sqls, null);

        DataTable grouptable = new DataTable();
        grouptable = db.GetTable("select distinct groupname from popedomgroup", null);
        for (int group_i = 0; group_i < grouptable.Rows.Count; group_i++)
        {
            selectvalue += "<option value=\"" + grouptable.Rows[group_i]["groupname"].ToString() + "\"";
            if (grouptable.Rows[group_i]["groupname"].ToString() == "自定义")
                selectvalue += " selected=\"selected\"";

            selectvalue += ">" + grouptable.Rows[group_i]["groupname"].ToString() + "</option>";
        }
        return usertable;
        //
    }



    /// <summary>
    /// ///////  变换权限组
    /// </summary>
    /// <param name="db"></param>
    protected void Movegroup(DBClass db)
    {

        string[] sign ={ "," };
        string[] set_users = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);

        //  1. //////////////////////////////
        string clear_sql = "update popedom set popedom=0 where popedom.userno in ('";
        foreach (string u in set_users)
        {
            clear_sql += u + "','";

        }
        clear_sql += "')";
        db.ExecuteNonQuery(clear_sql, null);
        // 2. ////////////////////////////

        string updatesql = "update popedom set popedom=1  where popedom.userno in('";
        foreach (string u2 in set_users)
        {
            updatesql += u2 + "','";

        }
        updatesql += "') and popedom.variable in(select distinct variable from popedomgroup g where g.groupname=? and g.popedom=1)";
        OdbcParameter param_movegroup = new OdbcParameter("@popedomgroup", OdbcType.VarChar, 50);
        param_movegroup.Value = Request.Form.Get("movegroupname").ToString();

        db.ExecuteNonQuery(updatesql, param_movegroup);

        //  3. //////////////
        string popegroupname_sql = "update tbuser set popedomgroup=? where tbuser.userno in('";
        foreach (string u3 in set_users)
        {
            popegroupname_sql += u3 + "','";
        }
        popegroupname_sql += "')";
        db.ExecuteNonQuery(popegroupname_sql, param_movegroup);

        db.closedb();
       Fun.alert("","移动成功",Link.url("/user_mgr/", "user_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();


    }





    /// <summary>
    /// ///////////删除用户 （不是真的删除）
    /// </summary>
    /// <param name="db"></param>

    protected void DeleteUser(DBClass db)
    {
        string[] sign ={ "," };
        string[] set_users = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);
        string delete_sql = "update tbuser set isdelete=1 where tbuser.userno in ('";
        foreach (string u in set_users)
        {
            delete_sql += u + "','";

        }
        delete_sql += "')";
        db.ExecuteNonQuery(delete_sql, null);
		db.closedb();
    Fun.alert("","删除成功",Link.url("/user_mgr/", "user_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();


    }


</script>

<html>
<head runat="server">
    <title>用户查找</title>
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

</script>
    
</head>
<body>
<myhead:myhead ID="head1" runat="server" />
  
  
              <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
                <tr>
                    <td height="32" class="small" style="width: 50px">
                    <td width="100" nowrap class="small"><table>
                      <tr>
                        <td> <b><font color="#ffffff"> 用户管理</font></b></td>
                      </tr>
                    </table>
                    </td>
                <td class="small" nowrap><table>
                      <tr>
                        <td  class=small>  用户查找结果："<%=condition%>"</td>
                      </tr>
                    </table></td>
                </tr>
            </table>
  
  

   
  	
 			<form action="<%= Link.url("/user_mgr/","user_search.aspx","","set","","","")%>" method="post" name="selform" >
 			
     <div id="Div1">
  <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
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
      <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
          <td align="center" colspan="10" height="22" class="but1" style="width: 100%;">
              <input type="hidden" id="actiontype" name="actiontype" style="width: 23px; height: 19px" />
              共
              <%=total%>
              条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%>
              页，每页
              <%=pagesize%>
              条 <a href="<%= Link.url("/user_mgr/","user_search.aspx","1","search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),department,"") %>">
                  首页</a> <a href="<%= Link.url("/user_mgr/","user_search.aspx",(nowpage-1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),department,"") %>">
                      上一页</a> &nbsp;<a href="<%= Link.url("/user_mgr/","user_search.aspx",(nowpage+1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),department,"") %>">下一页</a>
              <a href="<%= Link.url("/user_mgr/","user_search.aspx",maxpage.ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),department,"") %>">
                  尾页</a> &nbsp;&nbsp;&nbsp;
          </td>
      </tr>
      <tr>
      
      <td align="right" colspan="10" height="22" class="but1" style="width:100%;">
       <font color="red">选择权限组</font> &nbsp;<select name="movegroupname" style="width: 12%">    <%=selectvalue %></select>
          
              <input onClick="{if(confirm('此操作将用户添加到 这个组吗！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='movegroup';document.selform.submit();return true;}return false;}" type="submit" value="添加到此组" name="action2"> 
             <input type="button" value="删除选定用户" onClick="{if(confirm('此操作将用户删除吗！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" name="delbuttion" style="width: 85px; height: 22px">&nbsp;
           <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"> 反选 &nbsp; 
      </td>
      </tr> 
          
       </table>   
 
 </div>
</form>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
