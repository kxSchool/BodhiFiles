<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<HTML>
<HEAD>
<TITLE>金石协同办公管理系统</TITLE>

<STYLE>
DIV {
	FONT-SIZE: 9pt; LINE-HEIGHT: 15pt
}
BODY {
	SCROLLBAR-FACE-COLOR: #f6f7fb; SCROLLBAR-HIGHLIGHT-COLOR: #e8ebf1; SCROLLBAR-SHADOW-COLOR: #e8ebf1; SCROLLBAR-3DLIGHT-COLOR: #e8ebf1; SCROLLBAR-ARROW-COLOR: #000000; SCROLLBAR-TRACK-COLOR: #e8ebf1; SCROLLBAR-DARKSHADOW-COLOR: #e8ebf1
}
TABLE {
	FONT-SIZE: 9pt; LINE-HEIGHT: 15pt
}
.td1 {
	BORDER-RIGHT: #cccccc 1px solid; BORDER-TOP: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid; BORDER-BOTTOM: #cccccc 1px solid
}


</style>


<SCRIPT language=JavaScript>
<!--

function $( id ){return document.getElementById( id );}


/**
 * 对象坐标
 */
function fPosition(oElement) {
	if(!oElement){
		var oElement = this;
	}
    var valueT = 0, valueL = 0;
    do {
      valueT += oElement.offsetTop  || 0;
      valueL += oElement.offsetLeft || 0;
      oElement = oElement.offsetParent;
    } while (oElement);
    return [valueL, valueT];
};
function isChildNode(e, id){
	var e = e || event;
	var target = e.target || e.srcElement;
	if(target.id == "Top_catchword_pic" || target.id == "Top_catchword_words") return true;
	while(target){
		if(target.id == id){
			return true;
		}
		if(target.parentNode){
			target = target.parentNode;
		}else{
			return false;
		}
	}
	return false;
}
function hideTips(){
	if(!window.t){
		t = window.setTimeout('$("J_div").style.display = "none";t=null;', 5000);
	}
}
document.onmouseover = function(e){
	if(isChildNode(e, "J_div")){
		window.clearTimeout(t);
		t = null;
	}else{
		hideTips();
	}
}

	function fEvent(sType,oInput){
		switch (sType){
			case "focus" :
				oInput.isfocus = true;
				oInput.style.backgroundColor='#FFFFD8';
			case "mouseover" :
				oInput.style.borderColor = '#99E300';
				break;
			case "blur" :
				oInput.isfocus = false;
				oInput.style.backgroundColor="";
			case "mouseout" :
				if(!oInput.isfocus){
					oInput.style.borderColor='#A1BCA3';
				}
				break;
		}
	}


//-->
</SCRIPT>


    <script type="text/javascript" language="javascript">
 function form_check(){
   var myform =document.getElementById("form1");
   var username=document.getElementById("username");
     var pwd=document.getElementById("pwd");
       var checkcode=document.getElementById("checkcode");
       
	   
   if(username.value==""){window.alert("登录名不能为空");username.focus();return (false);}
   if(pwd.value==""){window.alert("登录密码不能为空");pwd.focus();return (false);}
   if(checkcode.value==""){window.alert("验证码不能为空");checkcode.focus();return (false);}
    //alert(username.value+" "+pwd.value+"  "+checkcode.value);
	//myform.action="ChkLogin.aspx";
    // myform.submit();
   return true;
      }


function reloadcode()
{
   location.reload();
}

