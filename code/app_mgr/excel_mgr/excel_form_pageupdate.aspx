<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>



<script runat="server">

    protected StringBuilder sb = new StringBuilder();
    protected int cols;
	protected string sqls,sid,stxt;

    protected string excelurl = "";
    protected string title = "";
    protected bool isedit = false;
	public string contentstring = "",strConn ="";
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
	public int listfeild;

    protected void Page_Load(object sender, EventArgs e)
    {

	

            if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "")
            {
				  Fun.alert("","参数错误！",Link.url("/app_mgr/excel_mgr/","excel_list.aspx","","","","","") ,"返回");
                Response.End();
            }
            else
            {
			sid = Request.QueryString["param1"].ToString();
			DBClass db = new DBClass();
        DataTable popedomgrouptable = new DataTable();
		sqls = "SELECT id, filetitle, fileurl, description FROM tbexcel where id=" + sid;
        popedomgrouptable = db.GetTable(sqls, null);
		excelurl = popedomgrouptable.Rows[0]["fileurl"].ToString();
        title =Server.UrlDecode( popedomgrouptable.Rows[0]["filetitle"].ToString());
		stxt =Server.UrlDecode( popedomgrouptable.Rows[0]["description"].ToString());
		db.closedb();
                
            }


            strConn = "Provider=Microsoft.Jet.Oledb.4.0;Data Source=" + ConfigurationSettings.AppSettings["excel_center"].ToString() + excelurl + ";Extended Properties=Excel 8.0";
            OleDbConnection conn = new OleDbConnection(strConn);
			 if (Request.QueryString["param3"] == null || Request.QueryString["param3"] == "")
			 {
			
            OleDbDataAdapter adp = new OleDbDataAdapter("Select * from [Sheet1$] where 识别码 like '" +  Session["username"].ToString() + "%'", conn);
            DataTable dt = new DataTable();
            adp.Fill(dt);
			total = int.Parse(dt.Rows.Count.ToString()); pagesize = 10;  //每页显示
        maxpage = total / pagesize;
        if (total % pagesize > 0)
        {
            maxpage++;
        }
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "" || Convert.ToInt32(Request.QueryString["param2"]) < 1)
        {
            nowpage = 1;
        }
        else
        {
            nowpage = Convert.ToInt32(Request.QueryString["param2"].ToString());
        }
		if (Request.QueryString["param2"] !=null & Request.QueryString["param2"]!="")
		{
        if (Request.QueryString["param2"] !=null & Request.QueryString["param2"]!="")
		{
        if (Convert.ToInt32(Request.QueryString["param2"]) > maxpage)    //防止太大
            nowpage = maxpage;
			}
			else
			{nowpage=1;}
			}
			else
			{nowpage=1;}
        if (nowpage <= 0)
            nowpage = 1;  //没有这一句当记录为空是点下一页出错
        int id = (nowpage - 1) * pagesize + 1;
        int showcount;
        if (nowpage * pagesize < dt.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = dt.Rows.Count;
			cols = dt.Columns.Count;
         if (dt.Columns.Count > 1)
			{ 
            
                sb.Append("<tr class=\"lvtCol\"><td align=\"center\" style=\"height: 18px;\"><input type=\"checkbox\" name=\"checkbox\" value=\"checkbox\" onClick=\"javascript:SelectAll()\"></td>");
               if (dt.Columns.Count > 5) {listfeild=5;}
			    for (int i = 1; i < listfeild; i++)
                {
                    sb.Append("<td align=\"center\" style=\"height: 30px;\"> ");
                    sb.Append(dt.Columns[i].Caption.ToString());
                    sb.Append("</td>");

                }
				sb.Append("</tr>\n");

        for (int ix = (nowpage - 1) * pagesize; ix < showcount; ix++)
        {
            
                string cap=dt.Rows[ix][0].ToString();
				cap=cap.Substring(8 > cap.Length ? 0 : cap.Length - 8);
				sb.Append("<tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\"><td align=\"center\" style=\"height: 18px;\"><input name=\"sel\" id=\"sel\" type=\"checkbox\" value=\"" + cap + "\" onclick=\"cca(this)\"/></td>");
				if (dt.Columns.Count > 5) {listfeild=5;}
			    for (int i = 1; i < listfeild; i++)
                {cap=dt.Rows[ix][i].ToString();
                    sb.Append("<td align=\"center\" style=\"height: 24px;\"> ");
                    sb.Append(cap);
                    sb.Append("</td>");

                }
				sb.Append("</tr>\n");

            
				
            }
			}
			}
			else
			{
			if (Request.QueryString["param3"].ToString() == "delete")
            {
                string actiontype = "";
                if (Request.Form.Get("actiontype") != null)
                    actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别
					
                    if (actiontype == "delete")
                    {
					//Response.Write(Request.QueryString["param1"]);
					//Response.Write( Request.Form.Get("sel").ToString());
	                // Response.End();
					 if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                {
                 
					  Fun.alert("","请先选择表格中删除的行！",Link.url("/app_mgr/excel_mgr/","excel_list.aspx","","","","","") ,"返回");
                    Response.End();

                }
			OleDbDataAdapter adp = new OleDbDataAdapter("Select * from [Sheet1$] where right(识别码,8) in (" + Request.Form.Get("sel").ToString() + ") and 识别码 like '" +  Session["username"].ToString() + "%'", conn);
            DataTable dt = new DataTable();
            adp.Fill(dt);
			//Response.Write( dt.Rows[0][0].ToString());
			int colscount = Convert.ToInt32(dt.Columns.Count);

                    StringBuilder insertsb = new StringBuilder();
                    insertsb.Append("update ");
                    insertsb.Append("[Sheet1$]  set ");


                    for (int ii = 0; ii < colscount; ii++)
                    {
                        if (ii < (colscount - 1))
                            insertsb.Append(dt.Columns[ii].Caption.ToString() + "='',");
                        else
                            insertsb.Append(dt.Columns[ii].Caption.ToString() + "=''");
                    }
					insertsb.Append(" where right(识别码,8) in (" + Request.Form.Get("sel").ToString() + ") and 识别码 like '" +  Session["username"].ToString() + "%'");
					//Response.Write(insertsb.ToString());
					//Response.End();
                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand(insertsb.ToString(), conn);
                
                   
              
                    cmd.ExecuteNonQuery();

            
                    }
            }//save
			}
			contentstring = sb.ToString();
            conn.Close();
        }







    
   protected void DeleteData(DBClass db)
    {
	//Response.Write(Request.QueryString["param1"]);
	Response.End();

	} 

