<%@ Page Language="C#" %>
<%@ Import Namespace="SendMail" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>
<script runat="server">
public string mailcontent,companyname,email,smtp,smtp_email,smtp_username,smtp_password,info,counts,tot;
protected void Page_Load(object sender, EventArgs e)
{

	 DBClass db = new DBClass();
	 DataTable dt = db.GetTable("select count(*) as counts from tbcustom where  email like '%@%' and  send=false");
                if (dt.Rows.Count > 0)
                {
                    if (Convert.ToInt32(dt.Rows[0]["counts"].ToString())<5000)
					{
					counts = dt.Rows[0]["counts"].ToString();
					tot=dt.Rows[0]["counts"].ToString();
					}
					else
					{
					counts= dt.Rows[0]["counts"].ToString();
					tot=dt.Rows[0]["counts"].ToString();
					}
                }
				db.closedb();
}
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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

<script type="text/javascript" src="/jqueryui/js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="/jqueryui/js/jquery-ui-1.8.14.custom.min.js"></script>

<style type="text/css">
<!--
body{
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	padding-bottom: 0px;
	font: 62.5% "微软雅黑", sans-serif;
}
#bodys{
	margin-top:8px;
	margin-left:auto;
	margin-right:auto;
	width:644px;
	border: thin dotted #CCCCCC;
	height:444px;
	border-radius:5px 5px 5px 5px;	
}
#title{
	margin-left:auto;
	margin-right:auto;
	height:30px;
	border-bottom-width: thin;
	border-bottom-style: dotted;
	border-bottom-color: #CCCCCC;
	text-align: center;
	width:95%;
	padding-top:16px;
	font-size:15px;
	font-family:"微软雅黑";
	font-weight:bold;
	background-image: url(/default/imgs/mail.gif);
	background-repeat: no-repeat;
	background-position: 173px 8px;
}

#row{
	padding-top:10px;
	height:25px;
}

a{
color:#999999;
text-decoration:none;
}
.ac{
	color:#999999;
}
.ae{
	color:#ffffff;
}
 .ui-dialog-titlebar-close{
 display: ;
}
-->
</style>

<link rel="stylesheet" href="/jqueryui/css/redmond/jquery-ui-1.8.14.custom.css">

<title>邮件发送器</title>

</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
<TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small>
    <table>
        <tr>
          <td> <b><font color="#ffffff">邮件群发</font></b></td>
        </tr>
    </table>
    </td>
    <td align="center" nowrap class=small>
	 　</td>
  </tr>
</TABLE>
<div align="left">
  <div id="bodys">
<form id="form1" name="form1" action="#" method="post">
<div id="title">AJAX定时发送邮件</div>
<div id="row"></div>
<div id="row">
  <div id="col1" style="padding-left:270px;padding-top:25px;"><input type="submit" name="submit" value="开始发送" style="width:90px; height:35px; font-weight: bold;font-size:12px;" />
</div>
</div>
</form>
<div id="dialog" title="提示:">
<div id="msg" style="padding-top:30px;font-size:14px;font-family:'微软雅黑';text-align: center;">
</div>
</div>
</div>
<div id="dialog-modal" title="提交发送中... ...">
<h4 id="titles"></h4>
<div id="progressbar"></div>
</div>
<script type="text/javascript">
var mail;
var usermail;
var length;
var x;
var y;
var co;
var mesg;
var currentmail;
var time;
var siteurl = "custommail.aspx"; 
$(document).ready(function() {
	$("input:submit").button();
	$("input:submit").click(function() {
     starts();
     return false; 
    });
    
});

$('#dialog').dialog({
	autoOpen: false,
	width: 300,
    modal: false,
	buttons: {						
	}
});   

function starts(){
	co=1000;
    x=0;
	y=co ;
    currentmail=0;
    loaddialog();	
}

function loaddialog() {
    $( "#dialog:ui-dialog" ).dialog( "destroy" );
    $( "#dialog-modal" ).dialog({width:300,modal:true});
    time=setInterval("ajaxpost()",1500);
    $(".ui-dialog-titlebar-close").click(function(){
    clearInterval(time);
   })
}
    

		

function abc(msg){
    if (x<co && currentmail<=co ) {
        x=x+1;
        $("#progressbar").progressbar({value:x*100/co});
        $("#titles").html(currentmail + msg);
        time=setInterval("ajaxpost()",1500);
        currentmail=currentmail+1;
    } else {
        clearInterval(time);
        $("#titles").html('数据更新完成!');
        $("#progressbar").progressbar({value:100});
    }
}

function ajaxpost(){
clearInterval(time);
var page ='1';  
var b ='b'; 
    $.ajax({
        url:siteurl,
        type:'POST',
        dataType:'text',
        data:'page=' + encodeURIComponent(page) + '&b=' + encodeURIComponent(b) ,
        success:function(msg){
            abc(msg);
        }
    });
}
	



</script>


</div>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>