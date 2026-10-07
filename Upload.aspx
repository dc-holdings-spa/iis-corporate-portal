<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Configuration" %>
<%
string siteName = ConfigurationManager.AppSettings["SITE_NAME"] ?? "Corporate Portal";
string siteTagline = ConfigurationManager.AppSettings["SITE_TAGLINE"] ?? "Document Portal";
string footerLabel = ConfigurationManager.AppSettings["FOOTER_LABEL"] ?? "Internal Document Management System v3.2.1";

// ── Extension allowlist (business documents only) ─────────────────────
// This is the CODE-LEVEL defense. The web.config <location path="uploads">
// section provides a second layer by blocking .aspx/.ashx/.asp at the IIS
// handler level. The vuln plugin removes BOTH layers.
string[] allowedExtensions = new string[] {
    ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx",
    ".odt", ".ods", ".odp", ".rtf", ".txt", ".csv",
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tif", ".tiff",
    ".zip", ".7z", ".rar"
};
const long maxFileSizeBytes = 50L * 1024 * 1024; // 50 MB

string msg = "";
if (Request.Files.Count > 0) {
    var f = Request.Files[0];
    if (f == null || string.IsNullOrEmpty(f.FileName) || f.ContentLength == 0) {
        msg = "<div class='alert alert-error'>&#10008; No file selected or file is empty.</div>";
    } else if (f.ContentLength > maxFileSizeBytes) {
        msg = "<div class='alert alert-error'>&#10008; File exceeds maximum allowed size (50 MB).</div>";
    } else {
        // Path.GetFileName strips directory separators — prevents path traversal
        var name = Path.GetFileName(f.FileName);

        // Reject names with characters that could cause filesystem issues
        if (name.IndexOfAny(new char[] { '<', '>', ':', '"', '|', '?', '*' }) >= 0) {
            msg = "<div class='alert alert-error'>&#10008; File name contains invalid characters.</div>";
        } else {
            var ext = Path.GetExtension(name).ToLowerInvariant();
            if (string.IsNullOrEmpty(ext) || Array.IndexOf(allowedExtensions, ext) < 0) {
                msg = "<div class='alert alert-error'>&#10008; File type <strong>" + Server.HtmlEncode(ext) + "</strong> is not permitted. Allowed formats: PDF, DOCX, XLSX, PPTX, images, and other business documents.</div>";
            } else {
                var dst = Server.MapPath("~/uploads/" + name);
                f.SaveAs(dst);
                msg = "<div class='alert alert-success'>&#10004; Document uploaded successfully: <strong>" + Server.HtmlEncode(name) + "</strong></div>";
            }
        }
    }
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
