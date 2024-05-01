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
    protected StringBuilder selectfile = new StringBuilder();
    protected string type_idd = "";
    protected string filetype_idd = "";


    protected StringBuilder selectdatatypesb = new StringBuilder();
    protected string datatypeselect = ""; // 文件类别选择
    protected string mydept_id = "";     //本部门号


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            //初始化上传文件类型 下拉框
            StringBuilder selectdatatypesb = new StringBuilder();
            DataTable typetable = db.GetTable("select * from tbdatatype where userno='" + Session["userno"].ToString() + "'", null);

            for (int i = 0; i < typetable.Rows.Count; i++)
            {
                selectdatatypesb.Append("<option value=\"");
                selectdatatypesb.Append(typetable.Rows[i]["id"].ToString() + "\"");
                selectdatatypesb.Append(">" + typetable.Rows[i]["name"].ToString() + "</option>");
            }
            datatypeselect = selectdatatypesb.ToString();


            mydept_id = Session["dept_id"].ToString();


            //显示资料列表

            ShowPage(db);

        }

        else
        {




            if (Request.QueryString["param2"] == "set")
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
                    if (actiontype == "movetype")
                    {
                        MoveType(db);
                    }


                }

            }  //set

            if (Request.QueryString["param2"].ToString() == "search")
            {
                string condition = Request.Form.Get("param3").ToString();
                string datatype = Request.Form.Get("param4").ToString();
                string filetype = Request.Form.Get("param5").ToString();
                Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","data_search.aspx","","search",condition,datatype,filetype));
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
        double allfilesize = 0.0;
        string strsize;

        DataTable datatable = new DataTable();

        if (Request.QueryString["param4"] == null || Request.QueryString["param4"].ToString() == "")
        {
            type_idd = "";
            sqls = "select tbdata.*,tbdatatype.id as typeid,tbdatatype.name as typename from tbdata left join tbdatatype on tbdata.type_id=tbdatatype.id  where  tbdata.userno= ?  ";

        }
        else
        {
            type_idd = Request.QueryString["param4"].ToString();
            sqls = "select tbdata.*,tbdatatype.id as typeid,tbdatatype.name as typename from tbdata left join tbdatatype on tbdata.type_id=tbdatatype.id  where  tbdata.userno= ? and tbdata.type_id=" + type_idd;
        }


        if (Request.QueryString["param5"] == null || Request.QueryString["param5"].ToString() == "")
        {
            filetype_idd = "";
        }
        else
        {
            filetype_idd = Request.QueryString["param5"].ToString();
            sqls = sqls + " and  right(tbdata.fileurl,4)='" + filetype_idd + "'";

        }
        sqls = sqls + " order by tbdata.uptime desc";

        //填充下拉框
        DataTable typetable = db.GetTable("select * from tbdatatype where userno='" + Session["userno"].ToString() + "'", null);
        for (int i = 0; i < typetable.Rows.Count; i++)
        {
            selectsb.Append("<option value=\"");
            selectsb.Append(typetable.Rows[i]["id"].ToString() + "\"");
            if (typetable.Rows[i]["id"].ToString() == type_idd)
            {
                selectsb.Append("selected = \"selected\"");
            }

            selectsb.Append(">" + typetable.Rows[i]["name"].ToString() + "</option>");
        }

        //填充文件下拉框 
        DataTable typetables = db.GetTable("select RIGHT(fileurl, 4) AS fileurl2 from tbdata where userno='" + Session["userno"].ToString() + "' group by RIGHT(fileurl, 4)", null);
        for (int i = 0; i < typetables.Rows.Count; i++)
        {
            selectfile.Append("<option value=\"");
            selectfile.Append(typetables.Rows[i]["fileurl2"].ToString() + "\"");
            if (typetables.Rows[i]["fileurl2"].ToString() == filetype_idd)
            {
                selectfile.Append("selected = \"selected\"");
            }

            selectfile.Append(">" + typetables.Rows[i]["fileurl2"].ToString() + "</option>");
        }

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
            sb.Append("<td height=\"24\" align=\"left\" ><img src=\"/images/filetype/" + newext + ".gif\"/>&nbsp;<a  href=\""+Link.url("/app_mgr/ziliao_mgr/","data_down.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\">" + datatable.Rows[i]["filetitle"].ToString() + "</a></td>\n");
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
            sb.Append("<td height=\"24\" align=\"center\" ><a href=\"" +Link.url("/app_mgr/ziliao_mgr/", "data_infoedit.aspx",datatable.Rows[i]["id"].ToString(),"","","","") + "\">编辑</a></td>\n");
            sb.Append("<td height=\"24\" align=\"right\" width=60>" + strsize + "</td>\n");
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
        FileInfo f, tof;
        for (int i = 0; i < setfilestable.Rows.Count; i++)
        {

            frompath = ConfigurationSettings.AppSettings["data_center"].ToString() + setfilestable.Rows[i]["fileurl"].ToString();
            topath = ConfigurationSettings.AppSettings["delete_center"].ToString() + setfilestable.Rows[i]["fileurl"].ToString();
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
     
		   Fun.alert("","选中的文件已经成功取消共享",Link.url("/app_mgr/ziliao_mgr/", "data_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();


    }





    /// <summary>
    /// /////////移动类别
    /// </summary>
    /// <param name="db"></param>
    protected void MoveType(DBClass db)
    {



        string up_sql = "update tbdata set type_id=? where tbdata.id in (" + Request.Form.Get("sel").ToString() + ")";
        OdbcParameter pa = new OdbcParameter("@newtype", OdbcType.Int, 4);
        pa.Value = Request.Form.Get("datatype2").ToString();


        db.ExecuteNonQuery(up_sql, pa);
        db.closedb();
         Fun.alert("","移动成功",Link.url("/app_mgr/ziliao_mgr/", "data_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }

</script>
<html>
<head id="Head1" runat="server">
    <title>资料管理</title>
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

<!--   多文件上传弹出框部分    -->
<script type="text/javascript" language="javascript">
<!--

 
if(!x_open_path)
	var x_open_path = '/js/round/';	

var symbol_img = x_open_path + "symbol.gif";
var max_img = x_open_path + "max.gif";
var restore_img = x_open_path + "min.gif";
var close_img = x_open_path + "close.gif";
var help_img = x_open_path + "help.gif";
var title_img = x_open_path + "title.gif";
var bottom_img = x_open_path + "bottom.gif";
var intern_img = x_open_path + "intern.gif";
var grip_img = x_open_path + "grip.gif";
var forward_img = x_open_path + "forward.gif";
var back_img = x_open_path + "back.gif";
var border_img = x_open_path + "border.gif";
var loading_page = x_open_path + "loading.htm";
 

win_frame = "<div id='x_open_win' style='position:absolute;z-index:100; width: 420px; height: 350px ;left:10px;top:10px;font-size:12px; display:none ' onselectstart='return false'>\r\n";
win_frame += "<div>\r\n";
win_frame += "<table width='100%'  border='0' cellspacing='0' cellpadding='0'>\r\n";
win_frame += "	<tr>\r\n";
win_frame += "		<td width='19'><img src='" + symbol_img + "' width='19' height='21' border='0'  title='重新载入当前网页' onclick='xopen_reload();'//></td>\r\n";
win_frame += "		<td width='5' style='background: url(" + title_img + "); padding:0px'></td><td style='background: url(" + title_img + "); padding:0px' onmousedown='initialize_drag(event)' ondblclick='maximize()'><font color='#333333'><div id='title_msg_layer'><strong>title</strong></div></font>\r\n";
win_frame += "		</td>\r\n";
win_frame += "		<td style='background: url(" + title_img + "); padding:0px' onmousedown='initialize_drag(event)' ondblclick='maximize()'></td>\r\n";
win_frame += "	<td width='44' style='cursor:default; ' align='center'>";
win_frame += "<img src='" + help_img + "' width='12' height='21' border='0' onclick='xopen_about()' title='关于本程式' />";
win_frame += "<img src='" + max_img + "' id='max_button_name' onclick='maximize()' width='16' height='21' border='0' title='放大窗口' />";
win_frame += "<img src='" + close_img + "' onclick='closeit()' width='16' height='21' border='0' title='关闭窗口' />";
win_frame += "</td>\r\n";
win_frame += "	</tr>\r\n";
win_frame += "</table>\r\n";
win_frame += "</div>\r\n";
win_frame += "<div id='x_open_content' align=center style='width:100%;  margin: 0px;background-color: #ffffff;	MOZ-OPACITY:0.50;FILTER :  Alpha(opacity=100);'>\r\n";
win_frame += "<table style='width:100%; height:100%; margin: 0px;' border='0' cellpadding='0' cellspacing='0'>\r\n";
win_frame += "	<tr>\r\n";
win_frame += "		<td width='1'><img src='" + border_img + "' id='border_img_name1' border='0' style='border:0px; width:1px; height:317px; margin: 0px;' /></td>\r\n";
win_frame += "		<td>\r\n";
win_frame += "		<iframe id='x_open_frame' name='x_open_frame' src='" + loading_page + "' frameborder=0 noresize style='width:100%; height:100%;background-color: #ffffff;color: #333;margin: 0px; padding: 0px;border:0px '></iframe>\r\n";
win_frame += "		</td>\r\n";
win_frame += "		<td width='1'><img src='" + border_img + "' id='border_img_name2' border='0' style='border:0px; width:1px; height:317px; margin: 0px;' /></td>\r\n";
win_frame += "	</tr>\r\n";
win_frame += "</table>\r\n";
win_frame += "</div>\r\n";
win_frame += "<div align='center' style='width:100%;height:15px;background: url(" + bottom_img + ");' onselectstart='return false'>\r\n";
win_frame += "<table width='100%'  border='0' cellspacing='0' cellpadding='0'>\r\n";
win_frame += "	<tr>\r\n";
win_frame += "		<td width='19'><img src='" + intern_img + "' width='28' height='15' border='0' /></td>\r\n";
win_frame += "			<td width='42'><img src='" + back_img + "' width='19' height='13' border='0' title='后退' onclick='xopen_back();'/><img src='" + forward_img + "' width='19' height='13' border='0'  title='前进' onclick='xopen_forward();'/></td>\r\n";
win_frame += "		<td><div id='size_info_layer'>&nbsp;</div></td>\r\n";
win_frame += "		<td>&nbsp;</td>\r\n";
win_frame += "		<td width='19'><img src='" + grip_img + "' width='19' height='15' border='0' style='cursor:nw-resize' title='改变窗口大小' onmousedown='return initialize_resize(event)' /></td>\r\n";
win_frame += "	</tr>\r\n";
win_frame += "</table>\r\n";
win_frame += "</div>\r\n";
win_frame += "</div>\r\n";
win_frame += "<div id='x_open_win_border' style='position:absolute;z-index:100;width:0px;height:0px;display:none'></div>\r\n";
window.document.write(win_frame);


// obj
var x_open_win_id = document.getElementById("x_open_win");
var x_open_content_id = document.getElementById("x_open_content");
var title_msg_layer_id = document.getElementById("title_msg_layer");
var x_open_frame_id = document.getElementById("x_open_frame");
var max_button_name_id = document.getElementById("max_button_name");
var border_img_name1_id = document.getElementById("border_img_name1");
var border_img_name2_id = document.getElementById("border_img_name2");
var x_open_win_border_id = document.getElementById("x_open_win_border");	
var size_info_layer_id =  document.getElementById("size_info_layer");	

var dragapproved = false;
var dragresized = false;
var minrestore = 0;
var initialwidth, initialheight;
var x_open_ie5 = document.all && document.getElementById;
var x_open_ns6 = document.getElementById && !document.all;
var title_height = 36;
 

 
function x_open(title, url, width, height){
	if (!x_open_ie5 && !x_open_ns6)
		window.open(url, "", "width=width,height=height,scrollbars=1");
	else{
		x_open_win_id.style.display = '';

		initialwidth = width;
		initialheight = height ;
		change_size(initialwidth, initialheight);
		x_open_win_id.style.left = "200px";
		x_open_win_id.style.top=x_open_ns6 ? window.pageYOffset * 1 + 100 + "px" : iecompattest().scrollTop * 1 + 100 + "px";
		x_open_frame_id.src = url;
		title_msg_layer_id.innerHTML = '<font color=#333333>' + title + '</font>';
	}
}

function iecompattest(){
	return (!window.opera && document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function xopen_about(){
	str = "韩欣 版权所有";
	alert(str);
}
function xopen_back(){
	x_open_frame.history.back();
}
function xopen_forward(){
	x_open_frame.history.go(1);
}
function xopen_reload(){
	x_open_frame.location.reload();
}
function closeit(){
	x_open_frame_id.src = loading_page;
	x_open_win_id.style.display = "none";
	return true;
}


function maximize(){
	if (minrestore == 0){
		minrestore = 1; //maximize window
		max_button_name_id.setAttribute("src", restore_img);
		max_button_name_id.setAttribute("title", '还原窗口');
		w = x_open_ns6 ? window.innerWidth - 40 : iecompattest().clientWidth - 20;
		h = x_open_ns6 ? window.innerHeight - 40 : iecompattest().clientHeight - 20;
		change_size(w, h);
	}
	else{
		minrestore=0; //restore window
		max_button_name_id.setAttribute("src", max_img);
		max_button_name_id.setAttribute("title", '放大窗口');
		change_size(initialwidth, initialheight);
	}
	x_open_win_id.style.left = x_open_ns6 ? window.pageXOffset + 10 + "px" : iecompattest().scrollLeft + 10 + "px";
	x_open_win_id.style.top = x_open_ns6 ? window.pageYOffset + 10 + "px" : iecompattest().scrollTop + 10 + "px";
}

function change_size(w, h){ 
		if(w > 150 ) {
			x_open_win_id.style.width = w;
		}else{
			x_open_win_id.style.width = 150;
		}
		if(h > 0 ) {
			x_open_win_id.style.height = border_img_name1_id.style.height = border_img_name2_id.style.height = x_open_frame_id.style.height = h;
		}else{
			x_open_win_id.style.height = border_img_name1_id.style.height = border_img_name2_id.style.height = x_open_frame_id.style.height = 0;
			
		}
		size_info_layer_id.innerHTML = '<font style="font-size:11px;font-family:Courier New">size:' + remove_units(x_open_win_id.style.width) + 'x' + remove_units(x_open_win_id.style.height) + '</font>';
}
 
function remove_units(elem){
	return(parseInt(elem.replace(/px/g,"")));			
}
//<<<drag move

function initialize_drag(e){
	var evt = x_open_ns6 ? e : event;
	offsetx = evt.clientX;
	offsety = evt.clientY;
	tempx = parseInt(x_open_win_id.style.left);
	tempy = parseInt(x_open_win_id.style.top);

	dragapproved = true;
	//x_open_frame.style.display = 'none';
	x_open_frame_id.style.display = 'none';
	document.body.style.cursor = 'move';
	document.onmousemove = drag_drop;
	x_open_win_id.onmouseup = drag_drop_stop;
}

function drag_drop(e){
	if(dragapproved){
		var evt = x_open_ns6 ? e : event;
		x_open_win_id.style.left = tempx + evt.clientX - offsetx + "px";
		x_open_win_id.style.top = tempy + evt.clientY - offsety + "px";
	}
	return false;
}
function drag_drop_stop(e){
	dragapproved = false;
	//x_open_content_id.style.display = '';
	x_open_frame_id.style.display = '';
	document.body.style.cursor = 'default';
	document.onmousemove=null;
}
 
//>>>drag move

//resize===<<<
function initialize_resize(e){
	evt = x_open_ns6 ? e : event;
	x_open_win_border_id.style.left = x_open_win_id.style.left;
	x_open_win_border_id.style.top = x_open_win_id.style.top;
	x_open_win_border_id.style.width = x_open_win_id.style.width;
	x_open_win_border_id.style.height = x_open_win_id.style.height;

	click_x = evt.clientX;
	click_y = evt.clientY;
	evt_width = click_x - remove_units(x_open_win_id.style.left);
	evt_height = click_y - remove_units(x_open_win_id.style.top);
	dragresized = true;
	x_open_win_border_id.style.display = '';
	x_open_win_border_id.style.border='1px #808080 solid';
	
	document.body.style.cursor = 'nw-resize';
	document.onmousemove = drag_resize;
	document.onmouseup = drag_resize_stop;
	return false;
}
function drag_resize(e){
	if(dragresized){
		var evt = x_open_ns6 ? e : event;
		w = evt_width + (evt.clientX - click_x);
		h = evt_height + (evt.clientY - click_y);
		if(w > 0 ) {
			x_open_win_border_id.style.width = w;
		}
		if(h > 0 ) {
			x_open_win_border_id.style.height = h;
		}
	}
	document.body.style.cursor = 'nw-resize';
	return false;
}
function drag_resize_stop(e){
	dragresized=false;
	change_size(remove_units(x_open_win_border_id.style.width), remove_units(x_open_win_border_id.style.height));
	x_open_win_border_id.style.border='0px';
	x_open_win_border_id.style.display = 'none';
	document.body.style.cursor='default';
	document.onmousemove=null;
}
//resize===>>>
	
//-->



</script>
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
      document.getElementById("fd").style.display="none";
      document.getElementById("uploadingdiv").style.display="";
 }




function ChangeType(type)
{
    url="<%=Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","","","type_idd",filetype_idd) %>";
	 url = url.replace("type_idd",type);
	
	  window.location=url;

}
function ChangefileType(type)
{

    url="<%=Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","","",type_idd,"typedd") %>";
	 url = url.replace("typedd",type);
	  window.location=url;

}

function allsearch()
{
	 url="<%=Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","search","param3_idd","param4_idd","param5_idd") %>";
	 url = url.replace("param3_idd",encodeURI(document.selform2.param3.value));
	  url = url.replace("param4_idd",encodeURI(document.selform2.param4.value));
	  url = url.replace("param5_idd",encodeURI(document.selform2.param5.value));
     document.selform2.action=url;
	 //alert(url);
document.selform2.submit();
}

</script>


<style type="text/css"> 
#fd{     
    width:600px; 
    height:250px; 
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

	<form action="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","search","","","")%>" method="post" name="selform2" >
  <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">我的资料</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>
                                       <select name="param5" onChange="ChangefileType(this.value)"   style="height:20px;"> 
                                <option value="">文件类别</option>
                                <% =selectfile.ToString() %>
                                 </select>
								 <select name="param4" onChange="ChangeType(this.value)"   style="height:20px;"> 
                                <option value="">全部类别</option>
                                <% =selectsb.ToString() %>
                                 </select> <input type="text" name="param3" style="width: 164px; height: 20px;" />
                                         <input type="button" value="查找" onClick="allsearch()" style="width: 75px; height: 21px;" /></td>
        </tr>
    </table> </td>
  </tr>
</TABLE>
</form>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                                     <td align="left" valign="middle" bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                       <tr>
                                         <td align="left"><a onclick = "show('fd');return false;" href="#"><img src="/images/upload.jpg" style="border:0;" alt="" /></a><a onclick = "javascript:x_open('多文件上传', 'data_mutiupload.html',600,400);" href="#"><img src="/images/mutiup.jpg" style="border:0;" alt="" /></a><a onClick="{if(confirm('此操作将资料放入回收站！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='delete';document.selform.submit();return true;}return false;}" href="#"><img src="/images/deletefile.jpg" style="border:0;" alt="" /></a><a  onclick="javascript:document.getElementById('actiontype').value='share';document.selform.submit()" href="#"><img src="/images/share.jpg" style="border:0;" alt="" /></a><a  onclick="{if(confirm('此操作将取消选定文件的共享功能！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='cancelshare';document.selform.submit();return true;}return false;}" href="#"><img src="/images/cancelshare.jpg" style="border:0;" /></a><a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_typemanage.aspx","0","","","","") %>"><img src="/images/typemgr.jpg" style="border:0;" alt="" /></a>&nbsp; </td>
                                       <td align="left">
									   <div id="fd2" class="content" style="display:none;filter:alpha(opacity=100);opacity:1;">
</div>
</td>
                                       </tr>
                                     </table>
									 
                                   </td>
                                 </tr>
                                 <tr>
                                     <td align="center">

 
<script type="text/javascript"> 
    var prox; 
    var proy; 
    var proxc; 
    var proyc; 
    function show(id){/*--打开--*/ 
        clearInterval(prox); 
        clearInterval(proy); 
        clearInterval(proxc); 
        clearInterval(proyc); 
        var o = document.getElementById(id); 
        o.style.display = "block"; 
        o.style.width = "1px"; 
        o.style.height = "4px";  
        prox = setInterval(function(){openx(o,600)},10); 
    }     
    function openx(o,x){/*--打开x--*/ 
		var b = document.getElementById("fd1");  
	b.style.display = "";
        var cx = parseInt(o.style.width); 
        if(cx < x) 
        { 
            o.style.width = (cx + Math.ceil((x-cx)/5)) +"px"; 
        } 
        else 
        { 
            clearInterval(prox); 
            proy = setInterval(function(){openy(o,250)},10); 
        } 
    }     
    function openy(o,y){/*--打开y--*/     
        var cy = parseInt(o.style.height); 
        if(cy < y) 
        { 
            o.style.height = (cy + Math.ceil((y-cy)/5)) +"px"; 
        } 
        else 
        { 
            clearInterval(proy);             
        } 
    }     
    function closeed(id){/*--关闭--*/ 
        clearInterval(prox); 
        clearInterval(proy); 
        clearInterval(proxc); 
        clearInterval(proyc);         
        var o = document.getElementById(id); 
        if(o.style.display == "block") 
        { 
            proyc = setInterval(function(){closey(o)},10);             
        }         
    }     
    function closey(o){/*--打开y--*/ 
		var x = document.getElementById("fd1");  
	x.style.display = "none";    
        var cy = parseInt(o.style.height); 
        if(cy > 0) 
        { 
            o.style.height = (cy - Math.ceil(cy/5)) +"px"; 
        } 
        else 
        { 
            clearInterval(proyc);                 
            proxc = setInterval(function(){closex(o)},10); 
        } 
    }     
    function closex(o){/*--打开x--*/
        var cx = parseInt(o.style.width); 
        if(cx > 0) 
        { 
            o.style.width = (cx - Math.ceil(cx/5)) +"px"; 
        } 
        else 
        { 
            clearInterval(proxc); 
            o.style.display = "none"; 
        } 
    }     
     
     
    /*-------------------------鼠标拖动---------------------*/     
    var od = document.getElementById("fd2");     
    var dx,dy,mx,my,mouseD; 
    var odrag; 
    var isIE = document.all ? true : false; 
    document.onmousedown = function(e){ 
        var e = e ? e : event; 
        if(e.button == (document.all ? 1 : 0)) 
        { 
            mouseD = true;             
        } 
    } 
    document.onmouseup = function(){ 
        mouseD = false; 
        odrag = ""; 
        if(isIE) 
        { 
            od.releaseCapture(); 
            od.filters.alpha.opacity = 100; 
        } 
        else 
        { 
            window.releaseEvents(od.MOUSEMOVE); 
            od.style.opacity = 1; 
        }         
    } 
     
     
    //function readyMove(e){     
    od.onmousedown = function(e){ 
        odrag = this; 
        var e = e ? e : event; 
        if(e.button == (document.all ? 1 : 0)) 
        { 
            mx = e.clientX; 
            my = e.clientY; 
            od.style.left = od.offsetLeft + "px"; 
            od.style.top = od.offsetTop + "px"; 
            if(isIE) 
            { 
                od.setCapture();                 
                od.filters.alpha.opacity = 50; 
            } 
            else 
            { 
                window.captureEvents(Event.MOUSEMOVE); 
                od.style.opacity = 0.5; 
            } 
             
            //alert(mx); 
            //alert(my); 
             
        }  
    } 
    document.onmousemove = function(e){ 
        var e = e ? e : event; 
         
        //alert(mrx); 
        //alert(e.button);         
        if(mouseD==true && odrag) 
        {         
            var mrx = e.clientX - mx; 
            var mry = e.clientY - my;     
            od.style.left = parseInt(od.style.left) +mrx + "px"; 
            od.style.top = parseInt(od.style.top) + mry + "px";             
            mx = e.clientX; 
            my = e.clientY; 
             
        } 
    } 
     
     
</script> 
										 
                                         <table border="0" align="center" cellpadding="0" cellspacing="0">
                                             <tr>
                                                 <td height="4">
                                                     <div id="fd" style="display:none; filter: alpha(opacity=100); opacity: 1;">
                                                         <div id="fd1" class="content">
                                                             <table width="550" border="0" cellspacing="0" cellpadding="0">
                                                                 <tr>
                                                                     <td align="right">
                                                                         
                                                                     </td>
                                                                 </tr>
                                                             </table>
                                                             <form name="form1" method="post" action="<%= Link.url("/app_mgr/ziliao_mgr/","data_upload.aspx","","save","","","")%>" enctype="multipart/form-data">
                                                                 <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                                     <tr>
                                                                         <td>&nbsp;
                                                                             </td>
                                                                     </tr>
                                                                     <tr>
                                                                         <td width="70" height="30">
                                                                             选取资料：</td>
                                                                         <td height="20" align="left">
                                                                             <input name="myfile" type="file" id="myfile" size="40" runat="server" /></td>
                                                                     </tr>
                                                                     <tr>
                                                                         <td width="70" height="30">
                                                                             资料分类：</td>
                                                                       <td height="20" align="left">
                                                                             
                                                                             <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                               <tr>
                                                                                 <td><select name="param4">
                                                                                 <option value="0">选择文件分类</option>
                                                                                 <%= datatypeselect %>
                                                                             </select></td>
                                                                                 <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                   <tr>
                                                                                     <td height="25"> 共享设定：</td>
                                                                                     <td height="20" align="left">
                                                                                       <input type="radio" name="shareset" checked="checked" value="0" />
    私人
    <input type="radio" name="shareset" value="<%= mydept_id %>" />
    本部门共享
    <input type="radio" name="shareset" value="10000" />
    全局共享 </td>
                                                                                   </tr>
                                                                                 </table></td>
                                                                               </tr>
                                                                             </table>
                                                                       </td>
                                                                     </tr>
                                                                     <tr>
                                                                         <td width="70" height="30">
                                                                             资料命名：</td>
                                                                       <td height="20" align="left">
                                                                             <input name="filetitle" type="text" size="40" />
                                                                           </td>
                                                                     </tr>
                                                                     <tr>
                                                                         <td width="70" height="25">
                                                                             查找描述：
                                                                         </td>
                                                                         <td height="20" align="left">
                                                                             <textarea name="content" rows="6" cols="40"></textarea></td>
                                                                     </tr>
                                                                     <tr>
                                                                         <td width="70" height="25">
                                                                         </td>
                                                                       <td height="20">
                                                                             <input name="Submit" type="submit" onClick="divhide();" value="上传资料" style="width: 120px;height:30pt;" />
																			 <input type="button" value="关闭上传窗口" onClick="closeed('fd');return false;" style="width: 120px;height:30pt;" />
                                                                         </td>
                                                                     </tr>
                                                                 </table>
                                                             </form>
                                                         </div>
                                                     </div>
                                                 </td>
                                             </tr>
                                         </table>
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
                                               <td align="center"><span class="content">您的资料可能比较大，请耐心等待!资料上传中.......</span></td>
                                             </tr>
                                           </table>
                                        
                                       </div>                                   </td>
                                 </tr>
                                 
                           </table>

 			<form action="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","set","","","")%>" method="post" name="selform" >

     <table width="100%" border="0" cellpadding="0" cellspacing="1"  class="lvt small">
         <tr class="lvtCol">
             <td height="30" align="center">
                 序号</td>
             <td align="center" style="height: 18px;">
                 <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:SelectAll()"></td>
             <td align="center" style="height: 18px; width: 38%;">
                 资 料 名 称</td>
             <td align="center">
                 上传时间</td>
             <td align="center">
                 共享状态</td>
             <td align="center">
                 编 辑</td>
             <td align="center">
                 大小</td>
         </tr>
          
        <%=contentstring %>
         <tr bgcolor="white" onMouseOver="this.className='lvtColDataHover'" onMouseOut="this.className='lvtColData'">
             <td align="center" colspan="10" height="35" class="but1" style="width: 100%;">
                 <table width="211" border="0" align="left" cellpadding="0" cellspacing="0">
                     <tr>
                         <td width="160" align="right">
                             <select name="datatype2" style="height: 20px;">
                                 <option value="0">分类选择</option>
                                 <% =selectsb.ToString() %>
                             </select>
                         </td>
                         <td width="140" align="center">
                             <input onClick="{if(confirm('此操作将选中资料移动到这个类别！\n\n确定要执行此项操作吗？')){document.getElementById('actiontype').value='movetype';document.selform.submit();return true;}return false;}"
                                 type="button" value="移动到此类别" name="action2" style="width: 93px"></td>
                     </tr>
                 </table>
                 <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
                 <input type="hidden" name="filetypeid" value="<% =type_idd %>" />
                 共
                 <%=total%>
                 个资料，当前第 &nbsp;<font color="red"><%=nowpage%></font>/
                 <%=maxpage%>
                 页，每页
                 <%=pagesize%>
                 个&nbsp; <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","1","","",type_idd, HttpUtility.UrlEncode(filetype_idd, System.Text.Encoding.UTF8)) %>">
                     首页</a> <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx",(nowpage-1).ToString(),"","",type_idd, HttpUtility.UrlEncode(filetype_idd, System.Text.Encoding.UTF8)) %>">
                         上一页</a> &nbsp;<a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx",(nowpage+1).ToString(),"","",type_idd, HttpUtility.UrlEncode(filetype_idd, System.Text.Encoding.UTF8)) %>">下一页</a>&nbsp;
                 <a href="<%= Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx",maxpage.ToString(),"","",type_idd, HttpUtility.UrlEncode(filetype_idd, System.Text.Encoding.UTF8)) %>">
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
