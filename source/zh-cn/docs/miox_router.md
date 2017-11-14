title: miox-router
---

`miox-router` 是专注于高效表达路由关系的一个插件。

对 nodejs 的 [koa](https://www.npmjs.com/package/koa) 熟悉的开发者或许已经发现，miox 采用了 koa 的中间件(middleware)机制，
因此 miox-router 本质上是一个专注于路由功能的中间件，miox-router 在设计和实现上也高度还原了 [koa-router](https://www.npmjs.com/package/koa-router)，
这使得对 koa 与 `koa-router` 熟悉的开发者能够更快速地上手。

> koa: Expressive HTTP middleware framework to make web applications and APIs more enjoyable to write
>
> koa-router: Router middleware for koa

也可以说，miox-router 是一个运行在浏览器中的简化版的 koa-router。

## 与其他 SPA router 相比

miox-router 所提供的功能与传统web后端的 router 更相似，但不同于 react-router/vue-router。
miox-router 的哲学是：

- miox-router 不提供 push/go/replace 等与会话历史交互的方法，专注于表达URL到Webview的映射逻辑这一个任务
- miox 会在每次会话历史变化后传递一个 URL 给 miox-router，miox-router 根据该URL渲染对应的 webview
- 一个 URL 所响应的 webview 不是静态映射，而是可编程的

> push/go/replace 等与会话历史交互的方法由 miox 提供，这与 location、history 等方法由浏览器提供是等价的。

> 与传统web开发不同，在 miox 中每次会话历史变化都会执行路由处理。

## API

### new Router()

创建一个新的 router。

```javascript
var Router = require('miox-router');
var router = new Router();
```

### router.patch ==> router

定义一条新的 route 规则，将特定的URL模式与回调函数进行关联。

```javascript
router
    .patch('/', async (app, next) => {
        await app.render(Home);
    })
    .patch('/user/:id', async (app, next) => {
        ...
        await app.render(User);
    });
```

### URL parameters

URL路径上的命名参数可以通过 app.params 来访问。

```javascript
router.patch('/:category/:title', function (app, next) {
    console.log(app.params);
    // => { category: 'xxx', title: 'xxx' }
});
```

### router.routes ==> middleware function

将配置的路由规则合并起来，组装成一个中间件，给 miox 使用。

```javascript
app.use(router.routes());
```
