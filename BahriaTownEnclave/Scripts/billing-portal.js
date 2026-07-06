// Billing portal client-side logic.
function hoverIn(el, styles) {
  if (el.dataset.origStyle === undefined) el.dataset.origStyle = el.getAttribute('style') || '';
  Object.assign(el.style, styles);
}
function hoverOut(el) {
  if (el.dataset.origStyle !== undefined) el.setAttribute('style', el.dataset.origStyle);
}

// ---- nav scroll style ----
(function () {
  var nav = document.getElementById('mainNav');
  if (!nav) return;
  function onScroll() {
    var s = window.scrollY > 40;
    nav.style.background = s ? 'rgba(7,46,29,0.96)' : 'rgba(10,61,39,0)';
    nav.style.boxShadow = s ? '0 6px 24px rgba(0,0,0,0.18)' : 'none';
    nav.style.paddingTop = s ? '11px' : '16px';
    nav.style.paddingBottom = s ? '11px' : '16px';
    nav.style.backdropFilter = s ? 'blur(8px)' : 'none';
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
})();

// ---- reveal-on-scroll + counters ----
(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var heroGrid = document.getElementById('heroGrid');
  if (reduce && heroGrid && heroGrid.pauseAnimations) { try { heroGrid.pauseAnimations(); } catch (e) {} }

  var items = Array.prototype.slice.call(document.querySelectorAll('[data-reveal]'));
  var counts = new Map();
  items.forEach(function (el) {
    var p = el.parentElement;
    var i = counts.get(p) || 0; counts.set(p, i + 1);
    if (reduce) { el.style.opacity = '1'; el.style.transform = 'none'; return; }
    el.style.opacity = '0';
    el.style.transform = 'translateY(28px)';
    el.style.transition = 'opacity .7s cubic-bezier(.16,.84,.44,1), transform .7s cubic-bezier(.16,.84,.44,1)';
    el.style.transitionDelay = (Math.min(i, 6) * 70) + 'ms';
  });
  if (!reduce && 'IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (ents) {
      ents.forEach(function (e) { if (e.isIntersecting) { e.target.style.opacity = '1'; e.target.style.transform = 'none'; io.unobserve(e.target); } });
    }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });
    items.forEach(function (el) { io.observe(el); });
  }

  var counters = Array.prototype.slice.call(document.querySelectorAll('[data-count]'));
  function animateCounter(el) {
    var target = parseFloat(el.dataset.count) || 0;
    var suffix = el.dataset.suffix || '';
    var dur = 1500, start = performance.now();
    function step(now) {
      var t = Math.min(1, (now - start) / dur);
      var eased = 1 - Math.pow(1 - t, 3);
      var val = Math.round(target * eased);
      el.textContent = val.toLocaleString('en-US') + suffix;
      if (t < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }
  if ('IntersectionObserver' in window && !reduce) {
    var cio = new IntersectionObserver(function (ents) {
      ents.forEach(function (e) { if (e.isIntersecting) { animateCounter(e.target); cio.unobserve(e.target); } });
    }, { threshold: 0.5 });
    counters.forEach(function (el) { cio.observe(el); });
  } else {
    counters.forEach(function (el) { el.textContent = el.dataset.count + (el.dataset.suffix || ''); });
  }
  setTimeout(function () { items.forEach(function (el) { el.style.opacity = '1'; el.style.transform = 'none'; }); }, 4000);
})();

// ---- mobile menu ----
function toggleMobile() {
  var m = document.getElementById('mobileMenu');
  m.style.display = (m.style.display === 'none' || !m.style.display) ? 'block' : 'none';
}
function closeMobile() {
  document.getElementById('mobileMenu').style.display = 'none';
}

// ---- bill lookup (real backend) ----
var billType = 'electricity'; // 'electricity' => Download Bill, 'maintenance' => Pay via KuickPay
var currentRef = null;

var tabBase = 'border:none;cursor:pointer;font-weight:700;font-size:14px;padding:9px 16px;border-radius:9px;transition:background .2s, color .2s;';
var tabActive = 'background:#fff;color:#0E5A35;';
var tabInactive = 'background:transparent;color:rgba(255,255,255,0.8);';

function updateTabStyles() {
  var elec = document.getElementById('tabElectricBtn');
  var maint = document.getElementById('tabMaintBtn');
  elec.style.cssText = tabBase + (billType === 'electricity' ? tabActive : tabInactive);
  maint.style.cssText = tabBase + (billType === 'maintenance' ? tabActive : tabInactive);
  document.getElementById('lookupLabel').textContent = billType === 'electricity'
    ? 'Enter KuickPay Reference Number to Download Bill'
    : 'Enter KuickPay Reference Number to Pay Bill';
}
function setElectric() { billType = 'electricity'; updateTabStyles(); }
function setMaint() { billType = 'maintenance'; updateTabStyles(); }

function onRef() {
  document.getElementById('errorBox').style.display = 'none';
}
function onKey(e) {
  if (e.key === 'Enter') fetchBill();
}

function areaHintFromPrefix(prefix) {
  if (prefix === '01000') return 'Electricity — Phase 1–6';
  if (prefix === '01010') return 'Maintenance — Phase 1–6';
  if (prefix === '01060') return 'Electricity — Phase 7–8';
  if (prefix === '01070') return 'Maintenance — Phase 7–8';
  if (prefix === '00550') return 'Electricity — Bahria Enclave';
  if (prefix === '01550') return 'Maintenance — Bahria Enclave';
  return '';
}

