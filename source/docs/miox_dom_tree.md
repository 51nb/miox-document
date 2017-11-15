title: DOM 树结构
---

如下图所示：

![miox 中的顶层DOM树](https://pic.51zhangdan.com/u51/storage/93/95c96445-7671-378c-8470-a7b44692b5b3.png)

其中最顶层的元素代表整个SPA，它有且仅有一个子元素，称为 `webviewsElement`，该元素通过访问 `miox.element` 获取。
`webviewsElement` 可以有多个 `webviewElement` 子元素，每个 `webviewElement` 有且仅有一个子元素，
这个子元素才是真正通过 `vue`/`react` 渲染出来的视图，受到 `vue`/`react` 所控制。

miox 在处理 webview 切换时，控制的是 `webviewElement`，因此开发者在编写切换动画插件时，获取到的也是 `webviewElement`。

另外，开发者在编写 `vue`/`react` 等视图库的渲染引擎时，
每次创建一个新的 `webview`，需要同时创建一个 `webviewElement` 来挂载这个 webview。
同理，销毁 webview 时，除了销毁 webview 本身外，也要同时移除 `webviewElement`。

> 注意：目前 webview create/destory 和 mount/unmount 是同时出现的。
