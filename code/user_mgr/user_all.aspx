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
    protected StringBuilder selectsb = new StringBuilder();
    protected string dept_id = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        DBClass db = new DBClass();

        //页面载入显示
        string sqls;
        DataTable usertable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {


            DataTable grouptable = new DataTable();
            grouptable = db.GetTable("select distinct groupname from popedomgroup", null); // 权限组下拉框
            for (int group_i = 0; group_i < grouptable.Rows.Count; group_i++)
            {
                selectvalue += "<option value=\"" + grouptable.Rows[group_i]["groupname"].ToString() + "\"";
                selectvalue += ">" + grouptable.Rows[group_i]["groupname"].ToString() + "</option>";
            }


        }
        else
        {


            if (Request.QueryString["param2"] == "set")
            {

                string actiontype = "";
                if (Request.Form.Get("actiontype") != null)
                    actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别



                if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                {
				    db.closedb();
                    Fun.goback("","没有选择任何用户","返回");
                    Response.End();
                }
                else
                {


                    if (actiontype == "movegroup")
                    {//将选择用户放到 指定组   1.将选中用户的权限清空  2. 将选中用户的权限  根据要放入的权限组的权限设定  3. 将用户的权限组名改为新的
                        //测试完全正确

                        Movegroup(db);

                    }
                    if (actiontype == "delete")
                    {

                        DeleteUser(db);

                    }
                    if (actiontype == "movedept")
                    {
                        MoveDept(db);
                    }



                }



            }  //set

        }



        //分页页面显示
        string countsql = "";




        if (Request.QueryString["param4"] == null || Request.QueryString["param4"].ToString() == "")
        {
            dept_id = "";  //列出全部
            sqls = "select tbuser.*,department.* from tbuser left join department on tbuser.dept_id=department.id where  isdelete=0 order by createdate desc";
        }
        else
        {
            dept_id = Request.QueryString["param4"].ToString();
            sqls = "select tbuser.*,department.* from tbuser left join department on tbuser.dept_id=department.id where isdelete=0 and tbuser.dept_id=" + dept_id + " order by createdate desc";
        }
        usertable = db.GetTable(sqls, null);


        contentstring = "";
        total = usertable.Rows.Count;

        pagesize = 40;  //每页显示
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





        //填充下拉框
        DataTable depttable = db.GetTable("select * from department", null);
        for (int i = 0; i < depttable.Rows.Count; i++)
        {
            selectsb.Append("<option value=\"");
            selectsb.Append(depttable.Rows[i]["id"].ToString() + "\"");
            if (depttable.Rows[i]["id"].ToString() == dept_id)
            {
                selectsb.Append("selected = \"selected\"");
            }

            selectsb.Append(">" + depttable.Rows[i]["deptname"].ToString() + "</option>");
        }




        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {
            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href='" + Link.url("/log_mgr/","log_loginsearch.aspx","","",HttpUtility.UrlEncode(usertable.Rows[i]["username"].ToString(), System.Text.Encoding.UTF8),"","") + "'>" + usertable.Rows[i]["userid"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >");
            if (usertable.Rows[i]["qq"].ToString()=="" || usertable.Rows[i]["qq"]==null)
                sb.Append("<!--img src=\"/images/offline.gif\"/-->");
            else
                sb.Append("<a href=\"tencent://message/?uin="+ usertable.Rows[i]["qq"].ToString()+ "&Site=江苏省如皋经济开发区招商局_内部管理系统&Menu=yes"+"\"><img src=\"http://wpa.qq.com/pa?p=1:"+ usertable.Rows[i]["qq"].ToString()+ ":1\" border=\"0\" alt=\"在线qq交流\"/></a>");

            sb.Append("</td>\n");

            sb.Append("<td height=\"24\" align=\"center\" ><a href='" + Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search",HttpUtility.UrlEncode(usertable.Rows[i]["username"].ToString(), System.Text.Encoding.UTF8),"","") + "'>" + usertable.Rows[i]["username"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href='" + Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search","","",usertable.Rows[i]["dept_id"].ToString()) + "'>" + usertable.Rows[i]["deptname"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["createdate"].ToString() + "</td>\n");
            if (usertable.Rows[i]["popedomgroup"].ToString() == "")
                sb.Append("<td height=\"24\" align=\"center\" ><font color=\"red\">自定义权限</font></td>\n");
            else
                sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["popedomgroup"].ToString() + "</td>\n");

            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+ Link.url("/user_mgr/","user_all_info.aspx",usertable.Rows[i]["userno"].ToString(),"","","","") + "\">用户详情</a></td>\n");
                        sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();
        db.closedb();
    }




    /// <summary>
    /// ///// 移动到某权限组
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
       Fun.alert("","移动成功",Link.url("/user_mgr/", "user_all.aspx", "", "", "", "", ""),"返回");
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
         Fun.alert("","删除成功",Link.url("/user_mgr/", "user_all.aspx", "", "", "", "", ""),"返回");


    }



    /// <summary>
    /// ///////移动部门
    /// </summary>
    /// <param name="db"></param>
    protected void MoveDept(DBClass db)
    {
        string[] sign ={ "," };
        string[] set_users = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);

        
        string updatesql = "update tbuser set dept_id=?  where tbuser.userno in('";
        foreach (string u2 in set_users)
        {
            updatesql += u2 + "','";

        }
        updatesql += "')";

        OdbcParameter parammove = new OdbcParameter("@newdept_id", OdbcType.Int, 4);
        parammove.Value = Convert.ToInt32(Request.Form.Get("movetodept").ToString());

        db.ExecuteNonQuery(updatesql, parammove);
       db.closedb();
       Fun.alert("","移动成功",Link.url("/user_mgr/", "user_all.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }


</script>

<html>
<head runat="server">
    <title>用户管理</title>
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
	//e.className='lvtColDataHover';
		e.style.backgroundColor="#FFFFe2";
	else
	//e.className='lvtColData';
		e.style.backgroundColor="#ffffff";
} 
function form_check(){
   if(document.addform.userid.value==""){window.alert("登录名不能为空");document.addform.userid.focus();return (false);}
   if(document.addform.password.value==""){window.alert("密码不能为空");document.addform.password.focus();return (false);}
   if(document.addform.username.value==""){window.alert("真实姓名不能为空");document.addform.username.focus();return (false);}
   return true;
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
   if(confirm("确定要删除此用户吗？"))
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
             alert("对不起，您没有选择任何用户");
        else
        
          alert(users);
     
}


function ChangeDept(dept)
{

    url="<%=Link.url("/user_mgr/","user_all.aspx","","","","deptdd","") %>";
	 url = url.replace("deptdd",dept);
	  window.location=url;

}

</script>

</head>
<body>
<myhead:myhead ID="head1" runat="server" />
    <div>
        <form name="form1" method="post" action="<%= Link.url("/user_mgr/","user_search.aspx","","search","","","")%>">
            <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
                <tr>
                    <td height="32" class="small" style="width: 50px">
                    <td class="small" nowrap><table>
                      <tr>
                        <td> <b><font color="#ffffff"> 系统用户</font></b></td>
                      </tr>
                    </table></td>
                    <td class="small" nowrap>
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                 用户查询：</td>
                                <td style="width: 20px; height: 24px;">
                                </td>
                                <td style="height: 24px">
                                    <select name="department" onChange="ChangeDept(this.value)">
                                        <option value="">部门选择</option>
                                        <% =selectsb.ToString() %>
                                    </select>
                                    &nbsp;
                                    <input type="text" name="param3" style="width: 213px; height: 20px;" /></td>
                                <td style="width: 42px; height: 24px;">
                                    <input type="submit" value="查找" style="width: 75px; height: 20px;" /></td>
                            </tr>
                      </table>
                    </td>
                </tr>
            </table>
        </form>
    </div>
 
 
   <div>

  	
 			<form action="<%= Link.url("/user_mgr/","user_all.aspx","","set","","","")%>" method="post" name="selform" >
 <div id="Div1">
  <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
    <tr class="lvtCol">
			<td height="30" align="center"> 序号</td>
         
			<td align="center" >
                登录日志</td>
             <td align="center" >
                QQ</td>
			<td align="center">
                所属信息</td>
                	<td align="center" >
                部门</td>
			<td align="center"  style="height: 18px; width: 16%;">
                注册日期</td>
			<td align="center" >
                权限组</td>
			<td align="center" >
                查看信息</td>
	  </tr>
          
   
          <%=contentstring %>
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="8" height="22" class="but1" style="width:100%;">
      <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      
      共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%>
       
            页，每页 
          <%=pagesize%> 条 <a href="<%= Link.url("/user_mgr/","user_all.aspx","1","","",dept_id,"") %>">首页</a> <a href="<%= Link.url("/user_mgr/","user_all.aspx",(nowpage-1).ToString(),"","",dept_id,"") %>">上一页</a> &nbsp;<a href="<%= Link.url("/user_mgr/","user_all.aspx",(nowpage+1).ToString(),"","",dept_id,"") %>">下一页</a> <a href="<%= Link.url("/user_mgr/","user_all.aspx",maxpage.ToString(),"","",dept_id,"") %>">尾页</a></td>
        
      </tr> 
          <tr bgcolor=white>
         <td align="right" colspan="8" height="22" class="but1" style="width:100%;">&nbsp;           </td> 
          </tr>
           <tr>
             <td align="right" colspan="8" height="22" class="but1" style="width:100%;">&nbsp;</td>
           </tr>
    </table>   
     </div>
     </form>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
