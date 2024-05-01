<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>



<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>


<script runat="server">

    protected string companyname,username,postcode,phonecode,phone,province,capital,city,mainproducts,fax,mobilephone,website,email,createdate,userno;
    protected string oldispublic = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        DBClass db = new DBClass();

            
			if (Request.QueryString["param1"] == "saveedit")
            {
                SaveEdit(db);
            }

        db.closedb();

    }




    /// <summary>
    /// ////修改类别
    /// </summary>
    /// <param name="db"></param>

    protected void SaveEdit(DBClass db)
    {
        if (Request.Form.Get("companyname").ToString() == "")
        {
             db.closedb();
			 Fun.goback("","类别名不能为空！","返回");
            Response.End();
        }

        string sql = "insert into tbcustom  (companyname,username,postcode,phonecode,phone,province,capital,city,mainproducts,fax,mobilephone,website,email,createdate,userno) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        OdbcParameter[] param ={ 
           new OdbcParameter("@companyname",OdbcType.VarChar,255),
           new OdbcParameter("@username",OdbcType.VarChar,255),
           new OdbcParameter("@postcode",OdbcType.VarChar,255),
           new OdbcParameter("@phonecode",OdbcType.VarChar,255),
           new OdbcParameter("@phone",OdbcType.VarChar,255),
           new OdbcParameter("@province",OdbcType.VarChar,255),
           new OdbcParameter("@capital",OdbcType.VarChar,255),
           new OdbcParameter("@city",OdbcType.VarChar,255),
           new OdbcParameter("@mainproducts",OdbcType.VarChar,255),
           new OdbcParameter("@fax",OdbcType.VarChar,255),
           new OdbcParameter("@mobilephone",OdbcType.VarChar,255),
           new OdbcParameter("@website",OdbcType.VarChar,255),
           new OdbcParameter("@email",OdbcType.VarChar,255),
           new OdbcParameter("@createdate",OdbcType.DateTime),
           new OdbcParameter("@userno",OdbcType.VarChar,255)

        }; 
        param[0].Value = Request.Form.Get("companyname").ToString().Trim();
        param[1].Value = Request.Form.Get("username").ToString().Trim();
        param[2].Value = Request.Form.Get("postcode").ToString().Trim();
        param[3].Value = Request.Form.Get("phonecode").ToString().Trim();
        param[4].Value = Request.Form.Get("phone").ToString().Trim();
        param[5].Value = Request.Form.Get("provinceCN").ToString().Trim();
        param[6].Value = Request.Form.Get("capitalCN").ToString().Trim();
        param[7].Value = Request.Form.Get("cityCN").ToString().Trim();
        param[8].Value = Request.Form.Get("mainproducts").ToString().Trim();
        param[9].Value = Request.Form.Get("fax").ToString().Trim();
        param[10].Value = Request.Form.Get("mobilephone").ToString().Trim();
        param[11].Value = Request.Form.Get("website").ToString().Trim();
        param[12].Value = Request.Form.Get("email").ToString().Trim();
        param[13].Value = Request.Form.Get("createdate").ToString().Trim();
        param[14].Value = Request.Form.Get("userno").ToString().Trim();

        db.ExecuteNonQuery(sql, param);
        db.closedb();
        Response.Redirect(Link.url("/app_mgr/crm_mgr/","custom_add.aspx","","","","",""));
        Response.End();
    }

</script>

<html>
<head id="Head1" runat="server">
    <title>修改类别</title>
    <script language="javascript" src="/js/area.js"></script>
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
   if(document.form1.companyname.value==""){window.alert("请输入公司名称名称");document.form1.companyname.focus();return (false);}

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

 <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">客户添加</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>&nbsp; </td>
        </tr>
    </table> </td>
  </tr>
</TABLE>
 <div>
    <form name="form1" method="post" action="<%= Link.url("/app_mgr/crm_mgr/","custom_add.aspx","saveedit","","","","") %>" onsubmit ="return form_check();">
        <table align="center" border="0">
            <tr>
                <td colspan="2" style="height: 27px" >
                  </td>
          </tr>
          <tr>
          
                <td style="height: 30px">
                    公司名称：</td>
                <td style="width: 153px; height: 30px;">
                <input type="text" name="companyname" style="width: 257px; height: 20px;" value="<%=companyname %>" /></td>
            </tr>
           
             
              <tr>
                <td style="height: 30px"> 联系人员：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="username" style="width: 257px; height: 20px;" value="<%=username %>" /></td>
              </tr>
              <tr>
                <td style="height: 30px"> 邮政编码：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="postcode" style="width: 257px; height: 20px;" value="<%=postcode %>" /></td>
              </tr>
              <tr>
                <td style="height: 30px"> 电话区号：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="phonecode" style="width: 257px; height: 20px;" value="<%=phonecode %>" /></td>
              </tr>
              <tr>
                <td style="height: 30px"> 联系电话：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="phone" style="width: 257px; height: 20px;" value="<%=phone %>" /></td>
              </tr>
              <tr>
                <td style="height: 30px"> 所属省区：</td>
                <td style="width: 153px; height: 30px;">
                  <table border="0" cellspacing="0">
                    <tr>
                      <td><select name="provinceCN" id="provinceCN" onchange="javascript:changeProvinceList(this,this.form.capitalCN,this.options[this.selectedIndex].value);this.form.cityCN.length=1;">
                          <option value="" selected>选择省份</option>
                        </select>
                      </td>
                      <td><select name="capitalCN" id="capitalCN" onchange='javascript:changeCapitalCity(this,this.form.cityCN,this.options[this.selectedIndex].value);'>
                          <option value="" selected>选择城市</option>
                      </select></td>
                      <td><select name="cityCN" id="cityCN">
                          <option value="" selected>选择区县</option>
                        </select>
                          </td>
                    </tr>
                  </table>
				  <script language="javascript"> 
//生成省级分类下拉菜单
	createProvince(document.form1.provinceCN);
//调用定位区域函数
	//selectRegion('南通','CityID',document.RegionForm);
	
</script></td>
              </tr>
              <tr>
                <td style="height: 30px"> 主营产品：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="mainproducts" style="width: 257px; height: 20px;" value="<%=mainproducts %>" /></td>
              </tr>
              <tr>
                <td style="height: 30px"> 公司传真：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="fax" style="width: 257px; height: 20px;" value="<%=fax %>" /></td>
              </tr>
              <tr>
                <td style="height: 30px"> 手机号码：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="mobilephone" style="width: 257px; height: 20px;" value="<%=mobilephone %>" /></td>
              </tr>
			  <tr>
                <td style="height: 30px"> 公司网站：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="website" style="width: 257px; height: 20px;" value="<%=website %>" /></td>
              </tr>
			  <tr>
                <td style="height: 30px"> 电子邮件：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="email" style="width: 257px; height: 20px;" value="<%=email %>" /></td>
              </tr>
			  <tr>
                <td style="height: 30px"> 录入人员：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="userno" style="width: 257px; height: 20px;" value="<%=Session["userno"].ToString()%>" /></td>
              </tr>
			  <tr>
                <td style="height: 30px"> 录入时间：</td>
                <td style="width: 153px; height: 30px;">
                  <input type="text" name="createdate" style="width: 257px; height: 20px;" value="<%=DateTime.Now %>" /></td>
              </tr>
              <tr>
                <td>                </td>
                <td style="width: 153px"> 
                <input type="submit" value="修改" style="width: 65px" />
                  <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />                </td>
             </tr>
        </table>
 </form>
 
 </div>
 
 <br>
<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
