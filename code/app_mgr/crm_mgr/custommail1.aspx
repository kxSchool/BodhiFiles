<%@ Page Language="C#" %>
<%@ Import Namespace="SendMail" %>
<%@ Import Namespace="EC" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>
<script runat="server">
public string mailcontent,mailtitle,companyname,email,id,datatime,smtp,smtp_email,smtp_username,smtp_password,info;
protected void Page_Load(object sender, EventArgs e)
{

	 DBClass db = new DBClass();
	 DataTable dt = db.GetTable("select * from tbmail_ad");
                if (dt.Rows.Count > 0)
                {
                    mailtitle= dt.Rows[0]["mailtitle"].ToString();
					mailcontent = dt.Rows[0]["mailcontent"].ToString();
                }
		        dt = db.GetTable("select * from tbcustom where isdelete=false and send=false and companyname like '%测试帐号%'");
                System.Random a=new Random(System.DateTime.Now.Millisecond); 
                
				if (dt.Rows.Count > 0)
                {
                    int RandKey =a.Next(dt.Rows.Count);
					
					companyname = dt.Rows[0]["companyname"].ToString();
					email = dt.Rows[0]["email"].ToString();
					id=dt.Rows[0]["id"].ToString();
                } else {
					Response.Write(dt.Rows.Count);
					Response.End();
				}
	            //dt = db.GetTable("select * from tbsmtp");
                //if (dt.Rows.Count > 0)
                //{
                 //   smtp = dt.Rows[0]["smtp"].ToString();
				//	smtp_email = dt.Rows[0]["email"].ToString();
				//	smtp_username = dt.Rows[0]["username"].ToString();
				//	smtp_password = dt.Rows[0]["password"].ToString();
               // }
				//Response.Write(smtp_email);
if (email!="")
{
		db.ExecuteNonQuery("update tbcustom set send=true where id=" + id, null);
		info=  "　邮件：" + email + "　标题："  +   companyname   + "<br>";
        MailObj _mail = new MailObj();
		datatime=System.DateTime.Now.ToString();
		mailcontent=mailcontent.Replace("usermail",email);
        _mail.sendMail(email, mailtitle + ":" + companyname + datatime, mailcontent);
        _mail.Dispose();		
}
	db.closedb();
}
</script>
<%=info%>