
<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>



<script runat="server">


  protected string upfileuserno="";
    protected void Page_Load(object sender, EventArgs e)
    {
      


        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {
          

        }
        else
        {

            if (Request.QueryString["param2"].ToString() == "save" & this.myfile.Value != "")
            {
                   DBClass db = new DBClass();
				        OdbcParameter[] checkparam ={ 
                         new OdbcParameter("@userid",OdbcType.VarChar),
                        new OdbcParameter("@password",OdbcType.VarChar)
                 
                    };
					checkparam[0].Value=Request.Form["upfileusername"];
					checkparam[1].Value=Request.Form["upfilepwd"];
				
				  DataTable chtable=db.GetTable("select * from tbuser where userid=? and password=?",checkparam);
				    if(chtable.Rows.Count<=0)
					{
					  
Fun.alert("","对不起，用户名或是密码错误！",Link.url("/app_mgr/ziliao_mgr/", "data_uploaddirect.aspx", "", "","", "", ""),"返回");
					}
				   upfileuserno=chtable.Rows[0]["userno"].ToString();
                  FileUpload(db);
				 db.closedb();
            }
			else
			{
			   
Fun.alert("","请选择要上传的文件！",Link.url("/app_mgr/ziliao_mgr/", "data_uploaddirect.aspx", "", "","", "", ""),"返回");
			}

        }

       
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
			Fun.goback("","","返回");
Fun.alert("","对不起，请选择要上传的资料",Link.url("/app_mgr/ziliao_mgr/", "data_uploaddirect.aspx", "", "","", "", ""),"返回");
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
        param[5].Value = upfileuserno;
        param[6].Value = 0;
        param[7].Value = 0;

       db.ExecuteNonQuery("insert into tbdata ( filetitle,fileurl,description,filesizes,uptime,userno,popedom,type_id ) values  ( ?,?,?,?,?,?,?,?)", param);
    
        db.closedb();
          Fun.alert("","上传成功",Link.url("/app_mgr/ziliao_mgr/", "data_uploaddirect.aspx", "", "","", "", ""),"继续上传");
        Response.End();

    }
	
 

</script>
<html>
    <title>资料直传</title>



<style type="text/css">

 BODY {
	FONT-SIZE: 9pt;
}


</style>
<script type="text/javascript">
 function Login()
 {if(document.formx.myfile.value==""){window.alert("文件选取框不能为空!");document.formx.myfile.focus();return (false);}
  if(document.formx.upfileusername.value==""){window.alert("登录名不能为空!");document.formx.upfileusername.focus();return (false);}
   if(document.formx.upfilepwd.value==""){window.alert("登录密码不能为空!");document.formx.upfilepwd.focus();return (false);}
	 document.formx.submit();
	  divhide();
 }
function divhide()
 {
      document.getElementById("uploaddiv").style.display="none";
      document.getElementById("uploadingdiv").style.display="";
 }
  </script>
</head>
<body bgcolor="#FFFFFF">
 

 
 
 <table border="0" align="center" cellpadding="0" cellspacing="0">
   <tr>
     <td align="center" valign="middle"><div id="uploaddiv">
            <table border="0" align="center" cellpadding="0" cellspacing="0" >
        <form name="formx" id="formx" method="post" action="<%= Link.url("/app_mgr/ziliao_mgr/","data_uploaddirect.aspx","","save","","","")%>" enctype="multipart/form-data">

	<tr>
              <td width="83" height="20"><font color="#FF0000" size="2"> 本地资料：</font></td>
              <td height="20" colspan="2" align="left"><input name="myfile" type="file" id="myfile" style=" width:244pt;height:23px;" runat="server" /></td>
    </tr>
            
              <tr>
                <td><font color="#FF0000" size="2">用户帐号：</font></td>
                <td width="253" rowspan="2" align="left">                <table border="0" cellspacing="0" cellpadding="0">
                 <tr>
                   <td><input name="upfileusername" type="text" style=" width:190pt;height:23px;"/></td>
                 </tr>
                 <tr>
                   <td><input name="upfilepwd" type="password" style=" width:190pt;height:23px;"/></td>
                 </tr>
				 
               </table>
                </td>
               <td width="72" rowspan="2" align="left" valign="bottom">                <div align="center">
                 <input name="mysubmit" type="button" onClick="Login();" value="存入系统" style="width: 65px" />              
               </div></td>
              </tr>
              <tr>
                <td><font color="#FF0000" size="2">登录密码：</font></td>
              </tr>
			       <tr>
               <td height="20"><font color="#999999" size="2"> 重新命名：</font></td>
               <td height="20" colspan="2" align="left"><input name="filetitle" type="text" style=" width:190pt;height:23px;"/>&nbsp;</td>
             </tr>
             <tr>
                <td height="20" align="left"><font color="#999999" size="2">
                资料描述：<br>
                  (可不填)</font></td>
                <td height="20" colspan="2" align="left">
                  <textarea name="content" style=" width:190pt;height:60px;"></textarea>                </td>
             </tr>
   </form>   </table>

 
 </div><div id="uploadingdiv" style="display:none; filter: alpha(opacity=100);width: 327px; height: 162px;">
        <table border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
          <tr>
            <td height="24" bgcolor="#666699"><table width="320" height="20" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="323" bgcolor="#666699">&nbsp;</td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td height="60" align="center" bgcolor="#CCCCCC"><span class="content"><font color="#000000" size="2">资料可能比较大，请耐心等待!资料上传中....</font></span></td>
          </tr>
        </table>
 </div></td>
   </tr>
</table>
 
</body>
</html>
