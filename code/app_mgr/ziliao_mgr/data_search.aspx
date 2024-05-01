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
    protected string condition = "";
    protected string datatype = "";
	protected string filetype = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
      
            db.closedb();
			Fun.goback("","你没有输入查询条件","返回");
            Response.End();

        }
        else
        {
                  
  
            if (Request.QueryString["param2"] == "search")
            {  // 查找功能

                ShowPage(db);

            }
            else
            {
                if (Request.QueryString["param2"] == "set")
                {

                    if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                    {
                                  db.closedb();
			Fun.goback("","你没有选择任何资料","返回");

				
                    }
                    else
                    {

                        string actiontype = "";
                        if (Request.Form.Get("actiontype") != null)
                            actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别

                        if (actiontype == "delete")
                        {
                            DeleteData(db);
                        }
                        if (actiontype == "share") 
                          {
                              SetShareFile(db);

                           }
                           if (actiontype == "cancelshare")
                           {
                               CancelShareFile(db);
                            }
                    }
                }
            }

          
        }



        db.closedb();


    }




    /// <summary>
    /// ////////显示结果页面
    /// </summary>
    /// <param name="db"></param>
    void ShowPage(DBClass db)
    {

     condition = Request.QueryString["param3"]==null ? "": Request.QueryString["param3"].ToString();
     datatype = Request.QueryString["param4"] == null ? "" : Request.QueryString["param4"].ToString();
     filetype = Request.QueryString["param5"] == null ? "" : Request.QueryString["param5"].ToString();



        string sqls;

        if (datatype == "")
        {

            sqls = " select tbdata.id,tbdata.userno, tbdata.filetitle, tbdata.fileurl, tbdata.description, tbdata.filesizes,  tbdata.uptime, tbdata.popedom, tbdata.type_id, tbdata.sharetime, tbdatatype.name, tbdatatype.createdate from tbdata left join tbdatatype on  tbdata.type_id=tbdatatype.id where ( tbdata.filetitle like '%" + condition + "%' or description like '%" +
               condition + "%'  ) and tbdata.userno='" + Session["userno"].ToString() + "'";
        }
        else
        {

            sqls = " select tbdata.id,tbdata.userno, tbdata.filetitle, tbdata.fileurl, tbdata.description, tbdata.filesizes,  tbdata.uptime, tbdata.popedom, tbdata.type_id, tbdata.sharetime, tbdatatype.name, tbdatatype.createdate  from tbdata left join tbdatatype on  tbdata.type_id=tbdatatype.id where ( tbdata.filetitle like '%" + condition + "%' or description like '%" +
               condition + "%'  ) and tbdata.userno='" + Session["userno"].ToString() + "' and tbdata.type_id="+datatype;
        }
		
		if (filetype == "")
        {           }
        else
        {
           sqls = sqls + " and right(tbdata.fileurl,4)='" + filetype + "'";
        }
		sqls=sqls + " order by tbdata.uptime desc";

		
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
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["id"].ToString() + "\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" ><img src=\"/images/filetype/" + newext + ".gif\"/>&nbsp;<a  href=\"" + Link.url("/app_mgr/ziliao_mgr/", "data_down.aspx", datatable.Rows[i]["id"].ToString(), "", "", "", "") + "\">" + datatable.Rows[i]["filetitle"].ToString() + "</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["name"].ToString() + "&nbsp;</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["uptime"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >");
            if (Convert.ToInt32(datatable.Rows[i]["popedom"].ToString()) >= 1 && Convert.ToInt32(datatable.Rows[i]["popedom"].ToString()) < 10000)
            {
                sb.Append("" + "部门共享" + "</font></td>\n");
            }
            else
            {
                if (datatable.Rows[i]["popedom"].ToString() == "10000")
                    sb.Append("<font color=\"red\">" + "全局共享" + "</font></td>\n");
                else
                    sb.Append("私人");
            }
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\"" + Link.url("/app_mgr/ziliao_mgr/", "data_infoedit.aspx", datatable.Rows[i]["id"].ToString(), "", "", "", "") + "\">编辑</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a  href=\"" + Link.url("/app_mgr/ziliao_mgr/", "data_down.aspx", datatable.Rows[i]["id"].ToString(), "", "", "", "") + "\">下载资料</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + strsize + "</td>\n");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();
    
    
    }





    /// <summary>
    /// ///////////删除资料
    /// </summary>
    /// <param name="db"></param>

    protected void DeleteData(DBClass db)
    {


        //得到所有操作文件名
        string files = "select * from tbdata where tbdata.id in (" + Request.Form.Get("sel").ToString() + ")";
        DataTable setfilestable = db.GetTable(files, null);


        //复制到回收站表
        string copy_sql;
        for (int ii = 0; ii < setfilestable.Rows.Count; ii++)
        {
            copy_sql = "insert into tbdatarecycle(filetitle,fileurl,description,filesizes,uptime,userno,popedom,type_id) values(?,?,?,?,?,?,?,?)";
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

        //删除原表
        string delete_sql = "delete from tbdata where tbdata.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);

        //移动文件
        string frompath = "", topath = "";
        FileInfo f;
        for (int i = 0; i < setfilestable.Rows.Count; i++)
        {

            frompath = Server.MapPath("/data_center/" + setfilestable.Rows[i]["fileurl"].ToString());
            topath = Server.MapPath("/data_delete/" + setfilestable.Rows[i]["fileurl"].ToString());
            f = new FileInfo(frompath);
            if (f.Exists)
            {
                File.Move(frompath, topath);
            }

        }


        db.closedb();
      Fun.alert("","删除成功",Link.url("/app_mgr/ziliao_mgr/", "data_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();


    }


    /// <summary>
    /// /////////设定共享 
    /// </summary>
    /// <param name="db"></param>
    protected void SetShareFile(DBClass db)
    {



        string ids = Request.Form.Get("sel").ToString();

        Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","data_shareset.aspx",ids,"","","",""));

    }



    /// <summary>
    /// /////////取消共享 
    /// </summary>
    /// <param name="db"></param>
    protected void CancelShareFile(DBClass db)
    {


        string up_sql = "update tbdata set popedom=0 where tbdata.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(up_sql, null);

        db.closedb();
       Fun.alert("","删除成功",Link.url("/app_mgr/ziliao_mgr/", "data_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();


    }

</script>

<html>
<head id="Head1" runat="server">
    <title>资料查找结果</title>
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


function ConfirmDel()
{
   if(confirm("确定要删除此资料吗？"))
     return true;
   else
     return false;
}

function deleteusers()
{
     var users="";
      for(var i=0;i<document.selform.sel.length;i++)
      {
            var e=document.selform.sel[i];
            if(e.checked)
                users=users+e.value+",";
           
      }
      if(users.length==0)
             alert("对不起，您没有选择任何文件");
        else
        
          alert(users);
     
}



</script>


</head>
<body>


 

<myhead:myhead ID="Myhead1" runat="server" />

 <div><table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >
  	
 			<form action="<%= Link.url("/app_mgr/ziliao_mgr/","data_search.aspx","","set","","","")%>" method="post" name="selform" >
 			
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                 <tr>
                                 <td>
                                     <table border="0" cellspacing="0" cellpadding="0" width="100%" class="hdrTabBg">
                                         <tr>
                                             <td height="32" class="small" style="width: 50px">
                                           <td class="small" nowrap>
                                                 <table>
                                                     <tr>
                                                         <td align="center" valign="middle" class="small" style="height: 16px">
                                                          我的资料搜索结果: <span class="txtGreen">"<%= condition %>"</span>                                                       </td>
                                                     </tr>
                                                 </table>
                                           </td>
                                         </tr>
                                     </table>
                                 
                                 </td>
                                 </tr>
                            
                                     <tr>
                                     <td align="left" valign="middle"  style="width: 845px; height: 26px">
                                    <a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a><a onClick="{if(confirm('此操作将资料放到回收站！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" /></a><a  onclick="javascript:document.getElementById('actiontype').value='share';document.selform.submit();" href="#"><img src="/images/share.jpg" style="border:0;" alt="" /></a><a  onclick="{if(confirm('此操作将取消选定文件的共享功能！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='cancelshare';document.selform.submit();return true;}return false;}" href="#"><img src="/images/cancelshare.jpg" style="border:0;" /></a>
                                    </td>
                                 </tr>
                             </table>



     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">

         <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
        	<td align="center" style="height: 18px;">
                <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()" style="width: 22px"></td>
			<td align="center"  style="height: 18px; width: 38%;">
                资 料 名 称</td>
			<td align="center" style="height: 18px; width: 11%;">
                资料类别</td>
			<td align="center" >
                上传时间</td>
  
	    <td align="center">
                共享状态</td>

			<td align="center">
                编 辑</td>

           <td align="center" style="width: 10%; height: 18px;">
               下 载</td>
            <td align="center" style="width:7%; height: 18px;">
                大小</td>
        
            
          </tr>
          
        <%=contentstring %>
       
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="10" height="22" class="but1" style="width:100%;">
      <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      共  <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/   <%=maxpage%>
       
            页，每页 
          <%=pagesize%>个&nbsp; <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_search.aspx","1","search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),datatype,HttpUtility.UrlEncode(filetype, System.Text.Encoding.UTF8)) %>">首页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_search.aspx",(nowpage-1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),datatype,HttpUtility.UrlEncode(filetype, System.Text.Encoding.UTF8)) %>">上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_search.aspx",(nowpage+1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),datatype,HttpUtility.UrlEncode(filetype, System.Text.Encoding.UTF8)) %>">下一页</a>&nbsp;
          <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_search.aspx",maxpage.ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),datatype,HttpUtility.UrlEncode(filetype, System.Text.Encoding.UTF8)) %>">尾页</a></td>
        
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
 
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
