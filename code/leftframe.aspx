<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text" %>



<script  runat="server">

    protected string menustring = "";
    protected int big_count;
    protected int[] sub_count;
    protected string[] big_menu;
    protected string[,] sub_menu;
    protected string[,] sub_menulink;


    protected string onlineperson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();



        if (Session["userno"] == null || Session["userno"].ToString() == "")
        {
            db.closedb();
            Response.Write("javascript:window.parent.location.href=\"" + Link.url("/", "default.aspx","","","","","") + "\";");
            Response.End();
        }

        sub_count = new int[50];
        big_menu = new string[50];
        sub_menu = new string[50, 100];
        sub_menulink = new string[50, 100];

        string sqlstr = "select tbsystem.parentvalue,popedom.variable as submenuname,tbsystem.variable as linkurl,tbsystem.orderbysencond,tbsystem.orderbyparent from popedom,tbsystem where  popedom.variable=tbsystem.sencondvalue and popedom.popedom=1 and  popedom.userno='" + Session["userno"].ToString() + "' order by tbsystem.orderbyparent asc,tbsystem.orderbysencond asc";
        //Response.Write(sqlstr);
		DataTable dt = new DataTable();
        dt = db.GetTable(sqlstr, null);

        if (dt.Rows.Count > 0)
        {
            string bigmenuname = dt.Rows[0]["parentvalue"].ToString();

            //添加第一个大类
            big_menu[big_count] = bigmenuname;
            big_count++;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["parentvalue"].ToString() == bigmenuname)
                {

                    sub_menu[big_count - 1, sub_count[big_count - 1]] = dt.Rows[i]["submenuname"].ToString();
                    sub_menulink[big_count - 1, sub_count[big_count - 1]] = dt.Rows[i]["linkurl"].ToString();
                    sub_count[big_count - 1]++;

                }
                else
                {

                    bigmenuname = dt.Rows[i]["parentvalue"].ToString();
                    big_menu[big_count] = bigmenuname;
                    big_count++;


                    sub_menu[big_count - 1, sub_count[big_count - 1]] = dt.Rows[i]["submenuname"].ToString();
                    sub_menulink[big_count - 1, sub_count[big_count - 1]] = dt.Rows[i]["linkurl"].ToString();
                    sub_count[big_count - 1]++;

                }
            }

        }





        db.closedb();

    }

</script>

<html>
<head id="Head1" runat="server">
<title></title>
    
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" href="css/common.css" type="text/css" />
<script  type="text/javascript">

	   
	   function getObject(objectId)
	   {
	   if(document.getElementById&&document.getElementById(objectId))
	   {
	   return document.getElementById(objectId)
	   }
	   else if(document.all&&document.all(objectId))
	   {
	   return document.all(objectId)
	   }
	   else if(document.layers&&document.layers[objectId])
	   {
	   return document.layers[objectId]
	   }
	   else
	   {
	   return false
	   }
	   }
	   


	   function hideorshow(divid){
	       subsortid="sub_sort_"+divid.substring(11);
		   if(getObject(divid).style.display=="none")
		   {
		   for (var i=0;i<<%=big_count%>;i++)
		    {
			getObject("sub_detail_"+i).style.display="none";
			getObject("sub_sort_"+i).className="list_tilte_onclick";
			}
		   getObject(divid).style.display="block";getObject(subsortid).className="list_tilte"}
		   else
		   {getObject(divid).style.display="none";getObject(subsortid).className="list_tilte_onclick"}
		   
		   }
</script>
</head>

     
<BODY>


<div id="left_content">
  <div id="user_info"><a href="<%=Link.url("/","department.aspx","","","","","")%>" target="main"><%=Session["deptname"].ToString()%></a>:<%=Session["username"].ToString()%><br />
    [<a href="<%=Link.url("/","document.aspx","","","","","")%>" target="main">返回登陆启始页</a>]</div>
<div id="main_nav">
<div id="right_main_nav">
<%  for (int i_big = 0; i_big < big_count; i_big++)
{%>	
		
<div class="<%
if (i_big<big_count-1)
 {Response.Write("list_tilte_onclick");}
 else
 {Response.Write("list_tilte");}
 %>" id="sub_sort_<%=i_big %>" onclick="hideorshow('sub_detail_<%=i_big %>')" style="width: 158px">
<span>&nbsp;<% =big_menu[i_big] %></span>
</div>

<div class="list_detail" id="sub_detail_<%=i_big %>"  style="display:<%
if (i_big<big_count-1)
 {Response.Write("none");}%>;" >
<ul>
<%  for (int i_sub = 0; i_sub < sub_count[i_big]; i_sub++)
{%>
<li id="dfd">&nbsp;<a href="<%= Link.url("/", sub_menulink[i_big,i_sub],"","","","","")   %>" target="<%
if (sub_menulink[i_big,i_sub]=="logout.aspx" )
{Response.Write("_parent");
}
else
{Response.Write("main");
}
%>" class="left_back"><%=sub_menu[i_big,i_sub] %></a></li>
<%}%>
</ul>		
</div>
 <%}%>

</div> 
</div>
</div>




</body>
</html>
