<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BahriaTownEnclave.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="Official Bahria Town Electricity consumer billing — view and download electricity bills, KuickPay payment." />
    <title>Bahria Town Power &amp; Maintenance — Consumer Billing Portal</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@600;700;800&family=Noto+Nastaliq+Urdu:wght@400;600&display=swap" rel="stylesheet" />

    <style>
*{box-sizing:border-box;}
  html{scroll-behavior:smooth;}
  body{margin:0;font-family:'Inter',sans-serif;color:#1C2B24;background:#FFFFFF;-webkit-font-smoothing:antialiased;}
  ::selection{background:#00C2FF;color:#06251a;}
  .urdu{font-family:'Noto Nastaliq Urdu',serif;direction:rtl;line-height:2.2;}
  section[id]{scroll-margin-top:84px;}
  /* electricity flow */
  @keyframes flow{ to { stroke-dashoffset:-400; } }
  @keyframes nodePulse{ 0%,100%{ opacity:.35; transform:scale(.8);} 50%{ opacity:1; transform:scale(1.3);} }
  @keyframes winGlow{ 0%,100%{ fill:#0b3826; } 45%,65%{ fill:#FFD86B; } }
  @keyframes spin{ to{ transform:rotate(360deg);} }
  @keyframes floaty{ 0%,100%{ transform:translateY(0);} 50%{ transform:translateY(-10px);} }
  @keyframes sparkFlash{ 0%,100%{ opacity:0; transform:scale(.4);} 8%,16%{ opacity:1; transform:scale(1.3);} 24%{ opacity:0; transform:scale(.6);} }
  @keyframes coreThrob{ 0%,100%{ opacity:.5;} 50%{ opacity:1;} }
  @keyframes ringSpin{ to{ transform:rotate(360deg);} }
  .node{ transform-box:fill-box; transform-origin:center; animation:nodePulse 2.4s ease-in-out infinite; }
  .win{ animation:winGlow 3.6s ease-in-out infinite; }
  .wire-flow{ stroke-dasharray:24 150; animation:flow 5s linear infinite; }
  .wire-flow.fast{ stroke-dasharray:16 90; animation-duration:3.2s; }
  .spark-flash{ transform-box:fill-box; transform-origin:center; animation:sparkFlash 2.6s ease-in-out infinite; }
  .core-throb{ animation:coreThrob 1.8s ease-in-out infinite; }
  .ring-spin{ transform-box:fill-box; transform-origin:center; animation:ringSpin 14s linear infinite; }
  @media (prefers-reduced-motion: reduce){
    html{scroll-behavior:auto;}
    .node,.win,.wire-flow,.floaty,.spark-flash,.core-throb,.ring-spin{ animation:none !important; }
    .win{ fill:#FFD86B; }
  }

    </style>
</head>
<body>

<div id="appRoot" style="min-height:100vh;overflow-x:hidden;">

  <!-- ===================== NAVBAR ===================== -->
  <nav id="mainNav" style="position:fixed;top:0;left:0;right:0;z-index:60;display:flex;align-items:center;justify-content:space-between;padding:16px clamp(20px,5vw,56px);background:rgba(10,61,39,0.0);transition:background .3s ease, box-shadow .3s ease, padding .3s ease;">
    <a href="#home" style="display:flex;align-items:center;gap:12px;text-decoration:none;">
      <div style="width:46px;height:46px;border-radius:12px;background:linear-gradient(135deg,#0E5A35,#0a4429);display:flex;align-items:center;justify-content:center;border:1px solid rgba(201,162,39,0.45);box-shadow:0 4px 14px rgba(0,0,0,.25);overflow:hidden;">
        <img src="Images/billing-logo.png" alt="Bahria Town Power &amp; Maintenance logo" width="34" height="34" style="display:block;object-fit:contain;">
      </div>
      <div style="line-height:1.1;">
        <div style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:16px;color:#fff;letter-spacing:.2px;">BAHRIA TOWN</div>
        <div style="font-size:10.5px;letter-spacing:2px;color:#C9A227;font-weight:600;">POWER &amp; MAINTENANCE</div>
      </div>
    </a>
    <div style="display:flex;align-items:center;gap:6px;" class="nav-desktop">
      
        <a href="#home" style="text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s;" onmouseenter="hoverIn(this, { color:'#fff', background:'rgba(255,255,255,0.1)' })" onmouseleave="hoverOut(this)">Home</a>
      

        <a href="#services" style="text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s;" onmouseenter="hoverIn(this, { color:'#fff', background:'rgba(255,255,255,0.1)' })" onmouseleave="hoverOut(this)">Services</a>
      

        <a href="#projects" style="text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s;" onmouseenter="hoverIn(this, { color:'#fff', background:'rgba(255,255,255,0.1)' })" onmouseleave="hoverOut(this)">Projects</a>
      

        <a href="#how" style="text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s;" onmouseenter="hoverIn(this, { color:'#fff', background:'rgba(255,255,255,0.1)' })" onmouseleave="hoverOut(this)">How It Works</a>
      

        <a href="#lookup" style="text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s;" onmouseenter="hoverIn(this, { color:'#fff', background:'rgba(255,255,255,0.1)' })" onmouseleave="hoverOut(this)">Pay Bill</a>
      

        <a href="#contact" style="text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s;" onmouseenter="hoverIn(this, { color:'#fff', background:'rgba(255,255,255,0.1)' })" onmouseleave="hoverOut(this)">Contact</a>
      
      <a href="#lookup" style="margin-left:10px;text-decoration:none;background:#C9A227;color:#1C2B24;font-weight:700;font-size:14px;padding:11px 20px;border-radius:10px;box-shadow:0 6px 18px rgba(201,162,39,.35);transition:transform .2s, box-shadow .2s;" onmouseenter="hoverIn(this, { transform:'translateY(-2px)', boxShadow:'0 10px 24px rgba(201,162,39,.5)' })" onmouseleave="hoverOut(this)">Pay Bill</a>
    </div>
    <button onclick="toggleMobile()" aria-label="Open menu" class="nav-mobile" style="display:none;background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.25);border-radius:10px;width:44px;height:44px;align-items:center;justify-content:center;cursor:pointer;">
      <svg width="22" height="22" viewBox="0 0 24 24" stroke="#fff" stroke-width="2" stroke-linecap="round"><path d="M3 6h18M3 12h18M3 18h18"></path></svg>
    </button>
  </nav>

  <div id="mobileMenu" style="display:none;">
    <div style="position:fixed;inset:0;z-index:70;background:rgba(6,37,24,0.97);backdrop-filter:blur(6px);display:flex;flex-direction:column;padding:24px;">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
        <div style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;color:#fff;">Menu</div>
        <button onclick="closeMobile()" aria-label="Close menu" style="background:rgba(255,255,255,0.12);border:none;border-radius:10px;width:44px;height:44px;color:#fff;font-size:22px;cursor:pointer;">×</button>
      </div>
      
        <a href="#home" onclick="closeMobile()" style="text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1);">Home</a>
      

        <a href="#services" onclick="closeMobile()" style="text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1);">Services</a>
      

        <a href="#projects" onclick="closeMobile()" style="text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1);">Projects</a>
      

        <a href="#how" onclick="closeMobile()" style="text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1);">How It Works</a>
      

        <a href="#lookup" onclick="closeMobile()" style="text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1);">Pay Bill</a>
      

        <a href="#contact" onclick="closeMobile()" style="text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1);">Contact</a>
      
      <a href="#lookup" onclick="closeMobile()" style="margin-top:24px;text-align:center;text-decoration:none;background:#C9A227;color:#1C2B24;font-weight:700;padding:16px;border-radius:12px;">Pay Your Bill</a>
    </div>
  </div>

  <!-- ===================== HERO ===================== -->
  <header id="home" style="position:relative;min-height:96vh;display:flex;align-items:center;background:radial-gradient(120% 90% at 80% 10%, #115c39 0%, #0a4429 45%, #072e1d 100%);overflow:hidden;padding:120px clamp(20px,5vw,56px) 200px;">
    <!-- TODO: (Optional) drop a muted looping power-grid background <video> here; SVG below is the graceful fallback -->
    <svg id="heroGrid" viewBox="0 0 1440 560" preserveAspectRatio="xMidYMid slice" aria-hidden="true" style="position:absolute;inset:0;width:100%;height:100%;opacity:.92;">
      <defs>
        <linearGradient id="wireDim" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0" stop-color="#0c4d31"></stop><stop offset="1" stop-color="#0c4d31"></stop>
        </linearGradient>
        <filter id="glow" x="-60%" y="-60%" width="220%" height="220%">
          <feGaussianBlur stdDeviation="3.4" result="b"></feGaussianBlur><feMerge><feMergeNode in="b"></feMergeNode><feMergeNode in="SourceGraphic"></feMergeNode></feMerge>
        </filter>
        <filter id="softGlow" x="-120%" y="-120%" width="340%" height="340%">
          <feGaussianBlur stdDeviation="6" result="b"></feGaussianBlur><feMerge><feMergeNode in="b"></feMergeNode><feMergeNode in="SourceGraphic"></feMergeNode></feMerge>
        </filter>
        <radialGradient id="sky" cx="80%" cy="0%" r="90%">
          <stop offset="0" stop-color="#1b7a4c" stop-opacity=".5"></stop><stop offset="1" stop-color="#072e1d" stop-opacity="0"></stop>
        </radialGradient>
        <radialGradient id="sparkGrad" cx="50%" cy="50%" r="50%">
          <stop offset="0" stop-color="#ffffff"></stop><stop offset="35%" stop-color="#9fe9ff"></stop><stop offset="100%" stop-color="#00C2FF" stop-opacity="0"></stop>
        </radialGradient>
        <!-- wire path definitions (reused by base, flow overlay and travelling sparks) -->
        <path id="pw1" d="M0 120 Q360 210 720 130 T1440 132"></path>
        <path id="pw2" d="M0 158 Q360 250 720 170 T1440 172"></path>
        <path id="pw3" d="M0 196 Q360 288 720 210 T1440 212"></path>
        <path id="pw4" d="M0 96 Q360 150 720 92 T1440 96"></path>
        <path id="pwf1" d="M1274 92 C 1330 190 1190 168 1138 168"></path>
        <path id="pwf2" d="M1276 110 C 1200 200 1010 214 980 236"></path>
        <path id="pwf3" d="M724 196 C 820 250 960 230 1058 204"></path>
      </defs>
      <rect width="1440" height="560" fill="url(#sky)"></rect>
      <line x1="0" y1="332" x2="1440" y2="332" stroke="#0a4128" stroke-width="2"></line>

      <!-- dim base wires -->
      <g stroke="url(#wireDim)" stroke-width="2.5" fill="none">
        <use href="#pw4"></use><use href="#pw1"></use><use href="#pw2"></use><use href="#pw3"></use>
        <use href="#pwf1"></use><use href="#pwf2"></use><use href="#pwf3"></use>
      </g>
      <!-- flowing current overlays -->
      <g fill="none" filter="url(#glow)">
        <use href="#pw4" class="wire-flow fast" stroke="#7defff" stroke-width="2.4"></use>
        <use href="#pw1" class="wire-flow" stroke="#00C2FF" stroke-width="2.6"></use>
        <use href="#pw2" class="wire-flow" style="animation-delay:-1.6s" stroke="#5fe0ff" stroke-width="2.6"></use>
        <use href="#pw3" class="wire-flow" style="animation-delay:-3.2s" stroke="#00C2FF" stroke-width="2.6"></use>
        <use href="#pwf1" class="wire-flow fast" style="animation-delay:-.8s" stroke="#00C2FF" stroke-width="2.5"></use>
        <use href="#pwf2" class="wire-flow fast" style="animation-delay:-1.4s" stroke="#7defff" stroke-width="2.5"></use>
        <use href="#pwf3" class="wire-flow fast" style="animation-delay:-2.1s" stroke="#00C2FF" stroke-width="2.5"></use>
      </g>

      <!-- travelling current sparks (SMIL motion along the cables) -->
      <g class="sparks" fill="url(#sparkGrad)">
        <circle r="7"><animateMotion dur="4.6s" repeatCount="indefinite" rotate="auto"><mpath href="#pw1"></mpath></animateMotion></circle>
        <circle r="6"><animateMotion dur="4.6s" begin="-2.3s" repeatCount="indefinite"><mpath href="#pw1"></mpath></animateMotion></circle>
        <circle r="7"><animateMotion dur="5.2s" repeatCount="indefinite"><mpath href="#pw2"></mpath></animateMotion></circle>
        <circle r="6"><animateMotion dur="5.2s" begin="-2.6s" repeatCount="indefinite"><mpath href="#pw2"></mpath></animateMotion></circle>
        <circle r="7"><animateMotion dur="5.8s" repeatCount="indefinite"><mpath href="#pw3"></mpath></animateMotion></circle>
        <circle r="5"><animateMotion dur="4s" repeatCount="indefinite"><mpath href="#pw4"></mpath></animateMotion></circle>
        <circle r="6"><animateMotion dur="3.2s" repeatCount="indefinite"><mpath href="#pwf1"></mpath></animateMotion></circle>
        <circle r="6"><animateMotion dur="3.6s" begin="-1s" repeatCount="indefinite"><mpath href="#pwf2"></mpath></animateMotion></circle>
        <circle r="6"><animateMotion dur="3.4s" begin="-1.7s" repeatCount="indefinite"><mpath href="#pwf3"></mpath></animateMotion></circle>
      </g>

      <!-- pylons -->
      <g stroke="#0e6b41" stroke-width="3" fill="none" stroke-linecap="round">
        <g><path d="M160 332 L172 80 M188 332 L176 80 M150 200 L198 200 M120 128 L228 128 M150 96 L198 96 M155 248 L150 200 M193 248 L198 200"></path></g>
        <g><path d="M710 332 L722 80 M738 332 L726 80 M700 200 L748 200 M670 128 L778 128 M700 96 L748 96 M705 248 L700 200 M743 248 L748 200"></path></g>
        <g><path d="M1260 332 L1272 80 M1288 332 L1276 80 M1250 200 L1298 200 M1220 128 L1328 128 M1250 96 L1298 96 M1255 248 L1250 200 M1293 248 L1298 200"></path></g>
      </g>

      <!-- substation / transformer feeding the homes -->
      <g transform="translate(90,300)">
        <rect x="-30" y="0" width="60" height="32" rx="4" fill="#0a3d27" stroke="#0e6b41" stroke-width="2"></rect>
        <circle class="core-throb" cx="0" cy="16" r="9" fill="none" stroke="#00C2FF" stroke-width="2.5" filter="url(#glow)"></circle>
        <circle class="ring-spin" cx="0" cy="16" r="14" fill="none" stroke="#00C2FF" stroke-width="1" stroke-dasharray="3 6" opacity=".7"></circle>
        <path d="M-2 11 -6 18 0 18 -3 24" fill="none" stroke="#00C2FF" stroke-width="1.6" filter="url(#glow)"></path>
      </g>

      <!-- glowing junction nodes -->
      <g fill="#00C2FF" filter="url(#glow)">
        <circle class="node" cx="174" cy="80" r="4.5"></circle><circle class="node" style="animation-delay:-.8s" cx="724" cy="80" r="4.5"></circle><circle class="node" style="animation-delay:-1.6s" cx="1274" cy="80" r="4.5"></circle>
        <circle class="node" style="animation-delay:-.4s" cx="120" cy="128" r="3.5"></circle><circle class="node" style="animation-delay:-1.2s" cx="778" cy="128" r="3.5"></circle>
        <circle class="node" style="animation-delay:-.6s" cx="228" cy="128" r="3.5"></circle><circle class="node" style="animation-delay:-1.9s" cx="670" cy="128" r="3.5"></circle>
        <circle class="node" style="animation-delay:-1.1s" cx="1328" cy="128" r="3.5"></circle><circle class="node" style="animation-delay:-2.2s" cx="1220" cy="128" r="3.5"></circle>
        <circle class="node" style="animation-delay:-.9s" cx="174" cy="96" r="3"></circle><circle class="node" style="animation-delay:-1.5s" cx="724" cy="96" r="3"></circle>
      </g>
      <!-- arcing spark flashes at insulators -->
      <g fill="#dffaff" filter="url(#softGlow)">
        <circle class="spark-flash" cx="198" cy="200" r="3.5"></circle>
        <circle class="spark-flash" style="animation-delay:-1.3s" cx="748" cy="200" r="3.5"></circle>
        <circle class="spark-flash" style="animation-delay:-.7s" cx="1298" cy="200" r="3.5"></circle>
        <circle class="spark-flash" style="animation-delay:-1.9s" cx="90" cy="316" r="4"></circle>
      </g>

      <!-- CITY SKYLINE: houses, offices & highrise buildings that light up (baseline y=332) -->
      <g stroke="#1b8a57" stroke-width="1.5">
        <!-- back-row faint towers for depth -->
        <g fill="#0a3a26" stroke="none" opacity=".7">
          <rect x="900" y="214" width="40" height="118"></rect><rect x="1196" y="196" width="46" height="136"></rect><rect x="1300" y="232" width="38" height="100"></rect>
        </g>

        <!-- office block -->
        <g fill="#0c462e"><rect x="828" y="236" width="86" height="96"></rect></g>
        <g fill="#08351f" stroke="none"><rect x="828" y="236" width="86" height="9"></rect></g>
        <g fill="#0e5a35" stroke="none">
          <rect class="win" x="838" y="252" width="13" height="11" rx="1"></rect><rect x="858" y="252" width="13" height="11" rx="1"></rect><rect class="win" style="animation-delay:.5s" x="878" y="252" width="13" height="11" rx="1"></rect><rect x="898" y="252" width="9" height="11" rx="1"></rect>
          <rect x="838" y="270" width="13" height="11" rx="1"></rect><rect class="win" style="animation-delay:1.1s" x="858" y="270" width="13" height="11" rx="1"></rect><rect x="878" y="270" width="13" height="11" rx="1"></rect><rect class="win" style="animation-delay:1.7s" x="898" y="270" width="9" height="11" rx="1"></rect>
          <rect class="win" style="animation-delay:.8s" x="838" y="288" width="13" height="11" rx="1"></rect><rect x="858" y="288" width="13" height="11" rx="1"></rect><rect x="878" y="288" width="13" height="11" rx="1"></rect><rect x="898" y="288" width="9" height="11" rx="1"></rect>
          <rect x="838" y="306" width="13" height="11" rx="1"></rect><rect x="858" y="306" width="13" height="11" rx="1"></rect><rect class="win" style="animation-delay:2.1s" x="878" y="306" width="13" height="11" rx="1"></rect><rect x="898" y="306" width="9" height="11" rx="1"></rect>
        </g>

        <!-- pitched-roof house -->
        <g fill="#0c462e"><polygon points="930,236 968,204 1006,236" stroke="#1b8a57"></polygon><rect x="938" y="236" width="60" height="96"></rect></g>
        <g fill="#0e5a35" stroke="none">
          <rect class="win" style="animation-delay:.3s" x="948" y="250" width="16" height="15" rx="2"></rect><rect class="win" style="animation-delay:1.4s" x="972" y="250" width="16" height="15" rx="2"></rect>
          <rect x="948" y="276" width="16" height="15" rx="2"></rect><rect class="win" style="animation-delay:2.2s" x="972" y="276" width="16" height="15" rx="2"></rect>
          <rect x="958" y="302" width="20" height="30" rx="2" fill="#08351f"></rect>
        </g>

        <!-- highrise tower (tall, slim) with antenna + beacon -->
        <g fill="#0d4f30"><rect x="1024" y="158" width="64" height="174"></rect></g>
        <g stroke="#1b8a57"><line x1="1056" y1="158" x2="1056" y2="138"></line></g>
        <circle class="node" cx="1056" cy="136" r="3.5" fill="#00C2FF" filter="url(#glow)" stroke="none"></circle>
        <g fill="#0e5a35" stroke="none">
          <rect class="win" style="animation-delay:.2s" x="1033" y="172" width="13" height="12" rx="1"></rect><rect x="1051" y="172" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:1.2s" x="1069" y="172" width="11" height="12" rx="1"></rect>
          <rect x="1033" y="192" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:.7s" x="1051" y="192" width="13" height="12" rx="1"></rect><rect x="1069" y="192" width="11" height="12" rx="1"></rect>
          <rect class="win" style="animation-delay:1.9s" x="1033" y="212" width="13" height="12" rx="1"></rect><rect x="1051" y="212" width="13" height="12" rx="1"></rect><rect x="1069" y="212" width="11" height="12" rx="1"></rect>
          <rect x="1033" y="232" width="13" height="12" rx="1"></rect><rect x="1051" y="232" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:2.6s" x="1069" y="232" width="11" height="12" rx="1"></rect>
          <rect class="win" style="animation-delay:1.5s" x="1033" y="252" width="13" height="12" rx="1"></rect><rect x="1051" y="252" width="13" height="12" rx="1"></rect><rect x="1069" y="252" width="11" height="12" rx="1"></rect>
          <rect x="1033" y="272" width="13" height="12" rx="1"></rect><rect x="1051" y="272" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:3s" x="1069" y="272" width="11" height="12" rx="1"></rect>
          <rect x="1033" y="292" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:2.3s" x="1051" y="292" width="13" height="12" rx="1"></rect><rect x="1069" y="292" width="11" height="12" rx="1"></rect>
          <rect x="1033" y="312" width="13" height="12" rx="1"></rect><rect x="1051" y="312" width="13" height="12" rx="1"></rect><rect x="1069" y="312" width="11" height="12" rx="1"></rect>
        </g>

        <!-- mid office -->
        <g fill="#0c462e"><rect x="1104" y="218" width="74" height="114"></rect></g>
        <g fill="#08351f" stroke="none"><rect x="1104" y="218" width="74" height="8"></rect></g>
        <g fill="#0e5a35" stroke="none">
          <rect x="1114" y="232" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:.6s" x="1133" y="232" width="13" height="12" rx="1"></rect><rect x="1152" y="232" width="13" height="12" rx="1"></rect>
          <rect class="win" style="animation-delay:1.3s" x="1114" y="252" width="13" height="12" rx="1"></rect><rect x="1133" y="252" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:2.4s" x="1152" y="252" width="13" height="12" rx="1"></rect>
          <rect x="1114" y="272" width="13" height="12" rx="1"></rect><rect x="1133" y="272" width="13" height="12" rx="1"></rect><rect x="1152" y="272" width="13" height="12" rx="1"></rect>
          <rect class="win" style="animation-delay:.9s" x="1114" y="292" width="13" height="12" rx="1"></rect><rect x="1133" y="292" width="13" height="12" rx="1"></rect><rect x="1152" y="292" width="13" height="12" rx="1"></rect>
          <rect x="1114" y="312" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:2.8s" x="1133" y="312" width="13" height="12" rx="1"></rect><rect x="1152" y="312" width="13" height="12" rx="1"></rect>
        </g>

        <!-- pitched-roof house -->
        <g fill="#0c462e"><polygon points="1198,250 1230,222 1262,250" stroke="#1b8a57"></polygon><rect x="1206" y="250" width="50" height="82"></rect></g>
        <g fill="#0e5a35" stroke="none">
          <rect class="win" style="animation-delay:1.6s" x="1214" y="262" width="15" height="14" rx="2"></rect><rect x="1234" y="262" width="15" height="14" rx="2"></rect>
          <rect x="1224" y="302" width="18" height="30" rx="2" fill="#08351f"></rect>
        </g>

        <!-- highrise tower 2 -->
        <g fill="#0d4f30"><rect x="1278" y="186" width="58" height="146"></rect></g>
        <g stroke="#1b8a57"><line x1="1307" y1="186" x2="1307" y2="170"></line></g>
        <circle class="node" style="animation-delay:-1.4s" cx="1307" cy="168" r="3.5" fill="#00C2FF" filter="url(#glow)" stroke="none"></circle>
        <g fill="#0e5a35" stroke="none">
          <rect class="win" style="animation-delay:.4s" x="1287" y="200" width="13" height="12" rx="1"></rect><rect x="1306" y="200" width="13" height="12" rx="1"></rect><rect x="1325" y="200" width="6" height="12" rx="1"></rect>
          <rect x="1287" y="220" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:1.8s" x="1306" y="220" width="13" height="12" rx="1"></rect><rect x="1325" y="220" width="6" height="12" rx="1"></rect>
          <rect class="win" style="animation-delay:1s" x="1287" y="240" width="13" height="12" rx="1"></rect><rect x="1306" y="240" width="13" height="12" rx="1"></rect><rect x="1325" y="240" width="6" height="12" rx="1"></rect>
          <rect x="1287" y="260" width="13" height="12" rx="1"></rect><rect x="1306" y="260" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:2.5s" x="1325" y="260" width="6" height="12" rx="1"></rect>
          <rect x="1287" y="280" width="13" height="12" rx="1"></rect><rect class="win" style="animation-delay:.7s" x="1306" y="280" width="13" height="12" rx="1"></rect><rect x="1325" y="280" width="6" height="12" rx="1"></rect>
          <rect x="1287" y="300" width="13" height="12" rx="1"></rect><rect x="1306" y="300" width="13" height="12" rx="1"></rect><rect x="1325" y="300" width="6" height="12" rx="1"></rect>
        </g>

        <!-- last small house -->
        <g fill="#0c462e"><polygon points="1352,270 1380,244 1408,270" stroke="#1b8a57"></polygon><rect x="1360" y="270" width="44" height="62"></rect></g>
        <g fill="#0e5a35" stroke="none">
          <rect class="win" style="animation-delay:2.9s" x="1368" y="282" width="13" height="12" rx="1"></rect><rect x="1386" y="282" width="13" height="12" rx="1"></rect>
          <rect x="1376" y="308" width="16" height="24" rx="2" fill="#08351f"></rect>
        </g>
      </g>
    </svg>
    <div style="position:absolute;inset:0;background:linear-gradient(180deg, rgba(7,46,29,0.55) 0%, rgba(7,46,29,0.2) 40%, rgba(7,46,29,0.85) 100%);"></div>

    <div style="position:relative;z-index:3;max-width:1200px;margin:0 auto;width:100%;">
      <div style="display:inline-flex;align-items:center;gap:10px;background:rgba(0,194,255,0.12);border:1px solid rgba(0,194,255,0.4);color:#9fe9ff;font-size:13px;font-weight:600;letter-spacing:.5px;padding:8px 16px;border-radius:100px;margin-bottom:24px;">
        <span style="width:8px;height:8px;border-radius:50%;background:#00C2FF;box-shadow:0 0 10px #00C2FF;"></span>
        OFFICIAL ELECTRICITY &amp; MAINTENANCE BILLING PORTAL
      </div>
      <h1 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(40px,6.5vw,82px);line-height:1.02;color:#fff;margin:0 0 18px;max-width:880px;letter-spacing:-1.5px;">
        Powering Pakistan's<br>Premier <span style="color:#C9A227;">Communities</span>
      </h1>
      <p style="font-size:clamp(17px,2vw,21px);color:rgba(255,255,255,0.82);max-width:620px;line-height:1.55;margin:0 0 14px;">
        View, download and pay your electricity &amp; maintenance bills online — from anywhere in the world, anytime.
      </p>
      <p class="urdu" style="color:#C9A227;font-size:20px;margin:0 0 36px;">اپنے بل دیکھیں، ڈاؤن لوڈ کریں اور آن لائن ادا کریں</p>
      <div style="display:flex;flex-wrap:wrap;gap:14px;">
        <a href="#lookup" onclick="setElectric()" style="display:inline-flex;align-items:center;gap:10px;text-decoration:none;background:#00C2FF;color:#06251a;font-weight:700;font-size:16px;padding:16px 28px;border-radius:12px;box-shadow:0 10px 30px rgba(0,194,255,.4);transition:transform .2s, box-shadow .2s;" onmouseenter="hoverIn(this, { transform:'translateY(-3px)', boxShadow:'0 16px 38px rgba(0,194,255,.55)' })" onmouseleave="hoverOut(this)">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="#06251a"><path d="M13 2 4 14h6l-1 8 9-12h-6l1-8z"></path></svg>View / Pay Electricity Bill
        </a>
        <a href="#lookup" onclick="setMaint()" style="display:inline-flex;align-items:center;gap:10px;text-decoration:none;background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.35);color:#fff;font-weight:700;font-size:16px;padding:16px 28px;border-radius:12px;transition:background .2s, transform .2s;" onmouseenter="hoverIn(this, { background:'rgba(255,255,255,0.2)', transform:'translateY(-3px)' })" onmouseleave="hoverOut(this)">
          View / Pay Maintenance Bill
        </a>
      </div>
    </div>
  </header>

  <!-- ===================== QUICK BILL LOOKUP ===================== -->
  <section id="lookup" style="position:relative;z-index:8;margin-top:-130px;padding:0 clamp(20px,5vw,56px) 80px;">
    <div style="max-width:1080px;margin:0 auto;background:#fff;border-radius:24px;box-shadow:0 30px 70px rgba(7,46,29,0.22);border:1px solid #eef1ef;overflow:hidden;">
      <div style="display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:16px;padding:28px clamp(24px,4vw,40px);background:linear-gradient(135deg,#0E5A35,#0a4429);">
        <div>
          <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:26px;color:#fff;margin:0 0 4px;">Download or Pay your bill</h2>
          <p style="color:rgba(255,255,255,0.75);font-size:14.5px;margin:0;">Enter your account number to view, download &amp; pay instantly.</p>
        </div>
        <div style="display:flex;background:rgba(255,255,255,0.12);border-radius:12px;padding:5px;">
          <button id="tabElectricBtn" onclick="setElectric()" style="border:none;cursor:pointer;font-weight:700;font-size:14px;padding:9px 16px;border-radius:9px;transition:background .2s, color .2s;background:#fff;color:#0E5A35;">⬇ Download Bill</button>
          <button id="tabMaintBtn" onclick="setMaint()" style="border:none;cursor:pointer;font-weight:700;font-size:14px;padding:9px 16px;border-radius:9px;transition:background .2s, color .2s;background:transparent;color:rgba(255,255,255,0.8);">By KuickPay</button>
        </div>
      </div>

      <div style="padding:clamp(24px,4vw,40px);">
        <div style="display:flex;flex-wrap:wrap;gap:14px;align-items:flex-end;">
          <label style="flex:1;min-width:240px;">
            <span id="lookupLabel" style="display:block;font-size:13px;font-weight:600;color:#5b6b62;margin-bottom:8px;">Enter Kuickpay Reference Number to Fetch Download Bill</span>
            <input id="refInput" value="" oninput="onRef(event)" onkeydown="onKey(event)" placeholder="e.g. 01000 or 01010 or 01060 or 01070 or 00550 or 01550" inputmode="numeric" style="width:100%;padding:15px 16px;border:1.5px solid #d7ddd9;border-radius:12px;font-size:16px;font-family:'Inter',sans-serif;outline:none;transition:border .2s, box-shadow .2s;" onfocus="hoverIn(this, { borderColor:'#0E5A35', boxShadow:'0 0 0 4px rgba(14,90,53,0.12)' })" onblur="hoverOut(this)">
          </label>
          <button onclick="fetchBill()" style="display:inline-flex;align-items:center;justify-content:center;gap:9px;background:#0E5A35;color:#fff;font-weight:700;font-size:16px;padding:16px 30px;border:none;border-radius:12px;cursor:pointer;min-width:160px;transition:background .2s, transform .2s;" onmouseenter="hoverIn(this, { background:'#0a4429', transform:'translateY(-2px)' })" onmouseleave="hoverOut(this)">
            <div id="loadingSpinner" style="display:none;"><span style="width:18px;height:18px;border:2.5px solid rgba(255,255,255,0.35);border-top-color:#fff;border-radius:50%;display:inline-block;animation:spin .7s linear infinite;"></span></div>
            <div id="fetchLabel" style="">Fetch Bill</div>
          </button>
        </div>

        <div id="errorBox" style="display:none;">
          <div style="margin-top:16px;display:flex;align-items:center;gap:10px;background:#fdf3f3;border:1px solid #f3d2d2;color:#b3382f;padding:13px 16px;border-radius:12px;font-size:14.5px;font-weight:500;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#b3382f" stroke-width="2"><circle cx="12" cy="12" r="9"></circle><path d="M12 8v5M12 16.5v.5"></path></svg>
            <span id="errorText"></span>
          </div>
        </div>

        <!-- ===== BILL SUMMARY CARD ===== -->
        <div id="billCard" style="display:none;">
          <div data-reveal="" style="margin-top:24px;border:1px solid #e7ece9;border-radius:18px;overflow:hidden;">
            <div style="display:flex;flex-wrap:wrap;justify-content:space-between;gap:14px;padding:22px 26px;background:#F4F6F5;border-bottom:1px solid #e7ece9;">
              <div>
                <div style="font-size:12px;letter-spacing:1px;font-weight:700;color:#8a988f;">BILL FOUND</div>
                <div style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:22px;color:#1C2B24;margin-top:4px;"><span id="billAreaLabel"></span></div>
                <div style="font-size:13px;color:#8a988f;margin-top:6px;">Ref #: <span id="billRef"></span></div>
              </div>
              <div style="text-align:right;">
                <span style="display:inline-block;padding:6px 14px;border-radius:100px;font-size:13px;font-weight:700;color:#fff;background:#0E5A35;">Verified</span>
              </div>
            </div>
            <div style="display:flex;flex-wrap:wrap;gap:28px;padding:16px 26px;background:#fff;border-top:1px solid #f0f3f1;">
              <div>
                <div style="font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase;">Amount Due</div>
                <div style="font-size:16px;font-weight:700;color:#0E5A35;margin-top:3px;"><span id="billAmountDue">—</span></div>
              </div>
              <div>
                <div style="font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase;">Due Date</div>
                <div style="font-size:16px;font-weight:700;color:#1C2B24;margin-top:3px;"><span id="billDueDate">—</span></div>
              </div>
              <div>
                <div style="font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase;">Meter No</div>
                <div style="font-size:16px;font-weight:700;color:#1C2B24;margin-top:3px;"><span id="billMeterNo">—</span></div>
              </div>
              <div>
                <div style="font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase;">Amount After Date</div>
                <div style="font-size:16px;font-weight:700;color:#c0392b;margin-top:3px;"><span id="billAmountAfterDate">—</span></div>
              </div>
              <div>
                <div style="font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase;">Billing Period</div>
                <div style="font-size:16px;font-weight:700;color:#1C2B24;margin-top:3px;"><span id="billBillingPeriod">—</span></div>
              </div>
            </div>
            <div style="display:flex;flex-wrap:wrap;gap:12px;padding:20px 26px;background:#fff;border-top:1px solid #f0f3f1;">
              <button id="billCardDownloadBtn" onclick="downloadPdf()" style="display:inline-flex;align-items:center;gap:9px;background:#fff;border:1.5px solid #0E5A35;color:#0E5A35;font-weight:700;font-size:15px;padding:13px 22px;border-radius:11px;cursor:pointer;transition:background .2s;" onmouseenter="hoverIn(this, { background:'#f0f6f2' })" onmouseleave="hoverOut(this)">
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v12M7 11l5 5 5-5M5 21h14"></path></svg>Download / View Bill (PDF)
              </button>
              <button id="billCardPayBtn" onclick="payViaKuickPay()" style="display:inline-flex;align-items:center;gap:9px;background:#C9A227;border:none;color:#1C2B24;font-weight:700;font-size:15px;padding:13px 22px;border-radius:11px;cursor:pointer;transition:background .2s;display:none;" onmouseenter="hoverIn(this, { background:'#b87f00' })" onmouseleave="hoverOut(this)">
                Pay via KuickPay
              </button>
            </div>
          </div>
        </div>

        <p style="margin:18px 0 0;font-size:12.5px;color:#a3afa8;">Use the KuickPay reference printed on your bill. <span style="color:#8a988f;">Your request is processed securely.</span></p>
      </div>
    </div>
  </section>

  <!-- ===================== SERVICES ===================== -->
  <section id="services" style="padding:40px clamp(20px,5vw,56px) 90px;background:#fff;">
    <div style="max-width:1200px;margin:0 auto;">
      <div data-reveal="" style="text-align:center;max-width:640px;margin:0 auto 52px;">
        <div style="color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px;">OUR SERVICES</div>
        <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px;">Everything you need, in one place</h2>
      </div>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:22px;">
        <div data-reveal="" style="background:#fff;border:1px solid #e9edeb;border-radius:20px;padding:34px 30px;transition:transform .3s, box-shadow .3s, border-color .3s;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 20px 44px rgba(7,46,29,0.12)', borderColor:'#cfe8db' })" onmouseleave="hoverOut(this)">
          <div style="width:60px;height:60px;border-radius:16px;background:rgba(0,194,255,0.12);display:flex;align-items:center;justify-content:center;margin-bottom:22px;">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="#00C2FF"><path d="M13 2 4 14h6l-1 8 9-12h-6l1-8z"></path></svg>
          </div>
          <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:21px;color:#1C2B24;margin:0 0 6px;">Electricity Billing</h3>
          <p class="urdu" style="color:#0E5A35;font-size:15px;margin:0 0 10px;">بجلی کے بل</p>
          <p style="color:#5b6b62;font-size:15px;line-height:1.6;margin:0;">View, download and pay your monthly power bills with detailed unit-wise consumption and history.</p>
        </div>
        <div data-reveal="" style="background:#fff;border:1px solid #e9edeb;border-radius:20px;padding:34px 30px;transition:transform .3s, box-shadow .3s, border-color .3s;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 20px 44px rgba(7,46,29,0.12)', borderColor:'#cfe8db' })" onmouseleave="hoverOut(this)">
          <div style="width:60px;height:60px;border-radius:16px;background:rgba(14,90,53,0.1);display:flex;align-items:center;justify-content:center;margin-bottom:22px;">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21V8l9-5 9 5v13M9 21v-6h6v6"></path></svg>
          </div>
          <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:21px;color:#1C2B24;margin:0 0 6px;">Maintenance Billing</h3>
          <p class="urdu" style="color:#0E5A35;font-size:15px;margin:0 0 10px;">مینٹیننس کے واجبات</p>
          <p style="color:#5b6b62;font-size:15px;line-height:1.6;margin:0;">Settle your society maintenance dues, view charges breakdown and keep your account clear.</p>
        </div>
        <div data-reveal="" style="background:#fff;border:1px solid #e9edeb;border-radius:20px;padding:34px 30px;transition:transform .3s, box-shadow .3s, border-color .3s;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 20px 44px rgba(7,46,29,0.12)', borderColor:'#cfe8db' })" onmouseleave="hoverOut(this)">
          <div style="width:60px;height:60px;border-radius:16px;background:rgba(201,162,39,0.14);display:flex;align-items:center;justify-content:center;margin-bottom:22px;">
            <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#C9A227" stroke-width="2"><circle cx="12" cy="12" r="9"></circle><path d="M3 12h18M12 3c2.5 3 2.5 15 0 18M12 3c-2.5 3-2.5 15 0 18"></path></svg>
          </div>
          <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:21px;color:#1C2B24;margin:0 0 6px;">Online Payment — Worldwide</h3>
          <p class="urdu" style="color:#0E5A35;font-size:15px;margin:0 0 10px;">دنیا بھر سے ادائیگی</p>
          <p style="color:#5b6b62;font-size:15px;line-height:1.6;margin:0;">Pay from anywhere, anytime — overseas residents included — via cards, wallets and bank transfer.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ===================== PROJECTS ===================== -->
  <section id="projects" style="padding:90px clamp(20px,5vw,56px);background:#F4F6F5;">
    <div style="max-width:1200px;margin:0 auto;">
      <div data-reveal="" style="text-align:center;max-width:640px;margin:0 auto 52px;">
        <div style="color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px;">BAHRIA TOWN PROJECTS</div>
        <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px;">Serving communities nationwide</h2>
      </div>
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:22px;">
        
          <div data-reveal="" style="background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })" onmouseleave="hoverOut(this)">
            <!-- Replace with official Bahria Town project photo -->
            <div style="height:180px;position:relative;background-image:linear-gradient(135deg,#0E5A35,#0a4429), repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px);background-blend-mode:overlay;display:flex;align-items:flex-end;padding:16px;">
              <span style="font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px;">project photo</span>
            </div>
            <div style="padding:22px;">
              <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px;">Bahria Town Rawalpindi / Islamabad</h3>
              <p style="color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5;">Phases 1–8 · the flagship master-planned community</p>
              <a href="#lookup" style="display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none;">View Bills <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2.2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"></path></svg></a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })" onmouseleave="hoverOut(this)">
            <!-- Replace with official Bahria Town project photo -->
            <div style="height:180px;position:relative;background-image:linear-gradient(135deg,#13724a,#0c4d31), repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px);background-blend-mode:overlay;display:flex;align-items:flex-end;padding:16px;">
              <span style="font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px;">project photo</span>
            </div>
            <div style="padding:22px;">
              <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px;">Bahria Town Lahore</h3>
              <p style="color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5;">Grand living in the heart of Punjab</p>
              <a href="#lookup" style="display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none;">View Bills <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2.2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"></path></svg></a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })" onmouseleave="hoverOut(this)">
            <!-- Replace with official Bahria Town project photo -->
            <div style="height:180px;position:relative;background-image:linear-gradient(135deg,#0a4429,#072e1d), repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px);background-blend-mode:overlay;display:flex;align-items:flex-end;padding:16px;">
              <span style="font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px;">project photo</span>
            </div>
            <div style="padding:22px;">
              <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px;">Bahria Town Karachi</h3>
              <p style="color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5;">A world-class city by the sea</p>
              <a href="#lookup" style="display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none;">View Bills <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2.2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"></path></svg></a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })" onmouseleave="hoverOut(this)">
            <!-- Replace with official Bahria Town project photo -->
            <div style="height:180px;position:relative;background-image:linear-gradient(135deg,#15784f,#0E5A35), repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px);background-blend-mode:overlay;display:flex;align-items:flex-end;padding:16px;">
              <span style="font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px;">project photo</span>
            </div>
            <div style="padding:22px;">
              <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px;">Bahria Enclave, Islamabad</h3>
              <p style="color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5;">Hillside elegance in the capital</p>
              <a href="#lookup" style="display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none;">View Bills <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2.2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"></path></svg></a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })" onmouseleave="hoverOut(this)">
            <!-- Replace with official Bahria Town project photo -->
            <div style="height:180px;position:relative;background-image:linear-gradient(135deg,#0E5A35,#13724a), repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px);background-blend-mode:overlay;display:flex;align-items:flex-end;padding:16px;">
              <span style="font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px;">project photo</span>
            </div>
            <div style="padding:22px;">
              <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px;">Bahria Golf City</h3>
              <p style="color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5;">Resort-style living on the greens</p>
              <a href="#lookup" style="display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none;">View Bills <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2.2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"></path></svg></a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer;" onmouseenter="hoverIn(this, { transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })" onmouseleave="hoverOut(this)">
            <!-- Replace with official Bahria Town project photo -->
            <div style="height:180px;position:relative;background-image:linear-gradient(135deg,#5b6b62,#3a4640), repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px);background-blend-mode:overlay;display:flex;align-items:flex-end;padding:16px;">
              <span style="font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px;">project photo</span>
            </div>
            <div style="padding:22px;">
              <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px;">More Projects</h3>
              <p style="color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5;">New communities coming online soon</p>
              <a href="#lookup" style="display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none;">Learn More <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2.2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"></path></svg></a>
            </div>
          </div>
        
      </div>
    </div>
  </section>

  <!-- ===================== HOW IT WORKS ===================== -->
  <section id="how" style="padding:90px clamp(20px,5vw,56px);background:#fff;">
    <div style="max-width:1100px;margin:0 auto;">
      <div data-reveal="" style="text-align:center;max-width:640px;margin:0 auto 56px;">
        <div style="color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px;">HOW IT WORKS</div>
        <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px;">Pay in four simple steps</h2>
      </div>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px;">
        
          <div data-reveal="" style="position:relative;padding:30px 24px;border:1px solid #e9edeb;border-radius:18px;background:#fcfdfc;">
            <div style="width:48px;height:48px;border-radius:14px;background:#0E5A35;color:#fff;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:20px;display:flex;align-items:center;justify-content:center;margin-bottom:18px;">1</div>
            <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:17px;color:#1C2B24;margin:0 0 7px;">Enter your number</h3>
            <p style="color:#5b6b62;font-size:14px;line-height:1.55;margin:0;">Type your consumer / account / reference number into the lookup box.</p>
          </div>
        

          <div data-reveal="" style="position:relative;padding:30px 24px;border:1px solid #e9edeb;border-radius:18px;background:#fcfdfc;">
            <div style="width:48px;height:48px;border-radius:14px;background:#0E5A35;color:#fff;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:20px;display:flex;align-items:center;justify-content:center;margin-bottom:18px;">2</div>
            <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:17px;color:#1C2B24;margin:0 0 7px;">View your bill</h3>
            <p style="color:#5b6b62;font-size:14px;line-height:1.55;margin:0;">Instantly see your charges, units, due date and balance.</p>
          </div>
        

          <div data-reveal="" style="position:relative;padding:30px 24px;border:1px solid #e9edeb;border-radius:18px;background:#fcfdfc;">
            <div style="width:48px;height:48px;border-radius:14px;background:#0E5A35;color:#fff;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:20px;display:flex;align-items:center;justify-content:center;margin-bottom:18px;">3</div>
            <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:17px;color:#1C2B24;margin:0 0 7px;">Download PDF</h3>
            <p style="color:#5b6b62;font-size:14px;line-height:1.55;margin:0;">Save or print an official copy of your bill for your records.</p>
          </div>
        

          <div data-reveal="" style="position:relative;padding:30px 24px;border:1px solid #e9edeb;border-radius:18px;background:#fcfdfc;">
            <div style="width:48px;height:48px;border-radius:14px;background:#0E5A35;color:#fff;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:20px;display:flex;align-items:center;justify-content:center;margin-bottom:18px;">4</div>
            <h3 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:17px;color:#1C2B24;margin:0 0 7px;">Pay securely</h3>
            <p style="color:#5b6b62;font-size:14px;line-height:1.55;margin:0;">Settle online via wallet, card or bank — get an instant receipt.</p>
          </div>
        
      </div>
    </div>
  </section>

  <!-- ===================== WHY PAY ONLINE (stats) ===================== -->
  <section style="padding:80px clamp(20px,5vw,56px);background:radial-gradient(120% 120% at 20% 0%, #115c39 0%, #0a4429 60%, #072e1d 100%);">
    <div style="max-width:1100px;margin:0 auto;">
      <div data-reveal="" style="text-align:center;margin-bottom:48px;">
        <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(26px,3.6vw,38px);color:#fff;margin:0;letter-spacing:-.5px;">Why pay online?</h2>
        <p style="color:rgba(255,255,255,0.7);margin:10px 0 0;font-size:16px;">Faster, safer and always available.</p>
      </div>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:18px;">
        
          <div data-reveal="" style="text-align:center;padding:28px 18px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:18px;">
            <div data-count="24" data-suffix="/7" style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(34px,5vw,52px);color:#00C2FF;line-height:1;">0/7</div>
            <div style="color:rgba(255,255,255,0.82);font-size:14.5px;margin-top:10px;font-weight:500;">Access, every day</div>
          </div>
        

          <div data-reveal="" style="text-align:center;padding:28px 18px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:18px;">
            <div data-count="100" data-suffix="%" style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(34px,5vw,52px);color:#00C2FF;line-height:1;">0%</div>
            <div style="color:rgba(255,255,255,0.82);font-size:14.5px;margin-top:10px;font-weight:500;">Secure payments</div>
          </div>
        

          <div data-reveal="" style="text-align:center;padding:28px 18px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:18px;">
            <div data-count="5" data-suffix="+" style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(34px,5vw,52px);color:#00C2FF;line-height:1;">0+</div>
            <div style="color:rgba(255,255,255,0.82);font-size:14.5px;margin-top:10px;font-weight:500;">Bahria projects</div>
          </div>
        

          <div data-reveal="" style="text-align:center;padding:28px 18px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:18px;">
            <div data-count="1" data-suffix="M+" style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(34px,5vw,52px);color:#00C2FF;line-height:1;">0M+</div>
            <div style="color:rgba(255,255,255,0.82);font-size:14.5px;margin-top:10px;font-weight:500;">Residents served</div>
          </div>
        
      </div>
    </div>
  </section>

  <!-- ===================== PAYMENT METHODS ===================== -->
  <section style="padding:80px clamp(20px,5vw,56px);background:#fff;">
    <div style="max-width:1000px;margin:0 auto;text-align:center;">
      <div data-reveal="">
        <div style="color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px;">PAYMENT METHODS</div>
        <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(26px,3.6vw,38px);color:#1C2B24;margin:10px 0 8px;letter-spacing:-.5px;">Pay your way</h2>
        <p style="color:#5b6b62;margin:0 auto 40px;max-width:560px;font-size:16px;">Local wallets and banks for residents, global gateways for overseas Pakistanis.</p>
      </div>
      <!-- TODO: Integrate payment gateway (1LINK / JazzCash / Easypaisa / Stripe / PayPal) -->
      <div data-reveal="" style="display:flex;flex-wrap:wrap;justify-content:center;gap:14px;">
        
          <div style="display:flex;align-items:center;gap:10px;padding:15px 24px;border:1px solid #e7ece9;border-radius:14px;background:#fcfdfc;font-weight:700;color:#1C2B24;font-size:15px;transition:border-color .2s, transform .2s;" onmouseenter="hoverIn(this, { borderColor:'#0E5A35', transform:'translateY(-3px)' })" onmouseleave="hoverOut(this)">
            <span style="width:10px;height:10px;border-radius:3px;background:#0E5A35;"></span>1LINK
          </div>
        

          <div style="display:flex;align-items:center;gap:10px;padding:15px 24px;border:1px solid #e7ece9;border-radius:14px;background:#fcfdfc;font-weight:700;color:#1C2B24;font-size:15px;transition:border-color .2s, transform .2s;" onmouseenter="hoverIn(this, { borderColor:'#0E5A35', transform:'translateY(-3px)' })" onmouseleave="hoverOut(this)">
            <span style="width:10px;height:10px;border-radius:3px;background:#C9A227;"></span>JazzCash
          </div>
        

          <div style="display:flex;align-items:center;gap:10px;padding:15px 24px;border:1px solid #e7ece9;border-radius:14px;background:#fcfdfc;font-weight:700;color:#1C2B24;font-size:15px;transition:border-color .2s, transform .2s;" onmouseenter="hoverIn(this, { borderColor:'#0E5A35', transform:'translateY(-3px)' })" onmouseleave="hoverOut(this)">
            <span style="width:10px;height:10px;border-radius:3px;background:#00C2FF;"></span>Easypaisa
          </div>
        

          <div style="display:flex;align-items:center;gap:10px;padding:15px 24px;border:1px solid #e7ece9;border-radius:14px;background:#fcfdfc;font-weight:700;color:#1C2B24;font-size:15px;transition:border-color .2s, transform .2s;" onmouseenter="hoverIn(this, { borderColor:'#0E5A35', transform:'translateY(-3px)' })" onmouseleave="hoverOut(this)">
            <span style="width:10px;height:10px;border-radius:3px;background:#0a4429;"></span>Debit / Credit Card
          </div>
        

          <div style="display:flex;align-items:center;gap:10px;padding:15px 24px;border:1px solid #e7ece9;border-radius:14px;background:#fcfdfc;font-weight:700;color:#1C2B24;font-size:15px;transition:border-color .2s, transform .2s;" onmouseenter="hoverIn(this, { borderColor:'#0E5A35', transform:'translateY(-3px)' })" onmouseleave="hoverOut(this)">
            <span style="width:10px;height:10px;border-radius:3px;background:#13724a;"></span>Kuickpay
          </div>
        
      </div>
    </div>
  </section>

  <!-- ===================== CONTACT ===================== -->
  <section id="contact" style="padding:90px clamp(20px,5vw,56px);background:#F4F6F5;">
    <div style="max-width:1140px;margin:0 auto;">
      <div data-reveal="" style="text-align:center;max-width:640px;margin:0 auto 52px;">
        <div style="color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px;">CONTACT &amp; SUPPORT</div>
        <h2 style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px;">Billing offices &amp; helplines</h2>
        <p style="color:#5b6b62;font-size:16px;margin:12px 0 0;">Reach the billing department for your project directly.</p>
      </div>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:22px;">
        
          <div data-reveal="" style="background:#fff;border:1px solid #e7ece9;border-radius:20px;padding:30px 28px;box-shadow:0 14px 40px rgba(7,46,29,0.06);transition:transform .3s, box-shadow .3s;" onmouseenter="hoverIn(this, { transform:'translateY(-6px)', boxShadow:'0 22px 50px rgba(7,46,29,0.12)' })" onmouseleave="hoverOut(this)">
            <div style="display:inline-flex;align-items:center;gap:9px;background:rgba(14,90,53,0.08);color:#0E5A35;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:16px;padding:9px 16px;border-radius:100px;margin-bottom:20px;">
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><path d="M3 21V8l9-5 9 5v13M9 21v-6h6v6"></path></svg>Bahria Enclave
            </div>
            <div style="display:flex;flex-direction:column;gap:14px;">
              <div style="display:flex;gap:12px;align-items:flex-start;">
                <svg width="19" height="19" style="flex:0 0 auto;margin-top:1px;" viewBox="0 0 24 24" fill="none" stroke="#C9A227" stroke-width="2"><path d="M12 21s7-5.5 7-11a7 7 0 0 0-14 0c0 5.5 7 11 7 11z"></path><circle cx="12" cy="10" r="2.5"></circle></svg>
                <span style="color:#3a4640;font-size:14.5px;line-height:1.5;">Billing Office, 1st Floor, Head Office, Sector I, Bahria Enclave</span>
              </div>
              <a href="tel:+92512721035" style="display:flex;gap:12px;align-items:center;text-decoration:none;">
                <svg width="19" height="19" style="flex:0 0 auto;" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3-8.6A2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 2 .7 2.9a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.2-1.2a2 2 0 0 1 2.1-.5c.9.3 1.9.6 2.9.7a2 2 0 0 1 1.7 2z"></path></svg>
                <span style="color:#1C2B24;font-size:14.5px;font-weight:600;">+92 (51) 2721035</span>
              </a>
              <a href="mailto:be.billingdepartment@gmail.com" style="display:flex;gap:12px;align-items:center;text-decoration:none;word-break:break-all;">
                <svg width="19" height="19" style="flex:0 0 auto;" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="m3 7 9 6 9-6"></path></svg>
                <span style="color:#0E5A35;font-size:14px;font-weight:600;">be.billingdepartment@gmail.com</span>
              </a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border:1px solid #e7ece9;border-radius:20px;padding:30px 28px;box-shadow:0 14px 40px rgba(7,46,29,0.06);transition:transform .3s, box-shadow .3s;" onmouseenter="hoverIn(this, { transform:'translateY(-6px)', boxShadow:'0 22px 50px rgba(7,46,29,0.12)' })" onmouseleave="hoverOut(this)">
            <div style="display:inline-flex;align-items:center;gap:9px;background:rgba(14,90,53,0.08);color:#0E5A35;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:16px;padding:9px 16px;border-radius:100px;margin-bottom:20px;">
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><path d="M3 21V8l9-5 9 5v13M9 21v-6h6v6"></path></svg>Phase 1 – 6
            </div>
            <div style="display:flex;flex-direction:column;gap:14px;">
              <div style="display:flex;gap:12px;align-items:flex-start;">
                <svg width="19" height="19" style="flex:0 0 auto;margin-top:1px;" viewBox="0 0 24 24" fill="none" stroke="#C9A227" stroke-width="2"><path d="M12 21s7-5.5 7-11a7 7 0 0 0-14 0c0 5.5 7 11 7 11z"></path><circle cx="12" cy="10" r="2.5"></circle></svg>
                <span style="color:#3a4640;font-size:14.5px;line-height:1.5;">Garden Avenue, near Civic Center, Phase 4</span>
              </div>
              <a href="tel:+92515733277" style="display:flex;gap:12px;align-items:center;text-decoration:none;">
                <svg width="19" height="19" style="flex:0 0 auto;" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3-8.6A2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 2 .7 2.9a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.2-1.2a2 2 0 0 1 2.1-.5c.9.3 1.9.6 2.9.7a2 2 0 0 1 1.7 2z"></path></svg>
                <span style="color:#1C2B24;font-size:14.5px;font-weight:600;">+92 (51) 5733277</span>
              </a>
              <a href="mailto:cbdbt1to6@gmail.com" style="display:flex;gap:12px;align-items:center;text-decoration:none;word-break:break-all;">
                <svg width="19" height="19" style="flex:0 0 auto;" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="m3 7 9 6 9-6"></path></svg>
                <span style="color:#0E5A35;font-size:14px;font-weight:600;">cbdbt1to6@gmail.com</span>
              </a>
            </div>
          </div>
        

          <div data-reveal="" style="background:#fff;border:1px solid #e7ece9;border-radius:20px;padding:30px 28px;box-shadow:0 14px 40px rgba(7,46,29,0.06);transition:transform .3s, box-shadow .3s;" onmouseenter="hoverIn(this, { transform:'translateY(-6px)', boxShadow:'0 22px 50px rgba(7,46,29,0.12)' })" onmouseleave="hoverOut(this)">
            <div style="display:inline-flex;align-items:center;gap:9px;background:rgba(14,90,53,0.08);color:#0E5A35;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:16px;padding:9px 16px;border-radius:100px;margin-bottom:20px;">
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><path d="M3 21V8l9-5 9 5v13M9 21v-6h6v6"></path></svg>Phase 7 – 8
            </div>
            <div style="display:flex;flex-direction:column;gap:14px;">
              <div style="display:flex;gap:12px;align-items:flex-start;">
                <svg width="19" height="19" style="flex:0 0 auto;margin-top:1px;" viewBox="0 0 24 24" fill="none" stroke="#C9A227" stroke-width="2"><path d="M12 21s7-5.5 7-11a7 7 0 0 0-14 0c0 5.5 7 11 7 11z"></path><circle cx="12" cy="10" r="2.5"></circle></svg>
                <span style="color:#3a4640;font-size:14.5px;line-height:1.5;">Usman Block, near Grid Station, Phase 8</span>
              </div>
              <a href="tel:+92515410387" style="display:flex;gap:12px;align-items:center;text-decoration:none;">
                <svg width="19" height="19" style="flex:0 0 auto;" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3-8.6A2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 2 .7 2.9a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.2-1.2a2 2 0 0 1 2.1-.5c.9.3 1.9.6 2.9.7a2 2 0 0 1 1.7 2z"></path></svg>
                <span style="color:#1C2B24;font-size:14.5px;font-weight:600;">+92 (51) 5410387 & 5410080</span>
              </a>
              <a href="mailto:Cbdbt7to9@gmail.com" style="display:flex;gap:12px;align-items:center;text-decoration:none;word-break:break-all;">
                <svg width="19" height="19" style="flex:0 0 auto;" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" stroke-width="2"><rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="m3 7 9 6 9-6"></path></svg>
                <span style="color:#0E5A35;font-size:14px;font-weight:600;">Cbdbt7to9@gmail.com</span>
              </a>
            </div>
          </div>
        
      </div>
    </div>
  </section>

  <!-- ===================== FOOTER ===================== -->
  <footer style="background:#072e1d;color:rgba(255,255,255,0.75);padding:60px clamp(20px,5vw,56px) 30px;">
    <div style="max-width:1200px;margin:0 auto;display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:36px;">
      <div>
        <div style="display:flex;align-items:center;gap:12px;margin-bottom:16px;">
          <div style="width:44px;height:44px;border-radius:11px;background:linear-gradient(135deg,#0E5A35,#0a4429);display:flex;align-items:center;justify-content:center;border:1px solid rgba(201,162,39,0.4);overflow:hidden;"><img src="Images/billing-logo.png" alt="Bahria Town logo" width="32" height="32" style="display:block;object-fit:contain;"></div>
          <div style="line-height:1.1;"><div style="font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;color:#fff;font-size:15px;">BAHRIA TOWN</div><div style="font-size:10px;letter-spacing:1.5px;color:#C9A227;font-weight:600;">POWER &amp; MAINTENANCE</div></div>
        </div>
        <p style="font-size:13.5px;line-height:1.6;margin:0 0 6px;max-width:260px;">Asia's premier housing society developer — powering premium communities across Pakistan.</p>
        <p class="urdu" style="color:#C9A227;font-size:15px;margin:8px 0 0;">ایشیا کا صفِ اول ہاؤسنگ ڈیولپر</p>
      </div>
      <div>
        <div style="color:#fff;font-weight:700;font-size:14px;margin-bottom:14px;">Quick Links</div>
        
          <a href="#home" style="display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s;" onmouseenter="hoverIn(this, { color:'#00C2FF' })" onmouseleave="hoverOut(this)">Home</a>
        

          <a href="#services" style="display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s;" onmouseenter="hoverIn(this, { color:'#00C2FF' })" onmouseleave="hoverOut(this)">Services</a>
        

          <a href="#projects" style="display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s;" onmouseenter="hoverIn(this, { color:'#00C2FF' })" onmouseleave="hoverOut(this)">Projects</a>
        

          <a href="#how" style="display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s;" onmouseenter="hoverIn(this, { color:'#00C2FF' })" onmouseleave="hoverOut(this)">How It Works</a>
        

          <a href="#lookup" style="display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s;" onmouseenter="hoverIn(this, { color:'#00C2FF' })" onmouseleave="hoverOut(this)">Pay Bill</a>
        

          <a href="#contact" style="display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s;" onmouseenter="hoverIn(this, { color:'#00C2FF' })" onmouseleave="hoverOut(this)">Contact</a>
        
      </div>
      <div>
        <div style="color:#fff;font-weight:700;font-size:14px;margin-bottom:14px;">Contact</div>
        <div style="font-size:14px;line-height:1.9;">Billing Office, 1st Floor, Head Office, Sector I, Bahria Enclave<br>+92 (51) 2721035<br>be.billingdepartment@gmail.com</div>
      </div>
      <div>
        <div style="color:#fff;font-weight:700;font-size:14px;margin-bottom:14px;">Follow</div>
        <div style="display:flex;gap:10px;">
          <a href="#" aria-label="Facebook" style="width:38px;height:38px;border-radius:10px;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;transition:background .2s;" onmouseenter="hoverIn(this, { background:'rgba(0,194,255,0.25)' })" onmouseleave="hoverOut(this)"><svg width="18" height="18" viewBox="0 0 24 24" fill="#fff"><path d="M14 9h3V6h-3a4 4 0 0 0-4 4v2H7v3h3v6h3v-6h3l1-3h-4v-2a1 1 0 0 1 1-1z"></path></svg></a>
          <a href="#" aria-label="Instagram" style="width:38px;height:38px;border-radius:10px;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;transition:background .2s;" onmouseenter="hoverIn(this, { background:'rgba(0,194,255,0.25)' })" onmouseleave="hoverOut(this)"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="5"></rect><circle cx="12" cy="12" r="4"></circle><circle cx="17.5" cy="6.5" r="1" fill="#fff"></circle></svg></a>
          <a href="#" aria-label="YouTube" style="width:38px;height:38px;border-radius:10px;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;transition:background .2s;" onmouseenter="hoverIn(this, { background:'rgba(0,194,255,0.25)' })" onmouseleave="hoverOut(this)"><svg width="18" height="18" viewBox="0 0 24 24" fill="#fff"><path d="M22 12s0-3-.4-4.4a2.5 2.5 0 0 0-1.8-1.8C18.4 5.4 12 5.4 12 5.4s-6.4 0-7.8.4A2.5 2.5 0 0 0 2.4 7.6C2 9 2 12 2 12s0 3 .4 4.4a2.5 2.5 0 0 0 1.8 1.8c1.4.4 7.8.4 7.8.4s6.4 0 7.8-.4a2.5 2.5 0 0 0 1.8-1.8C22 15 22 12 22 12zM10 15V9l5 3-5 3z"></path></svg></a>
        </div>
      </div>
    </div>
    <div style="max-width:1200px;margin:40px auto 0;padding-top:24px;border-top:1px solid rgba(255,255,255,0.1);display:flex;flex-wrap:wrap;gap:8px;justify-content:space-between;font-size:13px;color:rgba(255,255,255,0.55);">
      <span>© 2026 Bahria Town (Pvt) Ltd — Power &amp; Maintenance Billing Division.</span>
      <span class="urdu" style="font-size:14px;">جملہ حقوق محفوظ ہیں</span>
    </div>
  </footer>


  <style>
    @media (max-width: 860px){
      .nav-desktop{ display:none !important; }
      .nav-mobile{ display:flex !important; }
    }
  </style>
</div>


    <script src="Scripts/billing-portal.js"></script>
</body>
</html>
