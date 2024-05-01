<%@ Page Language="C#"  ValidateRequest="false"%>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>


<script runat="server">

    protected StringBuilder sb = new StringBuilder();
    protected StringBuilder selecttype = new StringBuilder();
	protected StringBuilder selectsb = new StringBuilder();
	protected string type_idd = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();
		DataTable typetable = db.GetTable("select * from tbvisittype order by createtime desc", null);
        for (int i = 0; i < typetable.Rows.Count; i++)
        {
            selectsb.Append("<option value=\"");
            selectsb.Append(typetable.Rows[i]["id"].ToString() + "\"");
            if (typetable.Rows[i]["id"].ToString() == type_idd)
            {
                selectsb.Append("selected = \"selected\"");
            }

            selectsb.Append(">" + typetable.Rows[i]["typename"].ToString() + "</option>");
        }
        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {



        }
        else
        {

            if (Request.QueryString["param2"].ToString() == "addcustombbs")
            {

                OdbcParameter[] param ={ 
                   new OdbcParameter("@news_id",OdbcType.Int),
                    new OdbcParameter("@userno",OdbcType.VarChar),
                    new OdbcParameter("@content",OdbcType.Text),
                    new OdbcParameter("@createtime",OdbcType.DateTime),
                     new OdbcParameter("@isdelete",OdbcType.Int)
                };
                param[0].Value = Request.QueryString["param1"].ToString();
				       sb.Append(Request.Form["Contents1"]);
				 sb.Append(Request.Form["Contents2"]);
				  sb.Append(Request.Form["Contents3"]);
				   sb.Append(Request.Form["Contents4"]);
				    sb.Append(Request.Form["Contents5"]);
             
                param[1].Value =  Session["userno"].ToString();
                param[2].Value = sb.ToString();
                param[3].Value = DateTime.Now;
                param[4].Value =0;
                db.ExecuteNonQuery("insert into tbcustombbs (news_id,userno,content,createtime,isdelete)values(?,?,?,?,?)", param);
                db.closedb();
			    Fun.alert("","发布信息成功！",null,null);
                //Response.Redirect( Link.url("/app_mgr/news_mgr/","news_mynews.aspx","","","","",""));
                Response.End();
            }

        }



        db.closedb();
    }

</script>
<html>
<head>
<title>信息发布</title>
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
// <!CDATA[



 

// ]]>
</script>

