using System;
using System.Data;
using System.Web;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;

namespace BahriaTownEnclave
{
    public partial class ViewBill : System.Web.UI.Page
    {
        private ReportDocument rdlc = new ReportDocument();

        protected bool PortalShowNotFound { get; private set; }
        protected bool PortalShowInvalidRef { get; private set; }
        protected bool PortalShowError { get; private set; }
        protected string PortalErrorMessage { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Ref"] == null)
                {
                    Response.Redirect("Default.aspx");
                }
                else
                {
                    LoadBillIntoViewer(Session["Ref"].ToString());
                }
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (IsPostBack && Session["rd"] != null)
            {
                CrystalReportViewer1.ReportSource = (ReportDocument)Session["rd"];
            }
        }

        private void LoadBillIntoViewer(string reference)
        {
            try
            {
                string prefix = reference.Length >= 5 ? reference.Substring(0, 5) : "";

                if (prefix != "01000" && prefix != "01010" && prefix != "01060" &&
                    prefix != "01070" && prefix != "00550" && prefix != "01550")
                {
                    PortalShowInvalidRef = true;
                    return;
                }

                if (!BillLookup.TryLoadBillData(reference, out DataTable dt, out string report) ||
                    dt == null || dt.Rows.Count == 0 || string.IsNullOrWhiteSpace(report))
                {
                    PortalShowNotFound = true;
                    return;
                }

                rdlc.Load(Server.MapPath(report));
                rdlc.SetDataSource(dt);
                CrystalReportViewer1.ReportSource = rdlc;
                CrystalReportViewer1.DataBind();
                Session["rd"] = rdlc;
            }
            catch (Exception)
            {
                PortalShowError = true;
                PortalErrorMessage = "Unable to load this bill. Please try again or contact the billing office.";
            }
        }

        protected void btnDownloadPDF_Click(object sender, EventArgs e)
        {
            if (Session["rd"] == null)
                return;

            ReportDocument report = (ReportDocument)Session["rd"];
            using (System.IO.Stream stream = report.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
            {
                byte[] buffer = new byte[stream.Length];
                stream.Read(buffer, 0, (int)stream.Length);

                Response.Clear();
                Response.ClearHeaders();
                Response.ClearContent();
                Response.Buffer = true;
                string refNo = Session["Ref"] != null ? Session["Ref"].ToString() : string.Empty;
                string pdfName = BillLookup.PdfFileNameForReference(refNo);
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "attachment; filename=\"" + pdfName.Replace("\"", "") + "\"");
                Response.BinaryWrite(buffer);
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
    }
}
