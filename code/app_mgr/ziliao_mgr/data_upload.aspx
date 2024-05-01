<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>


<script runat="server">

    protected StringBuilder sb = new StringBuilder();
    protected string datatypeselect = "";
    protected string mydept_id = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();


        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
            StringBuilder selectsb = new StringBuilder();
            DataTable typetable = db.GetTable("select * from tbdatatype where userno='" + Session["userno"].ToString() + "'", null);

            for (int i = 0; i < typetable.Rows.Count; i++)
            {
                selectsb.Append("<option value=\"");
                selectsb.Append(typetable.Rows[i]["id"].ToString() + "\"");
                selectsb.Append(">" + typetable.Rows[i]["name"].ToString() + "</option>");
            }
            datatypeselect = selectsb.ToString();


            mydept_id = Session["dept_id"].ToString();
        }
        else
        {

            if (Request.QueryString["param2"].ToString() == "save" & this.myfile.Value != "")
            {

                FileUpload(db);
            }
			else
			{
			   Fun.alert("","请选择要上传的文件！",Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","","","",""),"返回");
			}

        }

        db.closedb();
    }






    /// <summary>
    /// /////// 资料上传
    /// </summary>
    /// <param name="db"></param>
    protected void FileUpload(DBClass db)
    {
        string filetitle = Request.Form.Get("filetitle").ToString().Trim();
        string filename = this.myfile.Value;
        HttpPostedFile upfile = this.myfile.PostedFile;

        int filelength = upfile.ContentLength;

        if (filelength == 0)
        {
             db.closedb();
			Fun.goback("","对不起，请选择要上传的资料","返回");
        }
        if (filetitle == "")
        {
            //取得文件名
            filetitle = filename.Substring(filename.LastIndexOf("\\") + 1);
            int extlength = filetitle.Substring(filetitle.LastIndexOf(".")).Length;
            filetitle = filetitle.Substring(0, filetitle.Length - extlength);
        }

        int i = filename.LastIndexOf(".");

        //取得文件扩展名

        string newext = filename.Substring(i);


        filename = filename.Substring(filename.LastIndexOf("\\") + 1);
        DateTime now = DateTime.Now;

           Random rd = new Random();
            int rannum = rd.Next(0, 100) * 900450 + 200000;
        string newname = now.Year.ToString() + now.Month.ToString() + now.Day.ToString() + now.Minute.ToString() +
            now.Second.ToString() + rannum.ToString();

        myfile.PostedFile.SaveAs(ConfigurationSettings.AppSettings["data_center"].ToString() + newname + newext);
        OdbcParameter[] param ={ 
                         new OdbcParameter("@filetitle",OdbcType.VarChar),
                        new OdbcParameter("@fileurl",OdbcType.VarChar),
                       new OdbcParameter("@description",OdbcType.Text),
                        new OdbcParameter("@filesizes",OdbcType.VarChar),
                        new OdbcParameter("@uptime",OdbcType.DateTime),
                        new OdbcParameter("@userno",OdbcType.VarChar),
                        new OdbcParameter("@popedom",OdbcType.Int),
                        new OdbcParameter("@type_id",OdbcType.Int)
                    };
        param[0].Value = filetitle;
        param[1].Value = newname + newext;
        param[2].Value = Request.Form.Get("content").ToString();
        param[3].Value = filelength.ToString();
        param[4].Value = DateTime.Now;
        param[5].Value = Session["userno"].ToString();
        param[6].Value = Request.Form.Get("shareset");
        param[7].Value = Request.Form.Get("param4");

        db.ExecuteNonQuery("insert into tbdata ( filetitle,fileurl,description,filesizes,uptime,userno,popedom,type_id ) values  ( ?,?,?,?,?,?,?,?)", param);
        db.closedb();
        Response.Redirect(Link.url("/app_mgr/ziliao_mgr/","data_manage.aspx","","","","",""));
        Response.End();

    }
</script>
<html>
<head id="Head1" runat="server">
    <title>资料上传</title>


<link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

 BODY {
	FONT-SIZE: 9pt;
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
 function divhide()
 {
      document.getElementById("uploaddiv").style.display="none";
      document.getElementById("loadingdiv").style.display="";
 }

</script>

</head>
<body>

<myhead:myhead ID="Myhead1" runat="server" />
<br>
<br>
 <div id="uploaddiv">
    <form name="form1" method="post" action="<%= Link.url("/app_mgr/ziliao_mgr/","data_upload.aspx","","save","","","")%>" enctype="multipart/form-data">
        <table border="0" align="center" cellpadding="0" cellspacing="0" >
            <tr>
              <td height="25"> 选取资料：</td>
              <td height="20" align="left">
                <input name="myfile" type="file" id="myfile" size="40" runat="server" /></td>
            </tr>
            <tr>
              <td height="25"> 资料类型：</td>
              <td height="20" align="left">
                <select name="param4">
                  <option value="0">选择文件分类</option>
                  <%= datatypeselect %>
                </select>
              </td>
            </tr>
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
             <tr>
               <td height="25"> 资料命名：</td>
               <td height="20" align="left">
                 <input name="filetitle" type="text" size="40"/>
&nbsp;*文件名如果不填 则为原上传文件名</td>
             </tr>
             <tr>
                <td height="25">
                    关键词：
               </td>
                <td height="20" align="left"><textarea name="content" rows="6" cols="40"></textarea></td>
                
          </tr>
             
              <tr>
                <td height="25">
                </td>
                <td height="20"> 
        
                &nbsp;
                <input name="Submit" type="submit" onClick="divhide();" value="上传资料" style="width: 65px" />
                <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />                </td>
            
             </tr>
      </table>
 </form>
 
 </div>

 
 <DIV id="loadingdiv" style="Z-INDEX:99999; LEFT: 0px; VISIBILITY: hidden;WIDTH: 250px; POSITION: absolute; TOP: 0px; HEIGHT: 150px;display:none;">
		<TABLE cellSpacing=0 cellPadding=0 width="100%" bgcolor="#FFFFFF" border=0>
			<TR>
				<td width="100%" valign="top" align="center">
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="70" class="loft_win_head">消息提示</td>
							<td width="26" class="loft_win_head"> </td>
							<td align="right" class="loft_win_head">
								<span style="CURSOR: hand;font-size:12px;font-weight:bold;margin-right:4px;" title=最小化 onclick=minDiv() >- </span><span style="CURSOR: hand;font-size:12px;font-weight:bold;margin-right:4px;" title=关闭 onclick=closeDiv() >×</span>
							</td>
						</tr>
					</table>
				</td>
			</TR>
			<TR>
				<TD height="130" align="center" valign="middle" colSpan=3>
					<div id="contentDiv">
						<table width="100%" height="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td align="center" height="100%">
									<div>
										<a href="" target="_blank">！</a>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</TD>
			</TR>
		</TABLE>
	</DIV>
 
 
 <br>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
