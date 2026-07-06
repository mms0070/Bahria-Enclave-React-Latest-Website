<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewBill.aspx.cs" Inherits="BahriaTownEnclave.ViewBill" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bahria Town Electricity — Bill viewer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="crystalreportviewers13/js/crviewer/crv.js"></script>

    <style>
        :root {
            --util-blue: #0b5fa5;
            --util-blue-dark: #084a82;
            --util-blue-soft: #e8f1fa;
            --util-amber: #e6a200;
            --util-bg: #e9eef5;
            --util-ink: #1a2f45;
            --util-muted: #5a6d80;
            --util-line: #c5d4e3;
            --util-footer: #063a66;
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
            }
        }

        body {
            font-family: "IBM Plex Sans", system-ui, sans-serif;
            background: var(--util-bg);
            color: var(--util-ink);
            min-height: 100vh;
        }

        .bg-mesh {
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            background: radial-gradient(900px 500px at 50% 0%, rgba(11, 95, 165, 0.07), transparent 55%), var(--util-bg);
        }

        .page-z { position: relative; z-index: 1; }

        .cursor-dot, .cursor-ring {
            position: fixed;
            left: 0; top: 0;
            pointer-events: none;
            z-index: 100001;
            will-change: transform, opacity;
            opacity: 0;
            transition: opacity 0.25s ease;
        }

        body.has-animated-cursor .cursor-dot,
        body.has-animated-cursor .cursor-ring { opacity: 1; }

        body.has-animated-cursor { cursor: none; }

        body.has-animated-cursor a,
        body.has-animated-cursor button,
        body.has-animated-cursor input,
        body.has-animated-cursor .btn { cursor: pointer; }

        @media (prefers-reduced-motion: reduce) {
            body.has-animated-cursor { cursor: auto; }
            .cursor-dot, .cursor-ring { display: none !important; }
        }

        .cursor-dot {
            width: 14px;
            height: 14px;
            margin: -7px 0 0 -7px;
            border-radius: 50%;
            background: radial-gradient(circle at 32% 28%, #fffef5 0%, #fff176 25%, #ffeb3b 50%, #ffc107 78%, #f57f17 100%);
            box-shadow: 0 0 0 1px rgba(255, 213, 0, 0.9), 0 0 14px 3px rgba(255, 220, 0, 0.9);
            animation: cursor-bulb-flash 0.45s ease-in-out infinite alternate;
        }

        @keyframes cursor-bulb-flash {
            from { opacity: 1; filter: brightness(1.2); }
            to { opacity: 0.72; filter: brightness(0.9); }
        }

        .cursor-ring {
            width: 40px;
            height: 40px;
            margin: -20px 0 0 -20px;
            border-radius: 50%;
            border: 2px solid rgba(255, 213, 0, 0.85);
            animation: cursor-ring-blink 0.45s ease-in-out infinite alternate;
        }

        @keyframes cursor-ring-blink {
            from { opacity: 0.95; border-color: rgba(255, 241, 118, 0.95); }
            to { opacity: 0.38; border-color: rgba(255, 152, 0, 0.45); }
        }

        .top-strip {
            background: linear-gradient(90deg, #ffc400, #ffd54f, #ffc400);
            color: #3e2723;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            padding: 0.4rem 0.5rem;
            border-bottom: 2px solid #b87f00;
        }

        .navbar-main {
            background: #fff;
            border-bottom: 3px solid var(--util-blue);
            box-shadow: 0 2px 10px rgba(11, 95, 165, 0.08);
        }

        .navbar-light .navbar-brand {
            font-weight: 700;
            color: var(--util-blue) !important;
        }

        .navbar-light .nav-link {
            font-weight: 600;
            color: var(--util-muted) !important;
        }

        .navbar-light .nav-link:hover,
        .navbar-light .nav-link.active {
            color: var(--util-blue) !important;
        }

        .page-hero {
            padding: 2rem 0 1rem;
            text-align: center;
        }

        .page-hero h1 {
            font-weight: 700;
            font-size: clamp(1.35rem, 2.8vw, 1.75rem);
            color: var(--util-blue);
        }

        .page-hero p { color: var(--util-muted); max-width: 34rem; margin: 0.45rem auto 0; }

        .pulse-line {
            width: 64px;
            height: 4px;
            margin: 0.75rem auto 0;
            border-radius: 2px;
            background: linear-gradient(90deg, var(--util-blue), var(--util-amber));
        }

        .report-card {
            position: relative;
            border-radius: 8px;
            padding: 1.35rem 1.15rem 1.15rem;
            background: #fff;
            border: 1px solid var(--util-line);
            border-left: 5px solid var(--util-blue);
            box-shadow: 0 4px 22px rgba(11, 95, 165, 0.08);
        }

        .btn-download-pdf {
            border: none;
            border-radius: 6px;
            padding: 0.65rem 1.5rem;
            font-weight: 700;
            color: #fff !important;
            background: var(--util-blue);
            box-shadow: 0 2px 0 var(--util-blue-dark);
        }

        .btn-download-pdf:hover {
            background: var(--util-blue-dark);
            color: #fff !important;
        }

        .report-viewer-container {
            background: #fff;
            border-radius: 6px;
            overflow-x: auto;
            border: 1px solid var(--util-line);
            margin-top: 0.85rem;
        }

        .portal-vb-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 200000;
            align-items: center;
            justify-content: center;
            padding: 1.25rem;
            background: rgba(15, 39, 68, 0.55);
            backdrop-filter: blur(6px);
            animation: portal-vb-fade-in 0.35s ease;
        }

        .portal-vb-backdrop.is-open { display: flex; }

        @keyframes portal-vb-fade-in {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes portal-vb-pop {
            from { opacity: 0; transform: scale(0.94) translateY(10px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }

        @keyframes portal-vb-orbit {
            to { transform: rotate(360deg); }
        }

        @keyframes portal-vb-pulse-bar {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(250%); }
        }

        .portal-vb-dialog {
            position: relative;
            width: 100%;
            max-width: 420px;
            border-radius: 14px;
            padding: 1.75rem 1.5rem 1.5rem;
            background: #fff;
            box-shadow: 0 24px 60px rgba(11, 95, 165, 0.22), 0 0 0 1px rgba(11, 95, 165, 0.08);
            text-align: center;
            animation: portal-vb-pop 0.45s cubic-bezier(0.22, 1, 0.36, 1);
        }

        .portal-vb-dialog--download .portal-vb-orbit {
            border-color: rgba(11, 95, 165, 0.35);
        }

        .portal-vb-close {
            position: absolute;
            top: 0.55rem;
            right: 0.6rem;
            border: none;
            background: transparent;
            font-size: 1.5rem;
            line-height: 1;
            color: var(--util-muted);
            padding: 0.25rem 0.45rem;
            border-radius: 6px;
        }

        .portal-vb-close:hover { color: var(--util-blue); background: var(--util-blue-soft); }

        .portal-vb-orbit {
            width: 72px;
            height: 72px;
            margin: 0 auto 1rem;
            border-radius: 50%;
            border: 3px solid rgba(11, 95, 165, 0.2);
            border-top-color: var(--util-blue);
            animation: portal-vb-orbit 1.1s linear infinite;
        }

        .portal-vb-dialog h2 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--util-blue);
            margin-bottom: 0.5rem;
        }

        .portal-vb-dialog p {
            color: var(--util-muted);
            font-size: 0.95rem;
            margin-bottom: 0;
        }

        .portal-vb-progress {
            height: 4px;
            border-radius: 2px;
            background: var(--util-line);
            margin: 1.25rem 0 0;
            overflow: hidden;
        }

        .portal-vb-progress span {
            display: block;
            height: 100%;
            width: 40%;
            border-radius: 2px;
            background: linear-gradient(90deg, var(--util-blue), var(--util-amber));
            animation: portal-vb-pulse-bar 1.4s ease-in-out infinite;
        }

        .portal-vb-empty {
            border-radius: 8px;
            background: #fff;
            border: 1px dashed var(--util-line);
        }

        .site-footer {
            margin-top: 2.5rem;
            padding: 2rem 0 1.5rem;
            background: var(--util-footer);
            color: rgba(255, 255, 255, 0.9);
            border-top: 4px solid var(--util-amber);
        }

        .site-footer h5 {
            color: #ffe082;
            font-weight: 700;
            font-size: 0.98rem;
        }

        .site-footer .small { color: rgba(255, 255, 255, 0.82); }
    </style>
</head>
<body>
    <div class="bg-mesh" aria-hidden="true"></div>
    <div id="cursor-dot" class="cursor-dot" aria-hidden="true"></div>
    <div id="cursor-ring" class="cursor-ring" aria-hidden="true"></div>

    <form id="form1" runat="server" class="page-z">

        <iframe name="billPdfDownloadFrame" id="billPdfDownloadFrame" title="Bill PDF download" style="position:absolute;width:0;height:0;border:0;visibility:hidden" aria-hidden="true"></iframe>

        <div class="top-strip text-center">Consumer billing — duplicate bill &amp; payment services</div>

        <nav class="navbar navbar-expand-lg navbar-light navbar-main py-2">
            <div class="container">
                <a class="navbar-brand d-flex align-items-center gap-2" href="Default.aspx">
                    <img src="Images/logo.png" height="44" alt="Bahria Town" />
                    <span>Bahria Town Electricity</span>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="Default.aspx">Home</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <header class="page-hero container">
            <h1>Electricity bill (on-screen)</h1>
            <div class="pulse-line"></div>
            <p>Official bill image below. Use <strong>Download PDF</strong> for a signed copy for bank / record.</p>
        </header>

        <div class="container pb-5">
            <div class="row justify-content-center">
                <div class="col-xl-11">
                    <% if (!PortalShowNotFound && !PortalShowInvalidRef && !PortalShowError)
                        { %>
                    <div class="report-card">
                        <div class="text-center mb-2">
                            <asp:Button ID="btnDownloadPDF" runat="server"
                                Text="Download PDF"
                                CssClass="btn btn-download-pdf"
                                UseSubmitBehavior="false"
                                OnClientClick="return portalViewBillStartDownload(this);"
                                OnClick="btnDownloadPDF_Click" />
                        </div>
                        <div class="report-viewer-container">
                            <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server"
                                AutoDataBind="true"
                                HasCrystalLogo="False"
                                EnableTheming="False"
                                HasDrillUpButton="False"
                                HasToggleGroupTreeButton="False"
                                HasToggleParameterPanelButton="False"
                                HasZoomFactorList="False"
                                RenderingDPI="100"
                                ReuseParameterValuesOnRefresh="True"
                                ToolbarStyle-BorderStyle="None"
                                ToolPanelView="None"
                                ToolPanelWidth="0px"
                                Width="100%"
                                BorderColor="White"
                                BorderStyle="None"
                                HasDrilldownTabs="False"
                                DisplayStatusbar="False"
                                DisplayToolbar="False"
                                EnableToolTips="False"
                                HasExportButton="False"
                                HasGotoPageButton="False"
                                HasPageNavigationButtons="False"
                                HasPrintButton="False"
                                HasSearchButton="False" />
                        </div>
                    </div>
                    <% }
                        else
                        { %>
                    <div class="report-card portal-vb-empty">
                        <p class="text-muted mb-0">No on-screen bill is available for this reference. Use the notice on screen or return home.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div id="portalDownloadingBill" class="portal-vb-backdrop" role="dialog" aria-modal="true" aria-labelledby="portalDlTitle" aria-hidden="true">
            <div class="portal-vb-dialog portal-vb-dialog--download">
                <div class="portal-vb-orbit" aria-hidden="true"></div>
                <h2 id="portalDlTitle">Preparing your PDF</h2>
                <p>Your official bill is being generated. The download will begin shortly; please keep this tab open.</p>
                <div class="portal-vb-progress" aria-hidden="true"><span></span></div>
            </div>
        </div>

        <div id="portalNotFoundBill" class="portal-vb-backdrop" role="dialog" aria-modal="true" aria-labelledby="portalNfTitle" aria-hidden="true">
            <div class="portal-vb-dialog">
                <button type="button" class="portal-vb-close" onclick="portalViewBillClose('portalNotFoundBill')" aria-label="Close">&times;</button>
                <div class="portal-vb-orbit" style="animation-duration:1.4s;border-top-color:#c62828;border-color:rgba(198,40,40,0.25)" aria-hidden="true"></div>
                <h2 id="portalNfTitle">No bill on record</h2>
                <p>We could not find a bill for this consumer reference. Please check the number and try again, or contact the billing office.</p>
                <div class="mt-3">
                    <a class="btn btn-download-pdf" href="Default.aspx">Back to home</a>
                </div>
            </div>
        </div>

        <div id="portalInvalidRefBill" class="portal-vb-backdrop" role="dialog" aria-modal="true" aria-labelledby="portalInvTitle" aria-hidden="true">
            <div class="portal-vb-dialog">
                <button type="button" class="portal-vb-close" onclick="portalViewBillClose('portalInvalidRefBill')" aria-label="Close">&times;</button>
                <div class="portal-vb-orbit" style="animation-duration:1.25s;border-top-color:var(--util-amber);border-color:rgba(230,162,0,0.35)" aria-hidden="true"></div>
                <h2 id="portalInvTitle">Reference not accepted</h2>
                <p>This reference prefix is not valid for this portal. Please use the KuickPay consumer number printed on your bill.</p>
                <div class="mt-3">
                    <a class="btn btn-download-pdf" href="Default.aspx">Back to home</a>
                </div>
            </div>
        </div>

        <div id="portalErrorBill" class="portal-vb-backdrop" role="dialog" aria-modal="true" aria-labelledby="portalErrTitle" aria-hidden="true">
            <div class="portal-vb-dialog">
                <button type="button" class="portal-vb-close" onclick="portalViewBillClose('portalErrorBill')" aria-label="Close">&times;</button>
                <div class="portal-vb-orbit" style="animation-duration:1.2s" aria-hidden="true"></div>
                <h2 id="portalErrTitle">Something went wrong</h2>
                <p><%= Server.HtmlEncode(PortalErrorMessage ?? "Please try again later.") %></p>
                <div class="mt-3">
                    <a class="btn btn-download-pdf" href="Default.aspx">Back to home</a>
                </div>
            </div>
        </div>

        <footer class="site-footer page-z">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-4">
                        <h5>Bahria Enclave</h5>
                        <p class="small mb-0">Billing Office, 1st Floor, Head Office<br />Sector I, Bahria Enclave<br />
                        Tel: +92 (51) 2721035<br />Email: be.billingdepartment@gmail.com</p>
                    </div>
                    <div class="col-md-4">
                        <h5>Phase 1 &ndash; 6</h5>
                        <p class="small mb-0">Garden Avenue, near Civic Center, Phase 4<br />
                        Tel: +92 (51) 5733277<br />Email: cbdbt1to6@gmail.com</p>
                    </div>
                    <div class="col-md-4">
                        <h5>Phase 7 &ndash; 8</h5>
                        <p class="small mb-0">Usman Block, near Grid Station, Phase 8<br />
                        Tel: +92 (51) 5410387 &amp; 5410080<br />Email: Cbdbt7to9@gmail.com</p>
                    </div>
                </div>
                <hr class="border-secondary border-opacity-25 my-3" />
                <p class="text-center small mb-0" style="color: rgba(255,255,255,0.5);">&copy; <%: DateTime.Now.Year %> Bahria Town Electricity — IT &amp; Billing Division</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function portalViewBillClose(id) {
                var el = document.getElementById(id);
                if (!el) return;
                el.classList.remove("is-open");
                el.setAttribute("aria-hidden", "true");
            }
            function portalViewBillOpen(id) {
                var el = document.getElementById(id);
                if (!el) return;
                el.classList.add("is-open");
                el.setAttribute("aria-hidden", "false");
            }
            function portalViewBillStartDownload(btn) {
                var form = document.getElementById("<%= form1.ClientID %>");
                var modal = document.getElementById("portalDownloadingBill");
                if (!form || !btn) return false;
                var prevTarget = form.getAttribute("target") || "";
                if (modal) {
                    modal.classList.add("is-open");
                    modal.setAttribute("aria-hidden", "false");
                }
                form.target = "billPdfDownloadFrame";
                setTimeout(function () {
                    window.__doPostBack(btn.name, "");
                    setTimeout(function () {
                        if (prevTarget) form.target = prevTarget;
                        else form.removeAttribute("target");
                        if (modal) {
                            modal.classList.remove("is-open");
                            modal.setAttribute("aria-hidden", "true");
                        }
                    }, 3200);
                }, 700);
                return false;
            }

            (function () {
                var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
                var dot = document.getElementById("cursor-dot");
                var ring = document.getElementById("cursor-ring");
                var mx = 0, my = 0, rx = 0, ry = 0;

                function tick() {
                    rx += (mx - rx) * 0.2;
                    ry += (my - ry) * 0.15;
                    if (dot) dot.style.transform = "translate3d(" + mx + "px," + my + "px,0)";
                    if (ring) ring.style.transform = "translate3d(" + rx + "px," + ry + "px,0)";
                    requestAnimationFrame(tick);
                }

                if (!reduceMotion && dot && ring && window.matchMedia("(pointer: fine)").matches) {
                    document.body.classList.add("has-animated-cursor");
                    document.addEventListener("mousemove", function (e) {
                        mx = e.clientX;
                        my = e.clientY;
                    }, { passive: true });
                    tick();
                }
            })();

            document.addEventListener("DOMContentLoaded", function () {
                <% if (PortalShowNotFound) { %>portalViewBillOpen("portalNotFoundBill");<% } %>
                <% if (PortalShowInvalidRef) { %>portalViewBillOpen("portalInvalidRefBill");<% } %>
                <% if (PortalShowError) { %>portalViewBillOpen("portalErrorBill");<% } %>
            });
        </script>
    </form>
</body>
</html>
