<%@ Page Language="C#"  ValidateRequest="false" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">

    protected string idd = "";
    protected string news_title = "",mobilepwd="";
    protected StringBuilder typeselect = new StringBuilder();
    protected string type_id;

    protected void Page_Load(object sender, EventArgs e)
    {


        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "")
            {
                  Fun.goback("","参数错误！","返回");
                db.closedb();
                Response.End();
            }
            else
            {
                idd = Request.QueryString["param1"].ToString();

                DataTable dt = db.GetTable("select news_title,type_id,mobilepwd from tbnews where id=" + idd + " order by createtime desc");
                if (dt.Rows.Count > 0)
                {
                    type_id = dt.Rows[0]["type_id"].ToString();
					mobilepwd=dt.Rows[0]["mobilepwd"].ToString();
                    news_title = dt.Rows[0]["news_title"].ToString();
                }
                DataTable typetable = db.GetTable("select * from tbnewstype", null);
                for (int i = 0; i < typetable.Rows.Count; i++)
                {
			if (typetable.Rows[i]["id"].ToString()!="12" ||  Session["userid"].ToString()=="admin")
                {
                    typeselect.Append("<option value=\"");
                    typeselect.Append(typetable.Rows[i]["id"].ToString() + "\"");
                    if (type_id == typetable.Rows[i]["id"].ToString())
                        typeselect.Append("selected=\"selected\" ");
                    typeselect.Append(">" + typetable.Rows[i]["typename"].ToString() + "</option>");
                }
				}


            }
        }

        else
        {

            if (Request.QueryString["param2"].ToString() == "saveedit")
            {
        
                StringBuilder sb = new StringBuilder();
                string news_titleedit = Request.Form.Get("news_title").ToString();
                sb.Append(Request.Form.Get("Contents1").ToString());
                sb.Append(Request.Form.Get("Contents2").ToString());
                sb.Append(Request.Form.Get("Contents3").ToString());
                sb.Append(Request.Form.Get("Contents4").ToString());
                sb.Append(Request.Form.Get("Contents5").ToString());
				
	
                string updatesql = "update tbnews set news_title=?,mobilepwd=?,content=?,type_id=?,createtime=? where id=?";
                OdbcParameter[] param ={ 
                   new OdbcParameter("@news_title",OdbcType.VarChar,100),
				   new OdbcParameter("@mobilepwd",OdbcType.VarChar,100),
                    new OdbcParameter("@content",OdbcType.Text),
                    new OdbcParameter("@type_id",OdbcType.Int,4),
                    new OdbcParameter("@createtime",OdbcType.DateTime),
                    new OdbcParameter("@id",OdbcType.Int,4)
                };
				
				
				
                param[0].Value = Request.Form.Get("news_title").ToString();
				param[1].Value = Request.Form.Get("mobilepwd").ToString();
                param[2].Value = sb.ToString();
			  	
                param[3].Value = Convert.ToInt32(Request.Form.Get("newstype").ToString());
                param[4].Value = DateTime.Now.ToString();
                param[5].Value = Convert.ToInt32(Request.QueryString["param1"].ToString());
                 db.ExecuteNonQuery(updatesql, param);
				 
				 
                db.closedb();
			    Fun.alert("","修改信息成功！",Link.url("/app_mgr/news_mgr/","news_mynews.aspx","","","","","") ,"返回");
                //Response.Redirect(Link.url("/app_mgr/news_mgr/","news_mynews.aspx","","","","",""));
                Response.End();


            }

        }







        db.closedb();
    }







</script>
<html>
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
<SCRIPT LANGUAGE="JAVASCRIPT" SRC="/htmleditor/edt_main.js"></SCRIPT>
<SCRIPT LANGUAGE="JAVASCRIPT" SRC="/htmleditor/edt_color_slt.js"></SCRIPT>
<SCRIPT LANGUAGE="JAVASCRIPT" SRC="/htmleditor/edt_mo_slt.js"></SCRIPT>
<link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
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
<myhead:myhead ID="Myhead1" runat="server" /> <div>
    <form name="form1" method="post" action="" >
     <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" align="left" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">信息修改</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	  <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="20" class=delete>　提示：修改之后，发布日期将自动调整为最新时间。　</td>
        </tr>
      </table></td>
  </tr>