function closewindows()
{
  window.close();
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
		obj.innerHTML = "<img src=\"images/0.gif\" style=\"padding-left:" + (530-100) + ";\">";
	}
	else
	{
		win.style.height  = parseInt(tit.style.height) + 2*2;
		sha.style.height  = win.style.height;
		obj.innerHTML = "<img src=\"images/2.gif\" style=\"padding-left:" + (530-100) + ";\">";
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
				+ "<span style='width:12;border-width:0px;color:white;padding-top:3px;' onclick='min(this)'><img src=\"images/0.gif\" style=\"padding-left:" + (this.width-100) + ";\"></span>"
				+ "<span style='width:12;border-width:0px;color:white;padding-top:3px;' onclick='reloadcode()'><img src=\"images/r.gif\"></span>"
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

function initialize()
{

	var a = new xWin("1",530,290,300,180,"<strong>&nbsp;资料直传</strong>","<iframe width=\"520\" frameborder=\"0\" height=\"260\" src=\"app_mgr/ziliao_mgr/data_uploaddirect.aspx\"'></iframe>");
	
	ShowHide("1","none");//隐藏窗口1
}


</script>



<LINK href="css/hanxin.css" type=text/css rel=stylesheet>



</HEAD>

<BODY vLink=#ffffff aLink=#ffffff link=#ffffff bgColor=#102873 leftMargin=0 topMargin=0 scroll=no>
<TABLE height="100%" cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TR>
    <TD align=middle>


<TABLE width=746 height=440 border=0 align="center" cellPadding=0 cellSpacing=0>
<TR>
<TD width="746" vAlign=top background="images/baibianpingtai3.2.jpg">
<TABLE width="746" height="90" border=0 cellPadding=0 cellSpacing=0>
  <TR>
    <TD vAlign=bottom colSpan=2 height=70><table width="746" height="70" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="380" height="80" valign="bottom"><table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="25">&nbsp;</td>
              <td height="32" valign="bottom" ><a class="J_icon1" id="Top_catchword_pic" onMouseOver="document.getElementById('J_div').style.display=''"><font color="#FFFFFF" size="2" style="MARGIN-LEFT: 4px;"> 公共服务▲</font></a> </td>
            </tr>
          </table></td>
          <td width="366" valign="bottom"><table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
              <td valign="bottom"><B><FONT 
                  style="FONT-SIZE: 28px; LETTER-SPACING: -1pt;MARGIN-TOP: 3px; LINE-HEIGHT: 150%" face=楷体_GB2312 
                  color=#ebeadb>金石协同办公管理系统</FONT></B></td>
            </tr>
          </table></td>
        </tr>
      </table></TD>
  </TR>
  <TR>
    <TD width="455" rowspan="2" valign="top"><table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="25">&nbsp;</td>
          <td width="114" valign="middle" >
		  <DIV id=J_div style="display:none; ">
                <DIV id=J_intr>
				<A class=J_icon2 onClick="initialize();ShowHide('1',null);return false;" >资料直传</A>
				<A class=J_icon2 href="/phone" >手机登陆</A>
				<A class=J_icon2 href="/rgtj/index.html" >调查试卷</A>
				</DIV>
            </DIV>
			

			</td>
          </tr>
      </table>　    </TD>
    <TD width="291" height="85" vAlign=top>　<BR>
        　    </TD>
  </TR>
  <TR>
    <TD width="291" valign="top">
      <TABLE cellSpacing=0 cellPadding=0 width=206 border=0>
       <FORM name="form1" id="form1"
                      method="post" action="ChkLogin.aspx"> 
					  <TR valign="bottom">
          
            <TD width="55" height=32 align="right" noWrap>用户名：</TD>
            <TD>
                <INPUT class=css0 size=19 id="username" name="username" style=" width:90pt;height:23px;"></TD>
          
        </TR>
        <TR valign="bottom">
          <TD height=35 align="right" noWrap>密　码：</TD>
          <TD>
              <INPUT class="css0"  id="pwd" type="password" size=19  name="pwd" style=" width:90pt;height:23px;"></TD>
        </TR>
        <TR valign="bottom">
          <TD height=37 align="right" noWrap>验证码：</TD>
          <TD><table border="0" cellspacing="0" cellpadding="0">
                                                                  <tr>
                                                                    <td><input name="checkcode" type="text" id="checkcode" style=" width:38pt;height:23px;" size="6" maxlength="4"></td>
                                                                    <td><font face="宋体">&lt;--</font></td>
                                                                    <td><img id="codeimg" width="50px" style="cursor:hand" height="24px" onClick="reloadcode()" src="<%=Link.url("/","checkcode.aspx","","","","","")%>" alt="照此输入，看不清请点击重换" /></td>
                                                                  </tr>
                        </table></TD>
        </TR>
        <TR>
          <TD></TD>
          <TD height="37" valign="bottom"> <input  src="images/dl.jpg" type="image" onClick="return form_check();">
            <a href="javascript:window.close();"><img src="images/gb.jpg" border="0"></a></TD>
        </TR></form>
    </TABLE></TD>
  </TR>
  <TR>
    <TD colSpan=2 align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="56%" height="110">&nbsp;</td>
        <td width="44%" valign="bottom">　南通金石信息科技有限公司 © 2009 </td>
      </tr>
    </table></TD>
  </TR>
</TABLE></TD>
</TR>
</TABLE>
			
</TD>
</TR>
</TABLE>


<!--顶部浮动层-->


</BODY></HTML>
