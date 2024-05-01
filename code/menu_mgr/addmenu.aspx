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


        string sqls = "select * from tbsystem order by orderbyparent asc,orderbysencond asc";
        DataTable menutable = new DataTable();
        menutable = db.GetTable(sqls, null);


        //分页页面显示
        contentstring = "";
        total = menutable.Rows.Count;
        pagesize = 10;  //每页显示
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
        int showcount;
        if (nowpage * pagesize < menutable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = menutable.Rows.Count;

        string url;
        StringBuilder sb = new StringBuilder();

        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + menutable.Rows[i]["parentvalue"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+ Link.url("/menu_mgr/","menu_order.aspx", menutable.Rows[i]["id"].ToString(),"","","","") + "\">沉于最底</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + menutable.Rows[i]["sencondvalue"].ToString() + "</font></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/menu_mgr/","menu_order2.aspx", menutable.Rows[i]["id"].ToString(),"","","","") + "\">沉于最底</a></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" >" + menutable.Rows[i]["variable"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/menu_mgr/","menu_edit.aspx", Server.UrlEncode(menutable.Rows[i]["id"].ToString()),"","","","") + "\">编辑</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + menutable.Rows[i]["sencondvalue"].ToString() + "\"/></td>\n");
            sb.Append("</tr>\n");


            id++;

        }

        contentstring = sb.ToString();





        string action = Request.QueryString["param2"];
        if (action == "add")
        {
            Addmenu(db);
        }   //  add
        else
        {
            if (action == "delmuti")
            {
                DeleteMenu(db);
            }
        }


        db.closedb();

    }




    /// <summary>
    /// //////////添加菜单
    /// </summary>
    /// <param name="db"></param>
    protected void Addmenu(DBClass db)
    {
        string parentvalue = Request.Form.Get("parentvalue").ToString().Trim();
        string sencondvalue = Request.Form.Get("sencondvalue").ToString().Trim();
        string linkurl = Request.Form.Get("linkurl").ToString().Trim();

        OdbcParameter pp =  new OdbcParameter("@parentvalue",OdbcType.VarChar);
        pp.Value = sencondvalue;

        string sqlcheck = "select * from tbsystem where sencondvalue=?";
        DataTable dt = new DataTable();
        dt = db.GetTable(sqlcheck, pp);

        if (dt.Rows.Count >0)
        {
          
			   db.closedb();
			Fun.goback("","已经有此菜单了,请换一个二级菜单名！","返回");
            Response.End();
        }
        else
        {

            //添加菜单
            OdbcParameter[] OdbcParameter2 = {
                      new OdbcParameter("@variable",OdbcType.VarChar),   
                      new OdbcParameter("@sencondvalue",OdbcType.VarChar),
                       new OdbcParameter("@orderbysencond",OdbcType.DateTime),
                       new OdbcParameter("@parentvalue",OdbcType.VarChar),
                      new OdbcParameter("orderbyparent",OdbcType.DateTime)
              
                      };
            OdbcParameter2[0].Value = linkurl;
            OdbcParameter2[1].Value = sencondvalue;
            OdbcParameter2[2].Value = System.DateTime.Now.ToString();
            OdbcParameter2[3].Value = parentvalue;

            OdbcParameter checkparam = new OdbcParameter("@parentvalue", OdbcType.VarChar);
            checkparam.Value = parentvalue;
            sqlcheck = "select * from tbsystem where parentvalue=?";
            DataTable tbcheck2 = new DataTable();
            tbcheck2 = db.GetTable(sqlcheck, checkparam);
            if (tbcheck2.Rows.Count > 0)
            {
                OdbcParameter2[4].Value = tbcheck2.Rows[0]["orderbyparent"].ToString();
            }
            else
            {
                OdbcParameter2[4].Value = System.DateTime.Now.ToString();
            }

            string sql = "insert into tbsystem (variable,sencondvalue,orderbysencond,parentvalue,orderbyparent) values(?,?,?,?,?)";
            
            db.ExecuteNonQuery(sql, OdbcParameter2);


            //添加更新popedom 表
            string sqluser = "select * from tbuser";
            DataTable usertable = new DataTable();
            usertable = db.GetTable(sqluser, null);

            OdbcParameter[] OdbcParameter3 = {
                          new OdbcParameter("@userno",OdbcType.VarChar),   
                          new OdbcParameter("@variable",OdbcType.VarChar),
                           new OdbcParameter("@popedom",OdbcType.Int)
                              };
            for (int i = 0; i < usertable.Rows.Count; i++)
            {
                OdbcParameter3[0].Value = usertable.Rows[i]["UserNo"].ToString();
                OdbcParameter3[1].Value = sencondvalue;
                OdbcParameter3[2].Value = 0;
                sql = "insert into popedom (userno,variable,popedom) values(?,?,?)";
                db.ExecuteNonQuery(sql, OdbcParameter3);

            }
            //添加更新 popedomgroup
            string sqlgroup = "select distinct groupname,createdate from  popedomgroup";
            DataTable grouptable = new DataTable();
            grouptable = db.GetTable(sqlgroup, null);

            OdbcParameter[] OdbcParameter4 = {
                          new OdbcParameter("@groupname",OdbcType.VarChar),   
                          new OdbcParameter("@variable",OdbcType.VarChar),
                           new OdbcParameter("@popedom",OdbcType.Int),
                          new OdbcParameter("@createdate",OdbcType.DateTime)
                          
                              };
            for (int i = 0; i < grouptable.Rows.Count; i++)
            {
                OdbcParameter4[0].Value = grouptable.Rows[i]["groupname"].ToString();
                OdbcParameter4[1].Value = sencondvalue;
                OdbcParameter4[2].Value = 0;
                OdbcParameter4[3].Value = grouptable.Rows[i]["createdate"].ToString();
                sql = "insert into popedomgroup(groupname,variable,popedom,createdate) values(?,?,?,?)";
                db.ExecuteNonQuery(sql, OdbcParameter4);

            }


        }
       db.closedb();
      Fun.alert("","添加成功",Link.url("/menu_mgr/", "addmenu.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }




    /// <summary>
    /// ///////////删除菜单
    /// </summary>
    /// <param name="db"></param>
    protected void DeleteMenu(DBClass db)
    {
        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {
            db.closedb();
			Fun.goback("","没有选择任何记录！","返回");
            
        }
        else
        {
            string[] sign ={ "," };
            string[] delusers = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);
            string delsql = "delete from tbsystem where sencondvalue in('";
            string delpopedomsql = "delete from popedom where variable in('";
            string delpopedomgroupsql = "delete from popedomgroup where variable in('";


            foreach (string u in delusers)
            {
                delsql += u + "','";
                delpopedomsql += u + "','";
                delpopedomgroupsql += u + "','";


            }
            delsql += "')";
            delpopedomsql += "')";
            delpopedomgroupsql += "')";

            db.ExecuteNonQuery(delsql, null);
            db.ExecuteNonQuery(delpopedomsql, null);
            db.ExecuteNonQuery(delpopedomgroupsql, null);

            db.closedb();
              Fun.alert("","删除成功",Link.url("/menu_mgr/", "addmenu.aspx", "", "", "", "", ""),"返回");
            Response.End();

        }
    }


</script>

<html>
<head runat="server">
    <title>无标题页</title>
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
   if(document.form1.parentvalue.value==""){window.alert("大类菜单名不能为空");document.form1.parentvalue.focus();return (false);}
   if(document.form1.sencondvalue.value==""){window.alert("二级菜单不能为空");document.form1.sencondvalue.focus();return (false);}
     if(document.form1.linkurl.value==""){window.alert("链接地址不能为空");document.form1.linkurl.focus();return (false);}
      }

function ConfirmDel()
{
   if(confirm("确定要删除此菜单吗？"))
     return true;
   else
     return false;
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
<myhead:myhead ID="head1" runat="server" />
   <div>
    <form name="form1" method="post" action="<%= Link.url("/menu_mgr/","addmenu.aspx","","add","","","")%>" onsubmit ="return form_check();">
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
            <tr>
                <td height="32" class="small" style="width: 50px">
                    <td width="100" nowrap class=small><table>
                        <tr>
                          <td> <b><font color="#ffffff">栏目管理</font></b></td>
                        </tr>
                    </table></td>
                    <td class="small" nowrap>
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                <td class="small">
                    大类菜单：</td>
                <td>
                <input type="text" name="parentvalue" style="width: 100px" /></td>
                
          
          
                <td class="small">
                    小类菜单：</td>
                <td style="width: 134px">
                <input type="text"  style="width: 100px" name="sencondvalue" /></td>
                
            
            
                <td class="small">链接地址：
                </td>
                <td>  <input type="text" name="linkurl"  style="width: 150px" />
                </td>
                <td style="width: 42px"><input type="submit" value="添加" style="width: 61px" /></td>
             </tr>
        </table>
                </td>
            </tr>
        </table>
 </form>
 
 </div>
  <form action="<%= Link.url("/menu_mgr/","addmenu.aspx","","delmuti","","","")%>" method="post" name="selform" >
<div id="Div1">
  <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
    <tr class="lvtCol">
			<td height="30" align="center"> 序号</td>
            <td align="center" >
                主菜单</td>
			<td width="12%" align="center"  >
                主菜单排序</td>
			<td align="center" >
                二级菜单</td>
			<td width="10%" align="center"  >
                二级菜单排序</td>
			<td align="center" >
                链接地址</td>
			
			<td align="center" >
			编 辑</td>

             <td align="center">
            删除</td>
            
          </tr>
          
          <%=contentstring %>
          
           <tr><td align="right" colspan="10" height="22" class="but1">
      
      
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
         <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
        
          <td>&nbsp;</td>
          <td align="right"> 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%= Link.url("/menu_mgr/","addmenu.aspx","1","","","","") %>">首页</a> <a href="<%= Link.url("/menu_mgr/","addmenu.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/menu_mgr/","addmenu.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a> <a href="<%= Link.url("/menu_mgr/","addmenu.aspx",maxpage.ToString(),"","","","") %>">尾页</a> 
                                </td>
          <td align="right">
          <input onClick="{if(confirm('此操作将删除该菜单吗！\n\n确定要执行此项操作吗？')){document.selform.submit();return true;}return false;}" type="submit" value="删除" name="action2" style="width: 55px">
          <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()">
选择/反选  </td>
        </tr>
      </table>
           </td>
           </tr> 
          </table>
 </div>
</form>
<myfoot:myfoot ID="foot1" runat="server" /> 
</body>
</html>
