/*
 * js/sidebar.js — shared sidebar for every page on the site.
 *
 * Works from the root (index.html, chanel.html, privacy.html)
 * and from pages/ sub-pages. Detects depth, rewrites all hrefs,
 * and marks the current page with class="current".
 * Each section (Placement, Internship, ...) opens and closes with an arrow.
 * The section that holds the current page opens automatically.
 *
 * Usage:
 *   Root pages   → <div id="sidebar"></div><script src="js/sidebar.js"></script>
 *   pages/ pages → <div id="sidebar"></div><script src="../js/sidebar.js"></script>
 */
(function () {
  /* ── 1. Shared styles (header + sidebar) so every page looks the same ── */
  if (!document.getElementById('sidebar-styles')) {
    const style = document.createElement('style');
    style.id = 'sidebar-styles';
    style.textContent = `
      :root {
        --navy: #0f1f3d;
        --navy-soft: #33415c;
        --gold: #f2c230;
        --white: #ffffff;
        --line: #e3e8f0;
        --muted: #5a6785;
      }
      body > header {
        background: var(--navy);
        color: var(--white);
        padding: 14px 18px;
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 12px;
        border-bottom: 4px solid var(--gold);
      }
      #menuToggle {
        background: none;
        border: none;
        color: var(--white);
        font-size: 24px;
        cursor: pointer;
        padding: 0;
        margin: 0;
        width: auto;
        line-height: 1;
      }
      .sidebar {
        position: fixed;
        top: 0;
        left: -270px;
        width: 260px;
        height: 100%;
        background: var(--navy);
        padding: 20px;
        transition: left .3s;
        z-index: 1050;
        overflow-y: auto;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
      }
      .sidebar.open { left: 0; }
      .sidebar a {
        display: block;
        padding: 9px 0 9px 12px;
        color: var(--white);
        text-decoration: none;
        font-size: 15px;
      }
      .sidebar a:hover { color: var(--gold); }
      .sidebar a.current { font-weight: bold; color: var(--gold); }
      .sidebar a.home-link { padding-left: 0; }
      .nav-section-btn {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        margin-top: 12px;
        padding: 10px 0;
        border: 0;
        border-top: 1px solid rgba(255,255,255,.15);
        background: none;
        color: var(--gold);
        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 1px;
        cursor: pointer;
        text-align: left;
        font-family: inherit;
      }
      .nav-section-btn:hover { color: var(--white); }
      .nav-arrow { font-size: 14px; transition: transform .2s; }
      .nav-section-btn[aria-expanded="true"] .nav-arrow { transform: rotate(90deg); }
      .nav-links[hidden] { display: none; }
      #closeSidebar {
        background: none;
        border: none;
        color: var(--white);
        font-size: 22px;
        float: right;
        cursor: pointer;
        padding: 0;
        width: auto;
        line-height: 1;
      }
      .overlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(15,31,61,.4);
        z-index: 1040;
      }
      .overlay.active { display: block; }
    `;
    document.head.appendChild(style);
  }

  /* ── 2. Detect whether we are inside pages/ ── */
  const path = window.location.pathname.replace(/\\/g, '/');
  const inPages = /\/pages\//i.test(path);
  const currentFile = path.split('/').pop().toLowerCase() || 'index.html';

  /* ── 3. Menu structure (href is relative to ROOT) ── */
  const HOME = { label: 'Home', href: 'index.html' };
  const SECTIONS = [
    { title: 'Placement', links: [
      { label: 'Training Opportunities', href: 'pages/training-opportunities.html' },
      { label: 'Choose Internship Site', href: 'pages/internship-selection.html' },
      { label: 'Company Requirements',   href: 'pages/company-requirements.html' },
      { label: 'Application Status',     href: 'pages/application-notifications.html' },
      { label: 'Acceptance Documents',   href: 'pages/acceptance-documents.html' },
      { label: 'Placement Details',      href: 'pages/placement-details.html' },
      { label: 'Company Channels',       href: 'chanel.html' },
      { label: 'Review Student Status',  href: 'pages/review-student-status.html' },
      { label: 'Student Profile',        href: 'pages/update-student-profile.html' },
    ]},
    { title: 'Internship', links: [
      { label: 'Attendance',               href: 'pages/internship_log.html' },
      { label: 'Learning Objectives',      href: 'pages/learning_objectives.html' },
      { label: 'University Notifications', href: 'pages/university-notifications.html' },
    ]},
    { title: 'Reports', links: [
      { label: 'Progress Summary', href: 'pages/progress-summary.html' },
      { label: 'Reported Issues',  href: 'pages/reported-issues.html' },
    ]},
    { title: 'Evaluation', links: [
      { label: 'Evaluation Criteria',  href: 'pages/evaluation-criteria.html' },
      { label: 'Site Reviews',         href: 'pages/internship_reviews.html' },
      { label: 'Grade and Evaluation', href: 'pages/internship_grade.html' },
      { label: 'My Certificate',       href: 'pages/certificate.html' },
    ]},
    { title: 'Help', links: [
      { label: 'Contact Supervisor', href: 'pages/contact.html' },
      { label: 'Contact Support',    href: 'pages/contact-support.html' },
      { label: 'Privacy Settings',   href: 'privacy.html' },
    ]},
  ];

  /* ── 4. Resolve the href for the current depth ── */
  function resolve(href) {
    if (inPages) {
      if (href.startsWith('pages/')) return href.slice('pages/'.length);
      return '../' + href;
    }
    return href;
  }

  /* ── 5. Is this link the page we are on? ── */
  function isCurrent(href) {
    const inPagesLink = href.startsWith('pages/');
    if (inPages !== inPagesLink) return false;
    const file = (inPagesLink ? href.slice('pages/'.length) : href).toLowerCase();
    return file === currentFile;
  }

  function linkHtml(item, extraClass) {
    const classes = [extraClass, isCurrent(item.href) ? 'current' : ''].filter(Boolean).join(' ');
    return `<a href="${resolve(item.href)}"${classes ? ` class="${classes}"` : ''}>${item.label}</a>`;
  }

  /* ── 6. Build the HTML ── */
  let html = '<button id="closeSidebar" type="button" aria-label="Close menu">&times;</button>\n';
  html += linkHtml(HOME, 'home-link') + '\n';

  SECTIONS.forEach((section, i) => {
    const open = section.links.some((l) => isCurrent(l.href));
    const id = 'nav-group-' + i;
    html += `<button type="button" class="nav-section-btn" aria-expanded="${open}" aria-controls="${id}">` +
            `<span>${section.title}</span><span class="nav-arrow" aria-hidden="true">&#9656;</span></button>\n`;
    html += `<div class="nav-links" id="${id}"${open ? '' : ' hidden'}>\n` +
            section.links.map((l) => '  ' + linkHtml(l)).join('\n') + '\n</div>\n';
  });

  /* ── 7. Inject into the placeholder ── */
  const container = document.getElementById('sidebar');
  if (container) {
    if (container.tagName === 'DIV') {
      container.outerHTML = `<nav class="sidebar" id="sidebar">\n${html}</nav>`;
    } else {
      container.classList.add('sidebar');
      container.innerHTML = html;
    }
  }

  /* ── 8. Wire open/close after DOM is ready ── */
  function setupListeners() {
    const sidebar = document.querySelector('.sidebar#sidebar');
    let overlay = document.getElementById('overlay');
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.className = 'overlay';
      overlay.id = 'overlay';
      if (sidebar && sidebar.parentNode) sidebar.insertAdjacentElement('afterend', overlay);
      else document.body.appendChild(overlay);
    }

    function openSidebar()  { if (sidebar) sidebar.classList.add('open'); overlay.classList.add('active'); }
    function closeSidebar() { if (sidebar) sidebar.classList.remove('open'); overlay.classList.remove('active'); }

    const toggleBtn = document.getElementById('menuToggle');
    const closeBtn  = document.getElementById('closeSidebar');
    if (toggleBtn) toggleBtn.addEventListener('click', openSidebar);
    if (closeBtn)  closeBtn.addEventListener('click', closeSidebar);
    overlay.addEventListener('click', closeSidebar);

    // Open / close each section with its arrow
    if (sidebar) {
      sidebar.querySelectorAll('.nav-section-btn').forEach((btn) => {
        btn.addEventListener('click', () => {
          const group = document.getElementById(btn.getAttribute('aria-controls'));
          const isOpen = btn.getAttribute('aria-expanded') === 'true';
          btn.setAttribute('aria-expanded', String(!isOpen));
          if (group) group.hidden = isOpen;
        });
      });
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setupListeners);
  } else {
    setupListeners();
  }
})();