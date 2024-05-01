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
    public string contentstring;
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;

    protected StringBuilder selectsb = new StringBuilder();
    protected string news_id = "";


    protected StringBuilder selectdatatypesb = new StringBuilder();


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param3"] == null || Request.QueryString["param3"] == "")
        {

            //显示我发布的 信息列表

            ShowPage(db);

        }

        else
        {

            if (Request.QueryString["param3"] == "set")
            {



                if (Request.Form.Get("sel") == null || Request.Form.Get("sel").ToString() == "")
                {
				    db.closedb();
					    Fun.goback("","请先选择信息！" ,"返回");
                    Response.End();
                }
                else
                {

                    string actiontype = "";
                    if (Request.Form.Get("actiontype") != null)
                        actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别

                    if (actiontype == "delete")
                    {
                        DeleteNewsbbs(db);

                    }

                }
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

            news_id = "";
            sqls = "select tbnews.id as news_id,tbnews.news_title,tbnewsbbs.id,tbuser.username,tbnewsbbs.content,tbnewsbbs.createtime from (tbnewsbbs left join tbnews on tbnews.id=tbnewsbbs.news_id ) left join tbuser on tbnewsbbs.userno=tbuser.userno where tbnewsbbs.isdelete=0 and tbnews.userno=? order by tbnews.createtime desc,tbnewsbbs.createtime desc";


        OdbcParameter[] param1 ={ 
                       new OdbcParameter("@userno",OdbcType.VarChar,50)  };
        param1[0].Value = Session["userno"].ToString();
        datatable = db.GetTable(sqls, param1);

        //分页页面显示
        contentstring = "";
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
            sb.Append(" <tr bgcolor=white onMouseOver=\"this.className='lvtColDataHover'\" onMouseOut=\"this.className='lvtColData'\">");
			sb.Append("<td height=\"50\" align=\"center\"   valign=\"top\">" + id.ToString() + "</td>\n");
            sb.Append("<td height=\"50\" align=\"center\"  valign=\"top\"><br>");
			if (Request.ServerVariables["LOCAL_ADDR"]==Request.ServerVariables["REMOTE_ADDR"])
			sb.Append("<input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\"  value=\"" + datatable.Rows[i]["id"].ToString() + "\"/>\n");
			sb.Append("<br><img src=\"/images/defhead.gif\"></td>\n");
            sb.Append("<td height=\"150\" align=\"left\"  valign=\"top\"><font class=\"fontBold\">留言人:</font>" + datatable.Rows[i]["username"].ToString() + "\n");
            sb.Append("" + datatable.Rows[i]["createtime"].ToString() + "\n");
            sb.Append("　<font class=\"fontBold\">信息名称:</font>");
			sb.Append("<a  href=\""+Link.url("/app_mgr/news_mgr/","news_view.aspx",datatable.Rows[i]["news_id"].ToString(),"","","","") + "\"> &nbsp;&nbsp;" + datatable.Rows[i]["news_title"].ToString() + "</a><br>");
			sb.Append("" + datatable.Rows[i]["content"].ToString() + "<br></td>");

            id++;
        }

        contentstring = sb.ToString();

    }





    /// <summary>
    /// ///////////删除资料
    /// </summary>
    /// <param name="db"></param>

    protected void DeleteNewsbbs(DBClass db)
    {


     
        //删除原表
        string delete_sql = "update tbnewsbbs set isdelete =1 where tbnewsbbs.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(delete_sql, null);
        db.closedb();


			   Fun.alert("","删除成功！",Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",Request.QueryString["param1"].ToString(),"","","","") ,"返回");
        Response.End();


    }







    /// <summary>
    /// /////////移动类别
    /// </summary>
    /// <param name="db"></param>
    protected void MoveType(DBClass db)
    {

        string up_sql = "update tbnews set type_id=? where tbnews.id in (" + Request.Form.Get("sel").ToString() + ")";
        OdbcParameter pa = new OdbcParameter("@newtype", OdbcType.Int, 4);
        pa.Value = Request.Form.Get("newstype2").ToString();


        db.ExecuteNonQuery(up_sql, pa);
        db.closedb();

		   Fun.alert("","移动成功！",Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx","","","","","") ,"返回");
        Response.End();
    }


</script>
<html>
<head id="Head1" runat="server">
    <title>我发布的信息</title>
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
	var a = new xWin("1",550,300,250,b+20,"<strong>&nbsp;您将以[<%=Session["username"]%>]身份回复此信</strong>","<iframe width=\"550\" frameborder=\"0\" height=\"300\" src=\"<%=Link.url("/app_mgr/news_mgr/","newsbbs_add.aspx",news_id,"","","","")%>\"'></iframe>");
    ShowHide("1","none");
}
</script>

</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
	<form action="<%=Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",news_id,"","set","","") %>" method="post" name="selform2" >
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">回复留言明细</font></b> <a class="redword" onClick="initialize(1,'1',event);ShowHide('1',null);return false;"></a></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>&nbsp;</td>
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
                                         <td align="left">
										 <a onClick="javascript:history.go(-1);" href="#"><img src="/images/goback.jpg" style="border:0;" alt="" /></a>
										<%
										 if (Request.ServerVariables["LOCAL_ADDR"]==Request.ServerVariables["REMOTE_ADDR"])
										 {%>
										 <a onClick="{if(confirm('此操作将删除信息至回收站！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" />
										 </a>
										 <%}%>									     </td>
                                       </tr>
                                     </table>
                                   </td>
                                 </tr>
                    
                                 
                           </table>

 			<form action="<%=Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",news_id,"1","set","","") %>" method="post" name="selform" >

     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
         <tr class="lvtCol">
             <td height="30" align="center">
                 序号</td>
             <td align="center" style="height: 18px;">
                 <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"></td>
             <td align="center" style="height: 18px;">回复信息 回复内容 回复人/发布时间</td>
             </tr>
          
        <%=contentstring %>
         <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
             <td align="center" colspan="8" height="35" class="but1">                 <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
                 共
                 <%=total%>
                 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/
                 <%=maxpage%>
                 页，每页
                 <%=pagesize%>
                 个&nbsp; <a href="<%=Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",news_id,"1","","","") %>">
                     首页</a> <a href="<%=Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",news_id,(nowpage-1).ToString(),"","","") %>">
                         上一页</a> &nbsp;<a href="<%=Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",news_id,(nowpage+1).ToString(),"","","") %>">下一页</a>&nbsp;
                 <a href="<%=Link.url("/app_mgr/news_mgr/","newsbbs_mylog.aspx",news_id,maxpage.ToString(),"","","") %>">
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
