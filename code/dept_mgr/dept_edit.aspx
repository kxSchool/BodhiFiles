<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>
<script runat="server">

  protected string olddeptname;
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"]=="")
        {
            if (Request.QueryString["param1"] != null)
            {
                OdbcParameter p = new OdbcParameter("@id",OdbcType.Int,4);
                p.Value =Convert.ToInt32( Request.QueryString["param1"].ToString());
                olddeptname = db.GetTable("select deptname from department where id=?",p).Rows[0][0].ToString();

            }
            else
            {
                db.closedb();
			Fun.goback("","参数错误！","返回");
                Response.End();
            }
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




    /// <summary>
    /// ////修改部门
    /// </summary>
    /// <param name="db"></param>

    protected void SaveEdit(DBClass db)
    {
        if (Request.Form.Get("newdeptname").ToString() == "")
        {
             db.closedb();
			Fun.goback("","部门名称不能为空！","返回");
            
        }

        string sql = "update department set deptname=? where department.deptname='"+Request.Form["olddeptname"] +"'";
        OdbcParameter[] param ={ 
           new OdbcParameter("@newdeptname",OdbcType.VarChar)
        };
        param[0].Value = Request.Form.Get("newdeptname").ToString().Trim();
        db.ExecuteNonQuery(sql, param);

        db.closedb();
		  Fun.alert("","修改成功！",Link.url("/dept_mgr/","dept_manage.aspx","","","","","") ,"返回");
        Response.End();
    }

</script>

<html>
<head id="Head1" runat="server">
    <title>修改部门名</title>
    
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
   if(document.form1.newdeptname.value==""){window.alert("请输入新部门名称");document.form1.newdeptname.focus();return (false);}

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
          <td> <b><font color="#ffffff">部门名称编辑</font></b></td>
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
    <form name="form1" method="post" action="<%= Link.url("/dept_mgr/","dept_edit.aspx","","saveedit","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    旧部门名：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="olddeptname" readonly style="width: 157px" value="<%=olddeptname %>" /></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    新部门名：</td>
                <td style="width: 153px; height: 30px;">
                <input type="text" name="newdeptname" style="width: 157px"  value="<%=olddeptname %>"  /></td>
                
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
