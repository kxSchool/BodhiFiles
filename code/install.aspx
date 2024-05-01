<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string val = HardDiskVal.GetVal();
        Response.Write("您的注册码： " + val.ToLower());

    }

</script>