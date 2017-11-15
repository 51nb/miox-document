title: miox-animation
---

官方提供的页面切换动画集合。

## 使用

目前提供了2种切换动画： `slide` （默认）和 `push`。

- `slide` 新页面从右侧滑动进入，覆盖住老页面（会话历史前进时）；或老页面向右滑动退出，显示出新页面（会话历史后退时）
- `push` 新页面从下侧滑动进入，覆盖住老页面（会话历史前进时）；或老页面向下滑动退出，显示出新页面（会话历史后退时）

使用方法如下：

```javascript
import AnimationCreate from 'miox-animation';
const app = new Miox(options);
app.install(AnimationCreate('slide'));
```

## Events

```javascript
app.on("eventNameHere", async (webviewElement) => {})
```

> 这里的 `webviewElement` 是指应用了切换动画的元素，
> 其唯一子元素才是被 vue/react 等所控制的DOM树，`webviewElement` 是不受 vue/react 等控制。

|事件|触发时机|参数|
| :---- | :------ | :---- |
|animate:leave:before | webview离开之前触发，并且等待事件执行完成后才执行离开动画 | webviewElement |
|animate:leave:after | webview离开之后触发 | webviewElement |
|animate:enter:before | webview进入之前触发，并且等待事件执行完成后才执行进入动画 | webviewElement |
|animate:enter:after | webview进入之前触发 | webviewElement |




