<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">


    protected string mydept_id = "";
    protected string share_datalist = "";
    protected StringBuilder sb = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

        if (Request.QueryString["param2"] ==null || Request.QueryString["param2"]=="")
        {
            ShowPage(db);
        }
        else
        {
            if (Request.QueryString["param2"].ToString() == "save")
            {
                SaveShare(db);
            }
        }


        db.closedb();
    }



    /// <summary>
    /// ////////
    /// </summary>
    /// <param name="db"></param>

    protected void ShowPage(DBClass db)
    {
        mydept_id = Session["dept_id"].ToString();


        string files = "select * from tbdata where tbdata.id in (" + Request.QueryString["param1"].ToString() + ")";
        DataTable setfilestable = db.GetTable(files, null);
        if (setfilestable.Rows.Count > 0)
        {
            for (int i = 0; i < setfilestable.Rows.Count; i++)
            {
                sb.Append("<input name=\"sel\" id=\"sel\" type=\"checkbox\" onclick=\"cca(this)\" checked  value=\"" + setfilestable.Rows[i]["id"].ToString() + "\"/> &nbsp;");
                sb.Append(setfilestable.Rows[i]["filetitle"].ToString());
                sb.Append("<br>");
            }
            share_datalist = sb.ToString();

        }

    }




    /// <summary>
    /// ///////保存设定
    /// </summary>
    /// <param name="db"></param>

    protected void SaveShare(DBClass db)
    {


        OdbcParameter[] param = 
            { 
                new OdbcParameter("@popedom", OdbcType.Int),
                new OdbcParameter("@sharetime",OdbcType.DateTime)
            };
        param[0].Value = Convert.ToInt32(Request.Form.Get("shareset").ToString());
        param[1].Value = DateTime.Now.ToString();
        string up_sql = "update tbdata set popedom=?,sharetime=? where tbdata.id in (" + Request.Form.Get("sel").ToString() + ")";
        db.ExecuteNonQuery(up_sql, param);
        db.closedb();
      Fun.alert("","共享设定成功",Link.url("/app_mgr/ziliao_mgr/", "data_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();

    }
</script>

<html>
<head id="Head1" runat="server">
    <title>共享设定</title>


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
<br>
<br>
 <div>
    <form name="form1" method="post" action="<%= Link.url("/app_mgr/ziliao_mgr/","data_shareset.aspx","","save","","","")%>">
        <table align="center" border="0" style="width: 751px; height: 111px">
          
          
            <tr>
                <td style="height: 27px; width: 87px;" >
                    共享资料：</td>
                <td style="width: 370px; height: 27px; text-align:left;" align="left">
                
                <%= share_datalist %>
                
                </td>
                
          </tr>
         
      
             
    
               <tr>
                <td style="height: 27px; width: 87px;">
                    共享设定：</td>
                <td style="width: 370px; height: 27px;" align="left">
                <input type="radio" name="shareset" checked="checked" value="0" /> 私人
       <input type="radio" name="shareset" value="<%= mydept_id %>" /> 本部门共享
       <input type="radio" name="shareset" value="10000" /> 全局共享
              </td>
                
          </tr>
             
              <tr>
                <td style="width: 87px">
                
                </td>
                <td style="width: 370px" align="left"> 
        
                &nbsp;<input name="Submit" type="submit" value="保存设定" style="width: 65px" />
                <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />
                </td>
            
             </tr>
      
        </table>
 </form>
 
 </div>
 
 <br>
 <myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>

