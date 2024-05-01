﻿<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>



<script runat="server" language="C#">


  
    public string contentstring = "";
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
	protected string condition;
	


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == "search")
        {

            ShowPage(db);

        }

        else
        {




            if (Request.QueryString["param2"] == "set")
            {



                if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                {
  
					db.closedb();
					  Fun.alert("","请先选择表格！",Link.url("/app_mgr/excel_mgr/","excel_search.aspx","","","","","") ,"返回");
                    Response.End();

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
		 condition=Request.QueryString["param3"]==null ?"":Request.QueryString["param3"].ToString();
        StringBuilder sb = new StringBuilder();

        DataTable datatable = new DataTable();
        sqls = "select tbexcel.*,tbuser.username from tbexcel left join tbuser on tbexcel.userno=tbuser.userno where ( tbexcel.filetitle like '%"+ condition+"%' or tbuser.username like '%"+ condition+"%' ) and tbexcel.isdelete='0' order by uptime desc";

        datatable = db.GetTable(sqls, null);

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


            int indexi = datatable.Rows[i]["fileurl"].ToString().LastIndexOf(".") + 1;
            string newext = datatable.Rows[i]["fileurl"].ToString().Substring(indexi).ToLower();  //得到扩展名

            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
            sb.Append("<td height=\"24\" align=\"center\" >" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["id"].ToString() + "\"/></td>\n");
            sb.Append("<td height=\"24\" align=\"left\" ><img src=\"/images/filetype/" + newext + ".gif\"/>&nbsp; " + datatable.Rows[i]["filetitle"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["uptime"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" >" + datatable.Rows[i]["username"].ToString() + "</td>\n");
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/excel_mgr/","excel_down.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\">导出统计表</a></td>\n");
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
        string files = "select * from tbexcel where tbexcel.id in (" + Request.Form.Get("sel").ToString() + ")";
        DataTable setfilestable = db.GetTable(files, null);


        //删除表
        string delete_sql = "update  tbexcel set isdelete='1' where tbexcel.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);


        //移动文件
        string frompath = "", topath = "";
        FileInfo f, tof;
        for (int i = 0; i < setfilestable.Rows.Count; i++)
        {

            frompath = ConfigurationSettings.AppSettings["excel_center"].ToString() + setfilestable.Rows[i]["fileurl"].ToString();
            topath = ConfigurationSettings.AppSettings["excel_center"].ToString() + "删除统计表/" + setfilestable.Rows[i]["fileurl"].ToString();
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
		  Fun.alert("","成功删除至回收站！",Link.url("/app_mgr/excel_mgr/","excel_search.aspx","","","","","") ,"返回");
        Response.End();


    }



    

</script>












<html>
<head id="Head1" runat="server">
    <title>在线统计管理</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

#hanxin{
 margin: 0 auto;

text-align;center;
}
#uploadingdiv{     
    width:500px; 
    height:200px; 
    background:#EDF1F8;     
    border: 2px solid #849BCA; 
    margin-top:2px; 
    margin-left:2px; 
    float:left; 
    overflow:hidden; 
    position:absolute; 
    left:0px; 
    top:0px; 
    cursor:move; 
    float:left; 
    /*filter:alpha(opacity=50);*/ 
     
} 
.content{ 
    padding:10px; 
} 
</style>

<LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript" src="/js/datepicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript">
function cca(s)
{//选择后边颜色
	var e=s
	while (e.tagName != "TR")
		e = e.parentElement	
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


function showupload()
{
   
     if(  document.getElementById("uploaddiv").style.display=="")
         {  
          document.getElementById("uploaddiv").style.display="none";
          }
      else
         {
           document.getElementById("uploaddiv").style.display="";
          }
}


 function divhide()
 {
      document.getElementById("uploaddiv").style.display="none";
      document.getElementById("uploadingdiv").style.display="";
 }






</script>




</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />

	<form action="<%= Link.url("/app_mgr/excel_mgr/","excel_search.aspx","","search","","","") %>" method="post" name="selform2" >
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td nowrap class=small style="width: 100px"><table>
        <tr>
          <td> <b><font color="#ffffff">报表搜索结果</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>&nbsp;</td>
        </tr>
    </table> </td>
  </tr>
</TABLE>
</form>
  
 <div><table width="100%" border="0"
                     align="center" cellpadding="0" cellspacing="0">
                     <tr>
                         <td align="center" valign="top">
 <TABLE width=100% align=center border="0" cellspacing="0" cellpadding="0">
<tr>
<td >

 			
  <table width="100%" border="0" cellpadding="0" cellspacing="0"
                     align="center">
                     <tr>
                         <td width="100%" align="center" valign="top">
                             <table width="100%" border="0" cellpadding="0" cellspacing="0">
                               
                                     <tr>
                                     <td align="left" valign="middle" bgcolor="#FFFFFF"  style="width: 845px; height: 26px"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                       <tr>
                                         <td align="left"> <a href="<%= Link.url("/app_mgr/excel_mgr/", "excel_mgr.aspx", "", "", "", "", "") %>"><img src="/images/goback.jpg" style="border:0;" alt="" /></a>
										 <a onClick="{if(confirm('此操作将统计表格放入回收站！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" /></a> </td>
                                       </tr>
                                     </table>
                                   </td>
                                 </tr>
                                 <tr>
                                     <td>
                                         <div id="uploaddiv" style="display:none;">
                                             <form name="form1" method="post" action="<%= Link.url("/app_mgr/excel_mgr/","excel_upload.aspx","","save","","","") %>" enctype="multipart/form-data" >
                                                 <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                     
                                                     <tr><td>&nbsp;</td></tr>
                                                     <tr>
                                                         <td style="height: 25px">
                                                             选取统计表：</td>
                                                         <td align="left" style="height: 25px">
                                                             <input name="myfile" type="file" id="myfile" size="40" runat="server" />&nbsp; <font color="green">  目前仅
                                                             .xls表格</font></td>
                                                     </tr>
                                                
                                                     <tr>
                                                       <td height="25"> 重新命名：</td>
                                                       <td height="20" align="left">
                                                         <input name="filetitle" type="text" size="40" />
&nbsp;*文件名如果不填 则为原上传文件名</td>
                                                     </tr>
                                                     <tr>
                                                         <td height="25">
                                                             查找描述：
                                                         </td>
                                                         <td height="20" align="left">
                                                             <textarea name="content" style="height: 47px; width: 77%;"></textarea></td>
                                                     </tr>
                                                     <tr>
                                                         <td height="25">
                                                         </td>
                                                         <td height="20">
                                                             &nbsp;
                                                             <input name="Submit" type="submit" onClick="divhide();" value="上传资料" style="width: 65px" />
                                                             <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />
                                                         </td>
                                                     </tr>
                                                 </table>
                                             </form>
                                         </div>
                                         <br>
                                         <div id="uploadingdiv" style="display:none; filter: alpha(opacity=100); opacity: 1; left: 309px; top: 170px; width: 327px; height: 162px;">
                                           <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                             <tr>
                                               <td height="24"><table width="320" height="20" border="0" align="center" cellpadding="0" cellspacing="0">
                                                 <tr>
                                                   <td width="323" bgcolor="#666699">&nbsp;</td>
                                                 </tr>
                                               </table></td>
                                             </tr>
                                             <tr>
                                               <td align="center"><span class="content">您的统计表可能比较大，请耐心等待!资料上传中.......</span></td>
                                             </tr>
                                           </table>
                                        
                                       </div>
                                     </td>
                                 </tr>
                                 
                           </table>

 			<form action="<%= Link.url("/app_mgr/excel_mgr/","excel_search.aspx","","set","","","") %>" method="post" name="selform" >

     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
         <tr class="lvtCol">
             <td height="30" align="center">
                 序号</td>
             <td align="center" style="height: 18px;">
                 <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"></td>
             <td align="center" style="height: 18px; width: 38%;">
                 统 计 表 名 称</td>
             <td align="center">
                 上传时间</td>
          
             <td align="center">
                 统计人</td>  
                 
        
             <td align="center">
                 导出统计表</td>
         </tr>
          

<%=contentstring %>


        
         <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
             <td align="center" colspan="10" height="35" class="but1" style="width: 100%;">
                 <table width="211" border="0" align="left" cellpadding="0" cellspacing="0">
                     <tr>
                         <td width="160" align="right">
                          
                         </td>
                         <td width="140" align="center">
                         </td>
                     </tr>
                 </table>
                 <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />&nbsp;
                 共
                 <%=total%>
                 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/
                 <%=maxpage%>
                 页，每页
                 <%=pagesize%>
                 个&nbsp; <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_search.aspx","1","search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">
                     首页</a> <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_search.aspx",(nowpage-1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">
                         上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/excel_mgr/","excel_search.aspx",(nowpage+1).ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">下一页</a>&nbsp;
                 <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_search.aspx",maxpage.ToString(),"search",HttpUtility.UrlEncode(condition, System.Text.Encoding.UTF8),"","") %>">
                     尾页</a></td>
         </tr>
     </table>   
     
      </form>
       </td>
       </tr>
       </table>
    

 </td>
</tr>
</table>
 
 <br>  
 <myfoot:myfoot ID="foot1" runat="server" />

</body>
</html>
