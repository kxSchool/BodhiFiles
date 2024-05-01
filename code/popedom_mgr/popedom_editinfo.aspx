<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>


<script runat="server">
    protected string sid,oldname ;
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            if (Request.QueryString["param1"] != null)
        sid = Request.QueryString["param1"].ToString();
		string sqls;
        DataTable popedomgrouptable = new DataTable();
		sqls = "select * from popedomgroup where id=" + sid;
        popedomgrouptable = db.GetTable(sqls, null);
		oldname=popedomgrouptable.Rows[0]["groupname"].ToString();
		db.closedb();

        }
        else
        {
            if (Request.QueryString["param2"] == "saveedit")
            {
                SaveEdit(db);
            }

        }


        db.closedb();

    }






    protected void SaveEdit(DBClass db)
    {
        string sql = "update popedomgroup set groupname=? where  popedomgroup.groupname in (select groupname from popedomgroup where id=?)";
        OdbcParameter[] param ={ 
         
          new OdbcParameter("@newgroupname",OdbcType.VarChar,100),
            new OdbcParameter("@id",OdbcType.Int,4)
        };
     
        param[0].Value = Request.Form.Get("newgroupname").ToString().Trim(); 
        param[1].Value = Convert.ToInt32(Request.QueryString["param1"].ToString());

        db.ExecuteNonQuery(sql, param);

        sql = "update tbuser set popedomgroup=? where tbuser.popedomgroup in (select groupname from popedomgroup where id=?)";
     
        param[0].Value = Request.Form.Get("newgroupname").ToString().Trim();  
        param[1].Value = Request.QueryString["param1"];
        db.ExecuteNonQuery(sql, param);

        db.closedb();
         Fun.alert("","修改成功",Link.url("/popedom_mgr/", "popedom_group.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }

</script>

<html>
<head id="Head1" runat="server">
    <title>修改组名</title>
    
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
<myhead:myhead ID="Myhead1" runat="server" />
   <div>
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
            <tr>              <td width="50" height="32" nowrap class="small">&nbsp;
				    </td>
            <td width="100" nowrap class=small><table>
                  <tr>
                    <td> <b><font color="#ffffff">权限组名称编辑</font></b></td>
                  </tr>
              </table></td>
              <td height="2"><table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="32" class=small>&nbsp; 
                </td>
              </tr>
            </table>            </tr>
        </table>

 
 </div>

 <div>
    <form name="form1" method="post" action="<%= Link.url("/popedom_mgr/","popedom_editinfo.aspx",Request.QueryString["param1"].ToString(),"saveedit","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    旧组名：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="oldgroupname" readonly style="width: 157px" value="<%=oldname %>" /></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    新组名：</td>
                <td style="width: 153px; height: 30px;">
                <input type="text" name="newgroupname" style="width: 157px"   value="<%=oldname %>" /></td>
                
            </tr>
        
           
             
              <tr>
                <td>
                
                </td>
                <td style="width: 153px"> 
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
