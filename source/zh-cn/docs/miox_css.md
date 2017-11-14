title: 全局基础样式
---

`miox-css` 模块提供了SPA中的全局基础样式，我们建议开发者默认引入，它由两个部分组成：

0. `normalize.css`
0. miox 顶层DOM样式

> `miox-css` 也是 miox 的一个可选模块，开发者可以开发自己需要的 `miox-css`

对于 miox 的顶层DOM树，开发者可以结合下图来理解。

![](https://pic.51zhangdan.com/u51/storage/93/95c96445-7671-378c-8470-a7b44692b5b3.png)

其核心代码如下：

```css
/* 这里是 normalize.css v6.0.0 ... */

html,
body,
.mx-app,
.mx-webviews,
.mx-webview {
    height: 100%;
}

.mx-webviews {
    position: relative;
}

.mx-webview{
    position: absolute;
    z-index: 0;
    overflow-x: hidden;
    overflow-y: auto;
}

.mx-webview.active{
    z-index: 1;
}
```
