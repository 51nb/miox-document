<header id="banner" class="wrapper">
  <div class="inner">
    <h2 id="banner-title">{{ page.subtitle }}</h2>
    <div id="banner-start">
      <span id="banner-start-command">npm install miox-cli -g</span><a id="banner-start-link" href="docs/"><i class="fa fa-arrow-right"></i></a>
    </div>
    <div id="banner-share">{{ partial('partial/share') }}</div>
  </div>
</header>
<div id="content-wrap">
  <div class="wrapper">
    <div class="inner">
      {{ page.content }}
      <ul id="intro-cmd-wrap">
        <li class="intro-cmd-item">npm install miox-cli -g</li>
        <li class="intro-cmd-item">miox create</li>
        <li class="intro-cmd-item">npm install</li>
        <li class="intro-cmd-item">npm run dev</li>
        <li class="intro-cmd-item">npm run build</li>
      </ul>
      <div id="intro-get-started-wrap">
        <a href="/miox-doc/docs" id="intro-get-started-link">{{ __('index.get_started') }}</a>
      </div>
    </div>
  </div>
</div>