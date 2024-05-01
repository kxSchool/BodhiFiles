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
    protected string oldispublic = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] =="")
        {
            if (Request.QueryString["param1"] != null)
            {
                OdbcParameter p = new OdbcParameter("@id", OdbcType.Int, 4);
                p.Value = Convert.ToInt32(Request.QueryString["param1"].ToString());
                DataTable nt = db.GetTable("select typename,ispublic from tbnewstype where id=?", p);
                oldtypename = nt.Rows[0]["typename"].ToString();
                oldispublic = nt.Rows[0]["ispublic"].ToString();

            }
            else
            {
			 db.closedb();
				 Fun.goback("","参数出错！","");
               
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
			 Fun.goback("","类别名不能为空！","返回");
            Response.End();
        }

        string sql = "update tbnewstype set typename=?,ispublic=? where id=?";
        OdbcParameter[] param ={ 
         
           new OdbcParameter("@newtypename",OdbcType.VarChar,100),
            new OdbcParameter("@ispublic",OdbcType.Char,1),    
            new OdbcParameter("@id", OdbcType.Int, 4),
        }; 
        param[0].Value = Request.Form.Get("newtypename").ToString().Trim();
   
        param[1].Value = Request.Form.Get("ispublic").ToString();
           param[2].Value = Convert.ToInt32(Request.Form.Get("editid").ToString());
        
        db.ExecuteNonQuery(sql, param);
        db.closedb();
        Response.Redirect(Link.url("/app_mgr/news_mgr/","news_typemanage.aspx","","","","",""));
        Response.End();
    }

</script>

<html>
<head id="Head1" runat="server">
    <title>修改类别</title>
    
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
   if(document.form1.newtypename.value==""){window.alert("请输入新类别名称");document.form1.newtypename.focus();return (false);}

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
    <form name="form1" method="post" action="<%= Link.url("/app_mgr/news_mgr/","news_typeedit.aspx","","saveedit","","","") %>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px" >
                    旧类别名：</td>
                <td style="width: 153px; height: 27px;">
                <input type="text" name="oldtypename" readonly style="width: 157px" value="<%=oldtypename %>" /><input type="hidden" name="editid" value="<%= Convert.ToInt32(Request.QueryString["param1"].ToString()) %>" /></td>
                
          </tr>
          <tr>
          
                <td style="height: 30px">
                    新类别名：</td>
                <td style="width: 153px; height: 30px;">
                <input type="text" name="newtypename" style="width: 157px" value="<%=oldtypename %>" /></td>
                
            </tr>
          <tr>
          
                <td style="height: 30px">
                    属性：</td>
                <td style="height: 30px;">
               <input type="radio" name="ispublic" <% if( oldispublic=="0") Response.Write("checked"); %> value="0" />私有板块&nbsp; &nbsp;<input type="radio" <% if( oldispublic=="1") Response.Write("checked"); %> name="ispublic" value="1" />部门公开 &nbsp; &nbsp;<input type="radio" <% if( oldispublic=="2") Response.Write("checked"); %> name="ispublic" value="2" />全局公开 
               
               </td>
                
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
