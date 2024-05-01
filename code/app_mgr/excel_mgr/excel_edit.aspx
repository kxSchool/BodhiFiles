<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>


<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">

    protected string editid;
    protected string filetitle;
    protected string description;
    protected string createdate;



    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();



        if (Request.QueryString["param2"] == null ||Request.QueryString["param2"] == "" )
        {

            if (Request.QueryString["param1"] == "")
            {
            
                db.closedb();

		    Fun.goback("","参数错误删除！","返回");
                Response.End();
            }
            else
            {
                editid = Request.QueryString["param1"].ToString();
                ShowInfo(db);
            }


        }
        else
        {
	
            //保存修改
            SaveEdit(db);


        }


        db.closedb();
    }



    /// <summary>
    /// ////////////显示信息
    /// </summary>
    /// <param name="db"></param>
    protected void ShowInfo(DBClass db)
    {
        OdbcParameter param = new OdbcParameter("@id", OdbcType.Int, 4);
        param.Value = Convert.ToInt32(Request.QueryString["param1"].ToString());
        DataTable infotable = db.GetTable("select tbexcel.*,tbuser.userno from tbexcel left join tbuser on tbexcel.userno=tbuser.userno where tbexcel.id= ?", param);

        if (infotable.Rows.Count > 0)
        {
            filetitle = infotable.Rows[0]["filetitle"].ToString();
            description = infotable.Rows[0]["description"].ToString();
            createdate = infotable.Rows[0]["uptime"].ToString();
        }

    }







    /// <summary>
    /// /////////保存修改
    /// </summary>
    /// <param name="db"></param>

    private void SaveEdit(DBClass db)
    {
        OdbcParameter[] myparams ={ 
          
            new OdbcParameter("@filetitle",OdbcType.VarChar,100),
            new OdbcParameter("@description",OdbcType.Text), 
            new OdbcParameter("@id", OdbcType.Int, 4)
 
        };

       
        myparams[0].Value = Request.Form.Get("filetitle").ToString();
        myparams[1].Value = Request.Form.Get("description").ToString();
        myparams[2].Value = Convert.ToInt32(Request.Form.Get("editid").ToString());

        string sqls = "update tbexcel  set filetitle= ?,description=? where id=?";

        db.ExecuteNonQuery(sqls, myparams);
        db.closedb();
        Fun.alert("","修改成功",Link.url("/app_mgr/excel_mgr/", "excel_mgr.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }


</script>
<html>
<head id="Head1" runat="server">
    <title>报表修改</title>
        <LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript" src="/js/datepicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript">

// <!CDATA[

 function form_check(){
   if(document.form1.filetitle.value==""){  window.alert("请输入文件标题");document.form1.filetitle.focus();return (false);}
  
 }


// ]]>
</script>

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
    <form name="form1" method="post" action="<%= Link.url("/app_mgr/excel_mgr/","excel_edit.aspx","","save","","","")%>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px; width: 68px;" >
                    报表名称：</td>
                <td style="width: 353px; height: 27px; text-align:left">
                <input type="text" name="filetitle"  style="width: 299px" value="<%= filetitle %>"/></td>
                
          </tr>
         
             <tr>
                <td style="height: 27px; width: 68px;" >搜索描述：</td>
                <td style="width: 353px; height: 27px; text-align:left">
              
                 <textarea name="description" style="width: 332px" rows="7"><% =description %></textarea>
              
              </td>
                
          </tr>
             
 
    
          
                 <tr>
                <td style="height: 27px; width: 68px;" >
                    上传日期：</td>
                <td style="width: 353px; height: 27px; text-align:left">
               <font color="green"> <%= createdate %></font>
              </td>
                
          </tr>
            
             
              <tr>
                <td style="width: 68px">
                
                </td>
                <td style="width: 153px"> 
        <input type="hidden" name="editid" value="<%= editid %>" />
                &nbsp;<input name="Submit" type="submit" value="确认修改" style="width: 65px" />
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