</script>

<html>

<head>

<link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

 BODY {
	FONT-SIZE: 9pt
}

</style>
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

function deletedata() {
try {
if(confirm('此操作将该表中所选行数据删除！\n\n确定要执行此项操作吗？')){
document.getElementById('actiontype').value='delete';
document.selform.action='<%= Link.url("/app_mgr/excel_mgr/","excel_form_pageupdate.aspx",Request.QueryString["param1"],"","delete","","") %>';
document.selform.submit();
return true;
}
return false;
}
catch (e) {}
}





</script>

</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
<div>
  <TABLE width=100% border=0 align="center" cellpadding=0 cellspacing=0 class="hdrTabBg">
    <tr>
      <td height="32" class=small style="width:50px">&nbsp;</td>
      <td nowrap class=small style="width: 100px"><table>
          <tr>
            <td> <b><font color="#ffffff">在线填报</font></b></td>
          </tr>
      </table></td>
      <td align="center" nowrap class=small>&nbsp; </td>
    </tr>
  </TABLE>
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td align="left"><a onClick="deletedata();" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" /></a>&nbsp; </td>
    </tr>
  </table>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1"  class="lvt small">
    <form action="<%= Link.url("/app_mgr/excel_mgr/","excel_form_pageupdate.aspx",Request.QueryString["param1"],"set","","","") %>" method="post" name="selform" >
     
      <%=contentstring %>
      <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
        <td align="center" colspan="11" height="35" class="but1" style="width: 100%;">
          <table width="211" border="0" align="left" cellpadding="0" cellspacing="0">
            <tr>
              <td width="160" align="right"> </td>
              <td width="140" align="center"> </td>
            </tr>
          </table><input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
          共 <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/ <%=maxpage%> 页，每页 <%=pagesize%> 个&nbsp; <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_form_pageupdate.aspx",Request.QueryString["param1"],"1","","","") %>"> 首页</a> <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_form_pageupdate.aspx",Request.QueryString["param1"],(nowpage-1).ToString(),"","","") %>"> 上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/excel_mgr/","excel_form_pageupdate.aspx",Request.QueryString["param1"],(nowpage+1).ToString(),"","","") %>">下一页</a>&nbsp; <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_form_pageupdate.aspx",Request.QueryString["param1"],maxpage.ToString(),"","","") %>"> 尾页</a></td>
      </tr>
    </form>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td> <myfoot:myfoot ID="foot1" runat="server" /></td>
    </tr>
  </table>
  <br>
</div>

</body>
</html>
