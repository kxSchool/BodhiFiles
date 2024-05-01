<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>



<script runat="server">
    public string userid;

    protected void Page_Load(object sender, EventArgs e)
    {



        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

            if (Session["userid"] == null || Session["userid"].ToString() == "")
            {
                Response.Write("会话过期");
                Response.End();
            }
            else
            {
                userid = Session["userid"].ToString();
            }


        }
        else
        {
            string action = Request.QueryString["param2"];
            if (action == "saveedit")
            {
               
                if( Request.Form.Get("newpwd1").ToString().Trim()!= Request.Form.Get("newpwd2").ToString().Trim())
				{
				      Fun.goback("","两次输入的密码不一致","返回");
                    Response.End();
				} 
				
				DBClass db = new DBClass();
			DataTable pt=db.GetTable("select * from tbuser where userid='"+ Request.Form["hiddenuserid"]+"'");
              if(pt.Rows[0]["password"].ToString()!=Request.Form["oldpwd"])
			   {
			          db.closedb();
                    Fun.goback("","旧密码错误","返回");
                    Response.End();
			   }				
				
            
                OdbcParameter param =new OdbcParameter("@newpwd", OdbcType.VarChar);
                param.Value = Request.Form["newpwd1"].ToString().Trim();
          

             db.ExecuteNonQuery("UPDATE  tbUser set tbUser.PassWord='"+ Request.Form["newpwd1"] +"' where tbUser.UserID='"+Request.Form["hiddenuserid"]+"'", null);
             
                    db.closedb();
                      Fun.alert("","修改成功",Link.url("/", "document.aspx", "", "", "", "", ""),"返回首页");
                    Response.End();
          

            }
        }


    }

</script>
<html>
<head runat="server">
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
   if(document.form1.oldpwd.value==""){window.alert("请输入旧密码");document.form1.oldpwd.focus();return (false);}
   if(document.form1.newpwd1.value==""){window.alert("请输入新密码");document.form1.newpwd1.focus();return (false);}
     if(document.form1.newpwd2.value==""){window.alert("请再次输入新密码");document.form1.newpwd2.focus();return (false);}
     if(document.form1.newpwd1.value!=document.form1.newpwd2.value){window.alert("两次输入的密码不一致");document.form1.newpwd2.focus();return (false);}
     
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
<myhead:myhead ID="head1" runat="server" />

 <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">密码修改</font></b></td>
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
    <form name="form1" method="post" action="<%= Link.url("/user_mgr/","user_pwdedit.aspx","","saveedit","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    登录名：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="loginuserid" disabled style="width: 157px" value="<%=userid %>" /></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    旧密码：</td>
                <td style="width: 153px; height: 30px;">
                <input type="password" name="oldpwd" style="width: 157px" /></td>
                
            </tr>
            <tr>
                <td style="height: 24px">
                    新密码：
                </td>
                <td style="width: 153px; height: 24px;">  <input type="password" name="newpwd1" style="width: 157px" />&nbsp;
                </td>
            
             </tr  >
              <tr>
                <td style="height: 24px">
                    再次输入新密码：
                </td>
                <td style="width: 153px; height: 24px;">  <input type="password" name="newpwd2" style="width: 157px" />&nbsp;
                </td>
            
             </tr>
             
              <tr>
                <td>
                
                </td>
                <td style="width: 153px"> 
                <input type="hidden" name="hiddenuserid" value="<%=userid %>" />
                <input type="submit" value="修改" style="width: 65px" />
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
