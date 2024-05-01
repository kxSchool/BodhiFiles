<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">


DateTime dt1=Convert.ToDateTime(System.DateTime.Now.AddDays(-1).ToShortDateString().ToString());
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
    protected string news_id = "",contentstring = "",contentstring1 = "",news_titlestring = "",usernamestring = "",createtimestring="";
	protected StringBuilder selectsb = new StringBuilder();
    protected StringBuilder selectdatatypesb = new StringBuilder();
	
    protected void Page_Load(object sender, EventArgs e)
    {

string server_v1,server_v2;
server_v1=HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
server_v2=HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
if (server_v1!=null) 
{
if (server_v1.Substring(7, server_v2.Length) != server_v2 && server_v1.Substring(8, server_v2.Length) != server_v2)
{
Response.Write ("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
Response.Write ("<tr><td style='font:9pt Verdana'>");
Response.Write ("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
Response.Write ("</td></tr></table></center>");
Response.End();
}
}
else
{
Response.Write ("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
Response.Write ("<tr><td style='font:9pt Verdana'>");
Response.Write ("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
Response.Write ("</td></tr></table></center>");
Response.End();
}


if(Session["condition"]==null) {Session["condition"]="null";} 		
        DBClass db = new DBClass();
        
        news_id = Request.QueryString["param1"].ToString();
        OdbcParameter param1 = new OdbcParameter("@id",OdbcType.Int,4);
        param1.Value = news_id;
        DataTable dt = db.GetTable("select * from tbcustom where id=?",param1);
		news_titlestring= dt.Rows[0]["companyname"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
        contentstring ="联系人员:" +  dt.Rows[0]["username"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "邮政编码:" +  dt.Rows[0]["postcode"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "电话区号:" +  dt.Rows[0]["phonecode"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "联系电话:" +  dt.Rows[0]["phone"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "所属省区:" +  dt.Rows[0]["province"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "所属市区:" +  dt.Rows[0]["capital"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "所属县区:" +  dt.Rows[0]["city"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		contentstring =contentstring + "主营产品:" +  dt.Rows[0]["mainproducts"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		 contentstring =contentstring + "公司传真:" +  dt.Rows[0]["fax"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		 contentstring =contentstring + "手机号码:" +  dt.Rows[0]["mobilephone"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		 contentstring =contentstring + "公司网站:" +  dt.Rows[0]["website"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		 contentstring =contentstring + "电子邮件:" +  dt.Rows[0]["email"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>" ;
		usernamestring= dt.Rows[0]["username"].ToString();
		createtimestring= dt.Rows[0]["createdate"].ToString();
		//contentstring=contentstring.Replace("\n","<br>");
		if (Session["userid"].ToString()!="admin") {SetLoginLog(db);}
      ShowPage(db);
       
db.closedb();


    }
	
	
	  protected void SetLoginLog(DBClass db)
      {
        OdbcParameter[] param ={
          new OdbcParameter("@loginnewsid",OdbcType.Int,50),
          new OdbcParameter("@loginuserno",OdbcType.VarChar,50),
          new OdbcParameter("@logintime",OdbcType.DateTime),
          new OdbcParameter("@ip",OdbcType.VarChar,50),
          new OdbcParameter("@browser",OdbcType.VarChar,50),
		  new OdbcParameter("@os",OdbcType.VarChar,50)
        };
		string userAgent = Request.UserAgent == null ? "无" : Request.UserAgent;
        param[0].Value = news_id;
        param[1].Value = Session["userno"];
        param[2].Value = DateTime.Now.ToString();
        param[3].Value = HttpContext.Current.Request.UserHostAddress.ToString();
        param[4].Value = Request.Browser.Browser + Request.Browser.Version;
        param[5].Value = this.GetOSNameByUserAgent(userAgent);

        db.ExecuteNonQuery("insert into tbnewsLog(loginnewsid, loginuserno, logintime, ip, browser, os) values(?,?,?,?,?,?)", param);
		 }
	
	 private string GetOSNameByUserAgent(string userAgent)
    {
        string osVersion =userAgent;

        if (userAgent.Contains("NT 6.0"))
        {
            osVersion = "Windows Vista/Server 2008";
        }
        else if (userAgent.Contains("NT 5.2"))
        {
            osVersion = "Windows Server 2003";
        }
        else if (userAgent.Contains("NT 5.1"))
        {
            osVersion = "Windows XP";
        }
        else if (userAgent.Contains("NT 5"))
        {
            osVersion = "Windows 2000";
        }
        else if (userAgent.Contains("NT 4"))
        {
            osVersion = "Windows NT4";
        }
        else if (userAgent.Contains("Me"))
        {
            osVersion = "Windows Me";
        }
        else if (userAgent.Contains("98"))
        {
            osVersion = "Windows 98";
        }
        else if (userAgent.Contains("95"))
        {
            osVersion = "Windows 95";
        }
        else if (userAgent.Contains("Mac"))
        {
            osVersion = "Mac";
        }
        else if (userAgent.Contains("Unix"))
        {
            osVersion = "UNIX";
        }
        else if (userAgent.Contains("Linux"))
        {
            osVersion = "Linux";
        }
        else if (userAgent.Contains("SunOS"))
        {
            osVersion = "SunOS";
        }
        return osVersion;
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

            news_id = Request.QueryString["param1"].ToString();
            sqls = "SELECT tbcustombbs.id, tbUser.UserName, tbcustombbs.content, tbcustombbs.createtime FROM (tbcustombbs LEFT JOIN tbcustom ON tbcustombbs.news_id = tbcustom.id) LEFT JOIN tbUser ON tbcustombbs.userno = tbUser.UserNo WHERE (((tbcustombbs.isdelete)=0) AND ((tbcustom.id)=?)) ORDER BY tbcustombbs.createtime DESC";



        OdbcParameter[] param1 ={ 
                       new OdbcParameter("@id",OdbcType.VarChar,50)  };
        param1[0].Value = news_id;
        datatable = db.GetTable(sqls, param1);

        //分页页面显示
        contentstring1 = "";
        total = int.Parse(datatable.Rows.Count.ToString()); pagesize = 10;  //每页显示
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
        if (Request.QueryString["param2"] != "" && Convert.ToInt32(Request.QueryString["param2"]) > maxpage)    //防止太大
            nowpage = maxpage;
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
         if (i%2==0) {
			sb.Append(" <tr class=lvtColData>");
			}
         else
            {
            sb.Append(" <tr class=lvtColDataHover>");
			}
            sb.Append("<td height=\"50\" align=\"center\" ><img src=\"/images/defhead.gif\"><br>" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"150\" align=\"left\"  valign=\"top\">");
			sb.Append("<font class=\"fontBold\">留言人:" + datatable.Rows[i]["username"].ToString() + "\n");
            sb.Append("" + datatable.Rows[i]["createtime"].ToString() + "</font>\n");
			sb.Append("<br>" + datatable.Rows[i]["content"].ToString().Replace(Session["condition"].ToString(),"<font color=blue>" + Session["condition"].ToString() + "</font>") + "<br>");
            sb.Append("</td>\n");
            
            sb.Append("</tr>\n");

            id++;
        }

        contentstring1 = sb.ToString();

    }





    /// <summary>
    /// ///////////删除资料
    /// </summary>
    /// <param name="db"></param>
	
</script>

<html>
<head id="Head1" runat="server">
    <title>信息阅读</title>
    
    
   <LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet">
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
		e.style.backgroundColor="#D4D0C8";
} 


</script>

   <!--资料直传窗口-->
	
	<script type="text/javascript">
	
	
	var x0=0,y0=0,x1=0,y1=0;
var offx=6,offy=6;
var moveable=false;
var hover='orange',normal='#336699';//color;
var index=10000;//z-index;
//开始拖动;
function reloadcode()
{
   location.reload();
}

function closewindows()
{
  window.close();
}
function startDrag(obj)
{

	if(event.button==1)
	{
		//锁定标题栏;
		obj.setCapture();
		//定义对象;
		var win = obj.parentNode;
		var sha = win.nextSibling;
		//记录鼠标和层位置;
		x0 = event.clientX;
		y0 = event.clientY;
		x1 = parseInt(win.style.left);
		y1 = parseInt(win.style.top);
		//记录颜色;
		normal = obj.style.backgroundColor;
		//改变风格;
		obj.style.backgroundColor = hover;
		win.style.borderColor = hover;
		obj.nextSibling.style.color = hover;
		sha.style.left = x1 + offx;
		sha.style.top  = y1 + offy;
		moveable = true;
	}

}
//拖动;
function drag(obj)
{
	if(moveable)
	{
		var win = obj.parentNode;
		var sha = win.nextSibling;
		win.style.left = x1 + event.clientX - x0;
		win.style.top  = y1 + event.clientY - y0;
		sha.style.left = parseInt(win.style.left) + offx;
		sha.style.top  = parseInt(win.style.top) + offy;
	}
}
//停止拖动;
function stopDrag(obj)
{
	if(moveable)
	{
		var win = obj.parentNode;
		var sha = win.nextSibling;
		var msg = obj.nextSibling;
		win.style.borderColor     = normal;
		obj.style.backgroundColor = normal;
		msg.style.color           = normal;
		sha.style.left = obj.parentNode.style.left;
		sha.style.top  = obj.parentNode.style.top;
		obj.releaseCapture();
		moveable = false;
	}
}
//获得焦点;
function getFocus(obj)
{
	if(obj.style.zIndex!=index)
	{
		index = index + 2;
		var idx = index;
		obj.style.zIndex=idx;
		obj.nextSibling.style.zIndex=idx-1;
	}
}
//最小化;
function min(obj)
{
	var win = obj.parentNode.parentNode;
	var sha = win.nextSibling;
	var tit = obj.parentNode;
	var msg = tit.nextSibling;
	var flg = msg.style.display=="none";
	if(flg)
	{
		win.style.height  = parseInt(msg.style.height) + parseInt(tit.style.height) + 2*2;
		sha.style.height  = win.style.height;
		msg.style.display = "block";
		obj.innerHTML = "<img src=\"/htmleditor/images/0.gif\" style=\"padding-left:" + (530-130) + "px;\">";
	}
	else
	{
		win.style.height  = parseInt(tit.style.height) + 2*2;
		sha.style.height  = win.style.height;
		obj.innerHTML = "<img src=\"/htmleditor/images/2.gif\" style=\"padding-left:" + (530-130) + "px;\">";
		msg.style.display = "none";
	}
}
//创建一个对象;
function xWin(id,w,h,l,t,tit,msg)
{
	index = index+2;
	this.id      = id;
	this.width   = w;
	this.height  = h;
	this.left    = l;
	this.top     = t;
	this.zIndex  = index;
	this.title   = tit;
	this.message = msg;
	this.obj     = null;

	this.bulid=bulid;
	this.bulid();

	
}
//初始化;
function bulid()
{
	var str = ""
		+ "<div id=xMsg" + this.id + " "
		+ "style='"
		+ "z-index:" + this.zIndex + ";"
		+ "width:" + this.width + ";"
		+ "height:" + this.height + ";"
		+ "left:" + this.left + ";"
		+ "top:" + this.top + ";"
		+ "background-color:" + normal + ";"
		+ "color:" + normal + ";"
		+ "font-size:8pt;"
		+ "font-family:Tahoma;"
		+ "position:absolute;"
		+ "cursor:default;"
		+ "border:2px solid " + normal + ";"
		+ "' "
		+ "onmousedown='getFocus(this)'>"
			+ "<div "
			+ "style='"
			+ "background-color:" + normal + ";"
			+ "width:" + (this.width-2*2) + ";"
			+ "height:22;"
			+ "color:white;"
			+ "' "
			+ "onmousedown='startDrag(this)' "
			+ "onmouseup='stopDrag(this)' "
			+ "onmousemove='drag(this)' "
			+ "ondblclick='min(this.childNodes[1])'"
			+ ">"
				+ "<span style='width:" + (this.width-4*12) + ";padding-left:3px;'>" + this.title + "</span>"
				+ "<span style='width:12;border-width:0px;color:white;padding-top:3px;' onclick='min(this)'><img src=\"/htmleditor/images/0.gif\" style=\"padding-left:" + (530-130) + "px;\"></span>"
				+ "<span style='width:12;border-width:0px;color:white;padding-top:3px;' onclick='reloadcode()'><img src=\"/htmleditor/images/r.gif\"></span>"
			+ "</div>"
				+ "<div style='"
				+ "width:" + (this.width-6) + ";"
				+ "height:" + (this.height-20-8) + ";"
				+ "background-color:white;"
				+ "line-height:14px;"
				+ "word-break:break-all;"
				+ "padding:3px;"
				+ "'>" + this.message + "</div>"
		+ "</div>"
		+ "<div id=xMsg" + this.id + "bg style='"
		+ "width:" + this.width + ";"
		+ "height:" + this.height + ";"
		+ "top:" + this.top + ";"
		+ "left:" + this.left + ";"
		+ "z-index:" + (this.zIndex-1) + ";"
		+ "position:absolute;"
		+ "background-color:black;"
		+ "filter:alpha(opacity=40);"
		+ "'></div>";

if(navigator.appName.indexOf("Explorer") > -1){
   document.body.insertAdjacentHTML("beforeEnd",str);
} else{
   document.body.innerHTML+=str;
   //document.getElementById("body").textContent=str;
}


	   

}
//显示隐藏窗口
function ShowHide(id,dis){
	var bdisplay = (dis==null)?((document.getElementById("xMsg"+id).style.display=="")?"none":""):dis
	document.getElementById("xMsg"+id).style.display = bdisplay;
	document.getElementById("xMsg"+id+"bg").style.display = bdisplay;
}

function initialize(tbNewsForumID,newsid,event)
{   var b= event.clientY + document.body.scrollTop;
	var a = new xWin("1",550,300,250,b+20,"<strong>&nbsp;您将以[<%=Session["username"]%>]身份回复此信</strong>","<iframe width=\"550\" frameborder=\"0\" height=\"300\" src=\"<%=Link.url("/app_mgr/crm_mgr/","custombbs_add.aspx",news_id,"","","","")%>\"'></iframe>");
    ShowHide("1","none");
}
</script>

    <style type="text/css">
<!--
.style3 {FONT-SIZE: 16px; FONT-FAMILY: Arial, Helvetica, sans-serif; font-weight: bold;}
.style6 {
	font-family: "仿宋_GB2312";
	font-size: 14pt;
}
-->
    </style>
</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="33" valign="top">    <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td class=small nowrap><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="middle" class="small" style="height: 16px;">                               <span class="txtGreen">发布人:</span>　<span class="WdateFmtErr"><%=usernamestring%></span>　<span class="txtGreen">发布时间:</span>　<span class="WdateFmtErr"><%=createtimestring%></span>　　<span class="WdateFmtErr"><%=Request.Browser.Browser + Request.Browser.Version%></span></td>
        </tr>
    </table> </td>
  </tr>
 
</TABLE>    </td>
  </tr>
  <tr>
    <td valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="middle" bgcolor="#FFFFFF"  style="width: 845px; height: 26px"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td align="left"><a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a>
			  <a href="<%= Link.url("/app_mgr/crm_mgr/","custombbs_log.aspx",Request.QueryString["param1"].ToString(),"","","","") %>">			  </a>                  <a class="redword" onClick="initialize(1,'1',event);ShowHide('1',null);return false;"><img src="/images/addcustombbs.jpg" alt="" width="95" height="24" style="border:0;" /></a></td>
            </tr>
        </table></td>
      </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
      <tr>
        <td valign="top" bgcolor="#FFFFFF">
          <table width="100%" border="0" cellspacing="0" cellpadding="20">
            <tr>
              <td valign="top"><span class="dvHeaderText">信息标题:　<%=news_titlestring%></span><br>
			      <br>
			      <%=contentstring %></td>
            </tr>
        </table></td>
      </tr>
    </table>
    <table width="100%" border="0" cellpadding="3" cellspacing="1"  class="lvt small">
      <tr class="lvtCol">
        <td height="25" align="center"> 序号</td>
        <td align="center" style="height: 18px;"> 回复内容( 回复人/ 发布时间)</td>
      </tr>
      <%=contentstring1 %>
      <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
        <td align="center" colspan="8" height="35" class="but1" style="width: 100%;">
          <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
      共 <%=total%> 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/ <%=maxpage%> 页，每页 <%=pagesize%> 个&nbsp; <a href="<%=Link.url("/app_mgr/crm_mgr/","news_view.aspx",news_id,"1","","","") %>"> 首页</a> <a href="<%=Link.url("/app_mgr/crm_mgr/","news_view.aspx",news_id,(nowpage-1).ToString(),"","","") %>"> 上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/crm_mgr/","news_view.aspx",news_id,(nowpage+1).ToString(),"","","") %>">下一页</a>&nbsp; <a href="<%=Link.url("/app_mgr/crm_mgr/","news_view.aspx",news_id,maxpage.ToString(),"","","") %>"> 尾页</a></td>
      </tr>
    </table></td>
  </tr>
</table>

 
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>

