(function () {
  const btn = document.getElementById('copy-btn');
  if (!btn) return;

  function fallbackCopy(text) {
    const ta = document.createElement('textarea');
    ta.value = text;
    ta.setAttribute('readonly', '');
    ta.style.position = 'absolute';
    ta.style.left = '-9999px';
    document.body.appendChild(ta);
    ta.select();
    try { document.execCommand('copy'); } finally { document.body.removeChild(ta); }
  }

  let resetTimer;
  btn.addEventListener('click', async () => {
    const ip = btn.dataset.ip;
    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(ip);
      } else {
        fallbackCopy(ip);
      }
      btn.classList.add('copied');
      btn.setAttribute('aria-label', 'Copied');
      clearTimeout(resetTimer);
      resetTimer = setTimeout(() => {
        btn.classList.remove('copied');
        btn.setAttribute('aria-label', 'Copy IP address');
      }, 1500);
    } catch (e) {
      console.error('Copy failed', e);
    }
  });
})();
