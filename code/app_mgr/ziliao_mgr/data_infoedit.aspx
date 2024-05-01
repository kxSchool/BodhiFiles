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
	protected string fileurl;
    protected string filetitle;
    protected string description;
    protected string createdate;
    protected int type_id;
    protected string filesizes;
    protected StringBuilder selectsb = new StringBuilder();
    protected StringBuilder sharesetsb = new StringBuilder();

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
        DataTable infotable = db.GetTable("select tbdata.*,tbuser.userno,tbuser.dept_id from tbdata left join tbuser on tbdata.userno=tbuser.userno where tbdata.id=?", param);

        if (infotable.Rows.Count > 0)
        {
		 
		    fileurl= infotable.Rows[0]["fileurl"].ToString();
	
            filetitle = infotable.Rows[0]["filetitle"].ToString();
            description = infotable.Rows[0]["description"].ToString();
            type_id = Convert.ToInt32(infotable.Rows[0]["type_id"].ToString());
            createdate = infotable.Rows[0]["uptime"].ToString();
            double sizes;
            if (Convert.ToInt64(infotable.Rows[0]["filesizes"].ToString()) > 1024 * 1024)
            {
                sizes = Convert.ToDouble(infotable.Rows[0]["filesizes"].ToString()) / (1024 * 1024);
                filesizes = sizes.ToString("0.0") + "MB";
            }
            else
            {
                sizes = Convert.ToDouble(infotable.Rows[0]["filesizes"].ToString()) / 1024;
                filesizes = sizes.ToString("0.0") + "KB";

            }


            //填充类型下拉框
            DataTable typetable = db.GetTable("select * from tbdatatype where userno='" + Session["userno"].ToString() + "'", null);
            for (int i = 0; i < typetable.Rows.Count; i++)
            {
                selectsb.Append("<option value=\"");
                selectsb.Append(typetable.Rows[i]["id"].ToString() + "\"");
                if (typetable.Rows[i]["id"].ToString() == infotable.Rows[0]["type_id"].ToString())
                {
                    selectsb.Append("selected = \"selected\"");
                }

                selectsb.Append(">" + typetable.Rows[i]["name"].ToString() + "</option>");
            }

            //共享选择
            sharesetsb.Append("<input type=\"radio\" name=\"shareset\"");
            if (infotable.Rows[0]["popedom"].ToString() == "0")
                sharesetsb.Append(" checked=\"checked\"");
            sharesetsb.Append(" value=\"0\" /> 私人");

            sharesetsb.Append(" <input type=\"radio\" name=\"shareset\"");
            if (Convert.ToInt32(infotable.Rows[0]["popedom"].ToString()) > 0 && Convert.ToInt32(infotable.Rows[0]["popedom"].ToString()) < 10000)
                sharesetsb.Append(" checked=\"checked\"");
            sharesetsb.Append(" value=\"" + infotable.Rows[0]["dept_id"].ToString() + "\"/> 本部门共享");

            sharesetsb.Append(" <input type=\"radio\" name=\"shareset\"");
            if (infotable.Rows[0]["popedom"].ToString() == "10000")
                sharesetsb.Append(" checked=\"checked\"");
            sharesetsb.Append(" value=\"10000\" /> 全局共享");
        }

    }







    /// <summary>
    /// /////////保存修改
    /// </summary>
    /// <param name="db"></param>

    private void SaveEdit(DBClass db)
    {
	  //如果重新选择了文件要覆盖原来的
	    if(this.myfile.Value != "")
		{
		
		    HttpPostedFile upfile = this.myfile.PostedFile;
		  int filelength = upfile.ContentLength;

        if (filelength != 0) 
        {
             
			 FileInfo f;
		 string path = ConfigurationSettings.AppSettings["data_center"].ToString() +  Request.Form["editfileurl"];
           
	
		    f = new FileInfo(path);
			 if (f.Exists)
			 {	     	  
                    File.Delete(path);   //为什么不起作用？
			 }
			 //取得新文件名的扩展名
			  string newfilename,oldfilename;
			  newfilename=myfile.Value;
			        int i = newfilename.LastIndexOf(".");
                 string newext = newfilename.Substring(i);
			
				;
				oldfilename=Request.Form["editfileurl"].ToString();
				 i=oldfilename.Substring(oldfilename.LastIndexOf(".")).Length;
				oldfilename=oldfilename.Substring(0, oldfilename.Length - i);

		  myfile.PostedFile.SaveAs(ConfigurationSettings.AppSettings["data_center"].ToString() +oldfilename+newext);
		  
		  		
			  //保存记录
				OdbcParameter[] myparams1 ={ 
				
					new OdbcParameter("@filetitle",OdbcType.VarChar),
					new OdbcParameter("@fileurl",OdbcType.VarChar),
					new OdbcParameter("@description",OdbcType.Text),
					  new OdbcParameter("@filesizes",OdbcType.VarChar),
					new OdbcParameter("@type_id",OdbcType.Int),
					new OdbcParameter("@popedom",OdbcType.Int)
		 
				};
		
		  
				myparams1[0].Value = Request.Form.Get("filetitle").ToString();
				myparams1[1].Value =oldfilename+newext;
				myparams1[2].Value = Request.Form.Get("description").ToString();
				myparams1[3].Value = filelength.ToString();
				myparams1[4].Value = Request.Form.Get("param4").ToString();
				myparams1[5].Value = Request.Form.Get("shareset").ToString();
		
		
	string sqls = "update tbdata  set filetitle=?,fileurl=?,description=?,filesizes=?,type_id=?,popedom=?  where id="+Request.Form["editid"];
		
				db.ExecuteNonQuery(sqls, myparams1);
		  
		  
		  
        }
		  
		  
 
		  
		}
		
		else
		{
		
	  
			
			  //保存记录
				OdbcParameter[] myparams ={ 
				
					new OdbcParameter("@filetitle",OdbcType.VarChar),
					new OdbcParameter("@description",OdbcType.Text),
					new OdbcParameter("@type_id",OdbcType.Int),
					new OdbcParameter("@popedom",OdbcType.Int)
		 
				};
		
		  
				myparams[0].Value = Request.Form.Get("filetitle").ToString();
				myparams[1].Value = Request.Form.Get("description").ToString();
				myparams[2].Value = Request.Form.Get("param4").ToString();
				myparams[3].Value = Request.Form.Get("shareset").ToString();
		
		
	string sqls = "update tbdata  set filetitle=?,description=?,type_id=?,popedom=?  where id="+Request.Form["editid"];
		
				db.ExecuteNonQuery(sqls, myparams);
				
				
		}
        db.closedb();
        Fun.alert("","修改成功",Link.url("/app_mgr/ziliao_mgr/", "data_manage.aspx", "", "", "", "", ""),"返回");
        Response.End();
    }


