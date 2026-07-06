import { useEffect } from 'react';
import {
  hoverIn, hoverOut,
  initNavScroll, initReveal, updateTabStyles,
  toggleMobile, closeMobile,
  setElectric, setMaint,
  onRef, onKey,
  fetchBill, downloadPdf,
  payViaKuickPay,
} from './billing.js';

// Converts a CSS string ("color:red;font-size:14px") to a React style object.
function css(str) {
  if (!str) return {};
  return str.split(';').reduce((obj, rule) => {
    const idx = rule.indexOf(':');
    if (idx === -1) return obj;
    const prop = rule.slice(0, idx).trim();
    const val = rule.slice(idx + 1).trim();
    if (!prop || !val) return obj;
    const camel = prop.replace(/-([a-z])/g, (_, c) => c.toUpperCase());
    obj[camel] = val;
    return obj;
  }, {});
}

const hi = (styles) => (e) => hoverIn(e.currentTarget, styles);
const ho = () => (e) => hoverOut(e.currentTarget);

export default function App() {
  useEffect(() => {
    initNavScroll();
    initReveal();
    updateTabStyles();
  }, []);

  return (
    <div id="appRoot" style={css('min-height:100vh;overflow-x:hidden')}>

      {/* ===================== NAVBAR ===================== */}
      <nav id="mainNav" style={css('position:fixed;top:0;left:0;right:0;z-index:60;display:flex;align-items:center;justify-content:space-between;padding:16px clamp(20px,5vw,56px);background:rgba(10,61,39,0.0);transition:background .3s ease, box-shadow .3s ease, padding .3s ease')}>
        <a href="#home" style={css('display:flex;align-items:center;gap:12px;text-decoration:none')}>
          <div style={css('width:46px;height:46px;border-radius:12px;background:linear-gradient(135deg,#0E5A35,#0a4429);display:flex;align-items:center;justify-content:center;border:1px solid rgba(201,162,39,0.45);box-shadow:0 4px 14px rgba(0,0,0,.25);overflow:hidden')}>
            <img src="Images/billing-logo.png" alt="Bahria Town Power &amp; Maintenance logo" width="34" height="34" style={css('display:block;object-fit:contain')} />
          </div>
          <div style={css('line-height:1.1')}>
            <div style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:16px;color:#fff;letter-spacing:.2px")}>BAHRIA TOWN</div>
            <div style={css('font-size:10.5px;letter-spacing:2px;color:#C9A227;font-weight:600')}>POWER &amp; MAINTENANCE</div>
          </div>
        </a>
        <div style={css('display:flex;align-items:center;gap:6px')} className="nav-desktop">
          {['#home','#services','#projects','#how','#lookup','#contact'].map((href, i) => (
            <a key={href} href={href} style={css('text-decoration:none;color:rgba(255,255,255,0.85);font-size:14.5px;font-weight:500;padding:9px 14px;border-radius:8px;transition:color .2s, background .2s')}
              onMouseEnter={hi({ color:'#fff', background:'rgba(255,255,255,0.1)' })}
              onMouseLeave={ho()}>
              {['Home','Services','Projects','How It Works','Pay Bill','Contact'][i]}
            </a>
          ))}
          <a href="#lookup" style={css('margin-left:10px;text-decoration:none;background:#C9A227;color:#1C2B24;font-weight:700;font-size:14px;padding:11px 20px;border-radius:10px;box-shadow:0 6px 18px rgba(201,162,39,.35);transition:transform .2s, box-shadow .2s')}
            onMouseEnter={hi({ transform:'translateY(-2px)', boxShadow:'0 10px 24px rgba(201,162,39,.5)' })}
            onMouseLeave={ho()}>Pay Bill</a>
        </div>
        <button onClick={toggleMobile} aria-label="Open menu" className="nav-mobile" style={css('display:none;background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.25);border-radius:10px;width:44px;height:44px;align-items:center;justify-content:center;cursor:pointer')}>
          <svg width="22" height="22" viewBox="0 0 24 24" stroke="#fff" strokeWidth="2" strokeLinecap="round"><path d="M3 6h18M3 12h18M3 18h18" /></svg>
        </button>
      </nav>

      <div id="mobileMenu" style={css('display:none')}>
        <div style={css('position:fixed;inset:0;z-index:70;background:rgba(6,37,24,0.97);backdrop-filter:blur(6px);display:flex;flex-direction:column;padding:24px')}>
          <div style={css('display:flex;justify-content:space-between;align-items:center;margin-bottom:24px')}>
            <div style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;color:#fff")}>Menu</div>
            <button onClick={closeMobile} aria-label="Close menu" style={css('background:rgba(255,255,255,0.12);border:none;border-radius:10px;width:44px;height:44px;color:#fff;font-size:22px;cursor:pointer')}>×</button>
          </div>
          {['#home','#services','#projects','#how','#lookup','#contact'].map((href, i) => (
            <a key={href} href={href} onClick={closeMobile} style={css("text-decoration:none;color:#fff;font-size:22px;font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;padding:16px 4px;border-bottom:1px solid rgba(255,255,255,0.1)")}>
              {['Home','Services','Projects','How It Works','Pay Bill','Contact'][i]}
            </a>
          ))}
          <a href="#lookup" onClick={closeMobile} style={css('margin-top:24px;text-align:center;text-decoration:none;background:#C9A227;color:#1C2B24;font-weight:700;padding:16px;border-radius:12px')}>Pay Your Bill</a>
        </div>
      </div>

      {/* ===================== HERO ===================== */}
      <header id="home" style={css('position:relative;min-height:96vh;display:flex;align-items:center;background:radial-gradient(120% 90% at 80% 10%, #115c39 0%, #0a4429 45%, #072e1d 100%);overflow:hidden;padding:120px clamp(20px,5vw,56px) 200px')}>
        <svg id="heroGrid" viewBox="0 0 1440 560" preserveAspectRatio="xMidYMid slice" aria-hidden="true" style={css('position:absolute;inset:0;width:100%;height:100%;opacity:.92')}>
          <defs>
            <linearGradient id="wireDim" x1="0" y1="0" x2="1" y2="0">
              <stop offset="0" stopColor="#0c4d31" /><stop offset="1" stopColor="#0c4d31" />
            </linearGradient>
            <filter id="glow" x="-60%" y="-60%" width="220%" height="220%">
              <feGaussianBlur stdDeviation="3.4" result="b" /><feMerge><feMergeNode in="b" /><feMergeNode in="SourceGraphic" /></feMerge>
            </filter>
            <filter id="softGlow" x="-120%" y="-120%" width="340%" height="340%">
              <feGaussianBlur stdDeviation="6" result="b" /><feMerge><feMergeNode in="b" /><feMergeNode in="SourceGraphic" /></feMerge>
            </filter>
            {/* yellow electric arc glow */}
            <filter id="arcGlow" x="-200%" y="-200%" width="500%" height="500%">
              <feGaussianBlur stdDeviation="7" result="b" />
              <feMerge><feMergeNode in="b" /><feMergeNode in="b" /><feMergeNode in="SourceGraphic" /></feMerge>
            </filter>
            {/* hot-white inner glow for spark centres */}
            <filter id="hotGlow" x="-150%" y="-150%" width="400%" height="400%">
              <feGaussianBlur stdDeviation="3" result="b" /><feMerge><feMergeNode in="b" /><feMergeNode in="SourceGraphic" /></feMerge>
            </filter>
            {/* yellow travelling spark gradient */}
            <radialGradient id="yellowSpark" cx="50%" cy="50%" r="50%">
              <stop offset="0" stopColor="#ffffff" />
              <stop offset="30%" stopColor="#FFE55C" />
              <stop offset="100%" stopColor="#FF8C00" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="sky" cx="80%" cy="0%" r="90%">
              <stop offset="0" stopColor="#1b7a4c" stopOpacity=".5" /><stop offset="1" stopColor="#072e1d" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="sparkGrad" cx="50%" cy="50%" r="50%">
              <stop offset="0" stopColor="#ffffff" /><stop offset="35%" stopColor="#9fe9ff" /><stop offset="100%" stopColor="#00C2FF" stopOpacity="0" />
            </radialGradient>
            <path id="pw1" d="M0 120 Q360 210 720 130 T1440 132" />
            <path id="pw2" d="M0 158 Q360 250 720 170 T1440 172" />
            <path id="pw3" d="M0 196 Q360 288 720 210 T1440 212" />
            <path id="pw4" d="M0 96 Q360 150 720 92 T1440 96" />
            <path id="pwf1" d="M1274 92 C 1330 190 1190 168 1138 168" />
            <path id="pwf2" d="M1276 110 C 1200 200 1010 214 980 236" />
            <path id="pwf3" d="M724 196 C 820 250 960 230 1058 204" />
            {/* starburst spark — reused at each junction */}
            <symbol id="zap" overflow="visible">
              <line x1="0" y1="-15" x2="0" y2="-4"  stroke="#ffffff" strokeWidth="1.6" strokeLinecap="round"/>
              <line x1="4"  y1="-11" x2="11" y2="-4" stroke="#FFE055" strokeWidth="1.3" strokeLinecap="round"/>
              <line x1="15" y1="0"   x2="4"  y2="0"  stroke="#ffffff" strokeWidth="1.6" strokeLinecap="round"/>
              <line x1="11" y1="4"   x2="4"  y2="11" stroke="#FFE055" strokeWidth="1.3" strokeLinecap="round"/>
              <line x1="0"  y1="15"  x2="0"  y2="4"  stroke="#ffffff" strokeWidth="1.6" strokeLinecap="round"/>
              <line x1="-4" y1="11"  x2="-11" y2="4" stroke="#FFE055" strokeWidth="1.3" strokeLinecap="round"/>
              <line x1="-15" y1="0"  x2="-4" y2="0"  stroke="#ffffff" strokeWidth="1.6" strokeLinecap="round"/>
              <line x1="-11" y1="-4" x2="-4" y2="-11" stroke="#FFE055" strokeWidth="1.3" strokeLinecap="round"/>
              <circle r="3" fill="#ffffff"/>
            </symbol>
          </defs>
          <rect width="1440" height="560" fill="url(#sky)" />
          <line x1="0" y1="332" x2="1440" y2="332" stroke="#0a4128" strokeWidth="2" />
          <g stroke="url(#wireDim)" strokeWidth="2.5" fill="none">
            <use href="#pw4" /><use href="#pw1" /><use href="#pw2" /><use href="#pw3" />
            <use href="#pwf1" /><use href="#pwf2" /><use href="#pwf3" />
          </g>
          {/* seamless cyan current — all wires */}
          <g fill="none" filter="url(#glow)">
            <use href="#pw1" className="wire-flow" stroke="#00C2FF" strokeWidth="3" />
            <use href="#pw2" className="wire-flow" style={{animationDelay:'-1.5s'}} stroke="#00C2FF" strokeWidth="3" />
            <use href="#pw3" className="wire-flow" style={{animationDelay:'-3s'}} stroke="#00C2FF" strokeWidth="3" />
            <use href="#pw4" className="wire-flow" style={{animationDelay:'-.75s'}} stroke="#00C2FF" strokeWidth="2.8" />
            <use href="#pwf1" className="wire-flow" style={{animationDelay:'-2s'}} stroke="#00C2FF" strokeWidth="2.8" />
            <use href="#pwf2" className="wire-flow" style={{animationDelay:'-1s'}} stroke="#00C2FF" strokeWidth="2.8" />
            <use href="#pwf3" className="wire-flow" style={{animationDelay:'-2.5s'}} stroke="#00C2FF" strokeWidth="2.8" />
          </g>
          {/* yellow spark — only on pw1 and pw2 */}
          <g fill="none" filter="url(#arcGlow)">
            <use href="#pw1" className="wire-elec" style={{animationDelay:'-0.4s'}} stroke="#FFD700" strokeWidth="1.2" />
            <use href="#pw2" className="wire-elec" style={{animationDelay:'-0.9s'}} stroke="#FFD700" strokeWidth="1.0" />
          </g>
          {/* one glowing ball per wire */}
          <g fill="url(#sparkGrad)" filter="url(#glow)">
            <circle r="6"><animateMotion dur="4.6s" repeatCount="indefinite" rotate="auto"><mpath href="#pw1" /></animateMotion></circle>
            <circle r="6"><animateMotion dur="5.2s" begin="-2s" repeatCount="indefinite"><mpath href="#pw2" /></animateMotion></circle>
            <circle r="6"><animateMotion dur="5.8s" begin="-1s" repeatCount="indefinite"><mpath href="#pw3" /></animateMotion></circle>
            <circle r="5"><animateMotion dur="4s" begin="-1.5s" repeatCount="indefinite"><mpath href="#pw4" /></animateMotion></circle>
            <circle r="5"><animateMotion dur="3.6s" repeatCount="indefinite"><mpath href="#pwf1" /></animateMotion></circle>
            <circle r="5"><animateMotion dur="4.2s" begin="-2.1s" repeatCount="indefinite"><mpath href="#pwf2" /></animateMotion></circle>
            <circle r="5"><animateMotion dur="3.8s" begin="-0.8s" repeatCount="indefinite"><mpath href="#pwf3" /></animateMotion></circle>
          </g>
          {/* yellow spark ball — only on pw1 */}
          <g fill="url(#yellowSpark)" filter="url(#arcGlow)">
            <circle r="4"><animateMotion dur="4.6s" begin="-2.3s" repeatCount="indefinite" rotate="auto"><mpath href="#pw1" /></animateMotion></circle>
          </g>
          {/* starburst sparks at the three pole junctions */}
          <g filter="url(#arcGlow)">
            <g className="junction-zap" transform="translate(174,108)">
              <use href="#zap" />
            </g>
            <g className="junction-zap" style={{animationDelay:'-2.8s'}} transform="translate(724,108)">
              <use href="#zap" />
            </g>
            <g className="junction-zap" style={{animationDelay:'-5.1s'}} transform="translate(1274,108)">
              <use href="#zap" />
            </g>
          </g>
          {/* zigzag arc between pw1 and pw2 where they run close — fires at different times */}
          <path className="arc-zap"
            d="M720 133 L716 142 L723 151 L717 160 L720 169"
            fill="none" stroke="#FFD700" strokeWidth="2.2" strokeLinecap="round"
            filter="url(#arcGlow)" style={{animationDelay:'-4.0s'}} />
          <path className="arc-zap"
            d="M450 180 L446 190 L453 199 L447 209 L450 217"
            fill="none" stroke="#FFE055" strokeWidth="2" strokeLinecap="round"
            filter="url(#arcGlow)" style={{animationDelay:'-1.5s'}} />
          <g stroke="#0e6b41" strokeWidth="3" fill="none" strokeLinecap="round">
            <g><path d="M160 332 L172 80 M188 332 L176 80 M150 200 L198 200 M120 128 L228 128 M150 96 L198 96 M155 248 L150 200 M193 248 L198 200" /></g>
            <g><path d="M710 332 L722 80 M738 332 L726 80 M700 200 L748 200 M670 128 L778 128 M700 96 L748 96 M705 248 L700 200 M743 248 L748 200" /></g>
            <g><path d="M1260 332 L1272 80 M1288 332 L1276 80 M1250 200 L1298 200 M1220 128 L1328 128 M1250 96 L1298 96 M1255 248 L1250 200 M1293 248 L1298 200" /></g>
          </g>
          <g transform="translate(90,300)">
            <rect x="-30" y="0" width="60" height="32" rx="4" fill="#0a3d27" stroke="#0e6b41" strokeWidth="2" />
            <circle className="core-throb" cx="0" cy="16" r="9" fill="none" stroke="#00C2FF" strokeWidth="2.5" filter="url(#glow)" />
            <circle className="ring-spin" cx="0" cy="16" r="14" fill="none" stroke="#00C2FF" strokeWidth="1" strokeDasharray="3 6" opacity=".7" />
            <path d="M-2 11 -6 18 0 18 -3 24" fill="none" stroke="#00C2FF" strokeWidth="1.6" filter="url(#glow)" />
          </g>
          <g fill="#00C2FF" filter="url(#glow)">
            <circle className="node" cx="174" cy="80" r="4.5" />
            <circle className="node" style={{animationDelay:'-.8s'}} cx="724" cy="80" r="4.5" />
            <circle className="node" style={{animationDelay:'-1.6s'}} cx="1274" cy="80" r="4.5" />
            <circle className="node" style={{animationDelay:'-.4s'}} cx="120" cy="128" r="3.5" />
            <circle className="node" style={{animationDelay:'-1.2s'}} cx="778" cy="128" r="3.5" />
            <circle className="node" style={{animationDelay:'-.6s'}} cx="228" cy="128" r="3.5" />
            <circle className="node" style={{animationDelay:'-1.9s'}} cx="670" cy="128" r="3.5" />
            <circle className="node" style={{animationDelay:'-1.1s'}} cx="1328" cy="128" r="3.5" />
            <circle className="node" style={{animationDelay:'-2.2s'}} cx="1220" cy="128" r="3.5" />
            <circle className="node" style={{animationDelay:'-.9s'}} cx="174" cy="96" r="3" />
            <circle className="node" style={{animationDelay:'-1.5s'}} cx="724" cy="96" r="3" />
          </g>
          <g fill="#dffaff" filter="url(#softGlow)">
            <circle className="spark-flash" cx="198" cy="200" r="3.5" />
            <circle className="spark-flash" style={{animationDelay:'-1.3s'}} cx="748" cy="200" r="3.5" />
            <circle className="spark-flash" style={{animationDelay:'-.7s'}} cx="1298" cy="200" r="3.5" />
            <circle className="spark-flash" style={{animationDelay:'-1.9s'}} cx="90" cy="316" r="4" />
          </g>
          <g stroke="#1b8a57" strokeWidth="1.5">
            <g fill="#0a3a26" stroke="none" opacity=".7">
              <rect x="900" y="214" width="40" height="118" /><rect x="1196" y="196" width="46" height="136" /><rect x="1300" y="232" width="38" height="100" />
            </g>
            <g fill="#0c462e"><rect x="828" y="236" width="86" height="96" /></g>
            <g fill="#08351f" stroke="none"><rect x="828" y="236" width="86" height="9" /></g>
            <g fill="#0e5a35" stroke="none">
              <rect className="win" x="838" y="252" width="13" height="11" rx="1" /><rect x="858" y="252" width="13" height="11" rx="1" /><rect className="win" style={{animationDelay:'.5s'}} x="878" y="252" width="13" height="11" rx="1" /><rect x="898" y="252" width="9" height="11" rx="1" />
              <rect x="838" y="270" width="13" height="11" rx="1" /><rect className="win" style={{animationDelay:'1.1s'}} x="858" y="270" width="13" height="11" rx="1" /><rect x="878" y="270" width="13" height="11" rx="1" /><rect className="win" style={{animationDelay:'1.7s'}} x="898" y="270" width="9" height="11" rx="1" />
              <rect className="win" style={{animationDelay:'.8s'}} x="838" y="288" width="13" height="11" rx="1" /><rect x="858" y="288" width="13" height="11" rx="1" /><rect x="878" y="288" width="13" height="11" rx="1" /><rect x="898" y="288" width="9" height="11" rx="1" />
              <rect x="838" y="306" width="13" height="11" rx="1" /><rect x="858" y="306" width="13" height="11" rx="1" /><rect className="win" style={{animationDelay:'2.1s'}} x="878" y="306" width="13" height="11" rx="1" /><rect x="898" y="306" width="9" height="11" rx="1" />
            </g>
            <g fill="#0c462e"><polygon points="930,236 968,204 1006,236" stroke="#1b8a57" /><rect x="938" y="236" width="60" height="96" /></g>
            <g fill="#0e5a35" stroke="none">
              <rect className="win" style={{animationDelay:'.3s'}} x="948" y="250" width="16" height="15" rx="2" /><rect className="win" style={{animationDelay:'1.4s'}} x="972" y="250" width="16" height="15" rx="2" />
              <rect x="948" y="276" width="16" height="15" rx="2" /><rect className="win" style={{animationDelay:'2.2s'}} x="972" y="276" width="16" height="15" rx="2" />
              <rect x="958" y="302" width="20" height="30" rx="2" fill="#08351f" />
            </g>
            <g fill="#0d4f30"><rect x="1024" y="158" width="64" height="174" /></g>
            <g stroke="#1b8a57"><line x1="1056" y1="158" x2="1056" y2="138" /></g>
            <circle className="node" cx="1056" cy="136" r="3.5" fill="#00C2FF" filter="url(#glow)" stroke="none" />
            <g fill="#0e5a35" stroke="none">
              <rect className="win" style={{animationDelay:'.2s'}} x="1033" y="172" width="13" height="12" rx="1" /><rect x="1051" y="172" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'1.2s'}} x="1069" y="172" width="11" height="12" rx="1" />
              <rect x="1033" y="192" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'.7s'}} x="1051" y="192" width="13" height="12" rx="1" /><rect x="1069" y="192" width="11" height="12" rx="1" />
              <rect className="win" style={{animationDelay:'1.9s'}} x="1033" y="212" width="13" height="12" rx="1" /><rect x="1051" y="212" width="13" height="12" rx="1" /><rect x="1069" y="212" width="11" height="12" rx="1" />
              <rect x="1033" y="232" width="13" height="12" rx="1" /><rect x="1051" y="232" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'2.6s'}} x="1069" y="232" width="11" height="12" rx="1" />
              <rect className="win" style={{animationDelay:'1.5s'}} x="1033" y="252" width="13" height="12" rx="1" /><rect x="1051" y="252" width="13" height="12" rx="1" /><rect x="1069" y="252" width="11" height="12" rx="1" />
              <rect x="1033" y="272" width="13" height="12" rx="1" /><rect x="1051" y="272" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'3s'}} x="1069" y="272" width="11" height="12" rx="1" />
              <rect x="1033" y="292" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'2.3s'}} x="1051" y="292" width="13" height="12" rx="1" /><rect x="1069" y="292" width="11" height="12" rx="1" />
              <rect x="1033" y="312" width="13" height="12" rx="1" /><rect x="1051" y="312" width="13" height="12" rx="1" /><rect x="1069" y="312" width="11" height="12" rx="1" />
            </g>
            <g fill="#0c462e"><rect x="1104" y="218" width="74" height="114" /></g>
            <g fill="#08351f" stroke="none"><rect x="1104" y="218" width="74" height="8" /></g>
            <g fill="#0e5a35" stroke="none">
              <rect x="1114" y="232" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'.6s'}} x="1133" y="232" width="13" height="12" rx="1" /><rect x="1152" y="232" width="13" height="12" rx="1" />
              <rect className="win" style={{animationDelay:'1.3s'}} x="1114" y="252" width="13" height="12" rx="1" /><rect x="1133" y="252" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'2.4s'}} x="1152" y="252" width="13" height="12" rx="1" />
              <rect x="1114" y="272" width="13" height="12" rx="1" /><rect x="1133" y="272" width="13" height="12" rx="1" /><rect x="1152" y="272" width="13" height="12" rx="1" />
              <rect className="win" style={{animationDelay:'.9s'}} x="1114" y="292" width="13" height="12" rx="1" /><rect x="1133" y="292" width="13" height="12" rx="1" /><rect x="1152" y="292" width="13" height="12" rx="1" />
              <rect x="1114" y="312" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'2.8s'}} x="1133" y="312" width="13" height="12" rx="1" /><rect x="1152" y="312" width="13" height="12" rx="1" />
            </g>
            <g fill="#0c462e"><polygon points="1198,250 1230,222 1262,250" stroke="#1b8a57" /><rect x="1206" y="250" width="50" height="82" /></g>
            <g fill="#0e5a35" stroke="none">
              <rect className="win" style={{animationDelay:'1.6s'}} x="1214" y="262" width="15" height="14" rx="2" /><rect x="1234" y="262" width="15" height="14" rx="2" />
              <rect x="1224" y="302" width="18" height="30" rx="2" fill="#08351f" />
            </g>
            <g fill="#0d4f30"><rect x="1278" y="186" width="58" height="146" /></g>
            <g stroke="#1b8a57"><line x1="1307" y1="186" x2="1307" y2="170" /></g>
            <circle className="node" style={{animationDelay:'-1.4s'}} cx="1307" cy="168" r="3.5" fill="#00C2FF" filter="url(#glow)" stroke="none" />
            <g fill="#0e5a35" stroke="none">
              <rect className="win" style={{animationDelay:'.4s'}} x="1287" y="200" width="13" height="12" rx="1" /><rect x="1306" y="200" width="13" height="12" rx="1" /><rect x="1325" y="200" width="6" height="12" rx="1" />
              <rect x="1287" y="220" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'1.8s'}} x="1306" y="220" width="13" height="12" rx="1" /><rect x="1325" y="220" width="6" height="12" rx="1" />
              <rect className="win" style={{animationDelay:'1s'}} x="1287" y="240" width="13" height="12" rx="1" /><rect x="1306" y="240" width="13" height="12" rx="1" /><rect x="1325" y="240" width="6" height="12" rx="1" />
              <rect x="1287" y="260" width="13" height="12" rx="1" /><rect x="1306" y="260" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'2.5s'}} x="1325" y="260" width="6" height="12" rx="1" />
              <rect x="1287" y="280" width="13" height="12" rx="1" /><rect className="win" style={{animationDelay:'.7s'}} x="1306" y="280" width="13" height="12" rx="1" /><rect x="1325" y="280" width="6" height="12" rx="1" />
              <rect x="1287" y="300" width="13" height="12" rx="1" /><rect x="1306" y="300" width="13" height="12" rx="1" /><rect x="1325" y="300" width="6" height="12" rx="1" />
            </g>
            <g fill="#0c462e"><polygon points="1352,270 1380,244 1408,270" stroke="#1b8a57" /><rect x="1360" y="270" width="44" height="62" /></g>
            <g fill="#0e5a35" stroke="none">
              <rect className="win" style={{animationDelay:'2.9s'}} x="1368" y="282" width="13" height="12" rx="1" /><rect x="1386" y="282" width="13" height="12" rx="1" />
              <rect x="1376" y="308" width="16" height="24" rx="2" fill="#08351f" />
            </g>
          </g>
        </svg>
        <div style={css('position:absolute;inset:0;background:linear-gradient(180deg, rgba(7,46,29,0.55) 0%, rgba(7,46,29,0.2) 40%, rgba(7,46,29,0.85) 100%)')} />
        <div style={css('position:relative;z-index:3;max-width:1200px;margin:0 auto;width:100%')}>
          <div style={css('display:inline-flex;align-items:center;gap:10px;background:rgba(0,194,255,0.12);border:1px solid rgba(0,194,255,0.4);color:#9fe9ff;font-size:13px;font-weight:600;letter-spacing:.5px;padding:8px 16px;border-radius:100px;margin-bottom:24px')}>
            <span style={css('width:8px;height:8px;border-radius:50%;background:#00C2FF;box-shadow:0 0 10px #00C2FF')} />
            OFFICIAL ELECTRICITY &amp; MAINTENANCE BILLING PORTAL
          </div>
          <h1 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(40px,6.5vw,82px);line-height:1.02;color:#fff;margin:0 0 18px;max-width:880px;letter-spacing:-1.5px")}>
            Powering Pakistan's<br />Premier <span style={css('color:#C9A227')}>Communities</span>
          </h1>
          <p style={css('font-size:clamp(17px,2vw,21px);color:rgba(255,255,255,0.82);max-width:620px;line-height:1.55;margin:0 0 14px')}>
            View, download and pay your electricity &amp; maintenance bills online — from anywhere in the world, anytime.
          </p>
          <p className="urdu" style={css('color:#C9A227;font-size:20px;margin:0 0 36px')}>اپنے بل دیکھیں، ڈاؤن لوڈ کریں اور آن لائن ادا کریں</p>
          <div style={css('display:flex;flex-wrap:wrap;gap:14px')}>
            <a href="#lookup" onClick={setElectric} style={css('display:inline-flex;align-items:center;gap:10px;text-decoration:none;background:#00C2FF;color:#06251a;font-weight:700;font-size:16px;padding:16px 28px;border-radius:12px;box-shadow:0 10px 30px rgba(0,194,255,.4);transition:transform .2s, box-shadow .2s')}
              onMouseEnter={hi({ transform:'translateY(-3px)', boxShadow:'0 16px 38px rgba(0,194,255,.55)' })}
              onMouseLeave={ho()}>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="#06251a"><path d="M13 2 4 14h6l-1 8 9-12h-6l1-8z" /></svg>View / Pay Electricity Bill
            </a>
            <a href="#lookup" onClick={setMaint} style={css('display:inline-flex;align-items:center;gap:10px;text-decoration:none;background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.35);color:#fff;font-weight:700;font-size:16px;padding:16px 28px;border-radius:12px;transition:background .2s, transform .2s')}
              onMouseEnter={hi({ background:'rgba(255,255,255,0.2)', transform:'translateY(-3px)' })}
              onMouseLeave={ho()}>
              View / Pay Maintenance Bill
            </a>
          </div>
        </div>
      </header>

      {/* ===================== BILL LOOKUP ===================== */}
      <section id="lookup" style={css('position:relative;z-index:8;margin-top:-130px;padding:0 clamp(20px,5vw,56px) 80px')}>
        <div style={css('max-width:1080px;margin:0 auto;background:#fff;border-radius:24px;box-shadow:0 30px 70px rgba(7,46,29,0.22);border:1px solid #eef1ef;overflow:hidden')}>
          <div style={css('display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:16px;padding:28px clamp(24px,4vw,40px);background:linear-gradient(135deg,#0E5A35,#0a4429)')}>
            <div>
              <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:26px;color:#fff;margin:0 0 4px")}>Download or Pay your bill</h2>
              <p style={css('color:rgba(255,255,255,0.75);font-size:14.5px;margin:0')}>Enter your account number to view, download &amp; pay instantly.</p>
            </div>
            <div style={css('display:flex;background:rgba(255,255,255,0.12);border-radius:12px;padding:5px')}>
              <button id="tabElectricBtn" onClick={setElectric} style={css('border:none;cursor:pointer;font-weight:700;font-size:14px;padding:9px 16px;border-radius:9px;transition:background .2s, color .2s;background:#fff;color:#0E5A35')}>⬇ Download Bill</button>
              <button id="tabMaintBtn" onClick={setMaint} style={css('border:none;cursor:pointer;font-weight:700;font-size:14px;padding:9px 16px;border-radius:9px;transition:background .2s, color .2s;background:transparent;color:rgba(255,255,255,0.8)')}>By KuickPay</button>
            </div>
          </div>
          <div style={css('padding:clamp(24px,4vw,40px)')}>
            <div style={css('display:flex;flex-wrap:wrap;gap:14px;align-items:flex-end')}>
              <label style={css('flex:1;min-width:240px')}>
                <span id="lookupLabel" style={css('display:block;font-size:13px;font-weight:600;color:#5b6b62;margin-bottom:8px')}>Enter Kuickpay Reference Number to Fetch Download Bill</span>
                <input id="refInput" defaultValue="" onInput={onRef} onKeyDown={onKey}
                  placeholder="e.g. 01000 or 01010 or 01060 or 01070 or 00550 or 01550"
                  inputMode="numeric"
                  style={css('width:100%;padding:15px 16px;border:1.5px solid #d7ddd9;border-radius:12px;font-size:16px;outline:none;transition:border .2s, box-shadow .2s')}
                  onFocus={hi({ borderColor:'#0E5A35', boxShadow:'0 0 0 4px rgba(14,90,53,0.12)' })}
                  onBlur={ho()} />
              </label>
              <button onClick={fetchBill}
                style={css('display:inline-flex;align-items:center;justify-content:center;gap:9px;background:#0E5A35;color:#fff;font-weight:700;font-size:16px;padding:16px 30px;border:none;border-radius:12px;cursor:pointer;min-width:160px;transition:background .2s, transform .2s')}
                onMouseEnter={hi({ background:'#0a4429', transform:'translateY(-2px)' })}
                onMouseLeave={ho()}>
                <div id="loadingSpinner" style={css('display:none')}>
                  <span style={css('width:18px;height:18px;border:2.5px solid rgba(255,255,255,0.35);border-top-color:#fff;border-radius:50%;display:inline-block;animation:spin .7s linear infinite')} />
                </div>
                <div id="fetchLabel">Fetch Bill</div>
              </button>
            </div>
            <div id="errorBox" style={css('display:none')}>
              <div style={css('margin-top:16px;display:flex;align-items:center;gap:10px;background:#fdf3f3;border:1px solid #f3d2d2;color:#b3382f;padding:13px 16px;border-radius:12px;font-size:14.5px;font-weight:500')}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#b3382f" strokeWidth="2"><circle cx="12" cy="12" r="9" /><path d="M12 8v5M12 16.5v.5" /></svg>
                <span id="errorText" />
              </div>
            </div>
            <div id="billCard" style={css('display:none')}>
              <div data-reveal="" style={css('margin-top:24px;border:1px solid #e7ece9;border-radius:18px;overflow:hidden')}>
                <div style={css('display:flex;flex-wrap:wrap;justify-content:space-between;gap:14px;padding:22px 26px;background:#F4F6F5;border-bottom:1px solid #e7ece9')}>
                  <div>
                    <div style={css('font-size:12px;letter-spacing:1px;font-weight:700;color:#8a988f')}>BILL FOUND</div>
                    <div style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:22px;color:#1C2B24;margin-top:4px")}><span id="billAreaLabel" /></div>
                    <div style={css('font-size:13px;color:#8a988f;margin-top:6px')}>Ref #: <span id="billRef" /></div>
                  </div>
                  <div style={css('text-align:right')}>
                    <span style={css('display:inline-block;padding:6px 14px;border-radius:100px;font-size:13px;font-weight:700;color:#fff;background:#0E5A35')}>Verified</span>
                  </div>
                </div>
                <div style={css('display:flex;flex-wrap:wrap;gap:28px;padding:16px 26px;background:#fff;border-top:1px solid #f0f3f1')}>
                  <div>
                    <div style={css('font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase')}>Amount Due</div>
                    <div style={css('font-size:16px;font-weight:700;color:#0E5A35;margin-top:3px')}><span id="billAmountDue">—</span></div>
                  </div>
                  <div>
                    <div style={css('font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase')}>Due Date</div>
                    <div style={css('font-size:16px;font-weight:700;color:#1C2B24;margin-top:3px')}><span id="billDueDate">—</span></div>
                  </div>
                  <div>
                    <div style={css('font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase')}>Meter No</div>
                    <div style={css('font-size:16px;font-weight:700;color:#1C2B24;margin-top:3px')}><span id="billMeterNo">—</span></div>
                  </div>
                  <div>
                    <div style={css('font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase')}>Amount After Date</div>
                    <div style={css('font-size:16px;font-weight:700;color:#c0392b;margin-top:3px')}><span id="billAmountAfterDate">—</span></div>
                  </div>
                  <div>
                    <div style={css('font-size:11px;color:#8a988f;font-weight:600;letter-spacing:.6px;text-transform:uppercase')}>Billing Period</div>
                    <div style={css('font-size:16px;font-weight:700;color:#1C2B24;margin-top:3px')}><span id="billBillingPeriod">—</span></div>
                  </div>
                </div>
                <div style={css('display:flex;flex-wrap:wrap;gap:12px;padding:20px 26px;background:#fff;border-top:1px solid #f0f3f1')}>
                  <button id="billCardDownloadBtn" onClick={downloadPdf}
                    style={css('display:inline-flex;align-items:center;gap:9px;background:#fff;border:1.5px solid #0E5A35;color:#0E5A35;font-weight:700;font-size:15px;padding:13px 22px;border-radius:11px;cursor:pointer;transition:background .2s')}
                    onMouseEnter={hi({ background:'#f0f6f2' })} onMouseLeave={ho()}>
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 3v12M7 11l5 5 5-5M5 21h14" /></svg>Download / View Bill (PDF)
                  </button>
                  <button id="billCardPayBtn" onClick={payViaKuickPay}
                    style={css('display:none;align-items:center;gap:9px;background:#C9A227;border:none;color:#1C2B24;font-weight:700;font-size:15px;padding:13px 22px;border-radius:11px;cursor:pointer;transition:background .2s')}
                    onMouseEnter={hi({ background:'#b87f00' })} onMouseLeave={ho()}>
                    Pay via KuickPay
                  </button>
                </div>
              </div>
            </div>
            <p style={css('margin:18px 0 0;font-size:12.5px;color:#a3afa8')}>Use the KuickPay reference printed on your bill. <span style={css('color:#8a988f')}>Your request is processed securely.</span></p>
          </div>
        </div>
      </section>

      {/* ===================== SERVICES ===================== */}
      <section id="services" style={css('padding:40px clamp(20px,5vw,56px) 90px;background:#fff')}>
        <div style={css('max-width:1200px;margin:0 auto')}>
          <div data-reveal="" style={css('text-align:center;max-width:640px;margin:0 auto 52px')}>
            <div style={css('color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px')}>OUR SERVICES</div>
            <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px")}>Everything you need, in one place</h2>
          </div>
          <div style={css('display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:22px')}>
            {[
              { icon: <svg width="30" height="30" viewBox="0 0 24 24" fill="#00C2FF"><path d="M13 2 4 14h6l-1 8 9-12h-6l1-8z" /></svg>, bg:'rgba(0,194,255,0.12)', title:'Electricity Billing', urdu:'بجلی کے بل', desc:'View, download and pay your monthly power bills with detailed unit-wise consumption and history.' },
              { icon: <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 21V8l9-5 9 5v13M9 21v-6h6v6" /></svg>, bg:'rgba(14,90,53,0.1)', title:'Maintenance Billing', urdu:'مینٹیننس کے واجبات', desc:'Settle your society maintenance dues, view charges breakdown and keep your account clear.' },
              { icon: <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#C9A227" strokeWidth="2"><circle cx="12" cy="12" r="9" /><path d="M3 12h18M12 3c2.5 3 2.5 15 0 18M12 3c-2.5 3-2.5 15 0 18" /></svg>, bg:'rgba(201,162,39,0.14)', title:'Online Payment — Worldwide', urdu:'دنیا بھر سے ادائیگی', desc:'Pay from anywhere, anytime — overseas residents included — via cards, wallets and bank transfer.' },
            ].map(({ icon, bg, title, urdu, desc }) => (
              <div key={title} data-reveal=""
                style={css('background:#fff;border:1px solid #e9edeb;border-radius:20px;padding:34px 30px;transition:transform .3s, box-shadow .3s, border-color .3s')}
                onMouseEnter={hi({ transform:'translateY(-8px)', boxShadow:'0 20px 44px rgba(7,46,29,0.12)', borderColor:'#cfe8db' })}
                onMouseLeave={ho()}>
                <div style={{ width:'60px', height:'60px', borderRadius:'16px', background:bg, display:'flex', alignItems:'center', justifyContent:'center', marginBottom:'22px' }}>{icon}</div>
                <h3 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:21px;color:#1C2B24;margin:0 0 6px")}>{title}</h3>
                <p className="urdu" style={css('color:#0E5A35;font-size:15px;margin:0 0 10px')}>{urdu}</p>
                <p style={css('color:#5b6b62;font-size:15px;line-height:1.6;margin:0')}>{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===================== PROJECTS ===================== */}
      <section id="projects" style={css('padding:90px clamp(20px,5vw,56px);background:#F4F6F5')}>
        <div style={css('max-width:1200px;margin:0 auto')}>
          <div data-reveal="" style={css('text-align:center;max-width:640px;margin:0 auto 52px')}>
            <div style={css('color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px')}>BAHRIA TOWN PROJECTS</div>
            <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px")}>Serving communities nationwide</h2>
          </div>
          <div style={css('display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:22px')}>
            {[
              { title:'Bahria Town Rawalpindi / Islamabad', sub:'Phases 1–8 · the flagship master-planned community', grad:'linear-gradient(135deg,#0E5A35,#0a4429)' },
              { title:'Bahria Town Lahore', sub:'Grand living in the heart of Punjab', grad:'linear-gradient(135deg,#13724a,#0c4d31)' },
              { title:'Bahria Town Karachi', sub:'A world-class city by the sea', grad:'linear-gradient(135deg,#0a4429,#072e1d)' },
              { title:'Bahria Enclave, Islamabad', sub:'Hillside elegance in the capital', grad:'linear-gradient(135deg,#15784f,#0E5A35)' },
              { title:'Bahria Golf City', sub:'Resort-style living on the greens', grad:'linear-gradient(135deg,#0E5A35,#13724a)' },
              { title:'More Projects', sub:'New communities coming online soon', grad:'linear-gradient(135deg,#5b6b62,#3a4640)' },
            ].map(({ title, sub, grad }) => (
              <div key={title} data-reveal=""
                style={css('background:#fff;border-radius:20px;overflow:hidden;border:1px solid #e7ece9;transition:transform .3s, box-shadow .3s;cursor:pointer')}
                onMouseEnter={hi({ transform:'translateY(-8px)', boxShadow:'0 24px 50px rgba(7,46,29,0.15)' })}
                onMouseLeave={ho()}>
                <div style={{ height:'180px', position:'relative', backgroundImage:`${grad}, repeating-linear-gradient(45deg, rgba(255,255,255,0.06) 0 12px, transparent 12px 24px)`, backgroundBlendMode:'overlay', display:'flex', alignItems:'flex-end', padding:'16px' }}>
                  <span style={css('font-family:monospace;font-size:11px;color:rgba(255,255,255,0.85);background:rgba(0,0,0,0.25);padding:4px 8px;border-radius:6px')}>project photo</span>
                </div>
                <div style={css('padding:22px')}>
                  <h3 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:19px;color:#1C2B24;margin:0 0 6px")}>{title}</h3>
                  <p style={css('color:#5b6b62;font-size:14px;margin:0 0 16px;line-height:1.5')}>{sub}</p>
                  <a href="#lookup" style={css('display:inline-flex;align-items:center;gap:7px;color:#0E5A35;font-weight:700;font-size:14px;text-decoration:none')}>
                    {title === 'More Projects' ? 'Learn More' : 'View Bills'} <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" strokeWidth="2.2" strokeLinecap="round"><path d="M5 12h14M13 6l6 6-6 6" /></svg>
                  </a>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===================== HOW IT WORKS ===================== */}
      <section id="how" style={css('padding:90px clamp(20px,5vw,56px);background:#fff')}>
        <div style={css('max-width:1100px;margin:0 auto')}>
          <div data-reveal="" style={css('text-align:center;max-width:640px;margin:0 auto 56px')}>
            <div style={css('color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px')}>HOW IT WORKS</div>
            <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px")}>Pay in four simple steps</h2>
          </div>
          <div style={css('display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px')}>
            {[
              { n:'1', title:'Enter your number', desc:'Type your consumer / account / reference number into the lookup box.' },
              { n:'2', title:'View your bill', desc:'Instantly see your charges, units, due date and balance.' },
              { n:'3', title:'Download PDF', desc:'Save or print an official copy of your bill for your records.' },
              { n:'4', title:'Pay securely', desc:'Settle online via wallet, card or bank — get an instant receipt.' },
            ].map(({ n, title, desc }) => (
              <div key={n} data-reveal="" style={css('position:relative;padding:30px 24px;border:1px solid #e9edeb;border-radius:18px;background:#fcfdfc')}>
                <div style={css("width:48px;height:48px;border-radius:14px;background:#0E5A35;color:#fff;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:20px;display:flex;align-items:center;justify-content:center;margin-bottom:18px")}>{n}</div>
                <h3 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;font-size:17px;color:#1C2B24;margin:0 0 7px")}>{title}</h3>
                <p style={css('color:#5b6b62;font-size:14px;line-height:1.55;margin:0')}>{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===================== STATS ===================== */}
      <section style={css('padding:80px clamp(20px,5vw,56px);background:radial-gradient(120% 120% at 20% 0%, #115c39 0%, #0a4429 60%, #072e1d 100%)')}>
        <div style={css('max-width:1100px;margin:0 auto')}>
          <div data-reveal="" style={css('text-align:center;margin-bottom:48px')}>
            <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(26px,3.6vw,38px);color:#fff;margin:0;letter-spacing:-.5px")}>Why pay online?</h2>
            <p style={css('color:rgba(255,255,255,0.7);margin:10px 0 0;font-size:16px')}>Faster, safer and always available.</p>
          </div>
          <div style={css('display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:18px')}>
            {[{count:'24',suffix:'/7',label:'Access, every day'},{count:'100',suffix:'%',label:'Secure payments'},{count:'5',suffix:'+',label:'Bahria projects'},{count:'1',suffix:'M+',label:'Residents served'}].map(({ count, suffix, label }) => (
              <div key={label} data-reveal="" style={css('text-align:center;padding:28px 18px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:18px')}>
                <div data-count={count} data-suffix={suffix} style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(34px,5vw,52px);color:#00C2FF;line-height:1")}>0{suffix}</div>
                <div style={css('color:rgba(255,255,255,0.82);font-size:14.5px;margin-top:10px;font-weight:500')}>{label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===================== PAYMENT METHODS ===================== */}
      <section style={css('padding:80px clamp(20px,5vw,56px);background:#fff')}>
        <div style={css('max-width:1000px;margin:0 auto;text-align:center')}>
          <div data-reveal="">
            <div style={css('color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px')}>PAYMENT METHODS</div>
            <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(26px,3.6vw,38px);color:#1C2B24;margin:10px 0 8px;letter-spacing:-.5px")}>Pay your way</h2>
            <p style={css('color:#5b6b62;margin:0 auto 40px;max-width:560px;font-size:16px')}>Local wallets and banks for residents, global gateways for overseas Pakistanis.</p>
          </div>
          <div data-reveal="" style={css('display:flex;flex-wrap:wrap;justify-content:center;gap:14px')}>
            {[{label:'1LINK',color:'#0E5A35'},{label:'JazzCash',color:'#C9A227'},{label:'Easypaisa',color:'#00C2FF'},{label:'Debit / Credit Card',color:'#0a4429'},{label:'Kuickpay',color:'#13724a'}].map(({ label, color }) => (
              <div key={label}
                style={css('display:flex;align-items:center;gap:10px;padding:15px 24px;border:1px solid #e7ece9;border-radius:14px;background:#fcfdfc;font-weight:700;color:#1C2B24;font-size:15px;transition:border-color .2s, transform .2s')}
                onMouseEnter={hi({ borderColor:'#0E5A35', transform:'translateY(-3px)' })}
                onMouseLeave={ho()}>
                <span style={{ width:'10px', height:'10px', borderRadius:'3px', background:color }} />{label}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===================== CONTACT ===================== */}
      <section id="contact" style={css('padding:90px clamp(20px,5vw,56px);background:#F4F6F5')}>
        <div style={css('max-width:1140px;margin:0 auto')}>
          <div data-reveal="" style={css('text-align:center;max-width:640px;margin:0 auto 52px')}>
            <div style={css('color:#C9A227;font-weight:700;font-size:13px;letter-spacing:2px')}>CONTACT &amp; SUPPORT</div>
            <h2 style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:clamp(28px,4vw,42px);color:#1C2B24;margin:10px 0 0;letter-spacing:-1px")}>Billing offices &amp; helplines</h2>
            <p style={css('color:#5b6b62;font-size:16px;margin:12px 0 0')}>Reach the billing department for your project directly.</p>
          </div>
          <div style={css('display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:22px')}>
            {[
              { project:'Bahria Enclave', address:'Billing Office, 1st Floor, Head Office, Sector I, Bahria Enclave', phone:'+92 (51) 2721035', tel:'tel:+92512721035', email:'be.billingdepartment@gmail.com' },
              { project:'Phase 1 – 6', address:'Garden Avenue, near Civic Center, Phase 4', phone:'+92 (51) 5733277', tel:'tel:+92515733277', email:'cbdbt1to6@gmail.com' },
              { project:'Phase 7 – 8', address:'Usman Block, near Grid Station, Phase 8', phone:'+92 (51) 5410387 & 5410080', tel:'tel:+92515410387', email:'Cbdbt7to9@gmail.com' },
            ].map(({ project, address, phone, tel, email }) => (
              <div key={project} data-reveal=""
                style={css('background:#fff;border:1px solid #e7ece9;border-radius:20px;padding:30px 28px;box-shadow:0 14px 40px rgba(7,46,29,0.06);transition:transform .3s, box-shadow .3s')}
                onMouseEnter={hi({ transform:'translateY(-6px)', boxShadow:'0 22px 50px rgba(7,46,29,0.12)' })}
                onMouseLeave={ho()}>
                <div style={css("display:inline-flex;align-items:center;gap:9px;background:rgba(14,90,53,0.08);color:#0E5A35;font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;font-size:16px;padding:9px 16px;border-radius:100px;margin-bottom:20px")}>
                  <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0E5A35" strokeWidth="2"><path d="M3 21V8l9-5 9 5v13M9 21v-6h6v6" /></svg>{project}
                </div>
                <div style={css('display:flex;flex-direction:column;gap:14px')}>
                  <div style={css('display:flex;gap:12px;align-items:flex-start')}>
                    <svg width="19" height="19" style={css('flex:0 0 auto;margin-top:1px')} viewBox="0 0 24 24" fill="none" stroke="#C9A227" strokeWidth="2"><path d="M12 21s7-5.5 7-11a7 7 0 0 0-14 0c0 5.5 7 11 7 11z" /><circle cx="12" cy="10" r="2.5" /></svg>
                    <span style={css('color:#3a4640;font-size:14.5px;line-height:1.5')}>{address}</span>
                  </div>
                  <a href={tel} style={css('display:flex;gap:12px;align-items:center;text-decoration:none')}>
                    <svg width="19" height="19" style={css('flex:0 0 auto')} viewBox="0 0 24 24" fill="none" stroke="#0E5A35" strokeWidth="2"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3-8.6A2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 2 .7 2.9a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.2-1.2a2 2 0 0 1 2.1-.5c.9.3 1.9.6 2.9.7a2 2 0 0 1 1.7 2z" /></svg>
                    <span style={css('color:#1C2B24;font-size:14.5px;font-weight:600')}>{phone}</span>
                  </a>
                  <a href={`mailto:${email}`} style={css('display:flex;gap:12px;align-items:center;text-decoration:none;word-break:break-all')}>
                    <svg width="19" height="19" style={css('flex:0 0 auto')} viewBox="0 0 24 24" fill="none" stroke="#0E5A35" strokeWidth="2"><rect x="3" y="5" width="18" height="14" rx="2" /><path d="m3 7 9 6 9-6" /></svg>
                    <span style={css('color:#0E5A35;font-size:14px;font-weight:600')}>{email}</span>
                  </a>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===================== FOOTER ===================== */}
      <footer style={css('background:#072e1d;color:rgba(255,255,255,0.75);padding:60px clamp(20px,5vw,56px) 30px')}>
        <div style={css('max-width:1200px;margin:0 auto;display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:36px')}>
          <div>
            <div style={css('display:flex;align-items:center;gap:12px;margin-bottom:16px')}>
              <div style={css('width:44px;height:44px;border-radius:11px;background:linear-gradient(135deg,#0E5A35,#0a4429);display:flex;align-items:center;justify-content:center;border:1px solid rgba(201,162,39,0.4);overflow:hidden')}>
                <img src="Images/billing-logo.png" alt="Bahria Town logo" width="32" height="32" style={css('display:block;object-fit:contain')} />
              </div>
              <div style={css('line-height:1.1')}>
                <div style={css("font-family:'Plus Jakarta Sans',sans-serif;font-weight:800;color:#fff;font-size:15px")}>BAHRIA TOWN</div>
                <div style={css('font-size:10px;letter-spacing:1.5px;color:#C9A227;font-weight:600')}>POWER &amp; MAINTENANCE</div>
              </div>
            </div>
            <p style={css('font-size:13.5px;line-height:1.6;margin:0 0 6px;max-width:260px')}>Asia's premier housing society developer — powering premium communities across Pakistan.</p>
            <p className="urdu" style={css('color:#C9A227;font-size:15px;margin:8px 0 0')}>ایشیا کا صفِ اول ہاؤسنگ ڈیولپر</p>
          </div>
          <div>
            <div style={css('color:#fff;font-weight:700;font-size:14px;margin-bottom:14px')}>Quick Links</div>
            {['#home','#services','#projects','#how','#lookup','#contact'].map((href, i) => (
              <a key={href} href={href}
                style={css('display:block;color:rgba(255,255,255,0.7);text-decoration:none;font-size:14px;padding:5px 0;transition:color .2s')}
                onMouseEnter={hi({ color:'#00C2FF' })} onMouseLeave={ho()}>
                {['Home','Services','Projects','How It Works','Pay Bill','Contact'][i]}
              </a>
            ))}
          </div>
          <div>
            <div style={css('color:#fff;font-weight:700;font-size:14px;margin-bottom:14px')}>Contact</div>
            <div style={css('font-size:14px;line-height:1.9')}>Billing Office, 1st Floor, Head Office, Sector I, Bahria Enclave<br />+92 (51) 2721035<br />be.billingdepartment@gmail.com</div>
          </div>
          <div>
            <div style={css('color:#fff;font-weight:700;font-size:14px;margin-bottom:14px')}>Follow</div>
            <div style={css('display:flex;gap:10px')}>
              <a href="#" aria-label="Facebook" style={css('width:38px;height:38px;border-radius:10px;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;transition:background .2s')} onMouseEnter={hi({ background:'rgba(0,194,255,0.25)' })} onMouseLeave={ho()}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="#fff"><path d="M14 9h3V6h-3a4 4 0 0 0-4 4v2H7v3h3v6h3v-6h3l1-3h-4v-2a1 1 0 0 1 1-1z" /></svg>
              </a>
              <a href="#" aria-label="Instagram" style={css('width:38px;height:38px;border-radius:10px;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;transition:background .2s')} onMouseEnter={hi({ background:'rgba(0,194,255,0.25)' })} onMouseLeave={ho()}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2"><rect x="3" y="3" width="18" height="18" rx="5" /><circle cx="12" cy="12" r="4" /><circle cx="17.5" cy="6.5" r="1" fill="#fff" /></svg>
              </a>
              <a href="#" aria-label="YouTube" style={css('width:38px;height:38px;border-radius:10px;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;transition:background .2s')} onMouseEnter={hi({ background:'rgba(0,194,255,0.25)' })} onMouseLeave={ho()}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="#fff"><path d="M22 12s0-3-.4-4.4a2.5 2.5 0 0 0-1.8-1.8C18.4 5.4 12 5.4 12 5.4s-6.4 0-7.8.4A2.5 2.5 0 0 0 2.4 7.6C2 9 2 12 2 12s0 3 .4 4.4a2.5 2.5 0 0 0 1.8 1.8c1.4.4 7.8.4 7.8.4s6.4 0 7.8-.4a2.5 2.5 0 0 0 1.8-1.8C22 15 22 12 22 12zM10 15V9l5 3-5 3z" /></svg>
              </a>
            </div>
          </div>
        </div>
        <div style={css('max-width:1200px;margin:40px auto 0;padding-top:24px;border-top:1px solid rgba(255,255,255,0.1);display:flex;flex-wrap:wrap;gap:8px;justify-content:space-between;font-size:13px;color:rgba(255,255,255,0.55)')}>
          <span>© 2026 Bahria Town (Pvt) Ltd — Power &amp; Maintenance Billing Division.</span>
          <span className="urdu" style={css('font-size:14px')}>جملہ حقوق محفوظ ہیں</span>
        </div>
      </footer>
    </div>
  );
}
