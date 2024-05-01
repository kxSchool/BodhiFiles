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

        DataTable datatable = new DataTable();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            ShowPage(db);


        }
        else
        {

            if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
            {
                db.closedb();

                Fun.goback("","没有选择任何资","返回");
                Response.End();
            }
            else
            {


                string actiontype = "";
                if (Request.Form.Get("actiontype") != null)
                    actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别

                if (actiontype == "resumedelete")
                {//恢复

                    ResumeDelete(db);
                }


            }

        }





        db.closedb();
    }









    protected void ShowPage(DBClass db)
    {

        string sqls;

        sqls = " select tbdatarecycle.*,tbdatatype.id as typeid,tbdatatype.name as typename from tbdatarecycle left join tbdatatype on  tbdatarecycle.type_id=tbdatatype.id where tbdatarecycle.userno='" + Session["userno"].ToString() + "'  order by tbdatarecycle.uptime desc";

        DataTable datatable = db.GetTable(sqls, null);

        //分页页面显示
        contentstring = "";
        total = int.Parse(datatable.Rows.Count.ToString()); pagesize = 10;  //每页显示
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
        if (nowpage * pagesize < datatable.Rows.Count)
            showcount = nowpage * pagesize;
        else
            showcount = datatable.Rows.Count;

        double allfilesize;
        string strsize;
        StringBuilder sb = new StringBuilder();
        for (int i = (nowpage - 1) * pagesize; i < showcount; i++)
        {
            if (Convert.ToInt64(datatable.Rows[i]["filesizes"].ToString()) > 1024 * 1024)
            {
                allfilesize = Convert.ToDouble(datatable.Rows[i]["filesizes"].ToString()) / (1024 * 1024);
                strsize = allfilesize.ToString("0.0") + "MB";
            }
            else
            {
                allfilesize = Convert.ToDouble(datatable.Rows[i]["filesizes"].ToString()) / 1024;
                strsize = allfilesize.ToString("0.0") + "KB";

            }


            int indexi = datatable.Rows[i]["fileurl"].ToString().LastIndexOf(".") + 1;
            string newext = datatable.Rows[i]["fileurl"].ToString().Substring(indexi).ToLower();  //得到扩展名
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
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["fileurl"].ToString() + "\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" ><img src=\"/images/filetype/" + newext + ".gif\"/>&nbsp;<a  href=\"" + Link.url("/app_mgr/ziliao_mgr/", "deletedata_down.aspx", datatable.Rows[i]["id"].ToString(), "", "", "", "") + "\">" + datatable.Rows[i]["filetitle"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["typename"].ToString() + "&nbsp;</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + strsize + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a  href=\"" + Link.url("/app_mgr/ziliao_mgr/", "deletedata_down.aspx", datatable.Rows[i]["id"].ToString(), "", "", "", "") + "\">下载资料</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["uptime"].ToString() + "</td>\n");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();

    }




    /// <summary>
    /// /////////////恢复删除   
    /// </summary>
    /// <param name="db"></param>
    protected void ResumeDelete(DBClass db)
    {
        string[] sign ={ "," };
        string[] delids = Request.Form.Get("sel").ToString().Split(sign, StringSplitOptions.RemoveEmptyEntries);

        //得到所有操作文件名
        string files = "select * from tbdatarecycle where tbdatarecycle.fileurl in ('";
        foreach (string u in delids)
        {
            files += u + "','";

        }
        files += "')";
        DataTable setfilestable = db.GetTable(files, null);



        //恢复到 资料表
        string copy_sql;
        for (int ii = 0; ii < setfilestable.Rows.Count; ii++)
        {
            copy_sql = "insert into tbdata(filetitle,fileurl,description,filesizes,uptime,userno,popedom,type_id) values(?,?,?,?,?,?,?,?)";
            OdbcParameter[] param ={ 
                      new OdbcParameter("@filetitle",OdbcType.VarChar),
                      new OdbcParameter("@fileurl",OdbcType.VarChar),
                      new OdbcParameter("@description",OdbcType.Text),
                      new OdbcParameter("@filesizes",OdbcType.Int),
                      new OdbcParameter("@uptime",OdbcType.DateTime),
                      new OdbcParameter("@userno",OdbcType.VarChar),
                      new OdbcParameter("@popedom",OdbcType.Int),
                      new OdbcParameter("@type_id",OdbcType.Int)

             };
            param[0].Value = setfilestable.Rows[ii]["filetitle"].ToString();
            param[1].Value = setfilestable.Rows[ii]["fileurl"].ToString();
            param[2].Value = setfilestable.Rows[ii]["description"].ToString();
            param[3].Value = Convert.ToInt64(setfilestable.Rows[ii]["filesizes"].ToString());
            param[4].Value = Convert.ToDateTime(setfilestable.Rows[ii]["uptime"].ToString());
            param[5].Value = setfilestable.Rows[ii]["userno"].ToString();
            param[6].Value = Convert.ToInt32(setfilestable.Rows[ii]["popedom"].ToString());
            param[7].Value = Convert.ToInt32(setfilestable.Rows[ii]["type_id"].ToString());

            db.ExecuteNonQuery(copy_sql, param);
        }




        //删除 回收站表
        string delete_sql = "delete from tbdatarecycle where tbdatarecycle.fileurl in ('";
        foreach (string u in delids)
        {
            delete_sql += u + "','";

        }
        delete_sql += "')";
        db.ExecuteNonQuery(delete_sql, null);

        //恢复文件
        string frompath = "", topath = "";
        FileInfo f, tof;
        for (int i = 0; i < setfilestable.Rows.Count; i++)
        {

            frompath = ConfigurationManager.AppSettings["delete_center"] + setfilestable.Rows[i]["fileurl"].ToString();
            topath = ConfigurationManager.AppSettings["data_center"] + setfilestable.Rows[i]["fileurl"].ToString();
            f = new FileInfo(frompath);
            tof = new FileInfo(topath);
            //先检测如果要移动的文件夹内已经存在该文件 则删除要移动的文件 不需要再移动
            if (tof.Exists)
            {
                if (f.Exists)
                    File.Delete(frompath);
            }
            else
            {
                if (f.Exists)
                {
                    File.Move(frompath, topath);
                }
            }

        }


        db.closedb();
        Fun.alert("","恢复资料成功",Link.url("/app_mgr/ziliao_mgr/", "data_myrecycle.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }



</script>

<html>
<head id="Head1" runat="server">
    <title>用户回收站</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />


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

function ConfirmDel()
{
   if(confirm("删除该资料后将无法再恢复\n\n真的删除吗？"))
     return true;
   else
     return false;
}



</script>


</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />

  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td class=small nowrap><table>
      <tr>
        <td align="left" valign="middle" class="calendarNav" style="height: 16px">
                              我的资料回收站
          </td>
        </tr>
    </table> </td>
  </tr>
</TABLE>

 <div><table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >
 			<form action="<%= Link.url("/app_mgr/ziliao_mgr/","data_myrecycle.aspx","","set","","","")%>" method="post" name="selform" >
 			
   <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                              
                            
                                     <tr>
                                     <td align="left" valign="middle" bgcolor="#FFFFFF"  style="width: 845px; height: 26px">
                                    <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","","","","") %>"><img src="/images/goback.jpg" style="border:0;" alt="返回资料管理" /></a><a  onclick="{if(confirm('此操作将恢复资料！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='resumedelete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/resumedata.jpg" style="border:0;" alt="恢复资料" /></a>
                                    </td>
                                 </tr>
                           </table>



     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
       

          <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
        	<td align="center" style="height: 18px;">
                <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()" /></td>
			<td align="center"  style="height: 18px; width: 42%;">
                资 料 名 称</td>
			<td align="center" style="height: 18px; width:12%;">
                资料类型</td>

			<td align="center">
                大 小</td>

           <td align="center" style="width: 13%; height: 18px;">
                下载</td>
            <td align="center" style="width: 15%; height: 18px;">
                上传时间</td>
            
          </tr>
          
        <%=contentstring %>
       
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="10" height="22" class="but1" style="width:100%;">
      <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      共  <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/   <%=maxpage%>
       
            页，每页 
          <%=pagesize%>个&nbsp; <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_myrecycle.aspx","1","","","","") %>">首页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_myrecycle.aspx",(nowpage-1).ToString(),"","","","") %>">上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_myrecycle.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a>&nbsp;
          <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_myrecycle.aspx",maxpage.ToString(),"","","","") %>">尾页</a></td>
        
           </tr> 
          
       </table>   
       </td>
       </tr>
       </table>
    
 </form>

 </td>
</tr>
</table>
 
 
 
 <br>
 <br>
 <br>
 <br>
 
 <br>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>