function showError(msg) {
  document.getElementById('errorText').textContent = msg;
  document.getElementById('errorBox').style.display = 'flex';
  document.getElementById('billCard').style.display = 'none';
}

function setLoading(loading) {
  document.getElementById('loadingSpinner').style.display = loading ? 'inline-block' : 'none';
  document.getElementById('fetchLabel').style.display = loading ? 'none' : 'inline-block';
}

function fetchBill() {
  var ref = (document.getElementById('refInput').value || '').trim().replace(/\D/g, '');
  document.getElementById('errorBox').style.display = 'none';
  document.getElementById('billCard').style.display = 'none';

  if (billType === 'maintenance') {
    // KuickPay tab pays directly, mirroring payKuickPay().
    payViaKuickPayRef(ref);
    return;
  }

  if (ref === '' || ref.length < 5) {
    showError('Please enter a valid KuickPay reference number.');
    return;
  }
  var prefix = ref.substring(0, 5);
  var allowed = (prefix === '01000' || prefix === '01010' || prefix === '01060' ||
    prefix === '01070' || prefix === '00550' || prefix === '01550');
  if (!allowed) {
    showError('Reference number not recognized for this billing area.');
    return;
  }

  setLoading(true);
  fetch('BillExists.aspx?ref=' + encodeURIComponent(ref), { credentials: 'same-origin', headers: { 'Accept': 'application/json' } })
    .then(function (r) { if (!r.ok) throw new Error('bad status'); return r.json(); })
    .then(function (data) {
      setLoading(false);
      if (!data || data.reason === 'invalid') { showError('Please enter a valid KuickPay reference number.'); return; }
      if (data.reason === 'error') { showError('We could not reach the billing server. Please try again.'); return; }
      if (!data.found) { showError('No bill was found for this reference number.'); return; }
      currentRef = ref;
      document.getElementById('billRef').textContent = ref;
      document.getElementById('billAreaLabel').textContent = areaHintFromPrefix(prefix) || 'Bill found';

      // extra detail fields
      var amountEl = document.getElementById('billAmountDue');
      var dateEl   = document.getElementById('billDueDate');
      var meterEl  = document.getElementById('billMeterNo');
      if (amountEl) {
        var amt = data.amountDue;
        if (amt) {
          var num = parseFloat(String(amt).replace(/,/g, ''));
          amountEl.textContent = isNaN(num) ? amt : 'Rs. ' + Math.round(num).toLocaleString('en-US');
        } else { amountEl.textContent = '—'; }
      }
      if (dateEl) {
        var raw = data.dueDate;
        if (raw) {
          var d = new Date(raw);
          dateEl.textContent = isNaN(d.getTime()) ? raw
            : d.toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' });
        } else { dateEl.textContent = '—'; }
      }
      if (meterEl) meterEl.textContent = data.meterNo || '—';
      var billMonthEl = document.getElementById('billBillingPeriod');
      if (billMonthEl) {
        var mon = (data.billingMonth || '').trim();
        var yr  = data.billingYear ? Math.round(parseFloat(data.billingYear)) : '';
        billMonthEl.textContent = (mon && yr) ? mon + '-' + yr : (mon || yr || '—');
      }
      var afterEl = document.getElementById('billAmountAfterDate');
      if (afterEl) {
        var amt2 = data.amountAfterDate;
        if (amt2) {
          var num2 = parseFloat(String(amt2).replace(/,/g, ''));
          afterEl.textContent = isNaN(num2) ? amt2 : 'Rs. ' + Math.round(num2).toLocaleString('en-US');
        } else { afterEl.textContent = '—'; }
      }

      document.getElementById('billCardDownloadBtn').style.display = 'inline-flex';
      document.getElementById('billCardPayBtn').style.display = 'none';
      var card = document.getElementById('billCard');
      card.style.display = 'block';
      var reveal = card.querySelector('[data-reveal]');
      if (reveal) { reveal.style.opacity = '1'; reveal.style.transform = 'none'; }
    })
    .catch(function () {
      setLoading(false);
      showError('We could not reach the billing server. Please try again.');
    });
}

// ---- download (mirrors openBillPdfNewTab) ----
function downloadPdf() {
  if (!currentRef) return;
  fetch('BillAuthorize.aspx', {
    method: 'POST',
    credentials: 'same-origin',
    headers: { 'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
    body: 'ref=' + encodeURIComponent(currentRef)
  })
    .then(function (r) { if (!r.ok) throw new Error('authorize'); return r.json(); })
    .then(function (auth) {
      if (!auth || !auth.ok) {
        showError(auth && auth.reason === 'notfound' ? 'No bill was found for this reference number.' : 'We could not reach the billing server. Please try again.');
        return;
      }
      window.open('BillFrame.aspx', '_blank');
    })
    .catch(function () { showError('We could not reach the billing server. Please try again.'); });
}

// ---- payment (mirrors payKuickPay) ----
function payViaKuickPayRef(ref) {
  if (ref === '') { showError('Please enter your KuickPay reference number.'); return; }
  if (ref.length < 5) { showError('Invalid reference number.'); return; }
  var prefix = ref.substring(0, 5);
  if (prefix === '01000' || prefix === '01010' || prefix === '01060' || prefix === '01070') {
    window.location.href = 'https://portal.kuickpay.com/payNow/?cn=' + ref;
  } else {
    showError('Online payment for this area is under development.');
  }
}
function payViaKuickPay() {
  if (currentRef) payViaKuickPayRef(currentRef);
}

updateTabStyles();
