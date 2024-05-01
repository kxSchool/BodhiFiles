<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>



<script runat="server">

    protected StringBuilder sb = new StringBuilder();
    protected int cols;
	protected string sqls,sid,stxt;

    protected string excelurl = "";
    protected string title = "";
    protected bool isedit = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["param2"] == null ||Request.QueryString["param2"] == "")
        {
            if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "")
            {
				  Fun.alert("","参数错误！",Link.url("/app_mgr/excel_mgr/","excel_list.aspx","","","","","") ,"返回");
                Response.End();
            }
            else
            {
			sid = Request.QueryString["param1"].ToString();
			DBClass db = new DBClass();
        DataTable popedomgrouptable = new DataTable();
		sqls = "SELECT id, filetitle, fileurl, description FROM tbexcel where id=" + sid;
        popedomgrouptable = db.GetTable(sqls, null);
		excelurl = popedomgrouptable.Rows[0]["fileurl"].ToString();
        title =Server.UrlDecode( popedomgrouptable.Rows[0]["filetitle"].ToString());
		stxt =Server.UrlDecode( popedomgrouptable.Rows[0]["description"].ToString());
		db.closedb();
                
            }


            string strConn = "Provider=Microsoft.Jet.Oledb.4.0;Data Source=" + ConfigurationSettings.AppSettings["excel_center"].ToString() + excelurl + ";Extended Properties=Excel 8.0";
			
            OleDbConnection conn = new OleDbConnection(strConn);


            OleDbDataAdapter adp = new OleDbDataAdapter("Select * from [Sheet1$]", conn);
            DataTable dt = new DataTable();
            adp.Fill(dt);

            cols = dt.Columns.Count;

            sb.Append("<tr> <td style=\"height: 27px\" > ");
            sb.Append("<input type=\"hidden\" name=\"hid0\" value=\"" + dt.Columns[0].Caption.ToString() + "\" />");
            sb.Append("</td> <td style=\" height: 27px;\">");
            sb.Append("</td></tr>\n");

            if (dt.Columns.Count > 1)
            {

                for (int i = 1; i < dt.Columns.Count; i++)
                {
                    sb.Append("<tr> <td style=\"height: 27px\" > ");
                    sb.Append(dt.Columns[i].Caption.ToString());
                    sb.Append("<input type=\"hidden\" name=\"hid" + i.ToString() + "\" value=\"" + dt.Columns[i].Caption.ToString() + "\" />");
                    sb.Append("</td> <td style=\"height: 27px;\"> <textarea  name=\"col"+i.ToString()+"\" style=\"width:319px;height:60px;\"></textarea>");

                    sb.Append(" 最多255个字符!</td></tr>\n");

                }
            }
            conn.Close();
        }
        else
        {
            if (Request.QueryString["param2"].ToString() == "save")
            {



                string strConn = "Provider=Microsoft.Jet.Oledb.4.0;Data Source=" + ConfigurationSettings.AppSettings["excel_center"].ToString() + Request.Form.Get("excelurl").ToString() + ";Extended Properties=Excel 8.0";
                OleDbConnection conn = new OleDbConnection(strConn);



                string actiontype = "";
                if (Request.Form.Get("actiontype") != null)
                    actiontype = Request.Form.Get("actiontype").ToString();   //获得操作类别



                if (actiontype == "insert")
                {



                    //插入数据

                    int colscount = Convert.ToInt32(Request.Form.Get("colscount").ToString());

                    StringBuilder insertsb = new StringBuilder();
                    insertsb.Append("INSERT INTO ");
                    insertsb.Append("[Sheet1$] (");


                    for (int ii = 0; ii < colscount; ii++)
                    {
                        if (ii < (colscount - 1))
                            insertsb.Append(Request.Form.Get("hid" + ii.ToString()).ToString() + ",");
                        else
                            insertsb.Append(Request.Form.Get("hid" + ii.ToString()).ToString() + ")");
                    }

                    insertsb.Append(" values(");



                    for (int ii = 0; ii < colscount; ii++)
                    {
                        if (ii < (colscount - 1))
                            insertsb.Append("@col" + ii.ToString() + ",");
                        else
                            insertsb.Append("@col" + ii.ToString() + ")");
                    }



                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand(insertsb.ToString(), conn);
                
                    OleDbParameterCollection param = cmd.Parameters;
                    for (int ii = 0; ii < colscount; ii++)
                    {
                        param.Add(new OleDbParameter("@col" + ii.ToString(), OleDbType.VarChar,8000));

                    }
              Random rd = new Random();
            int rannum = rd.Next(0, 100) * 900450 + 200000;
                    param[0].Value = Session["username"].ToString() + DateTime.Now.ToString() + " ip:" + HttpContext.Current.Request.UserHostAddress.ToString()+"   " +rannum.ToString() + "";



                    if (param.Count > 1)
                    {
                        for (int ip = 1; ip < param.Count; ip++)
                        {
                            param[ip].Value = Request.Form.Get("col" + ip.ToString()).ToString().Trim().Length > 255 ? Request.Form.Get("col" + ip.ToString()).ToString().Trim().Substring(0, 255) : Request.Form.Get("col" + ip.ToString()).ToString().Trim();

                        }

                    }
                    cmd.ExecuteNonQuery();
                    conn.Close();
         
					  Fun.alert("","提交成功！",Link.url("/app_mgr/excel_mgr/","excel_list.aspx","","","","","") ,"返回");
                    Response.End();
                }//insert


            }//save


        }//else




    }
    
    

</script>

<html>

<head>

<link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">

 BODY {
	FONT-SIZE: 9pt
}

</style>

</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
<div>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="center"><TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
          <tr>
            <td height="32" class=small style="width:50px">&nbsp;</td>
            <td nowrap class=small style="width: 100px"><table style="width: 578px">
                <tr>
                  <td> <b><font color="#ffffff">在线填报</font></b><font color="red"><%=title %></font></td>
                </tr>
            </table></td>
            <td align="center" nowrap class=small>
              <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="32" class=small> </td>
                </tr>
            </table></td>
          </tr>
        </TABLE>
          <div>
            <form name="form1" method="post" action="<%= Link.url("/app_mgr/excel_mgr/","excel_form.aspx","","save","","","") %>">
              <table align="center" border="0">
                <tr>
                  <td height="25" colspan="2"></td>
                </tr><tr>
                  <td colspan="2"><%=stxt %></td>
                </tr>
				<%= sb.ToString() %>
                
                <tr>
                  <td>
                    <input type="hidden" name="colscount" value="<%=cols %>" />
                    <input type="hidden" name="excelurl" value="<%=excelurl %>" />
                  </td>
                  <td>
                    <input type="hidden" id="actiontype" name="actiontype" style="width: 47px; height: 20px" />
          &nbsp;
                    <input name="button" type="button" style="width: 65px" onClick="document.getElementById('actiontype').value='insert';document.form1.submit()" value="提交" />
                    <input name="button" type="button" style="width: 67px" onClick="javascript:window.close();" value="关闭" />
                  </td>
                </tr>
              </table>
            </form>
        </div></td>
      </tr>
    </table>
 </div>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