</script>
<html>
<head id="Head1" runat="server">
    <title>资料修改</title>
        <LINK href="/js/datepicker/default/datepicker.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript" src="/js/datepicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript">
function cca(s)
{//选择后边颜色
	var e=s
	while (e.tagName != "TR")
		e = e.parentElement;
	if(s.checked)
		e.style.backgroundColor="#FFFFe2";
	else
		e.style.backgroundColor="#ffffff";
}  
// <!CDATA[

 function form_check(){
  
   if(document.form1.filetitle.value==""){
     window.alert("请输入文件标题");
	 document.form1.filetitle.focus();
	 return (false);
	 }
    if(document.form1.param4.value==""){
	  window.alert("请选择资料类型！");
	  document.form1.param4.focus();
	  return (false);
	  }
	  document.getElementById("uploadingdiv_0").style.display="none";
	  document.getElementById("uploadingdiv_1").style.display="";
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
 <div id="uploadingdiv_0" style="display:;">
    <form name="form1" method="post" action="<%= Link.url("/app_mgr/ziliao_mgr/","data_infoedit.aspx","","save","","","")%>" enctype="multipart/form-data" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td style="height: 27px; width: 68px;" >
                    资料名称：</td>
                <td style="width: 353px; height: 27px; text-align:left">
                <input type="text" name="filetitle"  style="width: 299px" value="<%= filetitle %>"/></td>
                
          </tr>
		     <tr>
                <td style="height: 27px; width: 68px;" >
                    重传资料：</td>
               <td style="width: 353px; height: 27px; text-align:left">
			    
			       <input name="myfile" type="file" id="myfile" size="40" runat="server" /><br>
			 
		     <font color="#FF0000">  *重传资料将覆盖原来的文件</font></td>
                
          </tr>
         
             <tr>
                <td style="height: 27px; width: 68px;" >
                    关键词：</td>
                <td style="width: 353px; height: 27px; text-align:left">
              
                 <textarea name="description" style="width: 332px" rows="7"><% =description %></textarea>
              
              </td>
                
          </tr>
               <tr>
                <td style="height: 27px; width: 68px;" >
                    资料类别：</td>
                <td style="width: 353px; height: 27px; text-align:left">
                     <select name="param4"  style="height:44px; width: 101px;"> 
                                <option value="0">选择文件分类</option>
                                <% =selectsb.ToString() %>
                                 </select>
              </td>
                
          </tr>
          
            <tr>
                <td style="height: 27px; width: 68px;" >
                    共享设定：</td>
                <td style="width: 353px; height: 27px; text-align:left">
              
              <%= sharesetsb.ToString() %>
              
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
                <td style="height: 27px; width: 68px;" >
                    文件大小：</td>
                <td style="width: 353px; height: 27px; text-align:left">
               <font color="green"> <%= filesizes %></font>
              </td>
                
          </tr>
             
              <tr>
                <td style="width: 68px">
                
                </td>
                <td style="width: 153px"> 
        <input type="hidden" name="editid" value="<%= editid %>" />
		<input type="hidden" name="editfileurl" value="<%= fileurl %>" />
                &nbsp;<input name="Submit" type="submit" value="确认修改" style="width: 65px" />
  <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />
                </td>
            
             </tr>
      
        </table>
 </form>
 
 </div>
 <div id="uploadingdiv_1" style="display:none; filter: alpha(opacity=100); opacity: 1; left: 309px; top: 170px; width: 327px; height: 162px;">
                                           <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#999999">
                                             <tr>
                                               <td height="24" align="center" bgcolor="#FFFFFF"><table width="320" height="20" border="0" align="center" cellpadding="0" cellspacing="0">
                                                 <tr>
                                                   <td width="323" bgcolor="#666699">&nbsp;</td>
                                                 </tr>
                                               </table></td>
                                             </tr>
                                             <tr>
                                               <td align="center" bgcolor="#FFFFFF"><span class="content">您的资料可能比较大，请耐心等待!资料上传中.......</span></td>
                                             </tr>
   </table>
                                        
</div> 
 <br>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
