(function() {
  'use strict';

  function changeLang() {
    var lang = this.value;
    var canonical = this.dataset.canonical;
    if (lang === 'en') lang = '';
    if (lang) lang += '/';

    location.href = '/' + lang + canonical;
  }

  var a = document.getElementById('lang-select');
  var b = document.getElementById('mobile-lang-select');

  a && a.addEventListener('change', changeLang);
  b && b.addEventListener('change', changeLang);
}());
