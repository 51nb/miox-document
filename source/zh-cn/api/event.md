title: Events
---

Miox的事件不同于nodejs的events模块，它具有异步性，具体参看 [async-events-listener](https://www.npmjs.com/package/async-events-listener) 模块的解析。

```javascript
app.on('event name', async (...args) => {
    // await someTimeConsumingFun();
    // ...
})
```

## 常用事件

- **searchchange** 当URL的search部分改变的时候触发，仅在`strict:false`模式下生效。
- **hashchange** 当hash改变时候触发
- **app:start** 第一次渲染开始
- **app:end** 第一次渲染结束
- **process:start** 一次请求响应开发时候触发的事件
- **process:end** 一次请求响应结束时候触发的事件
- **webview:beforeEnter** 当有 webview 进入前触发
- **webview:beforeLeave** 当有 webview 离开前触发

## 不常用的事件

- **{httpStatusCode}** 页面正常渲染，即触发`200`事件，如果有错误，那么对应错误代码编号的事件，比如`500`,`502`等等。
- **client:render:mount** 服务端渲染模式下，浏览器端 Mounted 时触发
- **client:render:polyfill** 服务端渲染模式下，浏览器端兼容代码需要被加载时候触发，这时请求响应过程未完成。
- **server:render:polyfill** 服务端渲染模式下，服务端兼容代码需要被加载时候触发，这时请求响应过程已完成。
