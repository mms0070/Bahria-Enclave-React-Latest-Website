using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Configuration;

namespace BahriaTownEnclave
{
    internal static class BillLookup
    {
        internal const string AuthorizedBillRefSessionKey = "AuthorizedBillPdfRef";

        private static string ConnectionString =>
            WebConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

        /// <summary>
        /// WHERE clause: trimmed string match, or BIGINT match when both parse (handles
        /// numeric columns without leading zeros vs KuickPay ref with prefix zeros).
        /// </summary>
        private static string PaymentReferenceWhere(string columnBracketed)
        {
            string c = "LTRIM(RTRIM(CAST(" + columnBracketed + " AS NVARCHAR(200))))";
            return "(" + c + "=@ref OR (" +
                "TRY_CONVERT(BIGINT, " + c + ")=TRY_CONVERT(BIGINT, @ref) " +
                "AND TRY_CONVERT(BIGINT, @ref) IS NOT NULL))";
        }

        /// <summary>OR of all configured payment-reference columns for this consumer prefix.</summary>
        private static string PaymentReferenceWhereAny(string fiveDigitPrefix)
        {
            var parts = BillingTables.PaymentReferenceColumnsForPrefix(fiveDigitPrefix)
                .Select(col => "(" + PaymentReferenceWhere(col) + ")");
            return "(" + string.Join(" OR ", parts) + ")";
        }

        /// <summary>KuickPay refs are numeric; strips spaces/dashes from paste so length matches DB.</summary>
        internal static string NormalizeConsumerReference(string refNo)
        {
            if (string.IsNullOrWhiteSpace(refNo))
                return refNo;
            refNo = refNo.Trim();
            var digits = new StringBuilder(refNo.Length);
            foreach (char ch in refNo)
            {
                if (ch >= '0' && ch <= '9')
                    digits.Append(ch);
            }
            return digits.Length >= 5 ? digits.ToString() : refNo;
        }

        internal static bool TryGetFromClause(string refNo, out string fromClause)
        {
            fromClause = null;
            refNo = NormalizeConsumerReference(refNo);
            if (string.IsNullOrWhiteSpace(refNo) || refNo.Trim().Length < 5)
                return false;

            refNo = refNo.Trim();
            string prefix = refNo.Substring(0, 5);

            if (prefix == "01000")
                fromClause = BillingTables.Phase16ElectricityFrom;
            else if (prefix == "01010")
                fromClause = BillingTables.Phase16MaintenanceFrom;
            else if (prefix == "01060")
                fromClause = BillingTables.Phase78ElectricityFrom;
            else if (prefix == "01070")
                fromClause = BillingTables.Phase78MaintenanceFrom;
            else if (prefix == "00550")
                fromClause = BillingTables.GenericElectricityFrom;
            else if (prefix == "01550")
                fromClause = BillingTables.GenericMaintenanceFrom;
            else
                return false;

            return true;
        }

        internal static bool Exists(string refNo)
        {
            refNo = NormalizeConsumerReference(refNo);
            if (!TryGetFromClause(refNo, out string from))
                return false;

            string prefix = refNo.Trim().Substring(0, 5);
            string sql = "SELECT COUNT(*) FROM " + from + " WHERE " + PaymentReferenceWhereAny(prefix);
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                var p = new SqlParameter("@ref", SqlDbType.NVarChar, 200) { Value = refNo.Trim() };
                cmd.Parameters.Add(p);
                con.Open();
                object scalar = cmd.ExecuteScalar();
                if (scalar == null || scalar == DBNull.Value)
                    return false;
                return Convert.ToInt32(scalar) > 0;
            }
        }

        /// <summary>Loads bill row(s) and report virtual path (~/) for Crystal.</summary>
        internal static bool TryLoadBillData(string refNo, out DataTable dt, out string reportVirtualPath)
        {
            dt = null;
            reportVirtualPath = null;

            refNo = NormalizeConsumerReference(refNo);
            if (!TryGetFromClause(refNo, out string from))
                return false;

            refNo = refNo.Trim();
            string prefix = refNo.Substring(0, 5);
            string sql = "SELECT * FROM " + from + " WHERE " + PaymentReferenceWhereAny(prefix);

            if (prefix == "01010")
                reportVirtualPath = "~/Report/Phase 1 - 6/Maintenance6.rpt";
            else if (prefix == "01070")
                reportVirtualPath = "~/Report/Phase 7 - 8/Maintenance7.rpt";
            else if (prefix == "01550")
                reportVirtualPath = "~/Report/Maintenance.rpt";

            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                var p = new SqlParameter("@ref", SqlDbType.NVarChar, 200) { Value = refNo };
                cmd.Parameters.Add(p);
                using (var da = new SqlDataAdapter(cmd))
                {
                    dt = new DataTable();
                    da.Fill(dt);
                }
            }

            // Crystal .rpt fields are {Electricity.*} / {Maintenance.*}; SqlDataAdapter default TableName is "Table".
            ApplyCrystalAdoNetTableName(dt, prefix);

            if (dt.Rows.Count == 0)
                return false;

            string tarrif = "";
            if (dt.Columns.Contains("Tarrif") && dt.Rows[0]["Tarrif"] != DBNull.Value)
                tarrif = dt.Rows[0]["Tarrif"].ToString();

            if (prefix == "01000")
            {
                reportVirtualPath = (tarrif == "A-1b(03)T")
                    ? "~/Report/Phase 1 - 6/Electricity - Net Meter6.rpt"
                    : "~/Report/Phase 1 - 6/Electricity6.rpt";
            }
            else if (prefix == "01060")
            {
                reportVirtualPath = (tarrif == "A-1b(03)T")
                    ? "~/Report/Phase 7 - 8/Electricity - Net Meter7.rpt"
                    : "~/Report/Phase 7 - 8/Electricity7.rpt";
            }
            else if (prefix == "00550")
            {
                reportVirtualPath = (tarrif == "A-1b(03)T")
                    ? "~/Report/Electricity - Net Meter.rpt"
                    : "~/Report/Electricity.rpt";
            }

            return !string.IsNullOrWhiteSpace(reportVirtualPath);
        }

        internal static string PdfFileNameForReference(string refNo)
        {
            if (string.IsNullOrWhiteSpace(refNo))
                return "Bill.pdf";

            string s = refNo.Trim();
            foreach (char c in Path.GetInvalidFileNameChars())
                s = s.Replace(c.ToString(), string.Empty);

            if (s.Length == 0)
                s = "Bill";
            if (s.Length > 180)
                s = s.Substring(0, 180);
            if (s.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase))
                return s;
            return s + ".pdf";
        }

        /// <summary>
        /// Match ADO.NET table name to the Crystal report dataset name (design-time table alias).
        /// </summary>
        private static void ApplyCrystalAdoNetTableName(DataTable dt, string fiveDigitPrefix)
        {
            if (dt == null)
                return;
            if (fiveDigitPrefix == "01000" || fiveDigitPrefix == "01060" || fiveDigitPrefix == "00550")
                dt.TableName = "Electricity";
            else if (fiveDigitPrefix == "01010" || fiveDigitPrefix == "01070" || fiveDigitPrefix == "01550")
                dt.TableName = "Maintenance";
        }
    }
}
