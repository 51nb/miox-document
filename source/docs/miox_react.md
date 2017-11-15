title: miox-react
---

实现 miox 和 react 桥接的渲染引擎。

## 使用

```javascript
import Miox from 'miox';
import ReactEngine from 'miox-react';
import React from 'react';

class ExamplePage extends React.Component {
    constructor() {
        super();
        this.onclick = () => {
            this.$push("/b");
        };
    }

    webViewDidEnter() {
        console.log("webview did enter!")
    }

    render() {
        return <h1 onClick={this.onclick}>Hello World!</h1>;
    }
}

app = new Miox();
app.install(ReactEngine);
app.use(async app => await app.render(ExamplePage));
app.listen();
```

## React 增强

> 这里的 webview 就是 React.Component 实例

> 与 miox-vue2x 不同，react 采用了回调函数进行消息通讯


### webview.webViewDidEnter()
当前webview切换入后触发，不管这个webview是立即创建的还是从缓存中恢复的

### webview.webViewDidLeave()
当前webview切换出后触发

### webview.webViewDidActive()
当前webview被再次激活时触发，如果当前webview是立即创建的，该函数不会被调用，只在从缓存中激活才被调用

### webview.webViewSearchChange(prevUrlObj, nextUrlObj)
仅在非 `strict` 模式下有效，URL变化不涉及 pathname 且有 search 部分变化时才被调用，参数是变化前的URL和变化后的URL对象，
这里的URL对象是一个已经被结构化的对象，由 `url` 模块创建生成

### webview.webViewHashChange(prevUrlObj, nextUrlObj)
URL变化只涉及 hash 部分变化时才被调用，参数是变化前的URL和变化后的URL对象，
这里的URL对象是一个已经被结构化的对象，由 `url` 模块创建生成

### webview.$push/$go/$replace/$redirect/$link
与 SPA 的会话历史交互，是一个代理方法，实际上调用了 mixo 的同名方法
