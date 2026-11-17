/*
 * js/sidebar.js — shared sidebar for every page on the site.
 *
 * Works from the root (index.html, chanel.html, privacy.html)
 * and from pages/ sub-pages. Detects depth, rewrites all hrefs,
 * and marks the current page with class="current".
 *
 * Usage:
 *   Root pages   → <div id="sidebar"></div><script src="js/sidebar.js"></script>
 *   pages/ pages → <div id="sidebar"></div><script src="../js/sidebar.js"></script>
 */
(function () {
  /* ── 1. Inject sidebar styles from index.html if not already present ── */
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
      .sidebar {
        position: fixed;
        top: 0;
        left: -260px;
        width: 250px;
        height: 100%;
        background: var(--navy);
        padding: 20px;
        transition: left .3s;
        z-index: 1050;
        overflow-y: auto;
        box-sizing: border-box;
      }
      .sidebar.open { left: 0; }
      .sidebar a {
        display: block;
        padding: 10px 0;
        color: var(--white);
        text-decoration: none;
        font-family: inherit;
      }
      .sidebar a:hover { color: var(--gold); }
      .sidebar a.current { font-weight: bold; color: var(--gold); }
      .nav-section {
        margin-top: 16px;
        padding-top: 10px;
        border-top: 1px solid rgba(255,255,255,.15);
        color: var(--gold);
        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-family: inherit;
        margin-bottom: 0;
      }
      .sidebar .nav-section + a { margin-top: 4px; }
      #closeSidebar {
        background: none;
        border: none;
        color: var(--white);
        font-size: 22px;
        float: right;
        cursor: pointer;
        min-height: unset;
        padding: 0;
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

  /* ── 3. Menu structure ──────────────────────────────────────────
   * Each entry: { label, href }   — href is relative to ROOT.
   * Section headers: { section: 'Title' }
   * --------------------------------------------------------------- */
  const MENU = [
    { label: 'Home', href: 'index.html' },

    { section: 'Placement' },
    { label: 'Training Opportunities', href: 'pages/training-opportunities.html' },
    { label: 'Select Internship Site', href: 'intenrship_selection.html' },
    { label: 'Placement Details',    href: 'pages/placement-details.html' },
    { label: 'Company Requirements', href: 'pages/company-requirements.html' },
    { label: 'Company Channels',     href: 'chanel.html' },
    { label: 'Acceptance Documents', href: 'pages/acceptance-documents.html' },
    { label: 'Application Status',   href: 'pages/application-notifications.html' },
    { label: 'Student Profile',      href: 'pages/update-student-profile.html' },

    { section: 'Internship' },
    { label: 'Attendance',               href: 'pages/internship_log.html' },
    { label: 'Learning Objectives',      href: 'pages/learning_objectives.html' },
    { label: 'University Notifications', href: 'pages/university-notifications.html' },

    { section: 'Reports' },
    { label: 'Progress Summary', href: 'pages/progress-summary.html' },
    { label: 'Reported Issues',  href: 'pages/reported-issues.html' },

    { section: 'Evaluation' },
    { label: 'Evaluation Criteria', href: 'pages/evaluation-criteria.html' },
    { label: 'Site Reviews',        href: 'pages/internship_reviews.html' },
    { label: 'Grade and Evaluation',href: 'pages/internship_grade.html' },
    { label: 'My Certificate',      href: 'pages/certificate.html' },

    { section: 'Help' },
    { label: 'Contact Supervisor', href: 'pages/contact.html' },
    { label: 'Contact Support',    href: 'pages/contact-support.html' },
    { label: 'Privacy Settings',   href: 'privacy.html' },
  ];

  /* ── 4. Resolve the href for the current depth ── */
  function resolve(href) {
    if (inPages) {
      if (href.startsWith('pages/')) {
        return href.slice('pages/'.length); // same directory
      }
      return '../' + href;                  // back to root
    }
    return href;                            // already at root
  }

  /* ── 5. Decide which link is "current" ── */
  function isCurrent(href) {
    if (inPages) {
      if (href.startsWith('pages/')) {
        return href.slice('pages/'.length).toLowerCase() === currentFile;
      }
      return false;
    } else {
      if (!href.startsWith('pages/')) {
        const file = href.toLowerCase();
        return file === currentFile || (currentFile === '' && file === 'index.html');
      }
      return false;
    }
  }

  /* ── 6. Build the HTML ── */
  let html = '<button id="closeSidebar">&times;</button>\n';

  for (const item of MENU) {
    if (item.section) {
      html += `  <p class="nav-section">${item.section}</p>\n`;
    } else {
      const href    = resolve(item.href);
      const current = isCurrent(item.href) ? ' class="current"' : '';
      html += `  <a href="${href}"${current}>${item.label}</a>\n`;
    }
  }

  /* ── 7. Inject into the placeholder ── */
  const container = document.getElementById('sidebar');
  if (container) {
    if (container.tagName === 'DIV') {
      container.outerHTML = `<nav class="sidebar" id="sidebar">\n${html}</nav>`;
    } else {
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
      if (sidebar && sidebar.parentNode) {
        sidebar.insertAdjacentElement('afterend', overlay);
      } else {
        document.body.appendChild(overlay);
      }
    }

    function openSidebar()  { if (sidebar) sidebar.classList.add('open'); if (overlay) overlay.classList.add('active'); }
    function closeSidebar() { if (sidebar) sidebar.classList.remove('open'); if (overlay) overlay.classList.remove('active'); }

    const toggleBtn = document.getElementById('menuToggle');
    const closeBtn  = document.getElementById('closeSidebar');

    if (toggleBtn) toggleBtn.addEventListener('click', openSidebar);
    if (closeBtn)  closeBtn.addEventListener('click', closeSidebar);
    if (overlay)   overlay.addEventListener('click', closeSidebar);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setupListeners);
  } else {
    setupListeners();
  }
})();
