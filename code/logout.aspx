<%@ Page Language="C#" %>
<%@ Import Namespace="Common" %>


<script runat="server">

 protected void Page_Load(object sender, EventArgs e)
    {

        Session.Abandon();

        Response.Redirect(Link.url("/", "default.aspx","","","","",""));
        Response.End();
    }
</script>

