<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Configuration" %>
<%
string siteName = ConfigurationManager.AppSettings["SITE_NAME"] ?? "Corporate Portal";
string siteTagline = ConfigurationManager.AppSettings["SITE_TAGLINE"] ?? "Document Portal";
string footerLabel = ConfigurationManager.AppSettings["FOOTER_LABEL"] ?? "Internal Document Management System v3.2.1";

string msg = "";
if (Request.Files.Count > 0) {
    var f = Request.Files[0];
    var name = Path.GetFileName(f.FileName);
    var dst = Server.MapPath("~/uploads/" + name);
    f.SaveAs(dst);
    msg = "<div class='alert alert-success'>&#10004; Document uploaded successfully: <strong>" + Server.HtmlEncode(name) + "</strong></div>";
}
%>
<!DOCTYPE html>
<html>
<head>
  <title><%= Server.HtmlEncode(siteName) %> &mdash; <%= Server.HtmlEncode(siteTagline) %></title>
  <link rel="stylesheet" href="css/portal.css" />
</head>
<body>
  <div class="header">
    <h1><%= Server.HtmlEncode(siteName) %> <span><%= Server.HtmlEncode(siteTagline) %></span></h1>
    <div class="user-info">&#128100; <%= Request.ServerVariables["AUTH_USER"] != "" ? Request.ServerVariables["AUTH_USER"] : "Anonymous" %> &nbsp;|&nbsp; <%= DateTime.Now.ToString("MMM dd, yyyy") %></div>
  </div>
  <div class="nav">
    <a href="#" class="active">Upload</a>
    <a href="#">Documents</a>
    <a href="#">Shared</a>
    <a href="#">Archive</a>
    <a href="#">Settings</a>
  </div>
  <div class="container">
    <%= msg %>
    <div class="card">
      <h2>&#128196; Upload Document</h2>
      <form method="post" enctype="multipart/form-data">
        <div class="upload-area">
          <div class="icon">&#128449;</div>
          <p>Select a file to upload to the document repository.<br/>
          <span class="hint">Supported: PDF, DOCX, XLSX, PPTX, images, and other business documents.</span></p>
          <input type="file" name="f" />
          <br/><br/>
          <button type="submit" class="btn">Upload Document</button>
        </div>
      </form>
    </div>
    <div class="card recent">
      <h2>&#128337; Recent Activity</h2>
      <table>
        <tr><th>Document</th><th>Uploaded By</th><th>Date</th><th>Status</th></tr>
        <tr><td>Q3_Financial_Report.pdf</td><td>s.wilson</td><td><%= DateTime.Now.AddDays(-3).ToString("MMM dd, yyyy") %></td><td><span class="badge">Approved</span></td></tr>
        <tr><td>Vendor_NDA_Draft_v2.docx</td><td>a.kumar</td><td><%= DateTime.Now.AddDays(-4).ToString("MMM dd, yyyy") %></td><td><span class="badge">Pending Review</span></td></tr>
        <tr><td>Infrastructure_Audit.xlsx</td><td>r.johnson</td><td><%= DateTime.Now.AddDays(-6).ToString("MMM dd, yyyy") %></td><td><span class="badge">Approved</span></td></tr>
        <tr><td>Employee_Handbook_Update.pdf</td><td>m.garcia</td><td><%= DateTime.Now.AddDays(-9).ToString("MMM dd, yyyy") %></td><td><span class="badge">Archived</span></td></tr>
      </table>
    </div>
  </div>
  <div class="footer">&copy; <%= DateTime.Now.Year %> <%= Server.HtmlEncode(siteName) %> &mdash; <%= Server.HtmlEncode(footerLabel) %></div>
</body>
</html>
