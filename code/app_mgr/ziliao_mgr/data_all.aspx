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
    protected StringBuilder selectsb = new StringBuilder();
    protected string type_idd = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

            ShowPage(db);

        }

        else
        {




            if (Request.QueryString["param2"] == "set")
            {
                //查找
                if (Request.Form.Get("actiontype").ToString() == "search")
                {

                    string condition = Request.Form.Get("param3").ToString();
                    Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","data_adminsearch.aspx","","search",condition,"",""));

                }
                if (Request.Form.Get("actiontype").ToString() == "timesearch")
                {
                    //按时间查
                    string timefrom = Request.Form.Get("param4").ToString();
                    string timeto = Request.Form.Get("param5").ToString();
                    if (timeto == "")
                        timeto = DateTime.Now.ToString();
                    if (timefrom == "")
                    {
                         db.closedb();
						  	 Fun.goback("","请输入起始日期！","返回");
                    }
                    Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","data_adminsearchtime.aspx","","","", timefrom , timeto));

                }

                else
                {


                    if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                    {
                         db.closedb();
						 	 Fun.goback("","没有选择任何资料！","返回");
                    }
                    else
                    {

                        string actiontype = "";
                        if (Request.Form.Get("actiontype") != null)
                            actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别



                    }

                }

            }  //set

        }



        db.closedb();
    }





    /// <summary>
    /// /////////页面显示
    /// </summary>
    /// <param name="db"></param>
    protected void ShowPage(DBClass db)
    {

        //页面载入显示
        string sqls;
        int mytype_id;
        StringBuilder sb = new StringBuilder();
        double allfilesize = 0.0;
        string strsize;

        DataTable datatable = new DataTable();

        if (Request.QueryString["param4"] == null || Request.QueryString["param4"].ToString() == "0")
        {
            type_idd = "0";

            sqls = "select tbdata.*,tbuser.userno,username from tbdata left join tbuser on tbdata.userno=tbuser.userno order by tbdata.uptime desc";
			//Response.Write(sqls);
			//Response.End();
            datatable = db.GetTable(sqls, null);
        }


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
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["username"].ToString() + "</td>\n");
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
            sb.Append("<td height=\"24\" align=\"center\" >" + strsize + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a  href=\"" + Link.url("/app_mgr/ziliao_mgr/", "data_down.aspx", datatable.Rows[i]["id"].ToString(), "", "", "", "") + "\">下载资料</a></td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["uptime"].ToString() + "</td>\n");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();

    }


</script>
<html>
<head id="Head1" runat="server">
    <title>用户管理</title>
    

    
   
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
if (document.selform2.sel.length>1)
{
	for (var i=0;i<document.selform2.sel.length;i++) {
		var e=document.selform2.sel[i];
		e.checked=!e.checked;
		cca(e);	}
		}
		else
		{
		var e=document.selform2.sel;
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
      for(var i=0;i<document.selform2.sel.length;i++)
      {
            var e=document.selform2.sel[i];
            if(e.checked)
                users=users+e.value+",";
           
      }
      if(users.length==0)
             alert("对不起，您没有选择任何文件");
        else
        
          alert(users);
     
}



function allsearch()
{
	 url="<%=Link.url("/app_mgr/ziliao_mgr/","data_all.aspx","","set","param3_idd","","") %>";
	 url = url.replace("param3_idd",encodeURI(document.selform2.param3.value));
	 document.getElementById('actiontype').value='search';
     document.selform2.action=url;
	 //alert(url);
document.selform2.submit();
}

function allsearchtime()
{
	 url="<%=Link.url("/app_mgr/ziliao_mgr/","data_all.aspx","","set","param3_idd","","") %>";
	 url = url.replace("param3_idd",encodeURI(document.selform2.param3.value));
	 document.getElementById('actiontype').value='timesearch';
     document.selform2.action=url;
	 //alert(url);
document.selform2.submit();
}
</script>


</head>
<body>


 

<myhead:myhead ID="Myhead1" runat="server" />
    <div>
    <table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
<tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >
  	
 			<form action="<%=Link.url("/app_mgr/ziliao_mgr/","data_all.aspx","","set","","","")%>" method="post" name="selform2" >
 			
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                 
                                     <tr>
                                     <td align="left" valign="middle" >
                                       <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                           <tr>
                                             <td style="height: 25px"><a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_upload.aspx", "", "", "", "", "") %>"></a></td>
                                             <td align="right" style="height: 25px">
                                                 <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
                                                   <tr>
                                                     <td height="32" class=small style="width:50px">&nbsp;</td>
                                                     <td class=small nowrap><table>
                                                         <tr>
                                                           <td align="left" valign="middle" class="calendarNav" style="height: 16px"> 单位资料 </td>
                                                         </tr>
                                                     </table></td>
                                                   <td align="center" nowrap class=small><input type="text" name="param3" style="width: 150px; height: 20px;" />
                                                     <input name="button" type="button" style="width: 75px; height: 22px;" onClick="allsearch()" value="查找" /></td>
                                                   <td align="center" nowrap class=small>&nbsp; 按日期查&nbsp; 从
                                                     <input type="text" 
 name="param4" style="width: 100px;height: 20px;" onFocus="new WdatePicker(this)"/>
到
<input type="text" name="param5" style="width: 100px; height: 20px;"  onfocus="new WdatePicker(this)"  />
<input name="button2" type="button" style="width: 75px; height: 22px;" onClick="allsearchtime()" value="查找" /></td>
                                                   </tr>
                                                 </TABLE>
                                             </td>
                                           </tr>
                                       </table></td>
                                 </tr>
                             </table>



     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">

          
         <tr class="lvtCol"> 
			<td height="30" align="center"> 序号</td>
        	<td align="center" style="height: 18px;">
                <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()" /></td>
			<td align="center"  style="height: 18px;">
                资 料 名 称</td>
			<td align="center" >
                所有人</td>
            <td align="center" >
                共享状态</td>
			<td align="center" >
                大 小</td>

           <td align="center" style="width: 10%; height: 18px;">
                下载</td>
            <td align="center" style="width: 17%; height: 18px;">
                上传时间</td>
        
            
          </tr>
          
        <%=contentstring %>
       
       
      <tr  bgcolor=white onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
      <td align="center" colspan="10" height="22" class="but1" style="width:100%;">
      <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      <input type="hidden" name="filetypeid" value="<% =type_idd %>" />
          共
          <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/   <%=maxpage%>
       
            页，每页 
          <%=pagesize%>个&nbsp; <a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_all.aspx", "1", "", "", type_idd, "") %>">首页</a> <a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_all.aspx", (nowpage-1).ToString(), "", "", type_idd, "") %>">上一页</a> &nbsp;<a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_all.aspx", (nowpage+1).ToString(), "", "", type_idd, "") %>">下一页</a>&nbsp;
          <a href="<%=  Link.url("/app_mgr/ziliao_mgr/", "data_all.aspx", maxpage.ToString(), "", "", type_idd, "") %>">尾页</a></td>
        
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
