using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace BahriaTownEnclave
{
    public partial class BillAuthorize : Page
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/json; charset=utf-8";

            if (!string.Equals(Request.HttpMethod, "POST", System.StringComparison.OrdinalIgnoreCase))
            {
                Response.StatusCode = 405;
                Response.Write(new JavaScriptSerializer().Serialize(new Dictionary<string, object>
                {
                    { "ok", false },
                    { "reason", "method" }
                }));
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                return;
            }

            string refNo = Request.Form["ref"];
            var payload = new Dictionary<string, object>();

            if (string.IsNullOrWhiteSpace(refNo) || refNo.Trim().Length < 5 ||
                !BillLookup.TryGetFromClause(refNo, out _))
            {
                payload["ok"] = false;
                payload["reason"] = "invalid";
            }
            else
            {
                try
                {
                    if (!BillLookup.Exists(refNo))
                    {
                        payload["ok"] = false;
                        payload["reason"] = "notfound";
                    }
                    else
                    {
                        Session[BillLookup.AuthorizedBillRefSessionKey] =
                            BillLookup.NormalizeConsumerReference(refNo);
                        payload["ok"] = true;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("BillAuthorize: " + ex);
                    payload["ok"] = false;
                    payload["reason"] = "error";
                }
            }

            Response.Write(new JavaScriptSerializer().Serialize(payload));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
    }
}
