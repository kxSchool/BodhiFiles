using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using Common;
using Microsoft.Data.Odbc;

public partial class upload : System.Web.UI.Page
{
    string picPath = "";
    string picServer = ConfigurationSettings.AppSettings["data_center"].ToString();
    protected string itemID = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.QueryString["id"] != null)
        {
            itemID = Request.QueryString["id"];
        }
  
        if (IsPostBack)
        {
		     DBClass db = new DBClass();
            picPath = ConfigurationSettings.AppSettings["data_center"].ToString();
      
            doUpload(db);
        }
    }

    protected void doUpload(DBClass db)
    {
        try
        {
            HttpPostedFile file = file1.PostedFile;
			string newname=GetSaveFilePath() ;
			string ext=GetExtension(file.FileName);
            string strNewPath = newname+ ext;
            file.SaveAs(picPath+strNewPath);
			 int filelength = file.ContentLength;
		
		    string filetitle,filename;
			  filename=file1.Value;
			     filetitle = filename.Substring(filename.LastIndexOf("\\") + 1);
            int extlength = filetitle.Substring(filetitle.LastIndexOf(".")).Length;
            filetitle = filetitle.Substring(0, filetitle.Length - extlength);
		
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
        param[1].Value = strNewPath.Substring(1);
        param[2].Value ="";
        param[3].Value = filelength.ToString();
        param[4].Value = DateTime.Now;
        param[5].Value = Session["userno"].ToString();
        param[6].Value = 0;
        param[7].Value = 0;

        db.ExecuteNonQuery("insert into tbdata ( filetitle,fileurl,description,filesizes,uptime,userno,popedom,type_id ) values  ( ?,?,?,?,?,?,?,?)", param);
        db.closedb();
			
            string urlPath = picServer + strNewPath;
            urlPath = urlPath.Replace("\\", "/");
            WriteJs("parent.uploadsuccess('" + urlPath + "','" + itemID + "'); ");
            
        }
        catch (Exception ex)
        {
            WriteJs("parent.uploaderror();");            
        }
    }

    private string GetExtension(string fileName)
    {
        try
        {
            int startPos = fileName.LastIndexOf(".");
            string ext = fileName.Substring(startPos, fileName.Length - startPos);
            return ext;
        }
        catch (Exception ex)
        {
            WriteJs("parent.uploaderror('" + itemID + "');");
            return string.Empty;
        }
    }

    private string GetSaveFilePath()
    {
        try
        {
            DateTime dateTime = DateTime.Now;          
            return dateTime.ToString("\\\\yyyyMMddhhmmssffff");
        }
        catch (Exception ex)
        {
            WriteJs("parent.uploaderror();");
            return string.Empty;
        }
    }

    protected void WriteJs(string jsContent)
    {        
        this.Page.RegisterStartupScript("writejs","<script type='text/javascript'>"+ jsContent+"</script>");
    }

}
