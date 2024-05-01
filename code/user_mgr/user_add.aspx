<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>


<script runat="server">
public string new_userno;
 protected string selectvalue="";
    protected string deptselectvalue="";
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
		new_userno = "U_"+System.DateTime.Now.ToString("s");
		new_userno=new_userno.Replace(":","");
		new_userno=new_userno.Replace("T","");
		new_userno=new_userno.Replace("-","");
		//Response.Write(new_userno);
		//Response.End();

        if (Request.QueryString["param2"] == "" || Request.QueryString["param2"]==null)
        {

            //填充下拉框
            DataTable depttable = db.GetTable("select * from department", null);
            for (int dept_i = 0; dept_i < depttable.Rows.Count; dept_i++)
            {
                deptselectvalue+="<option value=\"";
                deptselectvalue+= depttable.Rows[dept_i]["id"].ToString() + "\"";

                deptselectvalue+=">" + depttable.Rows[dept_i]["deptname"].ToString() + "</option>";
            }

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
            if (Request.QueryString["param2"] == "adduser")
            {

                if (LimitUser.CheckLimitUserAdd(db) == false)
                {
                    db.closedb();

                    Fun.alert("","对不起，用户数已经超过了最大用户限制，请购","http://www.aixinsoft.cn","购买");
                    Response.End();
                }

                if (Request.Form.Get("department").ToString() == "0")
                {
                    db.closedb();
					
                    Fun.goback("","对不起，请选择部门！","返回");
                    Response.End();
                }


                
                //保证登录名唯一
                string chksql = "select * from tbuser where userid=?";
                OdbcParameter checkparam = new OdbcParameter("@userid",OdbcType.VarChar,20);
                checkparam.Value = Request.Form.Get("userid").ToString().Trim();
                int chkresult = db.GetTable(chksql,checkparam).Rows.Count;
                if (chkresult > 0)
                {
                  db.closedb();
                     Fun.goback("","对不起，此登录名用户已经存在！","返回");
                }


                //添加用户功能
       

                db.ExecuteNonQuery( " insert into tbuser ( userno,userid,password,popedomgroup,username,dept_id,createdate,isdelete ) values ('"+new_userno+ "','"+Request.Form["userid"].ToString().Trim()+"','"+  Request.Form.Get("password").ToString().Trim() +"','"+ Request.Form.Get("popedomgroup").ToString()+"','"+  Request.Form.Get("username").ToString().Trim()+"',"+ Request.Form.Get("department")+",'"+DateTime.Now.ToString()+  "',0)");

                //插入popedom  要先判读是哪个权限组  如‘自定义’全初始为0  其他要从popedomgroup表中读

                DataTable menutable = new DataTable();
                menutable = db.GetTable("select * from tbsystem");
                OdbcParameter[] popedomparam ={
                        new OdbcParameter("@userno", OdbcType.VarChar),
                        new OdbcParameter("@variable", OdbcType.VarChar),
                    };
                popedomparam[0].Value = new_userno;
                for (int i = 0; i < menutable.Rows.Count; i++)
                {
                    popedomparam[1].Value = menutable.Rows[i]["sencondvalue"].ToString();
                   db.ExecuteNonQuery("insert into popedom(userno,variable)values(?,?)", popedomparam);

                }
                //更新用户权限
                if (Request.Form.Get("popedomgroup").ToString() != "")
                {
                    OdbcParameter groupnameparam = new OdbcParameter("groupname", OdbcType.VarChar);
                    groupnameparam.Value = Request.Form.Get("popedomgroup").ToString();
                    DataTable popetable = db.GetTable("select variable from popedomgroup where groupname= ? and popedom=1", groupnameparam);
                    string updatepopedomsql = "update popedom set popedom=1 where popedom.userno='" + new_userno + "' and popedom.variable in('";
                    for (int i_pope = 0; i_pope < popetable.Rows.Count; i_pope++)
                    {
                        updatepopedomsql += popetable.Rows[i_pope]["variable"] + "','";
                    }
                    updatepopedomsql += "')";

                   db.ExecuteNonQuery(updatepopedomsql, null);

                }
                db.closedb();
                Fun.alert("","添加用户成功",Link.url("/user_mgr/", "user_manage.aspx", "", "", "", "", ""),"返回");
                Response.End();


            }

        }
        db.closedb();
    }



</script>

<html>
<head id="Head1" runat="server">
    <title>修改密码</title>
    
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
   if(document.form1.userid.value==""){window.alert("请输入登陆名");document.form1.userid.focus();return (false);}
   if(document.form1.password.value==""){window.alert("请输入密码");document.form1.password.focus();return (false);}
     if(document.form1.username.value==""){window.alert("请再次输入真实姓名");document.form1.username.focus();return (false);}
 
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
 <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">添加用户</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>
                                     
					</td>
        </tr>
    </table> </td>
  </tr>
</TABLE>

 <div>
    <form name="form1" method="post" action="<%= Link.url("/user_mgr/","user_add.aspx","","adduser","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    登录名：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="userid"  style="width: 157px"/></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    密码：</td>
                <td style="width: 153px; height: 30px;">
                <input type="password" name="password" style="width: 157px" /></td>
                
            </tr>
            <tr>
                <td style="height: 24px">
                    真实姓名：
                </td>
                <td style="width: 153px; height: 24px;">  <input type="text" name="username" style="width: 157px" />&nbsp;
                </td>
            
             </tr  >
                <tr>
                <td style="height: 24px">
                   选择部门 &nbsp;</td>
                <td style="width: 153px; height: 24px;">  <select name="department" style="width: 100%"><option value="0">/</option> <%= deptselectvalue %></select>&nbsp;
                </td>
            
             </tr>
              <tr>
                <td style="height: 24px">
                   选择权限组 &nbsp;</td>
                <td style="width: 153px; height: 24px;">  <select name="popedomgroup" style="width: 100%"><option value="">自定义权限</option> <%=selectvalue %></select>&nbsp;
                </td>
            
             </tr>
             
              <tr>
                <td>
                
                </td>
                <td style="width: 153px"> &nbsp;<input type="submit" value="添加" style="width: 65px" />
                  <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />
                </td>
            
             </tr>
      
        </table>
 </form>
 
 </div>
 
 <br>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
