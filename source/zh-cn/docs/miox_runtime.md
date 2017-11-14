title: Miox Runtime
---

Miox 会始终监听(listen)会话历史变化，
当会话历史变化后，miox 会取到接下来要呈现的 URL，然后进行路由匹配映射到具体的 webview。
从 URL 到 webview 的单次请求响应过程，Miox 采用了 koa 的中间件设计。

**Koa Middleware**

```javascript
app.use(async (ctx, next) => {
   await ctx.render(template, data);
   await next();
});
```

**Miox Middleware**

```javascript
app.use(async (ctx, next) => {
   await ctx.render(webviewConstructor, args)
   await next();
});
```

在进入中间件处理过程前，miox 会派发一个名为 `process:start` 事件，所有中间件全部执行结束后，会派发 `process:end` 事件。

开发者可以直接编写中间件控制 miox 的执行逻辑。在所有中间件中，有一个核心中间件称为路由(router)，官方提供了 `miox-router` 插件。

```javascript
import Router from 'miox-router';
const route = new Router();
route.patch('/', async ctx => await ctx.render(PageA));
app.on('process:start', () => {});
app.on('process:end', () => {});
// route.routes 实际就是返回一个中间件
app.use(route.routes());
```

## Render Service

```javascript
route.patch('/', async ctx => await ctx.render(PageA));
```

Miox 提供了**render**函数来渲染视图。
这种路由对应一个**function**回调的机制我们称为**动态路由机制**。它决定了路由不再仅仅对应页面，而是通过逻辑来动态对应。

> 比如说，我在A页面未登录状态下登陆，进入B页面，再从B页面回到A页面，那么A页面不再是之前的未登录页面。对比传统的做法，那么从B回到A的时候，A还是未登入页面。

**Render Service**还提供缓存webview功能，即**尽可能最大限度复用webview**。

如果我们在SPA中一直重新渲染同一个页面，那么势必会花大量时间来进行 webview 创建销毁，因此 miox 会智能管理 webview，当某个 webview 变成 inactive 时，miox 会根据当前运行状态选择销毁还是缓存该 webview。开发者通过 `mixoOptions.max` 参数来控制最大缓存webview的数量，让浏览器保持性能稳定。通过记录用户在SPA中会话历史(session history)，miox 能算出哪些 webview 可以被缓存，哪些需要销毁。

具体源码参看：[miox/src/miox/build/lib/render.js:61](https://github.com/51nb/miox/blob/master/src/miox/src/lib/render.js#L61)

而你无需关心这些，您这样操作一下的步骤即可：

```javascript
await ctx.render(webviewConstructor, options);
```

## Miox runtime loop

![runtime loop](https://pic.51zhangdan.com/u51/storage/cc/cf3f57a2-cf7c-ff70-0a90-9aea331f38dc.png)




