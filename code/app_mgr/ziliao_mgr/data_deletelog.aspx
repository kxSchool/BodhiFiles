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
    StringBuilder sb = new StringBuilder();


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();


        if (Request.QueryString["param2"] == null || Request.QueryString["param2"]=="")
        {
            ShowPage(db);
        }
        else
        {
            if (Request.QueryString["param2"].ToString() == "realdelete")
            {
                RealDeleteData(db);

            }


        }

        db.closedb();
    }





    /// <summary>
    /// /////////
    /// </summary>
    /// <param name="db"></param>
    protected void ShowPage(DBClass db)
    {
        //页面载入显示
        string sqls;
        DataTable usertable = new DataTable();
        sqls = "select  tbdeldata.*,tbuser.username,tbuser.dept_id,department.deptname from (( tbdeldata left join tbuser on tbdeldata.userno=tbuser.userno ) left join department on tbuser.dept_id=department.id )  order by tbdeldata.deletetime desc";
        usertable = db.GetTable(sqls, null);


        contentstring = "";
        total = usertable.Rows.Count; pagesize = 10;  //每页显示
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
        int showcount;  //显示数
        if (nowpage * pagesize < total)
            showcount = nowpage * pagesize;
        else
            showcount = total;




        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {int indexi = usertable.Rows[i]["fileurl"].ToString().LastIndexOf(".") + 1;
            string newext = usertable.Rows[i]["fileurl"].ToString().Substring(indexi).ToLower();  //得到扩展名
            if (newext != "gif" && newext != "jpg" && newext != "zip" && newext != "mp3" && newext != "png" && newext != "doc"
&& newext != "wmv" && newext != "wma" && newext != "xls" && newext != "rar" && newext != "rm" && newext != "avi" &&
newext != "psd" && newext != "pdf" && newext != "mp4" && newext != "iso" && newext != "exe" && newext != "dwg" &&
newext != "txt" && newext != "aac" && newext != "ace" && newext != "ai" && newext != "ain" && newext != "amr"
 && newext != "app" && newext != "arj" && newext != "asf" && newext != "asp" && newext != "aspx" && newext != "av"
 && newext != "bin" && newext != "bmp" && newext != "cab" && newext != "cad" && newext != "cat" && newext != "cdr"
 && newext != "chm" && newext != "com" && newext != "css" && newext != "cur" && newext != "dat" && newext != "dll"
 && newext != "dmv" && newext != "dps" && newext != "dpt" && newext != "dwg" && newext != "dxf" && newext != "emf"
 && newext != "eps" && newext != "et" && newext != "ett" && newext != "fla" && newext != "folder" && newext != "ftp"
 && newext != "hlp" && newext != "htm" && newext != "html" && newext != "icl" && newext != "ico" && newext != "img"
 && newext != "inf" && newext != "ini" && newext != "jpeg" && newext != "js" && newext != "m3u" && newext != "max"
 && newext != "mdb" && newext != "mde" && newext != "mht" && newext != "mid" && newext != "midi" && newext != "mov"
 && newext != "mpeg" && newext != "mpg" && newext != "msi" && newext != "nrg" && newext != "ocx" && newext != "ogg"
 && newext != "ogm" && newext != "pdf" && newext != "pot" && newext != "ppt" && newext != "psd" && newext != "pub"
 && newext != "qt" && newext != "ra" && newext != "ram" && newext != "rmvb" && newext != "rtf" && newext != "swf"
 && newext != "tar" && newext != "tif" && newext != "tiff" && newext != "url" && newext != "vbs" && newext != "vsd"
 && newext != "vss" && newext != "vst" && newext != "wav" && newext != "wm" && newext != "wave" && newext != "wmd"
 && newext != "wps" && newext != "wpt" && newext != "xls" && newext != "xlt" && newext != "xml" && newext != "zip") { newext = "unknown"; }


            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + usertable.Rows[i]["fileurl"].ToString() + "\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><img src=\"/images/filetype/" + newext + ".gif\"/>&nbsp;" + usertable.Rows[i]["filetitle"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["fileurl"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["username"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["deptname"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" >" + usertable.Rows[i]["deletetime"].ToString() + "</td>");
            sb.Append("<td height=\"24\" align=\"center\" ><a  href=\"" + Link.url("/app_mgr/ziliao_mgr/", "realdeldata_down.aspx", usertable.Rows[i]["id"].ToString(), "", "", "", "") + "\">下载资料</a></td>");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();

    }




    /// <summary>
    /// ////////////
    /// </summary>
    /// <param name="db"></param>

    protected void RealDeleteData(DBClass db)
    {


        if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
        {
           db.closedb();
			Fun.goback("","没有选择任何资料！","返回");
            Response.End();
        }
        else
        {


            if (HttpContext.Current.Request.ServerVariables["LOCAL_ADDR"].ToString() == HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString())
            {



                string[] sign ={ "," };
                string[] delids = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);



                //删除回收站表中的记录

                string deletesql = "delete from tbdeldata where fileurl in('";
                foreach (string u in delids)
                {
                    deletesql += u + "','";

                }
                deletesql += "')";


                db.ExecuteNonQuery(deletesql, null);




                //删除文件


                string realdeletepath;

                FileInfo ff;
                foreach (string u in delids)
                {

                    realdeletepath = ConfigurationSettings.AppSettings["realdelete_center"].ToString() + u.ToString();

                    ff = new FileInfo(realdeletepath);

                    if (ff.Exists)
                        ff.Delete();

                }


                db.closedb();
                Fun.alert("","删除成功" ,Link.url("/app_mgr/ziliao_mgr/", "data_deletelog.aspx", "", "", "", "", ""),"返回");
                Response.End();

            }

        }



    }


</script>
<html>
<head id="Head1" runat="server">
    <title>彻底删除资料日志管理</title>
   
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
    <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td class=small nowrap><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="middle" class="calendarNav" style="height: 16px;">
                              彻底删除资料日志 
          </td>
        </tr>
    </table> </td>
  </tr>
 
</TABLE>

   <table width="100%" border="0" cellpadding="0" cellspacing="0">

         <tr>
         <td align="left" valign="middle"  style="width: 845px; height: 26px">
        <a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a>
		<%
		if (Request.ServerVariables["LOCAL_ADDR"]==Request.ServerVariables["REMOTE_ADDR"])
		{%>
		<a  onclick="{if(confirm('此操作将资料彻底从磁盘删除！\n\n确定要执行此项操作吗？')){document.selform.submit();return true;}return false;}" href="#"><img src="/images/realdelete.jpg" style="border:0;" alt="彻底删除" /></a>
        <%}%>	</td>
     </tr>
 </table>

	<form action="<%= Link.url("/app_mgr/ziliao_mgr/","data_deletelog.aspx","","realdelete","","","")%>" method="post" name="selform" >
   <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
    
    
     <tr class="lvtCol">
        <td height="30" align="center"> 序号</td>
        <td align="center" style="height: 18px;">
                <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()" /></td>
      <td align="center"> 资料名称</td>
      <td align="center"> 文件名</td>
      <td align="center"> 资料所有人</td>
      <td align="center"> 所有人部门</td>
       <td align="center"> 删除时间</td>
        <td align="center"> 下载</td>
     </tr>
     <%=contentstring %>
       
       <tr>
       <td   bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'" align="center" colspan="10" height="22" class="but1" style="width:100%;"> 共 <%=total%> 条，当前第 &nbsp;<font color="red"><%=nowpage%></font>/&nbsp;<%=maxpage%> 页，每页 <%=pagesize%> 条 <a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_deletelog.aspx", "1", "", "", "", "") %>">首页</a> <a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_deletelog.aspx", (nowpage-1).ToString(), "", "", "", "") %>">上一页</a> &nbsp;<a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_deletelog.aspx", (nowpage+1).ToString(), "", "", "", "") %>">下一页</a> <a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_deletelog.aspx", maxpage.ToString(), "", "", "", "") %>">尾页</a></td>
     </tr>
   </table>
 </form>

 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
