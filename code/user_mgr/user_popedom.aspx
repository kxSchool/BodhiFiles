<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">

    protected string contentstring;

    protected string userno;

    protected void Page_Load(object sender, EventArgs e)
    {

        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

            int i_br = 0;
            //显示 该自定义用户的权限
            if (Request.QueryString["param1"] != null && Request.QueryString["param1"] != "")
                userno = Request.QueryString["param1"].ToString();
            OdbcParameter selparam = new OdbcParameter("@userno", OdbcType.VarChar, 20);
            selparam.Value = userno;

            string sql = "select popedom.userno,popedom.variable,popedom.popedom,tbsystem.parentvalue,tbsystem.orderbyparent,tbsystem.sencondvalue,";
            sql += "tbsystem.orderbysencond from popedom left join tbsystem on popedom.variable=tbsystem.sencondvalue where popedom.userno=? order by tbsystem.orderbyparent,tbsystem.orderbysencond";

            DataTable menutable = new DataTable();
            menutable = db.GetTable(sql, selparam);
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

        else
        {
            // 自定义某个用户 权限的设置   tbuser中的popedomgroup 置空  popedom 
            if (Request.QueryString["param2"] == "set")
            {

                string[] sign ={ "," };
                string[] menus = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);

                string updatesql_clear = "update popedom set popedom=0 where userno=?";
                string updatesql = "update popedom set popedom=1 where userno=? and variable in('";

                foreach (string m in menus)
                {
                    updatesql += m + "','";

                }
                updatesql += "')";

                string reset_popedomgroup = "update tbuser set popedomgroup='' where userno=?";

                OdbcParameter param = new OdbcParameter("@userno", OdbcType.VarChar, 100);
                param.Value = Request.Form.Get("userno").ToString();
                db.ExecuteNonQuery(updatesql_clear, param);  //清零
                db.ExecuteNonQuery(updatesql, param);
                db.ExecuteNonQuery(reset_popedomgroup, param);

                db.closedb();
				  Fun.alert("","权限设定成功，该用户已经为自定义权限用户",Link.url("/user_mgr/", "user_manage.aspx", "", "", "", "", ""),"返回");
             
                Response.End();

            }

        }




        db.closedb();

    }

</script>

<html>
<head id="Head1" runat="server">
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

    
</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />

<div>
   
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
            <tr>
                <td height="32" class="small" style="width: 50px">
                    
                </td>
            <td class="small"><table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="32" class=small> <b><font color="red"> <%= userno %> </font></b><b><font color="#ffffff">用户权限设置</font></b> </td>
              </tr>
            </table></td>
            </tr>
        </table>
</div>
<div>
   
 <form action="<%= Link.url("/user_mgr/","user_popedom.aspx","","set","","","")%>" method="post" name="selform">
                <div id="Div1">
             <table width="100%" border="0" cellpadding="1" cellspacing="1" class="lvt small">
                 <tr class="lvtCol">
                                         <td height="30" align="center">
                                             一级菜单</td>
                                         <td align="center">
                                             二级菜单</td>
                                     </tr>
                                  <%= contentstring %>
                 <tr>
                     <td colspan="2" align="right"  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
                         <input type="hidden" value="<%= userno %>" name="userno" />
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
