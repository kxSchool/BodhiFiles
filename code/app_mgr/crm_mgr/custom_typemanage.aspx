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
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();


        string sqls;
        DataTable typetable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            sqls = "select * from tbcustomtype  order by createtime desc";
            typetable = db.GetTable(sqls, null);
        }
        else
        {
            if (Request.QueryString["param2"] == "add")
            {

                AddNewsType(db);

            }
            if (Request.QueryString["param2"] == "del")
            {

                DeleteNewsType(db);
            }


        }



        //分页页面显示
        contentstring = "";
        total = int.Parse(typetable.Rows.Count.ToString()); pagesize = 10;  //每页显示
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
            nowpage = 1;

        int id = (nowpage - 1) * pagesize + 1;
        int showcount;
        if (nowpage * pagesize < typetable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = typetable.Rows.Count;

        StringBuilder sb = new StringBuilder();
        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + typetable.Rows[i]["typename"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/crm_mgr/","custom_typesort.aspx",typetable.Rows[i]["id"].ToString(),"","","","") + "\">置顶 </a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/crm_mgr/","custom_typeedit.aspx",typetable.Rows[i]["id"].ToString(),"","","","") + "\">编辑</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + typetable.Rows[i]["id"].ToString() + "\"/></td>\n" + "</tr>\n");

            id++;
        }
        contentstring = sb.ToString();
        db.closedb();
    }



    /// <summary>
    /// ///////////////添加类别
    /// </summary>
    /// <param name="db"></param>
    protected void AddNewsType(DBClass db)
    {

        //检测不能有同名  
        string checksql = "select * from tbcustomtype where typename= ?";
        OdbcParameter checkparam = new OdbcParameter("newname", OdbcType.VarChar, 100);
        checkparam.Value = Request.Form.Get("typename").ToString().Trim();
        int checkresult = db.GetTable(checksql, checkparam).Rows.Count;
        if (checkresult > 0)
        {
          
			db.closedb();
			 Fun.goback("","对不起，此类别已存在！","返回");
            Response.End();
        }

        OdbcParameter[] param ={ 
            new OdbcParameter("@typename", OdbcType.VarChar, 50),
            new OdbcParameter("@createtime",OdbcType.DateTime)
          };
        param[0].Value = Request.Form.Get("typename").ToString().Trim();
        param[1].Value = DateTime.Now.ToString();
        string insertsql = "insert into tbcustomtype(typename,createtime)values(?,?)";
        db.ExecuteNonQuery(insertsql, param);
        db.closedb();
        Response.Redirect( Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx","","","","",""));
        Response.End();
    }




    /// <summary>
    /// ///////////删除
    /// </summary>
    /// <param name="db"></param>
    protected void DeleteNewsType(DBClass db)
    {

        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {
		   db.closedb();
      
			 Fun.goback("","请先选择记录","返回");
            Response.End();
        }
        else
        {

            string deletesql = "delete from tbcustomtype where id in(" + Request.Form.Get("sel").ToString() + ")";
            db.ExecuteNonQuery(deletesql, null);


            //2 . tbnews
            string update_dept = "update tbnews set type_id=0 where tbnews.type_id in(" + Request.Form.Get("sel").ToString() + ")";
            db.ExecuteNonQuery(update_dept, null);
            db.closedb();
            Response.Redirect(Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx","","","","",""));
            Response.End();



        }

    }
</script>
<html>
<head id="Head1" runat="server">
    <title>资料类别</title>
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
   if(document.form1.typename.value==""){window.alert("类别名不能为空！");document.form1.typename.focus();return (false);}
 
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
    <form name="form1" method="post" action="<%=Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx","","add","","","") %>" onsubmit ="return form_check();">
        
            <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">类别管理</font></b></td>
        </tr>
    </table></td>
    <td class=small nowrap><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" valign="middle" class="small" style="height: 16px;">
                             类别名称：&nbsp;
            <input type="text" name="typename" style="width: 193px; height: 20px;" /><input type="submit" value="添加类别" style="width: 83px; height: 22px" />
          </td>
        </tr>
    </table> </td>
  </tr>
 
</TABLE>
        
 </form>
 
 
 </div>

 
 
 
 
<div id="hanxin">
   <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0" bordercolor="#0055E6">
<tr>
<td style="height: 103px" >
   
 			<form action="<%=Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx","","del","","","") %>" method="post" name="selform" >
 			
      <table width="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#0055E6"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
          <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
            <td align="center">
                类 别 名 称</td>
               <td align="center">
               类别排序 </td>   
             <td align="center"  >
                编辑类别</td>
		
			
		
            <td align="center">
            删 除</td>
            
          </tr>
          
            
          <%=contentstring %>
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="10" height="22" class="but1" style="width:100%;">
      
      
      共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%>
       
            页，每页 
          <%=pagesize%> 条 <a href="<%=Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx","1","","","","") %>">首页</a> <a href="<%=Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a> <a href="<%=Link.url("/app_mgr/crm_mgr/","custom_typemanage.aspx",maxpage.ToString(),"","","","") %>">尾页</a> &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"> 选择/反选
              <input onClick="{if(confirm('此操作将删除该类别吗！\n\n确定要执行此项操作吗？')){document.selform.submit();return true;}return false;}" type="submit" value="删除" name="action2" style="width: 67px"> 
           </td></tr> 
          
       </table>       </td>
       </tr>
       </table>
    
 </form>
 
 </td>
</tr>
</table>
 </div>
 
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>