<link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<SCRIPT LANGUAGE="JAVASCRIPT" SRC="/htmleditor/bbs_edt_main.js"></SCRIPT>
<SCRIPT LANGUAGE="JAVASCRIPT" SRC="/htmleditor/edt_color_slt.js"></SCRIPT>
<SCRIPT LANGUAGE="JAVASCRIPT" SRC="/htmleditor/edt_mo_slt.js"></SCRIPT>
<style type="text/css">
p {margin:0;padding:0;}
a {font-size:12px;}
td {font-size:12px;}
img {border:4;}
td.icon {width:24px;height:24px;text-align:center;vertical-align:middle;}
td.sp {width:8px;height:24px;text-align:center;vertical-align:middle;}
td.xz {width:47px;height:24px;text-align:center;vertical-align:middle;}
td.bq {width:49px;height:24px;text-align:center;vertical-align:middle;}
div a.n {height:16px; line-height:16px;display:block;border:1px solid #f6f6f6;padding:2px;color:#000000;text-decoration:none;}
div a.n:hover {background:#ffeec2;border:1px solid #000080;}
</style>
<style type="text/css">
.abtn {color:#039;font:normal 12px Tahoma;}
.ico {	height: 24px;	width: 24px; vertical-align:middle; text-align:center;
}
.ico2 {	height: 24px;	width: 27px; vertical-align:middle; text-align:center;
}
.ico3 {	height: 24px;	width: 25px; vertical-align:middle; text-align:center;
}
.ico4 {	height: 24px;	width: 8px; vertical-align:middle; text-align:center;
}
body{
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	background:#fff;
}
p {margin:0;padding:0;}
</style>
</head>
<body onLoad="OnLoad();try{parent.HtmlEditor_Onload();}catch(e){}">
<form name="form1" id="form1" method="post" action="">
  <div>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="100%" align="center"><table width="100%" border="0" align="center">
          <tr>
            <td width="100%">
              <table id="tmp" width="100%"  border="0" cellpadding="0" cellspacing="0" style="border:1px solid #81a9ce;background:#f2f7fb;">
                <tr>
                  <td height="26" style="padding-left:7px;border:1px solid #fff;"><table border="0" cellspacing="0" cellpadding="0" >
                      <tr>
                        <td>
                          <script>
			var dt=
			[ ["0 20px 20px 0"   ,"-10px 0 0 0","加粗" ,"Bold"  ]
			,["0 40px 20px 20px","-10px 0 0 0","斜体" ,"Italic"]
			,["0 60px 20px 40px","-10px 0 0 0","下划线","Underline"]
			];
			var a = (commHead + 'onclick="ExecCmd(\'$font$\');"' + commFunc + ' />').split("$");
			output(dt,a);
			a = (commHeadMask + ' name="tool_mask"/>').split("$");
			output(dt,a);
			</script>
                          <img src="/htmleditor/images/editoricon.gif"  style="position:absolute;clip:rect(0 322px 20px 320px);margin:-10px 0 0 -255px;" />
                          <script>
		   	var dt = 
		   	[
		   	   [ "0 80px 20px 60px" ,"-9px 0 0 17px","字体","imgFontface","fontface",80]
		   	  ,[ "0 100px 20px 80px","-8px 0 0 24px","字号","imgFontsize","fontsize",110]
		   	];
		    var a = (sComm + 'id="$id$" onClick=\'SaveEvent(event);DispBoard("$display$","","$left$");\' />').split("$");
            output(dt,a); 
			a = (commHeadMask + ' name="tool_mask"/>').split("$");
			output(dt,a);
           </script>
                          <img src="/htmleditor/images/editoricon.gif"  style="position:absolute;clip:rect(0 322px 20px 320px);margin:-10px 0 0 -138px;" />
                          <script>
		    var dt = 
		   	[
		   	   [ "0 120px 20px 100px","-8px 0 0 88px","左对齐","Justifyleft"]
		   	  ,[ "0 140px 20px 120px","-8px 0 0 88px","中间对齐","Justifycenter"]
		   	  ,[ "0 160px 20px 140px","-8px 0 0 89px","右对齐","Justifyright"]
		   	];
		     var a = (sComm + 'onclick="ExecCmd(\'$format$\')" />').split("$");
            output(dt,a);
			a = (commHeadMask + ' name="tool_mask"/>').split("$");
			output(dt,a);
		   </script>
                          <img src="/htmleditor/images/editoricon.gif" style="position:absolute;clip:rect(0 322px 20px 320px);margin:-10px 0 0 -67px;" alt="间隔线" />
                          <script>		   	
		   	var dt = 
		   	[
		   	   [ "0 180px 20px 160px","-8px 0 0 101px","数字编号","Insertorderedlist"]
		   	  ,[ "0 200px 20px 180px","-8px 0 0 106px","项目编号","Insertunorderedlist"]
		   	  ,[ "0 220px 20px 200px","-8px 0 0 108px","增加缩进","Outdent"]
		   	  ,[ "0 240px 20px 220px","-8px 0 0 109px","减少缩进","Indent"]
		   	  ,'<img src="/htmleditor/images/editoricon.gif"  style="position:absolute;clip:rect(0 322px 20px 320px);margin:-10px 0 0 34px;" alt="间隔线" />'
		   	];
		   	var a = (sComm + 'onclick="ExecCmd(\'$format$\')" />').split("$");
		    output(dt,a);
			a = (commHeadMask + ' name="tool_mask"/>').split("$");
			output(dt,a);
		   </script>
                          <script>
		    var dt = 
		   	[
		   	   [ "0 260px 20px 240px","-8px 0 0 -108px","字体颜色","OnForeColor(event)"]
		   	  ,[ "0 280px 20px 260px","-8px 0 0 -104px","背景颜色","OnBackColor(event)"]
		   	  ,[ "0 300px 20px 280px","-8px 0 0 81px","增加链接","addHyperLink()"]	  
		   	];
		   	var fcL=135,bcL=155;
		   	var a = (sComm + ' onclick="$onclick$" />').split("$");
		   	output(dt,a);
		   
			a = (commHeadMask + ' name="tool_mask"/>').split("$");
			output(dt,a);
		   </script>
                          <script>
		    var dt = 
		   	[
		   	   [ "0 380px 20px 362px","-8px 0 0 24px","表情","OnMo(event)"]  
		   	];
		   	var a = (sComm + ' onclick="$onclick$" />').split("$");
		   	output(dt,a);
		   
			a = (commHeadMask + ' name="tool_mask"/>').split("$");
			output(dt,a);
		   </script>
                          <script>
		    //var dt = 
		   	//[
		   	//   [ "0 362px 20px 322px","-8px 0 0 90px","上传图片","addImage()"]
			//];
			//var a = (sComm + ' onclick="$onclick$" id="add_pic_id" />').split("$");
			//output(dt,a);
			//a = (commHeadMask + ' id="add_pic_mask_id"/>').split("$");
			//output(dt,a);

			EnableToolBar(0);
		   </script>
                        </td>
                        <td width="1%" nowrap style="padding-left:418px;"><div id="htmlbtn" onClick="ChangeEditor();"><a class="abtn" href="javascript:void(0);"  title="编辑HTML源码">&lt;HTML模式&gt;</a></div>
                            <script> var l=parent.location+"";if(l.indexOf("setting")==-1){document.getElementById("htmlbtn").style.display = "";}
		   </script>
                        </td>
                      </tr>
                  </table></td>
                </tr>
              </table>
<div style="width:144px;height:100px;position:absolute;top:33px;left:50px;display:none" ID="dvForeColor" onblur="BrdBlur();">
                <table cellpadding=0 cellspacing=0 style="border:1px #888888 solid" width="218" height="25">
                </table>
              </div>
<div style="width:100px;height:100px;position:absolute;display:none;top:-500px;left:-500px" ID="dvPortrait" onblur="BrdBlur();"></div>
<div id="fontface" style="z-index:99; padding:1px; display:none; position:absolute;background:#f6f6f6;top:30px;left:0;border:1px solid #888888; width:110px; height:176px;" onblur="BrdBlur();">
<script>
var a = 
["'宋体';\">宋体</a>"
,"'黑体';\">黑体</a>"                     
,"'楷体_GB2312';\">楷书</a>" 
,"'幼圆';\">幼圆</a>" 
,"'Arial';\">Arial</a>"
,"'Arial Black';\">Arial Black</a>"
,"'Times New Roman';\">Times New Roman</a>"
//,"'Courier';\">Courier</a>"
,"'Verdana';\">Verdana</a>"
];
for(var i=0;i<a.length;i++)
  document.write('<a href="javascript:void(0)" onClick="ExecCmd(\'fontname\',(this.innerHTML==\'楷书\')?\'楷体_GB2312\':this.innerHTML);this.parentNode.style.display=\'none\'" class="n" style="font:normal 12px ' + a[i]);
</script>
</div>
<div id="fontsize" style="padding:1px; display:none; position:absolute;top:30px;left:0;background:#f6f6f6; border:1px solid #888888;width:115px; height:138px;line-height:28px" onblur="BrdBlur();">
<script>
var dt = 
[
 [1,'><font size=1>小</font></a>']
,[2,'><font size=2>中</font></a>']
,[4,'><font size=4>大</font></a>']
,[5,'style="line-height:28px;height:26px"><font size=5>较大</font></a>']
,[6,'style="line-height:36px;height:34px"><font size=6>最大</font></a>']
];
var a = '<a href="javascript:void(0)" onClick="ExecCmd(\'fontsize\',$size$);this.parentNode.style.display=\'none\'" class="n" $end$'.split("$"); 
output(dt,a);
</script>
</div>
<div style="position:absolute;top:30px;left:150px;display:none;border:1px solid #888888;background:#f6f6f6;" ID="dvMo" onblur="BrdBlur();"></div>
<div id="divEditor">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		
<tr><td style="border:1px solid #81a9ce;border-top:0;background:#fff;">
                      <iframe class="HtmlEditor" id="HtmlEditor" name="HtmlEditor" style="height:230px;width:100%;background:#fff;" frameborder="0" marginheight=0 marginwidth=0 src="about:blank"  onload="SetDiv();"></iframe>
                      <textarea id="sourceEditor"  name="sourceEditor" style="height:230px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;" onpropertychange="try{parent.SourceEditor_PropertyChange();}catch(e){}">
        </textarea>
                    </td>
                  </tr>
                </table>
            </div></td>
          </tr  >
          <tr>
            <td colspan="2" style="height: 24px">
             <select name="newstype2" style="height: 20px;">
                                 
                                 <% =selectsb.ToString() %>
                             </select> <input name="submitbt" type="button" onClick="submitcontent();" value="确定发布" style="width: 73px" />
&nbsp;
      <input type="button" name="back" onClick="javascript:history.go(-1);" value="重置" style="width: 79px" />            </td>
          </tr  >
        </table></td>
      </tr>
  </table>
    <textarea ID="Contents1"  name="Contents1" style="height:400px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;">
</textarea>
<textarea ID="Contents2"  name="Contents2" style="height:400px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;">
</textarea>
<textarea ID="Contents3"  name="Contents3" style="height:400px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;">
</textarea>
<textarea ID="Contents4"  name="Contents4" style="height:400px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;">
</textarea>
<textarea ID="Contents5"  name="Contents5" style="height:400px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;">
</textarea>
</form>
 
 <SCRIPT LANGUAGE="JavaScript"> 
function submitcontent(){
var dd=GetContents();
	document.getElementById("Contents1").value=dd.substring(0,30000);
	document.getElementById("Contents2").value=dd.substring(30000,60000);
	document.getElementById("Contents3").value=dd.substring(60000,90000);
	document.getElementById("Contents4").value=dd.substring(90000,120000);
	document.getElementById("Contents5").value=dd.substring(120000,150000);

	document.form1.action="<%= Link.url("/app_mgr/crm_mgr/","custombbs_add.aspx",Request.QueryString["param1"].ToString(),"addcustombbs","","","") %>"
	document.form1.submit();
}

</SCRIPT>


</body>
</html>
