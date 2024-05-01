<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data.OleDb" %>


<script runat="server" language="C#">
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();


        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

        }
        else
        {

            if (Request.QueryString["param2"].ToString() == "save" & this.myfile.Value != "")
            {

                FileUpload(db);
            }
			else
			{
			   Fun.alert("","请选择要上传的报表！",Link.url("/app_mgr/excel_mgr/","excel_mgr.aspx","","","","",""),"返回");
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
			
			 Fun.goback("","对不起，请选择要上传的统计表格","返回");
            Response.End();
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

        if (newext != ".xls")
        {

            db.closedb();
	
			 Fun.goback("","对不起，请上传 .xls 类型的表格！","返回");
            Response.End();
        }


        filename = filename.Substring(filename.LastIndexOf("\\") + 1);
        DateTime now = DateTime.Now;
          Random rd = new Random();
            int rannum = rd.Next(0, 100) * 900450 + 200000;
			
        string newname = now.Year.ToString() + now.Month.ToString() + now.Day.ToString() + now.Minute.ToString() +
            now.Second.ToString() + rannum.ToString();
// 保存文件
        myfile.PostedFile.SaveAs(ConfigurationSettings.AppSettings["excel_center"].ToString() + newname + newext);
		
		//检测文件
		
		
		      string strConn = "Provider=Microsoft.Jet.Oledb.4.0;Data Source=" + ConfigurationSettings.AppSettings["excel_center"].ToString() + newname + newext + ";Extended Properties=Excel 8.0";
			
            OleDbConnection conn = new OleDbConnection(strConn);


            OleDbDataAdapter adp = new OleDbDataAdapter("Select * from [Sheet1$]", conn);
            DataTable dtt = new DataTable();
            adp.Fill(dtt);
			if(dtt.Columns[0].Caption.ToString()!="识别码")
			{
			   conn.Close();
			   	FileInfo f=new FileInfo(ConfigurationSettings.AppSettings["excel_center"].ToString() + newname + newext);
				if(f.Exists)
				{ 
				    File.Delete(ConfigurationSettings.AppSettings["excel_center"].ToString() + newname + newext);
				 }
			
			   Fun.goback("","对不起，上传的表格第一列必须是'<font color=red>识别码</font>'！ ","返回重新上传");
			}
			else
			{
			   conn.Close();
			}


            string sql = "insert into tbexcel(filetitle,fileurl,description,uptime,userno,isdelete) values(?,?,?,?,?,?)";
        string isdelete="0";
		OdbcParameter[] param ={ 
                         new OdbcParameter("@filetitle",OdbcType.VarChar,100),
                        new OdbcParameter("@fileurl",OdbcType.VarChar,200),
                       new OdbcParameter("@description",OdbcType.Text),
                        new OdbcParameter("@uptime",OdbcType.DateTime),
                        new OdbcParameter("@userno",OdbcType.VarChar,50),
						new OdbcParameter("@isdelete",OdbcType.Char,1)
                   
                    };
        param[0].Value = filetitle;
        param[1].Value = newname + newext;
        param[2].Value = Request.Form.Get("content").ToString();
        param[3].Value = DateTime.Now.ToString();
        param[4].Value = Session["userno"].ToString();
		param[5].Value = isdelete.ToString();

        db.ExecuteNonQuery(sql, param);
        db.closedb();
        Response.Redirect(Link.url("/app_mgr/excel_mgr/","excel_mgr.aspx","","","","","") );
        Response.End();

    }
    
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
</head>
<body>
   <form name="form1" method="post" action="<%= Link.url("/app_mgr/excel_mgr/","excel_upload.aspx","","save","","","") %>" enctype="multipart/form-data" >
                                                 <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                     
                                                     <tr><td>&nbsp;</td></tr>
                                                     <tr>
                                                         <td style="height: 25px">
                                                             选取统计表：</td>
                                                         <td align="left" style="height: 25px">
                                                             <input name="myfile" type="file" id="myfile" size="40" runat="server" /></td>
                                                     </tr>
                                                
                                                     <tr>
                                                       <td height="25"> 重新命名：</td>
                                                       <td height="20" align="left">
                                                         <input name="filetitle" type="text" size="40" />
&nbsp;*文件名如果不填 则为原上传文件名</td>
                                                     </tr>
                                                     <tr>
                                                         <td height="25">
                                                             查找描述：
                                                         </td>
                                                         <td height="20" align="left">
                                                             <textarea name="content" style="height: 47px; width: 77%;"></textarea></td>
                                                     </tr>
                                                     <tr>
                                                         <td height="25">
                                                         </td>
                                                         <td height="20">
                                                             &nbsp;
                                                             <input name="Submit" type="submit" onclick="divhide();" value="上传资料" style="width: 65px" />
                                                             <input type="button" value="返回" onclick="javascript:history.go(-1);" style="width: 67px" />
                                                         </td>
                                                     </tr>
                                                 </table>
                                             </form>
</body>
</html>
