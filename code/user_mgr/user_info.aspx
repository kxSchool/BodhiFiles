<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<%@ Import Namespace="Microsoft.Data.Odbc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>

<%@ Register Src="/head.ascx" TagName="myhead" TagPrefix="myhead" %>
<%@ Register Src="/foot.ascx" TagName="myfoot" TagPrefix="myfoot" %>

<script runat="server">
    protected string username;
    protected string userno;
    protected string userid;
    protected string createdate;
    protected string usergrade;
    protected string deptselect;
    protected string olddeptid;
    protected string popedomgroupselect;
    protected string oldpopedomgroup;
    protected string sex;
    protected string email;
    protected string phone;
    protected string faxnum;
    protected string mobilephone;
    protected string msn;
    protected string qq;
    protected string postalcode;
    protected string address;


    protected string phonearea = "";
    protected string phonenum = "";
    protected string faxarea = "";
    protected string faxnumber = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        DBClass db = new DBClass();

        if (Request.QueryString["param2"] == null || Request.QueryString["param2"] == "")
        {

            //信息显示
            if (Request.QueryString["param1"] == null || Request.QueryString["param1"] == "")
            {
                Fun.goback("","参数错误!","返回");
                Response.End();
            }
            else
            {
                userno = Request.QueryString["param1"];
            }
            string sql = "select * from tbuser where userno=?";
            OdbcParameter param = new OdbcParameter("@userno", OdbcType.VarChar);
            param.Value = userno;
            DataTable usertable = db.GetTable(sql, param);
            if (usertable.Rows.Count < 1)
            {
			 db.closedb();
                Fun.goback("","参数错误!","返回");
                Response.End();
            }
            else
            {
                username = usertable.Rows[0]["username"].ToString();
                userid = usertable.Rows[0]["userid"].ToString();
                userno = usertable.Rows[0]["userno"].ToString();
                usergrade = usertable.Rows[0]["usergrade"].ToString();
                createdate = usertable.Rows[0]["createdate"].ToString();
                oldpopedomgroup = usertable.Rows[0]["popedomgroup"].ToString();
                olddeptid = usertable.Rows[0]["dept_id"].ToString();
                sex = usertable.Rows[0]["sex"].ToString();
                email = usertable.Rows[0]["email"].ToString();
                phone = usertable.Rows[0]["phone"].ToString();
                faxnum = usertable.Rows[0]["faxnum"].ToString();
                mobilephone = usertable.Rows[0]["mobilephone"].ToString();
                msn = usertable.Rows[0]["msn"].ToString();
                qq = usertable.Rows[0]["qq"].ToString();
                postalcode = usertable.Rows[0]["postalcode"].ToString();
                address = usertable.Rows[0]["address"].ToString();
                if (phone != "")
                {
                    phonearea = phone.Substring(0, phone.LastIndexOf("-"));
                    phonenum = phone.Substring(phone.LastIndexOf("-") + 1);
                }
                if (faxnum != "")
                {
                    faxarea = faxnum.Substring(0, faxnum.LastIndexOf("-"));
                    faxnumber = faxnum.Substring(faxnum.LastIndexOf("-") + 1);
                }

                //填充部门下拉框
                DataTable depttable = db.GetTable("select * from department", null);
                StringBuilder selectsb = new StringBuilder();
                for (int i = 0; i < depttable.Rows.Count; i++)
                {
                    selectsb.Append("<option value=\"");
                    selectsb.Append(depttable.Rows[i]["id"].ToString() + "\"");
                    if (depttable.Rows[i]["id"].ToString() == olddeptid)
                    {
                        selectsb.Append("selected = \"selected\"");
                    }

                    selectsb.Append(">" + depttable.Rows[i]["deptname"].ToString() + "</option>");
                }
                deptselect = selectsb.ToString();



                DataTable grouptable = new DataTable();
                grouptable = db.GetTable("select distinct groupname from popedomgroup", null);
                for (int group_i = 0; group_i < grouptable.Rows.Count; group_i++)
                {
                    popedomgroupselect += "<option value=\"" + grouptable.Rows[group_i]["groupname"].ToString() + "\"";
                    if (grouptable.Rows[group_i]["groupname"].ToString() == oldpopedomgroup)
                        popedomgroupselect += " selected=\"selected\"";

                    popedomgroupselect += ">" + grouptable.Rows[group_i]["groupname"].ToString() + "</option>";
                }
                //

            }

        }
        else
        { //保存信息

            if (Request.QueryString["param2"].ToString() == "saveedit")
            {



                OdbcParameter[] updateparam ={ 
                     new OdbcParameter("@username",OdbcType.VarChar),
                     new OdbcParameter("@sex",OdbcType.Char,1),
                    new OdbcParameter("@email",OdbcType.VarChar),
                      new OdbcParameter("@phone",OdbcType.VarChar),
                      new OdbcParameter("@faxnum",OdbcType.VarChar),
                      new OdbcParameter("@mobilephone",OdbcType.VarChar),
                      new OdbcParameter("@msn",OdbcType.VarChar),
                      new OdbcParameter("@qq",OdbcType.VarChar),
                      new OdbcParameter("@postalcode",OdbcType.VarChar),
                        new OdbcParameter("@address",OdbcType.VarChar)

                
                  };
                updateparam[0].Value = Request.Form.Get("username").ToString();
                updateparam[1].Value = Request.Form.Get("sex") == null ? "" : Request.Form.Get("sex").ToString();
                updateparam[2].Value = Request.Form.Get("email").ToString();
                updateparam[3].Value = Request.Form.Get("phonearea").ToString() + "-" + Request.Form.Get("phonenum").ToString();
                updateparam[4].Value = Request.Form.Get("faxarea").ToString() + "-" + Request.Form.Get("faxnumber").ToString();
                updateparam[5].Value = Request.Form.Get("mobilephone").ToString();
                updateparam[6].Value = Request.Form.Get("msn").ToString();
                updateparam[7].Value = Request.Form.Get("qq").ToString();
                updateparam[8].Value = Request.Form.Get("postalcode").ToString();
                updateparam[9].Value = Request.Form.Get("address").ToString();


                //更新 tbuser
                string upsql = "update tbuser set username=?,sex=?,email=?,phone=?,faxnum=?,mobilephone=?,msn=?,qq=?,postalcode=?,address=? where userno='"+  Request.Form.Get("edituserno") +"'";
                db.ExecuteNonQuery(upsql, updateparam);
                db.closedb();


                  Fun.alert("","信息修改成功",Link.url("/", "document.aspx", "", "", "", "", ""),"返回首页");
           

            }

        }



        db.closedb();



    }

