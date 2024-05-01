<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (HardDiskVal.CheckHardVal() == false)
        {
            //    Response.Write("if(confirm('对不起，非法使用本产品，请到本公司购买使用')){javascript:location.href='http://www.aixinsoft.cn/';}else{javascript:location.href='" + Link.url("/", "default.aspx","","","","","") + "'}");
            //   Response.End();
        }

        DBClass db = new DBClass();


        if (LimitUser.CheckLimitUserLogin(db) == false)
        {  
		       db.closedb();
			  Fun.alert("","对不起，用户数已经超过了最大用户限制，请购买加强版！","http://www.aixinsoft.cn" ,"返回");
        
            Response.End();
        }



        string userid = "jacky";
        string pwd ="jackyzhang";
        string checkcode ="jacky";;


        


        
        string sql = "select tbuser.*,department.* from tbuser left join department on tbuser.dept_id=department.id where tbuser.isdelete=0 and tbuser.UserId=?";
        OdbcParameter useridparam = new OdbcParameter("@userid",OdbcType.VarChar,20);
        useridparam.Value = userid;
        DataTable dt = new DataTable();
        dt = db.GetTable(sql, useridparam);

        if (dt.Rows.Count == 0)
        {
            errmsg("没有该用户");
        }
        else
        {

            if (dt.Rows[0]["PassWord"].ToString() == pwd)
            {


                Session.Timeout = 60;
                Session["userno"] ="U_20080904082901";
                Session["userid"] ="jacky";
                Session["username"] ="章爱军";
                Session["popedomgroup"] = dt.Rows[0]["popedomgroup"].ToString();
                Session["dept_id"] = dt.Rows[0]["dept_id"].ToString();
                Session["deptname"] = dt.Rows[0]["deptname"].ToString();

                SetLoginLog(db);

                Response.Redirect(Link.url("/","main.aspx","","","","",""));

                db.closedb();
                Response.End();

            }
            else
            {

                errmsg("用户名或密码错误");
            }

        }


        db.closedb();

    }




    protected void SetLoginLog(DBClass db)
    {

        
        OdbcParameter[] param ={
          new OdbcParameter("@loginurl",OdbcType.VarChar,100),
          new OdbcParameter("@loginname",OdbcType.VarChar,50),
           new OdbcParameter("@loginuserid",OdbcType.VarChar,50),
             new OdbcParameter("@logintime",OdbcType.DateTime),
             new OdbcParameter("@ip",OdbcType.VarChar,50),
             new OdbcParameter("@browser",OdbcType.VarChar,50),
             new OdbcParameter("@os",OdbcType.VarChar,50)

        };

        string userAgent = Request.UserAgent == null ? "无" : Request.UserAgent;


        param[0].Value = HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToString();
        param[1].Value = Session["username"];
        param[2].Value = Session["userid"];
        param[3].Value = DateTime.Now.ToString();
        param[4].Value = HttpContext.Current.Request.UserHostAddress.ToString();
        param[5].Value = Request.Browser.Browser + Request.Browser.Version;
        param[6].Value = this.GetOSNameByUserAgent(userAgent);

        db.ExecuteNonQuery("insert into tbloginLog(loginurl,loginname,loginuserid,logintime,ip,browser,os) values(?,?,?,?,?,?,?)", param);

       db.ExecuteNonQuery("update tbuser set online='" + DateTime.Now.ToString() + "' where userno='" + Session["userno"].ToString() + "'", null);

    }


    /// <summary>
    /// /////////错误信息
    /// </summary>
    /// <param name="msg"></param>
    public void errmsg(string msg)
    {
        Response.Write("<br><font size='2'>" + msg + "<a href='" + Link.url("/", "default.aspx","","","","","") + "'>返回</a></font>");
         
        Response.End();
    }



    /// <summary>
    /// 根据 User Agent 获取操作系统名称
    /// </summary>
    private string GetOSNameByUserAgent(string userAgent)
    {
        string osVersion = "未知";

        if (userAgent.Contains("NT 6.0"))
        {
            osVersion = "Windows Vista/Server 2008";
        }
        else if (userAgent.Contains("NT 5.2"))
        {
            osVersion = "Windows Server 2003";
        }
        else if (userAgent.Contains("NT 5.1"))
        {
            osVersion = "Windows XP";
        }
        else if (userAgent.Contains("NT 5"))
        {
            osVersion = "Windows 2000";
        }
        else if (userAgent.Contains("NT 4"))
        {
            osVersion = "Windows NT4";
        }
        else if (userAgent.Contains("Me"))
        {
            osVersion = "Windows Me";
        }
        else if (userAgent.Contains("98"))
        {
            osVersion = "Windows 98";
        }
        else if (userAgent.Contains("95"))
        {
            osVersion = "Windows 95";
        }
        else if (userAgent.Contains("Mac"))
        {
            osVersion = "Mac";
        }
        else if (userAgent.Contains("Unix"))
        {
            osVersion = "UNIX";
        }
        else if (userAgent.Contains("Linux"))
        {
            osVersion = "Linux";
        }
        else if (userAgent.Contains("SunOS"))
        {
            osVersion = "SunOS";
        }
        return osVersion;
    }
</script>


<html>
<head runat="server">
    <title>无标题页</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
