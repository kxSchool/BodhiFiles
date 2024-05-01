<%@ Page Language="C#" %>
<%@ Import Namespace="SendMail" %>
<%@ Import Namespace="EC" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %> 
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
public string mailcontent,mailtitle,companyname,email,id,datatime,smtp,smtp_email,smtp_username,smtp_password,info;
public int counts,ccounts;
protected void Page_Load(object sender, EventArgs e)
{

	 DBClass db = new DBClass();
	 DataTable dt = db.GetTable("select * from tbmail_ad");
                if (dt.Rows.Count > 0)
                {
                    mailtitle= dt.Rows[0]["mailtitle"].ToString();
					mailcontent = dt.Rows[0]["mailcontent"].ToString();
                }
				dt = db.GetTable("select count(*) as counts from tbcustom where  isdelete=false and send=false and  (email like '%@%' or email like '%.%' )");
                if (dt.Rows.Count > 0)
                {
					ccounts = Convert.ToInt32(dt.Rows[0]["counts"].ToString());
                }
				System.Random a=new Random(System.DateTime.Now.Millisecond); 
                int RandKey =a.Next(ccounts);
				dt = db.GetTable("SELECT MAX(id) AS ids FROM (SELECT TOP " + RandKey.ToString() + " id FROM tbcustom where  isdelete=false and send=false and  (email like '%@%' or email like '%.%' ) ) a", null);
		if (dt.Rows.Count == 0)
        {
            Response.End();
        }
		else
		{
		    RandKey=Convert.ToInt32(dt.Rows[0]["ids"].ToString());
		}
		        dt = db.GetTable("select top 1 * from tbcustom where  (email like '%@%' or email like '%.%' ) and isdelete=false and send=false and id=" + RandKey.ToString());
				
				if (dt.Rows.Count > 0)
                {
					id = dt.Rows[0]["id"].ToString();
					companyname = dt.Rows[0]["companyname"].ToString();
					email = dt.Rows[0]["email"].ToString().Trim();
                }
				//Response.Write(email);
				//Response.End();
				//Response.Write(email);
				//Response.End();
			   //dt = db.GetTable("select count(*) as counts from tbsmtp");
               // if (dt.Rows.Count > 0)
               // {
               //     counts = Convert.ToInt32(dt.Rows[0]["counts"].ToString());
               // }
	           // dt = db.GetTable("select * from tbsmtp");
				//a=new Random(System.DateTime.Now.Millisecond); 
               // RandKey =a.Next(counts);
				//for (int i =0; i <RandKey+1; i++) 
               // {
               //     smtp = dt.Rows[i]["smtp"].ToString();
				//	smtp_email = dt.Rows[i]["email"].ToString();
				//	smtp_username = dt.Rows[i]["username"].ToString();
				//	smtp_password = dt.Rows[i]["password"].ToString();
               // }
				//Response.Write(smtp_email);
if (email!="")
{ //Jmailclass.sendEmail(smtp_email,smtp_username,smtp_username,smtp_password,email,"天旗木皮供货商情报告:" + companyname ,mailcontent,smtp);
 db.ExecuteNonQuery("update tbcustom set send=true where id=" + id, null);
        MailObj _mail = new MailObj();
        datatime=System.DateTime.Now.ToString();
		mailcontent=mailcontent.Replace("usermail",email);
        _mail.sendMail(email, mailtitle + ":" + companyname + datatime, mailcontent);
        _mail.Dispose();
//info= id + "用户：" + smtp_username + "　邮件：" + smtp_email + "　密码：" + smtp_password +  "　邮件：" + email + "　标题："  +   companyname  +   "　smtp：" + smtp + "<br>";
info= "记录号:" + id + "　公司名:" + companyname + "　邮件：" + email + "　标题："  +   mailtitle ;
}

	db.closedb();
}
</script>
<%=info%>