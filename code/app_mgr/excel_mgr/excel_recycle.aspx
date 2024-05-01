<%@ Page Language="C#" %>
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



                if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                {
                      db.closedb();
					  Fun.alert("","请先选择表格！",Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx","","","","","") ,"返回");
                    Response.End();

                }
                else
                {

                    string actiontype = "";
                    if (Request.Form.Get("actiontype") != null)
                        actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别

                    if (actiontype == "resumedelete")
                    {

                        ResumeDelete(db);
                    }


                }

            }  //set

            if (Request.QueryString["param2"].ToString() == "search")
            {
                string condition = Request.Form.Get("param3").ToString();
                //string datatype = Request.Form.Get("param4").ToString();
                //string filetype = Request.Form.Get("param5").ToString();
                Response.Redirect(Link.url("/app_mgr/excel_mgr/","excel_recyclesearch.aspx","","search",condition,"",""));
		   }

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
        StringBuilder sb = new StringBuilder();

        DataTable datatable = new DataTable();
        sqls = "select tbexcel.*,tbuser.username from tbexcel left join tbuser on tbexcel.userno=tbuser.userno  where tbexcel.isdelete='1' order by uptime desc";

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
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\""+Link.url("/app_mgr/excel_mgr/","excel_deletedown.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\">导出统计表</a></td>\n");
            sb.Append("</tr>\n");

            id++;
        }

        contentstring = sb.ToString();

    }





    /// <summary>
    /// ///////////删除资料
    /// </summary>
    /// <param name="db"></param>

    protected void ResumeDelete(DBClass db)
    {


        //得到所有操作文件名
        string files = "select * from tbexcel where tbexcel.id in (" + Request.Form.Get("sel").ToString() + ")";
        DataTable setfilestable = db.GetTable(files, null);


        //恢复表
        string delete_sql = "update  tbexcel set isdelete='0' where tbexcel.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);


        //移动文件 恢复
        string frompath = "", topath = "";
        FileInfo f, tof;
        for (int i = 0; i < setfilestable.Rows.Count; i++)
        {
               frompath = ConfigurationSettings.AppSettings["excel_center"].ToString() + "删除统计表/" + setfilestable.Rows[i]["fileurl"].ToString();
            topath = ConfigurationSettings.AppSettings["excel_center"].ToString() + setfilestable.Rows[i]["fileurl"].ToString();
           
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
		  Fun.alert("","恢复成功！",Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx","","","","","") ,"返回");
     
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



function allsearch()
{
	 url="<%=Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx","","search","param3_idd","","") %>";
	  url = url.replace("param3_idd",encodeURI(document.selform2.param3.value));
     document.selform2.action=url;
document.selform2.submit();
}
</script>

<style type="text/css"> 
#fd{     
    width:600px; 
    height:200px; 
    background:#EDF1F8;     
    border: 2px solid #849BCA; 
    margin-top:2px; 
    margin-left:2px; 
    float:left; 
    overflow:hidden; 
    position:relative; 
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


</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />

	<form action="" method="post" name="selform2" >
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td nowrap class=small style="width: 100px"><table>
        <tr>
          <td> <b><font color="#ffffff">报表回收站</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>
		 <input type="text" name="param3" style="width: 186px; height: 20px;" />
                                         <input type="button" value="查找" onClick="allsearch()" style="width: 75px; height: 21px;" />
                          </td>
        </tr>
    </table> </td>
  </tr>
  
  </TABLE>
  

</form>
 
 			<form action="" method="post" name="selform" > 
   <table width="100%" border="0" cellpadding="0" cellspacing="1" >
         <tr>
             <td  align="left">
                <a  onclick="{if(confirm('此操作将恢复报表！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='resumedelete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/resumedata.jpg" style="border:0;" alt="恢复资料" /></a></td>

         </tr>
		 </table>


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
                 个&nbsp; <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx","1","","","","") %>">
                     首页</a> <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx",(nowpage-1).ToString(),"","","","") %>">
                         上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx",(nowpage+1).ToString(),"","","","") %>">下一页</a>&nbsp;
                 <a href="<%=Link.url("/app_mgr/excel_mgr/","excel_recycle.aspx",maxpage.ToString(),"","","","") %>">
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
