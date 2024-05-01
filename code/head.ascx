<%@ Control Language="C#" %>
<%@ Import Namespace="Common" %>
<script runat="server">

    public string userno;
    public string pwdurl;
    public string infourl;
    public string logouturl,user_all;
    protected string deptname;
    protected void Page_Load(object sender, EventArgs e)
    {



        string server_v1, server_v2;
        server_v1 = HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
        server_v2 = HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
        if (server_v1 != null)
        {
            if (server_v1.Substring(7, server_v2.Length) != server_v2 && server_v1.Substring(8, server_v2.Length) != server_v2)
            {
                Response.Write("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
                Response.Write("<tr><td style='font:9pt Verdana'>");
                Response.Write("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
                Response.Write("</td></tr></table></center>");
                Response.End();
            }
        }
        else
        {
            Response.Write("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
            Response.Write("<tr><td style='font:9pt Verdana'>");
            Response.Write("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
            Response.Write("</td></tr></table></center>");
            Response.End();
        }
		
		if(Session["userno"]==null)
		{
		   Response.Redirect(Link.url("/","logout.aspx","","","","",""));
		}
		
        userno = Session["userno"].ToString();
        deptname = Session["deptname"].ToString();
        pwdurl =Link.url("/user_mgr/","user_pwdedit.aspx",Session["userid"].ToString(),"","","","");
        infourl =Link.url("/user_mgr/","user_info.aspx",userno,"","","","");
        logouturl =Link.url("/","logout.aspx","","","","","");
		user_all=Link.url("/user_mgr/","user_all.aspx","","","","","");
        
    }
</script>
<table width="100%" height="60" border="0" cellpadding="0" cellspacing="0">
  <tr valign="bottom">
    <TD width="20%" height="30"  align="center"><a href="<%=Link.url("/","department.aspx","","","","","")%>">部门</a>：&nbsp;<font color="green"><%= deptname %></font></td>
    <TD width="30%" height="30"  align="left">属于权限组：&nbsp;<font color="green"><%=Session["popedomgroup"].ToString()==""?"自定义权限组":Session["popedomgroup"].ToString() %></font></td>
    <TD width="28%" height="30"  align="center"> <a href="<%= user_all %>">所有用户</a> &nbsp; <a href="<%= pwdurl %>">修改密码</a> &nbsp;
    <a href="<%=infourl %>">修改资料</a> &nbsp;<a  href="<%=logouturl %>" target="_parent">退出系统</a>
    </td>
  </tr>
	
	<tr>
	  <td height="20" colspan="3"  align="center"></td>
	</TR>
</table>
