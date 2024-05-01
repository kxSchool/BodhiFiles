<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>
<HTML>
<HEAD>
<TITLE>金石协同办公管理系统</TITLE>
<script type="text/javascript">
function reloadcode()
{
   location.reload();
}
 </script>
<STYLE>
DIV {
	FONT-SIZE: 9pt; LINE-HEIGHT: 15pt
}
BODY {
	SCROLLBAR-FACE-COLOR: #f6f7fb; SCROLLBAR-HIGHLIGHT-COLOR: #e8ebf1; SCROLLBAR-SHADOW-COLOR: #e8ebf1; SCROLLBAR-3DLIGHT-COLOR: #e8ebf1; SCROLLBAR-ARROW-COLOR: #000000; SCROLLBAR-TRACK-COLOR: #e8ebf1; SCROLLBAR-DARKSHADOW-COLOR: #e8ebf1
}
TABLE {
	FONT-SIZE: 9pt; LINE-HEIGHT: 15pt
}
.td1 {
	BORDER-RIGHT: #cccccc 1px solid; BORDER-TOP: #cccccc 1px solid; BORDER-LEFT: #cccccc 1px solid; BORDER-BOTTOM: #cccccc 1px solid
}


</style>




<LINK href="css/hanxin.css" type=text/css rel=stylesheet>



<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></HEAD>

<BODY vLink=#ffffff aLink=#ffffff link=#ffffff bgColor=#FFFFFF leftMargin=0 topMargin=0 scroll=no>
<TABLE height="100%" cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TR>
    <TD align=center><table width="189" height="194" border="0" cellpadding="0" cellspacing="0" background="images/phone.gif">
      <tr>
        <td align="center"><table width="160"  border="0" align="center" cellpadding="2" cellspacing="0" class="links">
          <tr>
            <td height="115"  class="99tt"><TABLE width="150" border=0 cellPadding=0 cellSpacing=0>
                <FORM name="form1" id="form1"
                      method="post" action="news_pwd.aspx">
                  <TR align="left" valign="bottom">
                    <TD width="43" height=35 noWrap>提取码:</TD>
                    <TD width="107">
                      <INPUT class="css0"  id="mobilepwd9" type="password" size=10  name="mobilepwd" style=" width:80pt;height:23px;"></TD>
                  </TR>
                  <TR align="left" valign="bottom">
                    <TD width="43" height=37 noWrap>验证码:</TD>
                    <TD><table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td><input name="checkcode" type="text" id="checkcode" style=" width:32pt;height:23px;" size="6" maxlength="4"></td>
                          <td><font face="宋体">←</font></td>
                          <td><img id="codeimg" width="50px" style="cursor:hand" height="24px" onClick="reloadcode()" src="/checkcode.aspx" alt="照此输入，看不清请点击重换" /></td>
                        </tr>
                    </table></TD>
                  </TR>
                  <TR align="center">
                    <TD height="37" colspan="2">
                      <input name="image" type="submit" value="信息提取" >
                    </TD>
                  </TR>
                </form>
            </TABLE></td>
          </tr>
        </table></td>
      </tr>
    </table>  
      </TD>
  </TR>
</TABLE>


<!--顶部浮动层-->
</BODY></HTML>
