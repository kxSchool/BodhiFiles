<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">

  protected string oldtypename;
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            if (Request.QueryString["param1"] != null)
            {
                OdbcParameter p = new OdbcParameter("@id", OdbcType.Int, 4);
                p.Value = Convert.ToInt32(Request.QueryString["param1"].ToString());
                oldtypename = db.GetTable("select name from tbdatatype where id=?", p).Rows[0][0].ToString();

            }
            else
            {
               db.closedb();
			Fun.goback("","参数出错","返回");
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
    /// ////修改类别
    /// </summary>
    /// <param name="db"></param>

    protected void SaveEdit(DBClass db)
    {
        if (Request.Form.Get("newtypename").ToString() == "")
        {
             db.closedb();
			Fun.goback("","类别名称不能为空","返回");
            
        }

        string sql = "update tbdatatype set name=? where tbdatatype.name='"+ Request.Form["oldtypename"]+"'";
        OdbcParameter[] param ={ 
           new OdbcParameter("@newtypename",OdbcType.VarChar)
        };
        param[0].Value = Request.Form.Get("newtypename").ToString().Trim();
        db.ExecuteNonQuery(sql, param);
        db.closedb();
      Fun.alert("","修改成功",Link.url("/app_mgr/ziliao_mgr/", "data_typemanage.aspx", "", "", "", "", ""),"返回");
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
          <td> <b><font color="#ffffff">类别编辑</font></b></td>
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
    <form name="form1" method="post" action="<%=Link.url("/app_mgr/ziliao_mgr/","data_typeedit.aspx","","saveedit","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    旧类别名：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="oldtypename" readonly style="width: 157px" value="<%=oldtypename %>" /></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    新类别名：</td>
                <td style="width: 153px; height: 30px;">
                <input type="text" name="newtypename" value="<%=oldtypename %>" style="width: 157px" /></td>
                
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
