using System;
using System.Web;

namespace BahriaTownEnclave
{
    public partial class BillFrame : System.Web.UI.Page
    {
        public string PageTitle { get; private set; }
        public string PdfFrameSrc { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            string refNo = Session[BillLookup.AuthorizedBillRefSessionKey] as string;

            if (string.IsNullOrWhiteSpace(refNo) || refNo.Trim().Length < 5)
            {
                Response.Redirect(ResolveUrl("~/Default.aspx"), false);
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                return;
            }

            refNo = refNo.Trim();
            string prefix = refNo.Substring(0, 5);
            bool allowed = prefix == "01000" || prefix == "01010" || prefix == "01060" ||
                prefix == "01070" || prefix == "00550" || prefix == "01550";
            if (!allowed)
            {
                Response.Redirect(ResolveUrl("~/Default.aspx"), false);
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                return;
            }

            PageTitle = refNo;
            PdfFrameSrc = "BillPdf.aspx";
        }
    }
}