</TABLE>

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

    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="850" align="center"><table border="0" align="center" style="width: 689px">
          <tr>
            <td width="90" style="height: 27px"> 信息类型： </td>
            <td style="width: 223px; height: 27px;">
              <select name="newstype" style="height:24px;">
                <option value="0">选择信息投送的类别</option>
                <%= typeselect.ToString() %>
              </select>
            </td>
          </tr  >
          <tr>
            <td width="90" style="height: 27px" > 信息标题：</td>
            <td  style="height: 27px;">
              <input type="text" id="news_title" name="news_title" value="<%= news_title %>"  style="width: 300px;height:20px"/>
              手机访问密码:
              <input type="text" id="mobilepwd" name="mobilepwd" value="<%=mobilepwd%>">
            </td>
          </tr>
          <tr>
            <td width="90" valign="top" style="height: 24px">信息内容： </td>
            <td>
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
		   	   [ "0 80px 20px 60px" ,"-9px 0 0 17px","字体","imgFontface","fontface",247]
		   	  ,[ "0 100px 20px 80px","-8px 0 0 24px","字号","imgFontsize","fontsize",285]
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
		   	var fcL=301,bcL=335;
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
              <div style="width:144px;height:100px;position:absolute;top:50px;left:50px;display:none" ID="dvForeColor" onblur="BrdBlur();">
                <TABLE CELLPADDING=0 CELLSPACING=0 style="border:1px #888888 solid" width="218" height="25">
                </TABLE>
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
              <div style="position:absolute;top:180px;left:300px;display:none;border:1px solid #888888;background:#f6f6f6;" ID="dvMo" onblur="BrdBlur();"></div>
              <div id="divEditor">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                  <tr>
                    <td style="border:1px solid #81a9ce;border-top:0;background:#fff;">
                      <IFRAME class="HtmlEditor" ID="HtmlEditor" name="HtmlEditor" style="height:400px;width:100%;background:#fff;" frameBorder="0" marginHeight=0 marginWidth=0 src="/htmleditor/blank.aspx?param1=<%=idd%>"  onload="SetDiv();"></IFRAME>
                      <textarea ID="sourceEditor"  name="sourceEditor" style="height:400px;width:100%;marign:0;padding:0;font:normal 12px Tahoma;display:none;word-break:break-all;border:none;background:#fff;" onpropertychange="try{parent.SourceEditor_PropertyChange();}catch(e){}">
        </textarea>
                    </td>
                  </tr>
                </table>
            </div></td>
          </tr  >
          <tr>
            <td width="90" style="height: 24px"> </td>
            <td style="width: 223px; height: 24px;">
              <input type="hidden" name="editid" value="<%= idd %>" />
              <input name="submitbt" type="button" onClick="submitcontent();" value="确定修改" style="width: 73px" />
        &nbsp;
              <input type="button" name="back" onClick="javascript:history.go(-1);" value="返回" style="width: 79px" />
            </td>
          </tr  >
        </table></td>
      </tr>
    </table>
    </form>
 </div>
  <SCRIPT LANGUAGE="JavaScript"> 

 function submitcontent()
 {

   if(document.form1.news_title.value==""){window.alert("新闻名称不能为空！");document.form1.news_title.focus();return (false);}
   if(document.form1.newstype.value=="0"){window.alert("请选择新闻类别！");return (false);}

    var dd=GetContents();
     if(dd==""){window.alert("请输入新闻内容！");return (false);}

	document.getElementById("Contents1").value=dd.substring(0,30000);
	document.getElementById("Contents2").value=dd.substring(30000,60000);
	document.getElementById("Contents3").value=dd.substring(60000,90000);
	document.getElementById("Contents4").value=dd.substring(90000,120000);
	document.getElementById("Contents5").value=dd.substring(120000,150000);
	document.form1.action="<%=Link.url("/app_mgr/news_mgr/","news_edit.aspx",Request.QueryString["param1"],"saveedit","","","") %>"
    document.form1.submit(); 	
    
 
 }
</SCRIPT>
 <br>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
