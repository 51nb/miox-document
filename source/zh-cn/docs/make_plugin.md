title: 编写插件
---

miox 的插件主要有三类：

- 桥接 miox 和视图库（vue/react等）的渲染引擎，官方提供了 `miox-vue2x`，`miox-react`
- 定义 webview 切换时的动画效果，官方提供了 `miox-animation`
- 表达路由关系的 router，官方提供了 `moix-router`

## 渲染引擎插件

要实现一个渲染引擎，关键在于了解 Miox 中 webview 的生命周期行为，核心是实现如下四个函数：

- `create(webviewConstructor)`
- `destroy(webview)`
- `enter(webview)`
- `leave(webview)`

以 `miox-react` 为例，从调用关系来看，miox 调用 `miox-react`，`miox-reaxt` 调用 `react`。

一个简单的渲染引擎可以如下实现：

```javascript
import React from 'react';
import ReactDom from 'react-dom';

class ReactEngine {
    constructor(app) {
        this.app = app;
    }
    // 实现 webview 的创建
    async create(webviewConstructor) {
        const webviewMountElement = this._createWebviewMountElement();
        const webview = ReactDom.render(
            React.createElement(webviewConstructor), webviewMountElement
        );
        return webview;
    }
    // 实现 webview 的销毁
    async destroy(webview) {
        const webviewMountElement = this._getWebviewMountElement(webview);
        ReactDom.unmountComponentAtNode(webviewMountElement);
        webviewMountElement.remove();
    }
    // 通知 webview 发生了 enter
    async enter(webview) {
        webview.webviewDidEnter && webview.webviewDidEnter();
    }
    // 通知 webview 发生了 leave
    async leave(webview) {
        webview.webviewDidLeave && webview.webviewDidLeave();
    }
    _createWebviewMountElement() {
        const webviewMountElement = document.createElement('div');
        webviewMountElement.classList.add('mx-webview');

        const webviewsElement = this.app.element;
        webviewsElement.appendChild(webviewMountElement);

        return webviewMountElement;
    }
    _getWebviewMountElement(webview) {
        return webview.parentNode;
    }
}

export default function install(app) {
    app.set('engine', ReactEngine);
}
```

## 过渡动画插件

要实现过渡动画的插件，开发者有几件事情要做：

- 通过 CSS 定义过渡动画效果，可以用 CSS 的 `transition`/`animation`
- 实现 `enter`/`leave` 函数，miox 会在对应 webview 切入/切出时调用这两个函数
- 通过 `miox.history.direction` 来确定动画方向，-1表示后退；0表示未知；1表示前进

核心代码如下：

```javascript
// 引入过渡动画相关的样式
import './index.scss';

class Transition {
    constructor(app) {
        this.app = app;
    }
    // 由 miox 调用
    async enter(webviewElement) {
        await _transition(webviewElement, "enter");
    }
    // 由 miox 调用
    async leave(webviewElement) {
        await _transition(webviewElement, "leave");
    }
    async _transition(webviewElement, enterOrLeave) {
        const direction = this.app.history.direction;
        const classname = `page-slide-${enterOrLeave}-when-history-${direction}`;

        // 该 classname 对应的 css 动画/过渡需要插件开发者自己编写
        webviewElement.classList.add(classname);
        await _transitionEnd(webviewElement);
        webviewElement.classList.remove(classname);
    }
}

export default (app) => {
    return new Transition(app);
}
```

## router 插件

miox 内部采用了 koa 的中间件设计来处理请求响应。
在一次请求响应处理过程中，开发者可以获取到当前请求的URL信息，并渲染对应的 webview。

```javascript
app.use(async (app, next) => {
    app.request.hostname,
    app.request.pathname,
    ...
    app.render(webviewConstructor, args);
})
```

## 其他插件

```javascript
app.install(callback: function(app){});
```

比如写一个 frameset 效果的插件，可以如下

```javascript
app.install(function(app){
    var doc = window.document;

    var div = doc.createElement("div");
    div.classList.add("frame-set");
    var navFrame = doc.createElement("div");
    navFrame.classList.add("frame-item");
    var contentFrame = doc.createElement("div");
    contentFrame.classList.add("frame-item");

    div.appendChild(navFrame);
    div.appendChild(contentFrame);
    doc.body.appendChild(div);

    app.set("container", contentFrame);
});
```

DOM 结构就会如下所示：

![](https://pic.51zhangdan.com/u51/storage/b9/ba2ca210-e955-8ac2-fa4c-446e96b7d4c9.png)
