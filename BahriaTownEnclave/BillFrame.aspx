<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BillFrame.aspx.cs" Inherits="BahriaTownEnclave.BillFrame" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#0a3d2c" />
    <title><%= Server.HtmlEncode(PageTitle) %></title>
    <style type="text/css">
        html, body { margin: 0; height: 100%; overflow: hidden; background: #0f2744; }
        iframe {
            border: 0;
            width: 100%;
            height: 100%;
            vertical-align: top;
            background: #1a1a1a;
        }
    </style>
</head>
<body>
    <iframe src="<%= Server.HtmlEncode(PdfFrameSrc) %>" title="<%= Server.HtmlEncode(PageTitle) %>"></iframe>
</body>
</html>
