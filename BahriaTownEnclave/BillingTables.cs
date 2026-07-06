using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.Configuration;

namespace BahriaTownEnclave
{
    internal static class BillingTables
    {
        private static readonly Regex SafeTableRef = new Regex(
            @"^(?:\[[^\]]+\]|[a-zA-Z_][a-zA-Z0-9_]*)(?:\.(?:\[[^\]]+\]|[a-zA-Z_][a-zA-Z0-9_]*))*$",
            RegexOptions.Compiled | RegexOptions.CultureInvariant);

        public static string GenericElectricityFrom => Resolve("BillingGenericElectricityTable", "Electricity");

        public static string GenericMaintenanceFrom => Resolve("BillingGenericMaintenanceTable", "Maintenance");

        /// <summary>Prefix 01000 — must match the table that stores Phase 1–6 electricity rows.</summary>
        public static string Phase16ElectricityFrom => Resolve("BillingPhase16ElectricityTable", "bahriabilling");

        /// <summary>Prefix 01060 — must match the table that stores Phase 7–8 electricity rows.</summary>
        public static string Phase78ElectricityFrom => Resolve("BillingPhase78ElectricityTable", "bahriabilling78");

        /// <summary>Prefix 01010 — Phase 1–6 maintenance.</summary>
        public static string Phase16MaintenanceFrom => Resolve("BillingPhase16MaintenanceTable", "bahriabillingment");

        /// <summary>Prefix 01070 — Phase 7–8 maintenance.</summary>
        public static string Phase78MaintenanceFrom => Resolve("BillingPhase78MaintenanceTable", "bahriabillingment78");

        private static readonly Regex BracketedIdentifier = new Regex(
            @"^\[[^\]]+\]$",
            RegexOptions.Compiled | RegexOptions.CultureInvariant);

        /// <summary>
        /// Column used in WHERE for KuickPay / online payment reference (must match the database).
        /// Default keeps the legacy spelling 'Refrence' used in existing schemas.
        /// </summary>
        public static string PaymentReferenceColumn
        {
            get
            {
                const string key = "BillingPaymentReferenceColumn";
                string raw = WebConfigurationManager.AppSettings[key];
                if (string.IsNullOrWhiteSpace(raw))
                    raw = "[Online PMNT Refrence]";
                raw = raw.Trim();
                if (!BracketedIdentifier.IsMatch(raw))
                    throw new InvalidOperationException(
                        "AppSettings[\"" + key + "\"] must be a single bracketed SQL column name " +
                        "(e.g. [Online PMNT Refrence] or [Online PMNT Reference]). Invalid value: " + raw);
                return raw;
            }
        }

        /// <summary>
        /// Optional second column (e.g. [NewReference]) OR-matched when set. Leave empty for a single column.
        /// </summary>
        public static string PaymentReferenceColumnOptional2
        {
            get
            {
                const string key = "BillingPaymentReferenceColumn2";
                string raw = WebConfigurationManager.AppSettings[key];
                if (string.IsNullOrWhiteSpace(raw))
                    return null;
                raw = raw.Trim();
                if (!BracketedIdentifier.IsMatch(raw))
                    throw new InvalidOperationException(
                        "AppSettings[\"" + key + "\"] must be a bracketed column name or empty. Invalid value: " + raw);
                return raw;
            }
        }

        /// <summary>All payment-reference columns to match (primary + optional second).</summary>
        public static IReadOnlyList<string> PaymentReferenceColumns
        {
            get
            {
                var list = new List<string> { PaymentReferenceColumn };
                string alt = PaymentReferenceColumnOptional2;
                if (!string.IsNullOrEmpty(alt))
                    list.Add(alt);
                return list;
            }
        }

        /// <summary>
        /// Columns for WHERE on payment reference, including optional extras for some prefixes
        /// (e.g. bahriabilling78 may store KuickPay ref in [NewRefrence] while [Online PMNT Refrence] is empty).
        /// </summary>
        public static IReadOnlyList<string> PaymentReferenceColumnsForPrefix(string fiveDigitPrefix)
        {
            var list = new List<string>(PaymentReferenceColumns);
            string extraKey = null;
            if (fiveDigitPrefix == "01060")
                extraKey = "BillingPhase78ElectricityPaymentReferenceExtraColumns";
            else if (fiveDigitPrefix == "01000")
                extraKey = "BillingPhase16ElectricityPaymentReferenceExtraColumns";

            if (extraKey == null)
                return list;

            foreach (string c in ParseExtraBracketedColumns(extraKey))
            {
                if (!list.Exists(x => string.Equals(x, c, StringComparison.OrdinalIgnoreCase)))
                    list.Add(c);
            }
            return list;
        }

        private static IEnumerable<string> ParseExtraBracketedColumns(string appSettingKey)
        {
            string raw = WebConfigurationManager.AppSettings[appSettingKey];
            if (string.IsNullOrWhiteSpace(raw))
                yield break;
            foreach (string part in raw.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                string c = part.Trim();
                if (!BracketedIdentifier.IsMatch(c))
                    throw new InvalidOperationException(
                        "AppSettings[\"" + appSettingKey + "\"] must be comma-separated bracketed column names " +
                        "(e.g. [NewRefrence],[OldRefrence]). Invalid segment: " + c);
                yield return c;
            }
        }

        private static string Resolve(string key, string defaultName)
        {
            string raw = WebConfigurationManager.AppSettings[key];
            if (string.IsNullOrWhiteSpace(raw))
                raw = defaultName;
            raw = raw.Trim();
            if (!SafeTableRef.IsMatch(raw))
                throw new InvalidOperationException(
                    "AppSettings[\"" + key + "\"] must be a single SQL table reference " +
                    "(e.g. Electricity, dbo.Electricity, [Website Bills]). Invalid value: " + raw);
            return raw;
        }
    }
}
