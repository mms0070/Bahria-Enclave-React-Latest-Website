using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace BahriaTownEnclave
{
    public partial class BillExists : Page
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/json; charset=utf-8";

            string refNo = Request.QueryString["ref"];
            var payload = new Dictionary<string, object>();

            if (string.IsNullOrWhiteSpace(refNo) || refNo.Trim().Length < 5 ||
                !BillLookup.TryGetFromClause(refNo, out _))
            {
                payload["found"] = false;
                payload["reason"] = "invalid";
            }
            else
            {
                try
                {
                    if (BillLookup.TryLoadBillData(refNo, out DataTable dt, out _) &&
                        dt != null && dt.Rows.Count > 0)
                    {
                        payload["found"] = true;
                        payload["reason"] = "ok";
                        DataRow row = dt.Rows[0];
                        payload["amountDue"] = FindColumn(row, "Amount Due dATE", "Amountafterdate", "Current Amount", "TotalBill");
                        payload["dueDate"]   = FindColumn(row, "DateDue", "validtill");
                        payload["meterNo"]        = FindColumn(row, "MeterNo", "Meter No", "meter#");
                        payload["amountAfterDate"] = FindColumn(row, "Amountafterdate");
                        payload["billingMonth"]    = FindColumn(row, "BillingMonth");
                        payload["billingYear"]     = FindColumn(row, "BilllingYear", "BillingYear");
                    }
                    else
                    {
                        bool found = BillLookup.Exists(refNo);
                        payload["found"] = found;
                        payload["reason"] = found ? "ok" : "notfound";
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("BillExists: " + ex);
                    payload["found"] = false;
                    payload["reason"] = "error";
                }
            }

            Response.Write(new JavaScriptSerializer().Serialize(payload));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

        private static string FindColumn(DataRow row, params string[] candidates)
        {
            foreach (string name in candidates)
            {
                if (row.Table.Columns.Contains(name))
                {
                    object val = row[name];
                    if (val != null && val != DBNull.Value)
                    {
                        string s = val.ToString().Trim();
                        if (s.Length > 0) return s;
                    }
                }
            }
            return null;
        }
    }
}
