<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">


    protected void Page_Load(object sender, EventArgs e)
    {
        string server_v1, server_v2;
        server_v1 = HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
        server_v2 = HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
        if (server_v1.Substring(7, server_v2.Length) != server_v2 && server_v1.Substring(8, server_v2.Length) != server_v2)
        {
            Response.Write("<br><br><center><table border=1 cellpadding=20 bordercolor=black bgcolor=#EEEEEE width=450>");
            Response.Write("<tr><td style='font:9pt Verdana'>");
            Response.Write("你提交的路径有误，禁止从站点外部提交数据请不要乱该参数！");
            Response.Write("</td></tr></table></center>");
            Response.End();
        }

        if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "")
        {
             
			Fun.goback("","参数错误！","返回");
            Page.Response.End();
        }
        DBClass db = new DBClass();
		string full_fileurl,sid,fileurl;
        string responsename = "", fileext;
		sid = Request.QueryString["param1"].ToString();
		string sqls;
        DataTable popedomgrouptable = new DataTable();
		sqls = "select * from tbdeldata where id=" + sid;
        popedomgrouptable = db.GetTable(sqls, null);
		fileurl=popedomgrouptable.Rows[0]["fileurl"].ToString();
        DataTable dt = db.GetTable("select tbdeldata.*,tbuser.userno,tbuser.username,tbuser.dept_id,department.id,department.deptname from (( tbdeldata left join tbuser on tbdeldata.userno=tbuser.userno ) left join department on tbuser.dept_id=department.id ) where fileurl='" + fileurl.ToString() + "'", null);
        if (dt.Rows.Count > 0)
        {
            responsename = dt.Rows[0]["filetitle"].ToString();

            int i = fileurl.ToString().LastIndexOf(".");

            //取得文件扩展名

            fileext = fileurl.ToString().Substring(i);
            responsename += fileext;
        }
        else
        {

			   db.closedb();
			Fun.goback("","下载文件出错,可能文件已被删除！","返回");
            Page.Response.End();
        }





        full_fileurl = ConfigurationSettings.AppSettings["realdelete_center"].ToString() + fileurl.ToString();
        Page.Response.Clear();
        bool success = ResponseFile(Page.Request, Page.Response, responsename, full_fileurl, 1024000);
        if (!success)
        {
             db.closedb();
			Fun.goback("","下载文件出错,可能文件已被删除！","返回");
        }

        db.closedb();
        Page.Response.End();




    }




    public static bool ResponseFile(HttpRequest _Request, HttpResponse _Response, string _fileName, string _fullPath, long _speed)
    {
        try
        {
            FileStream myFile = new FileStream(_fullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            BinaryReader br = new BinaryReader(myFile);
            try
            {
                _Response.AddHeader("Accept-Ranges", "bytes");
                _Response.Buffer = false;
                long fileLength = myFile.Length;
                long startBytes = 0;

                double pack = 10240; //10K bytes
                //每秒5次   即5*10K bytes每秒
                int sleep = (int)Math.Floor(1000 * pack / _speed) + 1;
                if (_Request.Headers["Range"] != null)
                {
                    _Response.StatusCode = 206;
                    string[] range = _Request.Headers["Range"].Split(new char[] { '=', '-' });
                    startBytes = Convert.ToInt64(range[1]);
                }
                _Response.AddHeader("Content-Length", (fileLength - startBytes).ToString());
                if (startBytes != 0)
                {
                    //Response.AddHeader("Content-Range", string.Format(" bytes {0}-{1}/{2}", startBytes, fileLength-1, fileLength));
                }
                _Response.AddHeader("Connection", "Keep-Alive");
                _Response.ContentType = "application/octet-stream";
                _Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_fileName, System.Text.Encoding.UTF8));

                br.BaseStream.Seek(startBytes, SeekOrigin.Begin);
                int maxCount = (int)Math.Floor((fileLength - startBytes) / pack) + 1;

                for (int i = 0; i < maxCount; i++)
                {
                    if (_Response.IsClientConnected)
                    {
                        _Response.BinaryWrite(br.ReadBytes(int.Parse(pack.ToString())));
                        Thread.Sleep(sleep);
                    }
                    else
                    {
                        i = maxCount;
                    }
                }
            }
            catch
            {
                return false;
            }
            finally
            {
                br.Close();

                myFile.Close();
            }
        }
        catch
        {
            return false;
        }
        return true;
    }
</script>