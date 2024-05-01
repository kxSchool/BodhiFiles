<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>





<script runat="server">



    protected void Page_Load(object sender, EventArgs e)
    {
	
	
	     DBClass db = new DBClass();
		 
		 DataTable datatable = new DataTable();
      string  sqls = "select tbnews.id as 编号,tbuser.username as 姓名,tbnews.news_title as 文章标题  from tbnews  left join tbuser on tbnews.userno=tbuser.userno";

        datatable = db.GetTable(sqls, null);
		 db.closedb();
	      CreateExcel(datatable,"hanxin");
	

    }


    public void CreateExcel(DataTable dt, string FileName)
    {


        HttpResponse resp;
        resp = Page.Response;
        resp.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");
        resp.ContentType = "application/ms-excel";

        resp.AddHeader("Content-Disposition", "attachment; filename=" + System.Web.HttpUtility.UrlEncode(FileName, System.Text.Encoding.UTF8) + ".xls");

        this.EnableViewState = false;

        string colHeaders = "", Is_item = "";
        int i = 0;

        //定义表对象与行对象，同时使用DataSet对其值进行初始化
        DataRow[] myRow = dt.Select("");

        //取得数据表各列标题，标题之间以\t分割，最后一个列标题后加回车符
        for (i = 0; i < dt.Columns.Count; i++)
        {
            colHeaders += dt.Columns[i].Caption.ToString() + "\t";
        }
        colHeaders += "\n";

        resp.Write(colHeaders);
        //逐行处理数据
        foreach (DataRow row in myRow)
        {
            //在当前行中，逐列取得数据，数据之间以\t分割，结束时加回车符\n
            for (i = 0; i < dt.Columns.Count; i++)
            {
                Is_item += row[i].ToString() + "\t";
            }
            Is_item += "\n";
            resp.Write(Is_item);
            Is_item = "";
        }


        //写缓冲区中的数据到HTTP头文件中
        resp.End();




    } 
    
    

</script>

