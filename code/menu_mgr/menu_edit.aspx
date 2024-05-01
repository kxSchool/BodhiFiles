<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">


    public string bigname;
    public string subname;
    public string url;
    protected string oldsencondvalueid;
	protected string oldsencondvalue;
	
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == "" || Request.QueryString["param2"] == null)
         {   
		    oldsencondvalueid =Request.QueryString["param1"].ToString();
			  ShowEditMenu(db);

           }
        if (Request.QueryString["param2"] != "" & Request.QueryString["param2"] != null)
        {//修改
		

            string action = Request.QueryString["param2"];
            if (action == "saveedit")
                SaveEditMenu(db);

        }
        db.closedb();

    }





    /// <summary>
    /// /////////   显示要编辑的菜单
    /// </summary>
    /// <param name="db"></param>
    protected void ShowEditMenu(DBClass db)
    {

        OdbcParameter myparam = new OdbcParameter("@oldsencondvalueid", OdbcType.Int);
        myparam.Value = oldsencondvalueid;
        string selectsql = "select * from tbsystem where id=?";
        DataTable tb = new DataTable();
        tb = db.GetTable(selectsql, myparam);
        if (tb.Rows.Count > 0)
        {
            bigname = tb.Rows[0]["parentvalue"].ToString();
            subname = tb.Rows[0]["sencondvalue"].ToString();
			oldsencondvalue=subname;
	
            url = tb.Rows[0]["variable"].ToString();
        }

    }




    /// <summary>
    /// ////////////保存菜单修改
    /// </summary>
    /// <param name="db"></param>
    protected void SaveEditMenu(DBClass db)
    {
	


        OdbcParameter[] paramsave ={  
  
            new OdbcParameter("@parentvalue",OdbcType.VarChar), 
            new OdbcParameter("@sencondvalue",OdbcType.VarChar), 
            new OdbcParameter("@variable",OdbcType.VarChar),
            new OdbcParameter("@orderbyparent",OdbcType.DateTime)
               };

        paramsave[0].Value = Request.Form.Get("parentvalue").ToString().Trim();
        paramsave[1].Value = Request.Form.Get("sencondvalue").ToString().Trim();
        paramsave[2].Value = Request.Form.Get("linkurl").ToString().Trim();
        //检查如果一级菜单是已存在的 则读取该菜单时间  否则now
        OdbcParameter parambigcheck = new OdbcParameter("@parentvalue", OdbcType.VarChar);
        parambigcheck.Value = Request.Form.Get("parentvalue").ToString().Trim();
        DataTable bigchecktb = db.GetTable("select * from tbsystem where parentvalue=?", parambigcheck);
        if (bigchecktb.Rows.Count > 0)
            paramsave[3].Value =Convert.ToDateTime( bigchecktb.Rows[0]["orderbyparent"].ToString());
        else
            paramsave[3].Value = System.DateTime.Now;
        //tbsystem

		
		 
        string sqlsave = "update tbsystem set parentvalue=?,sencondvalue=?,variable=?,orderbyparent=? where tbsystem.id="+Request.Form.Get("oldsencondvalueid");

	    db.ExecuteNonQuery(sqlsave, paramsave);

        //更新popedom

        OdbcParameter[] parampopedom1 ={ 
                   new OdbcParameter("@variable",OdbcType.VarChar) ,
                   new OdbcParameter("@old",OdbcType.VarChar)
                };
        parampopedom1[0].Value = Request.Form.Get("sencondvalue").ToString().Trim();
        parampopedom1[1].Value = Request.Form.Get("oldsencondvalue").ToString().Trim();

        string sqlupdate = "update popedom set variable=? where variable=?";
        db.ExecuteNonQuery(sqlupdate, parampopedom1);


        //更新 popedomgroup
        OdbcParameter[] parampopedom2 ={ 
                   new OdbcParameter("@variable",OdbcType.VarChar) ,
                   new OdbcParameter("@old",OdbcType.VarChar)
                };
        parampopedom2[0].Value = Request.Form.Get("sencondvalue").ToString().Trim();
        parampopedom2[1].Value = Request.Form.Get("oldsencondvalue").ToString().Trim();

        sqlupdate = "update popedomgroup set variable=? where variable=?";
       
	   
	   
	   
	    db.ExecuteNonQuery(sqlupdate, parampopedom2);

        db.closedb(); 
          Fun.alert("","修改成功",Link.url("/menu_mgr/", "addmenu.aspx", "", "", "", "", ""),"返回");
        Response.End();

    }
</script>

<html>
<head runat="server">
    <title>无标题页</title>
    
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
   if(document.form1.parentvalue.value==""){window.alert("大类菜单名不能为空");document.form1.parentvalue.focus();return (false);}
   if(document.form1.sencondvalue.value==""){window.alert("二级菜单不能为空");document.form1.sencondvalue.focus();return (false);}
     if(document.form1.linkurl.value==""){window.alert("链接地址不能为空");document.form1.linkurl.focus();return (false);}
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
          <td> <b><font color="#ffffff">栏目名称编辑</font></b></td>
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
    <form name="form1" method="post" action="<%= Link.url("/menu_mgr/","menu_edit.aspx","","saveedit","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    大类菜单名称：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="parentvalue" style="width: 157px" value="<%=bigname %>" /></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    二级菜单名称：</td>
                <td style="width: 153px; height: 30px;">
                <input type="text" name="sencondvalue" value="<%=subname %>" style="width: 157px" /></td>
                
            </tr>
            <tr>
                <td style="height: 24px">
                    链接地址：
                </td>
                <td style="width: 153px; height: 24px;">  <input type="text" name="linkurl" value="<%=url %>" style="width: 243px" />&nbsp;
                </td>
            
             </tr>
              <tr>
                <td>
                
                </td>
                <td style="width: 153px"> &nbsp;<input type="hidden" name="oldsencondvalueid" value="<%=oldsencondvalueid %>" /><input type="hidden" name="oldsencondvalue" value="<%=oldsencondvalue %>" />
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
