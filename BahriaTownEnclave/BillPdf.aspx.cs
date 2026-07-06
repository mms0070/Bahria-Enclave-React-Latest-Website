using System;
using System.Data;
using System.IO;
using System.Web;

using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

namespace BahriaTownEnclave
{
    public partial class BillPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string refNo = Session[BillLookup.AuthorizedBillRefSessionKey] as string;

            if (string.IsNullOrWhiteSpace(refNo) || refNo.Length < 5)
            {
                Response.StatusCode = 403;
                Response.ContentType = "text/plain; charset=utf-8";
                Response.Write("Bill session expired or missing. Open your bill again from the home page.");
                return;
            }

            refNo = refNo.Trim();

            if (!BillLookup.TryLoadBillData(refNo, out DataTable dt, out string rptPath) ||
                dt == null || dt.Rows.Count == 0 || string.IsNullOrWhiteSpace(rptPath))
            {
                Response.StatusCode = 404;
                Response.Write("Bill not found.");
                return;
            }

            try
            {
                using (ReportDocument rd = new ReportDocument())
                {
                    rd.Load(Server.MapPath(rptPath));
                    rd.SetDataSource(dt);

                    try
                    {
                        if (rd.SummaryInfo != null)
                            rd.SummaryInfo.ReportTitle = refNo;
                    }
                    catch
                    {
                        // Some .rpt templates may restrict summary edits; PDF still streams.
                    }

                    using (Stream stream = rd.ExportToStream(ExportFormatType.PortableDocFormat))
                    {
                        byte[] bytes = new byte[stream.Length];
                        stream.Read(bytes, 0, bytes.Length);

                        Response.Clear();
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.Buffer = true;

                        string pdfName = BillLookup.PdfFileNameForReference(refNo);
                        string safe = pdfName.Replace("\"", "");
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("Content-Disposition",
                            "inline; filename=\"" + safe + "\"; filename*=UTF-8''" + Uri.EscapeDataString(safe));
                        Response.AddHeader("Content-Length", bytes.Length.ToString());

                        Response.BinaryWrite(bytes);
                        Response.Flush();

                        HttpContext.Current.ApplicationInstance.CompleteRequest();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.StatusCode = 500;
                Response.ContentType = "text/plain";
                Response.Write("Error generating PDF: " + ex.Message);
            }
        }
    }
}