</script>

<html>
<head id="Head1" runat="server">
    <title>详细信息</title>
    <link href="/images/style.css" rel="stylesheet" type="text/css" />
	<link href="/css/main.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
<!--
td {  font-family: "宋体"; font-size: 9pt}
body {  font-family: "宋体"; font-size: 9pt}
select {  font-family: "宋体"; font-size: 9pt}
A {text-decoration: none; color: #336699; font-family: "宋体"; font-size: 9pt}
A:hover {text-decoration: underline; color: #FF0000; font-family: "宋体"; font-size: 9pt} 
-->
</style>
<!--media=print 这个属性可以在打印时有效--> 
<style media=print> 
.Noprint{display:none;} 
.PageNext{page-break-after: always;} 
</style>

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
  if(document.form1.username.value==""){window.alert("姓名不能为空！");document.form1.username.focus();return (false);}
  if(document.form1.password.value==""){window.alert("姓名不能为空！");document.form1.password.focus();return (false);}
  
  
     
      }



// ]]>
</script>




</head>
<body>
<myhead:myhead ID="Myhead1" runat="server" />
 <TABLE border=0 cellspacing=0 cellpadding=0 width=100% class="hdrTabBg">
  <tr>
    <td height="32" class=small style="width:50px">&nbsp;</td>
    <td width="100" nowrap class=small><table>
        <tr>
          <td> <b><font color="#ffffff">个人信息编辑</font></b></td>
        </tr>
    </table></td>
    <td align="center" nowrap class=small>
	<table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="32" class=small>
                                     
					</td>
        </tr>
    </table> </td>
  </tr>
</TABLE>


<div>
      <form name="form1" method="post" action="<%= Link.url("/user_mgr/","user_info.aspx","","saveedit","","","")%>" onsubmit ="return form_check();">
        <table width="525" border="0" align="center">
            <tr>
                <td width="100" align="right" style="height: 24px;width:27%;" >
                    用户编号：</td>
              <td width="339" style="width: 153px; height: 24px;">  <input type="text" name="userno" disabled="disabled" value="<%= userno%>" style="width: 157px" /></td>
          </tr>
          <tr>
          
                <td style="height: 24px" align="right" >
                    登录名：</td>
            <td style="width: 153px; height: 24px;">
                <input type="text" name="userid"  disabled="disabled" value="<%= userid%>" style="width: 157px" /></td>
          </tr>
            <tr>
                <td style="height: 24px" align="right" >
                    真实姓名：                </td>
              <td style="width: 153px; height: 24px;">  <input type="text" name="username" value="<%= username%>" style="width: 157px" /></td>
          </tr  >
		  
		     <tr>
                <td style="height: 24px" align="right" >
                    所属部门：                </td>
                <td style="width: 153px; height: 24px;"> <select name="deptname" disabled="disabled" style="width: 119px"><%= deptselect %></select>                </td>
          </tr  >
		    <tr>
                <td style="height: 24px" align="right" >
                    所属权限组：                </td>
                <td style="width: 153px; height: 24px;"> <select name="popedomgroup" disabled="disabled" style="width: 119px"><%= popedomgroupselect %></select>                </td>
          </tr  >
		  	    <tr>
                <td style="height: 24px" align="right" >
                    注册时间：                </td>
                <td style="width: 153px; height: 24px;">  <input type="text" name="createdate"  disabled="disabled" value="<%= createdate%>" style="width: 157px" />                </td>
          </tr  >
		    <tr>
                <td style="height: 24px" align="right" ><font color="green">其他信息:</font></td>
                <td style="width: 153px; height: 24px;">&nbsp;</td>
          </tr  >
		    <tr>
          
                <td style="height: 24px" align="right" >性别：</td>
              <td style="width: 153px; height: 24px;"><input type="radio" name="sex" <% if(sex=="1") Response.Write("checked"); %> value="1"/>
              男  <input type="radio"  <% if(sex=="0") Response.Write("checked"); %> name="sex" value="0"/> 女</td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >电子邮箱：</td>
              <td style="width: 153px; height: 24px;"><input type="text" name="email" value="<%= email %>" style="width: 157px" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >联系电话：</td>
                <td style=" height: 24px;">
                <input type="text" name="phonearea" value="<%=phonearea %>" size="4" maxlength="4" />  <input type="text" name="phonenum" value="<%= phonenum %>" size="20" maxlength="50" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >传真号码：</td>
                <td style=" height: 24px;">
                <input type="text" name="faxarea" value="<%= faxarea %>" size="4" maxlength="4" />  <input type="text" name="faxnumber" value="<%= faxnumber %>" size="20" maxlength="50" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >移动电话：</td>
                <td style="width: 153px; height: 24px;">
                <input type="text" name="mobilephone" value="<%= mobilephone %>" style="width: 157px" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >
                    MSN：</td>
            <td style="width: 153px; height: 24px;">
                <input type="text" name="msn" value="<%=msn %>" style="width: 157px" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >
                    QQ：</td>
            <td style="width: 153px; height: 24px;"><input type="text" name="qq" value="<%=qq %>" style="width: 157px" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >
                    邮政编码：</td>
            <td style="width: 153px; height: 24px;">
                <input type="text" name="postalcode" value="<%=postalcode %>" style="width: 157px" /></td>
          </tr>
		    <tr>
          
                <td style="height: 24px" align="right" >
                    联系地址：</td>
            <td style="width: 153px; height: 24px;">
                <input type="text" name="address" value="<%= address %>" style="width: 207px" /></td>
          </tr>
           
              <tr>
                <td>                </td>
                <td > 
                <input type="hidden" name="edituserno" value="<%=userno %>" />
                <input type="submit" value="修改" style="width: 65px" />
                <input type="button" value="返回" onClick="javascript:history.go(-1);" style="width: 67px" />                </td>
             </tr>
      </table>
        </form>
 
 </div>






<myfoot:myfoot ID="foot1" runat="server" />
</body>
</html>
