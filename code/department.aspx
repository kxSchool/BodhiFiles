<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text" %>
<%@ Register Src="head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>


<script runat="server">

    
DateTime dt1=Convert.ToDateTime(System.DateTime.Now.AddDays(-1).ToShortDateString().ToString());
    DataTable typetable = new DataTable();
    DataTable dt = new DataTable();
	int ii=0;
	int sub_i=0;
    protected void Page_Load(object sender, EventArgs e)
    {
	
	  
		
        DBClass db = new DBClass();
        typetable = db.GetTable("select * from department order by createtime");
        dt = db.GetTable("SELECT tbnews.*, tbnewstype.typename,tbuser.username,tbuser.dept_id FROM (tbnews LEFT JOIN tbnewstype ON tbnews.type_id = tbnewstype.id) LEFT JOIN tbUser ON tbnews.userno = tbUser.UserNo WHERE (((tbnews.isdelete)=0) AND ((tbnewstype.ispublic='1') or (tbnewstype.ispublic='2')) ) ORDER BY tbnews.createtime DESC",null);
       //string abc;
	   //abc="select tbnews.*,tbnewstype.typename from tbnews left join tbnewstype on tbnews.type_id=tbnewstype.id  where tbnews.isdelete=0 and tbnewstype.ispublic='1' order by tbnewstype.typename,tbnews.createtime";
	   //Response.Write(abc);
        db.closedb();
        
    }
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>无标题页</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	margin-top: 0px;
}
#hanxin{
 margin: 0 auto;

text-align;center;
}
#uploadingdiv{     
    width:500px; 
    height:200px; 
    background:#EDF1F8;     
    border: 2px solid #849BCA; 
    margin-top:2px; 
    margin-left:2px; 
    float:left; 
    overflow:hidden; 
    position:absolute; 
    left:0px; 
    top:0px; 
    cursor:move; 
    float:left; 
    /*filter:alpha(opacity=50);*/ 
     
} 
.content{ 
    padding:10px; 
} 
</style></head>
<script type="text/javascript" language="javascript">
function allsearch()
{
	 url="<%=Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search","","","param3_idd") %>";
	  url = url.replace("param3_idd",encodeURI(document.selform2.param3.value));
     document.selform2.action=url;
	 //alert(url);
document.selform2.submit();
}
</script>
<body>
<myhead:myhead ID="myhead1" runat="server" />
<TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">单位最新信息</font></b></td>
        </tr>
    </table></td>
    <td nowrap class=small>
	<table width="600" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
				
				<table border="0" align="center" cellpadding="0" cellspacing="0">
      <form action="<%=Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search","","","") %>" method="post" name="selform2" onSubmit="allsearch()">
	  <tr>
	  <td height="32" class=delBg>项目模糊定位:
	  </td>
        <td height="32" class=small>
          <input type="text" name="param3" style="width: 164px; height: 20px;" />
          <input name="button" type="button" style="width: 75px; height: 21px;" onClick="allsearch()" value="检索" /></td>
      </tr></form>
    </table></td>
                  </tr>
                </table></td>
  </tr>
</TABLE>
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
      
      <%    
        if(typetable.Rows.Count>0)
        {
            int dd = 0;
            for (int i = 0; i < typetable.Rows.Count; i++)
            {
            
             
                if (  i % 2 == 0)
                {
                   
               %>
             <tr>  
             <%
                }  %>
  
                        
            <td valign="top" style="height: 140px;width:33%;font-size:12px;">
                <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#C0C0C0">
                    <tr>
                      <td height="27" colspan="1" align="center" bgcolor="#FFFFFF">
                      <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0" class="save">
                        <tr>
                          <td class="txtGreen">　 <strong><%= typetable.Rows[i]["deptname"].ToString() %></strong></td>
                          <td width="45" align="center"><a href="<%=Link.url("/app_mgr/news_mgr/","news_allsearch.aspx","","search","","",typetable.Rows[i]["id"].ToString()) %>" class="txtGreen">more</a></td>
                        </tr>
                      </table></td>
                   
				    </tr>
                    <tr>
                        <td height="120" colspan="1" valign="top" bgcolor="#FFFFFF" style="font-size:12px;">  
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  
                      <%  sub_i=1;
					  for(ii = 0; ii < dt.Rows.Count; ii++)
						 {
						 if(typetable.Rows[i]["id"].ToString()==dt.Rows[ii]["dept_id"].ToString() && sub_i<=5 )
						        {%>
								<tr><td height="20">
						<IMG height="12" 
                              src="css/direct_blue.gif" width="10"><%=sub_i%>.
						<%if (Convert.ToDateTime(dt.Rows[ii]["createtime"].ToString())>dt1) {%><IMG src="css/new.gif"> <%}%><A class="word" 
                              title="<%= dt.Rows[ii]["news_title"].ToString()%>"
                              href=" <%= Link.url("app_mgr/news_mgr/","news_view.aspx",dt.Rows[ii]["id"].ToString(),"","","","") %>"　class="settingsTabHeader">&nbsp;<span class="txtGreen"><%= dt.Rows[ii]["news_title"].ToString()%></span>　[<%= dt.Rows[ii]["username"].ToString()%>]　[<%= dt.Rows[ii]["createtime"].ToString()%>]</A>
							  </td></tr>
					  <%sub_i++;}
                        if (sub_i > 5){sub_i = 1;break;}
						}%>	

</table></td>
                    </tr>
              </table>            </td>
          
            
              <% 
                  dd++;
				  
            if (dd == 2)
            {
                dd = 0;
             %>
             </tr>
             
             <%
            }
            }
        
        }

        if (typetable.Rows.Count > 0 && typetable.Rows.Count % 3 != 0)
        {
           %>
           </tr>
    
      <%} %>
  </table>
<myfoot:myfoot ID="foot2" runat="server" />
</body>
</html>
