<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">
    protected string contentstring,sqls,sid;
    protected string groupname;

    protected void Page_Load(object sender, EventArgs e)
    {

        DBClass db = new DBClass();


        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {            // 显示某组的权限
            ShowPopedom(db);

        }

        else
        {
            //修改某权限组的权限  涉及 popedomgroup  popedom中属于该组的用户的权限
            if (Request.QueryString["param2"] == "set")
            {
                SetPopedomSave(db);

            }

        }


        db.closedb();

    } //page_load



    /// <summary>
    /// ////////// 显示某权限组的权限
    /// </summary>
    /// <param name="db"></param>
    protected void ShowPopedom(DBClass db)
    {

        int i_br = 0;

        if (Request.QueryString["param1"] != null && Request.QueryString["param1"] != "")
		
		sid = Request.QueryString["param1"].ToString();
        DataTable popedomgrouptable = new DataTable();
		sqls = "select * from popedomgroup where id=" + sid;
        popedomgrouptable = db.GetTable(sqls, null);
		groupname=popedomgrouptable.Rows[0]["groupname"].ToString();
		db.closedb();

		string sql="select popedomgroup.groupname,popedomgroup.variable,popedomgroup.popedom,tbsystem.parentvalue,tbsystem.orderbyparent,tbsystem.sencondvalue,tbsystem.orderbysencond from  popedomgroup left join tbsystem on popedomgroup.variable=tbsystem.sencondvalue  where popedomgroup.groupname='"+groupname+"' order by tbsystem.orderbyparent asc,tbsystem.orderbysencond asc";
        DataTable menutable = new DataTable();
        menutable = db.GetTable(sql, null);
        contentstring = "";
        string bigclass = menutable.Rows[0]["parentvalue"].ToString();

        contentstring += "<tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\"> <td align=\"center\">" + menutable.Rows[0]["parentvalue"].ToString() + "</td>\n<td align=\"left\">";// 大类
        contentstring += menutable.Rows[0]["variable"].ToString() + "<input type=\"checkbox\" onclick=\"cca(this)\""; //小类
        if (menutable.Rows[0]["popedom"].ToString() == "1")
        {
            contentstring += " checked=\"checked\" ";
        }
        contentstring += " name=\"sel\" id=\"sel\" value=\"" + menutable.Rows[0]["variable"].ToString() + "\" />\n";
        i_br++;

        for (int i = 1; i < menutable.Rows.Count; i++)
        {

            if (menutable.Rows[i]["parentvalue"].ToString() == bigclass)
            {
                i_br++;
                contentstring += "&nbsp;" + menutable.Rows[i]["variable"].ToString() + "<input type=\"checkbox\" onclick=\"cca(this)\"";
                if (menutable.Rows[i]["popedom"].ToString() == "1")
                {
                    contentstring += " checked=\"checked\" ";
                }
                contentstring += " name=\"sel\" id=\"sel\" value=\"" + menutable.Rows[i]["variable"].ToString() + "\" />\n";
                if (i_br > 5)
                {

                    contentstring += "<br>";
                    i_br = 0;
                }


                if (i == menutable.Rows.Count - 1)
                    contentstring += "</td>\n</tr>\n";
            }
            else
            {
                i_br = 0;
                contentstring += "</td>\n</tr>\n"; //二级结束 关闭行 取下一大类 
                bigclass = menutable.Rows[i]["parentvalue"].ToString();
                contentstring += "<tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\"> <td align=\"center\">" + menutable.Rows[i]["parentvalue"].ToString() + "</td>\n<td align=\"left\">";// 大类
                contentstring += "&nbsp;" + menutable.Rows[i]["variable"].ToString() + "<input type=\"checkbox\" onclick=\"cca(this)\""; //小类
                if (menutable.Rows[i]["popedom"].ToString() == "1")
                {
                    contentstring += " checked=\"checked\" ";
                }
                contentstring += " name=\"sel\" id=\"sel\" value=\"" + menutable.Rows[i]["variable"].ToString() + "\" />\n";
                i_br++;
            }


        }

    }







    protected void SetPopedomSave(DBClass db)
    {


        //  1. 清空选定组权限  
        string updatesql_clear = "update popedomgroup set popedom=0 where groupname=?";
        OdbcParameter param = new OdbcParameter("@groupname", OdbcType.VarChar, 100);
        param.Value = Request.Form.Get("updategroupname").ToString();
        db.ExecuteNonQuery(updatesql_clear, param);

        // 2. 重置组的权限
        string updatesql = "update popedomgroup set popedom=1 where groupname=? and variable in('";

        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {

        }
        else
        {

            string[] sign ={ "," };
            string[] menus = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);
            foreach (string m in menus)
            {
                updatesql += m + "','";

            }
            updatesql += "')";
            db.ExecuteNonQuery(updatesql, param);

        }

        // 3. 清空该组的用户的所有权限  popedom 
        //clear
        string clearsql_popedom = "update popedom set popedom=0  where popedom.userno in (select t.userno from tbuser t where t.popedomgroup=?)";
        OdbcParameter popedom_param1 = new OdbcParameter("@popedomgroup", OdbcType.VarChar, 50);
        popedom_param1.Value = Request.Form.Get("updategroupname").ToString();
        db.ExecuteNonQuery(clearsql_popedom, popedom_param1);

        //  4. 重置用户的所有权限 

        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {

        }
        else
        {


            string upsql_popedom = "update popedom set popedom=1  where variable in('";
            string[] sign ={ "," };
            string[] menus = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);
            foreach (string m in menus)
            {
                upsql_popedom += m + "','";

            }
            upsql_popedom += "')";
            upsql_popedom += "and popedom.userno in (select t.userno from tbuser t where t.popedomgroup=?)";
            db.ExecuteNonQuery(upsql_popedom, popedom_param1);
        }

        db.closedb();

      Fun.alert("","操作菜单设置成功",Link.url("/popedom_mgr/", "popedom_group.aspx", "", "", "", "", ""),"返回");
        Response.End();

    }




</script>


<html>
<head runat="server">
    <title>组权限设定</title>
        <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

#hanxin{
 margin: 0 auto;

text-align;center;
}
</style>
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

</script>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<myhead:myhead ID="head1" runat="server" />
 <div>
 
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
            <tr>
                <td height="32" class="small" style="width: 50px">&nbsp;</td>
                    <td height="32" class=small> <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="32" class=small>
                               <b><font color="red">
                                                 <%=groupname %><input type="hidden" name="nowgroup" value="<%=groupname %>" />
                                             </font></b><b><font color="#ffffff">组权限设置</font></b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

 
 </div>
    <div>
        <form action="<%= Link.url("/popedom_mgr/","popedom_set.aspx","","set","","","")%>" method="post" name="selform">
          
                <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
                    <tr class="lvtCol">
                        <td height="30" align="center">
                            一级菜单</td>
                        <td align="center">
                            二级菜单</td>
                    </tr>
                    <%= contentstring %>
                 
                 
                    <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
                        <td colspan="2" align="right">
                            <input type="hidden" value="<%= groupname %>" name="updategroupname" />
                            <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()">
                            选择/反选&nbsp;
                            <input type="submit" name="save" value="保存" style="width: 67px" />
                            <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />
                        </td>
                    </tr>
                </table>
        </form>
    </div>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
