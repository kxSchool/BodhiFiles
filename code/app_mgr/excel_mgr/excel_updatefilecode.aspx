<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<script runat="server" language="C#">
    protected StringBuilder sb = new StringBuilder();
    protected int cols;
	protected string sqls,sid,stxt;
    protected string excelurl = "";
    protected string title = "";
    protected bool isedit = false;
	
    protected void Page_Load(object sender, EventArgs e)
    {

		FileUpdate();
	   Response.Write("成功");
    }
	
	
 protected void FileUpdate()
    {
            string strConn = "Provider=Microsoft.Jet.Oledb.4.0;Data Source=" + ConfigurationSettings.AppSettings["excel_center"].ToString() + "a.xls" + ";Extended Properties='Excel 8.0;HDR=yes;IMEX=1;'";
            OleDbConnection conn = new OleDbConnection(strConn);
			if(conn.State == ConnectionState.Open)
			     conn.Close();
  
			//conn.Open();
       //OleDbCommand cmd = new OleDbCommand("Alter   TABLE    [Sheet1$]   Add     f8  Text", conn);
	  //  cmd.ExecuteNonQuery();
	      conn.Close();
	
	
	/*        OleDbDataAdapter adp = new OleDbDataAdapter("Select * from [Sheet1$]", conn);
            DataTable dt = new DataTable();
            adp.Fill(dt);
			cols = dt.Columns.Count;
			if (dt.Columns.Count > 0)
			{
			for (int i = 0; i < dt.Columns.Count; i++)
                {
				Response.Write(dt.Columns[i].Caption.ToString());
				  }
             }
            conn.Close();
			*/	
				
			//string strConn = "Provider=Microsoft.Jet.Oledb.4.0;Data Source=" + ConfigurationSettings.AppSettings["excel_center"].ToString() + Request.Form.Get("excelurl").ToString() + ";Extended Properties='Excel 8.0;HDR=no;IMEX=1'";
            //OleDbConnection conn = new OleDbConnection(strConn);
          //  conn.Open();
           // OleDbCommand cmd = new OleDbCommand(insertsb.ToString(), conn);
           // OdbcParameterCollection param = cmd.Parameters;
           // cmd.ExecuteNonQuery();
           // conn.Close();
    }   
</script>