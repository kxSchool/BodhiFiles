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
        DataTable popedomgrouptable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            sqls = "select min(id) as idd,groupname,min(createdate) as createdate2 from popedomgroup group by groupname  order by min(createdate) desc";
            popedomgrouptable = db.GetTable(sqls, null);
        }
        else
        {
            if (Request.QueryString["param2"] == "addgroup")
            {  // 添加组功能  popedomgroup  

                AddPopedomGroup(db);

            }

            else
            {   //删除功能  action="del"  删除组后 要将tbuser 的权限组名置空 权限保留      // ok

                DeleteGroup(db);

            }
        }



        //分页页面显示
        contentstring = "";
        total = int.Parse(popedomgrouptable.Rows.Count.ToString()); pagesize = 10;  //每页显示
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
        if (nowpage * pagesize < popedomgrouptable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = popedomgrouptable.Rows.Count;


        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {

            contentstring = contentstring + " <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">" +
    "<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n" +
    "<td height=\"24\" align=\"center\" >" + popedomgrouptable.Rows[i]["groupname"].ToString() + "</td>\n" +
      "<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/popedom_mgr/", "popedom_editinfo.aspx", popedomgrouptable.Rows[i]["idd"].ToString(),"","","","")  +"\">编辑</a></td>\n" +
     "<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/popedom_mgr/","popedom_set.aspx",popedomgrouptable.Rows[i]["idd"].ToString(),"","","","") +"\">设置</a></td>\n" +
     "<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + popedomgrouptable.Rows[i]["groupname"].ToString() + "\"/></td>\n" + "</tr>\n";

            id++;
        }

        db.closedb();
    }



    /// <summary>
    /// ///////////////添加权限组
    /// </summary>
    /// <param name="db"></param>
    protected void AddPopedomGroup(DBClass db)
    {

        //检测不能有同名  
        string checksql = "select * from popedomgroup where groupname=?";
        OdbcParameter checkparam=new OdbcParameter("newgroupname",OdbcType.VarChar);
           checkparam.Value=Request.Form.Get("groupname").ToString().Trim();
           int checkresult = db.GetTable(checksql, checkparam).Rows.Count;
           if (checkresult > 0)
           {
               db.closedb();
            Fun.goback("","对不起，此组已经存在！","返回");
               Response.End();
           }

        string selectsql = "select distinct sencondvalue from tbsystem";
        DataTable menutable = db.GetTable(selectsql, null);
        OdbcParameter[] param ={ 
            new OdbcParameter("@groupname", OdbcType.VarChar),
            new OdbcParameter("@variable", OdbcType.VarChar),
            new OdbcParameter("@createdate",OdbcType.DateTime)
        };
        for (int menui = 0; menui < menutable.Rows.Count; menui++)
        {
            string groupname = Request.Form.Get("groupname").ToString().Trim();
            param[0].Value = groupname;
            param[1].Value = menutable.Rows[menui]["sencondvalue"].ToString();
            param[2].Value = DateTime.Now.ToString();
            string insertsql = "insert into popedomgroup ( groupname,variable,createdate) values( ?,?,?)";
            db.ExecuteNonQuery(insertsql, param);
        }
        db.closedb();
         Fun.alert("","添加成功",Link.url("/popedom_mgr/", "popedom_group.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }




    /// <summary>
    /// ///////////删除权限组
    /// </summary>
    /// <param name="db"></param>
    protected void DeleteGroup(DBClass db)
    {
      
        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {
            db.closedb();
          Fun.goback("","没有选择任何记录！","返回");
            Response.End();
        }
        else
        {
            string[] sign ={ "," };
            string[] delusers = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);
            string deletesql = "delete from popedomgroup where groupname in('";
            foreach (string u in delusers)
            {
                deletesql += u + "','";

            }
            deletesql += "')";
            db.ExecuteNonQuery(deletesql, null);


            //2 . tbuser 
            string update_popedomgroup = "update tbuser set popedomgroup='' where tbuser.popedomgroup in('";
            foreach (string u in delusers)
            {
                update_popedomgroup += u + "','";

            }
            update_popedomgroup += "')";
            db.ExecuteNonQuery(update_popedomgroup, null);

            db.closedb();
            Fun.alert("","删除成功",Link.url("/popedom_mgr/", "popedom_group.aspx", "", "", "", "", ""),"返回");
            Response.End();



        }
    
    }

</script>

<html>
<head runat="server">
    <title>权限组管理</title>
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
   if(document.form1.groupname.value==""){window.alert("组名不能为空！");document.form1.groupname.focus();return (false);}
 
      }

function ConfirmDel()
{
   if(confirm("确定要删除此权限组吗？"))
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<myhead:myhead ID="head1" runat="server" />
   <div>
    <form name="form1" method="post" action="<%= Link.url("/popedom_mgr/","popedom_group.aspx","","addgroup","","","")%>" onsubmit ="return form_check();">
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
            <tr>              <td width="50" height="32" nowrap class="small">&nbsp;
				    </td>
            <td width="100" nowrap class=small><table>
                  <tr>
                    <td> <b><font color="#ffffff">权限管理</font></b></td>
                  </tr>
              </table></td>
              <td height="2"><table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="32" class=small> 组名称：
                    <input type="text" size="20" name="groupname" />
                    <input name="submit" type="submit" value="添加" />
                </td>
              </tr>
            </table>            </tr>
        </table>
 </form>
 
 </div>

    <form action="<%= Link.url("/popedom_mgr/","popedom_group.aspx","","del","","","")%>" method="post" name="selform" >
<div id="Div1">
  <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
    <tr class="lvtCol">
                             <td height="30" align="center" > 序号</td>
                             <td align="center"> 权限组名称</td>
                             <td align="center"> 编辑名称</td>
                             <td align="center"> 可访问菜单设定</td>
                             <td align="center"> 删 除</td>
                           </tr>
                           <%=contentstring %>
                           <tr bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
                             <td align="center" colspan="10" class="but1" > 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%= Link.url("/popedom_mgr/","popedom_group.aspx","1","","","","") %>">首页</a> <a href="<%= Link.url("/popedom_mgr/","popedom_group.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/popedom_mgr/","popedom_group.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a> <a href="<%= Link.url("/popedom_mgr/","popedom_group.aspx",maxpage.ToString(),"","","","") %>">尾页</a> &nbsp;&nbsp;&nbsp;&nbsp;
                                 <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()">
                      选择/反选
                      <input onClick="{if(confirm('此操作将删除该组吗！\n\n确定要执行此项操作吗？')){document.selform.submit();return true;}return false;}" type="submit" value="删除" name="action2">
                             </td>
                           </tr>
                </table>
 </div>
</form>
 
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
