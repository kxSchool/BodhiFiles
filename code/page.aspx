<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<script runat="server">
    public int total;
    public int nowpage;
    public int pagesize;
    public int maxpage;
    protected void Page_Load(object sender, EventArgs e)
    {

        DBClass db = new DBClass();
        string begid="",endid="";
		string sql="";
		DataTable dt = new DataTable();
		pagesize = 10;  //每页显示
		sql="SELECT count(*) AS ids FROM tbcustom";
        dt = db.GetTable(sql, null);
	    total=int.Parse(dt.Rows[0]["ids"].ToString());
		
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
        if (nowpage * pagesize < total)
            showcount = nowpage * pagesize;
        else
            showcount = total;
			
		sql="SELECT MAX(id) AS ids FROM (SELECT TOP " + ((Convert.ToInt32(nowpage)-1)*Convert.ToInt32(pagesize)+1).ToString() + " id FROM tbcustom) a";
        dt = db.GetTable(sql, null);
		if (dt.Rows.Count == 0)
        {
            Response.Write("没有开始ID号");
        }
		else
		{
		    begid=dt.Rows[0]["ids"].ToString();
		}
		

		sql="SELECT MAX(id) AS ids FROM (SELECT TOP " + (Convert.ToInt32(nowpage)*Convert.ToInt32(pagesize)).ToString() + " id FROM tbcustom) a";
        dt = db.GetTable(sql, null);
		if (dt.Rows.Count == 0)
        {
            Response.Write("没有结束ID号");
        }
		else
		{
		    endid=dt.Rows[0]["ids"].ToString();
		}
 
       sql="SELECT * from tbcustom where id between " + begid + " and " + endid;
	  Response.Write(sql);
	  Response.Write("<br>");
	   Response.Write("nowpage:" + nowpage + " showcount:" + showcount  + " total:" + total  + " pagesize:" + pagesize   + " maxpage:" + maxpage );
       Response.Write("<br>");
	    dt = db.GetTable(sql, null);
  	 for (int i = 0; i < dt.Rows.Count; i++)
        {
		Response.Write(dt.Rows[i]["id"].ToString());
		Response.Write("<br>");
		}
		db.closedb();
		
		

    }

 </script>