title: Miox 的目标
---

用传统web页面开发的思维模式和开发习惯来开发SPA，让开发单页应用像开发传统web页面一样简单。

## 什么是 Miox

[Miox](https://github.com/51nb/miox) 是一个单页应用的管理框架(SPA management framework)。
在传统web开发中，浏览器会帮助开发者管理会话历史以及页面的创建、销毁、切入切出等生命行为，
在SPA开发中，这些工作需要由SPA的管理框架来实现，miox 就是做了这样的工作。

- miox 支持任何渲染引擎，就是说，使用 miox，开发者仍可以使用 react/vue 来编写业务代码。
- miox 专注做 SPA 的运行容器，因此它具有良好的扩展性，可以与 redux/vuex，SSR 等技术结合应用。

目前 Miox 在51信用卡全线业务中均有使用，PC端和移动端都有覆盖。

## Loading SPA Pages

Miox 借鉴了 HTML5 规范中 [Loading Web Pages](https://www.w3.org/TR/html51/browsers.html) 这一章，实现了 **Loading SPA Pages**。

在 HTML5 的 Loading Web Pages 约定了如下内容，由各个浏览器实现：

- 浏览上下文中的一个页面即一个 document，通过 `HTMLParser(htmlContent)` 来创建
- 管理 document 的生命周期，提供生命周期事件(pageshow, pagehide等)
- 维护浏览上下文的会话历史，提供给开发者与之交互的API，如 `history.go`, `location.replace`

在 SPA 中，情况变得不同，因为整个 SPA 就是单个 document，一个 SPA 由多个逻辑页面（miox 称为 webview）组成。
在 SPA 中，就需要手动管理 SPA 的会话历史以及其 webview 的生命周期。

> webview 就是 DOM 树，受到 vue/react 等的全部控制，miox 只能间接控制这个 DOM 树的创建与销毁。

miox 做了以下工作：

- SPA中的一个逻辑页面即一个 webview，通过 `new Vue(options)`, `React.createElement(Element)` 等来创建
- 管理 webview 的生命周期，提供生命周期事件(enter, leave等)
- 维护SPA的会话记录，提供给开发者与之交互的API，如 `miox.go`/`miox.replace`

Miox 期望通过实现统一的 **Loading SPA Pages**，让开发者不需要转变思维模式，像开发web页面一样开发SPA。

> 以 vue + vue-router 或 react + react-router 为例，尽管也间接实现了 **Loading SPA Pages** 中所述功能，
> 然而其设计并不以之为出发点，这是 miox 与它们之间的根本区别

> 名词说明
> - 浏览上下文：browsing context，一个 browsing context 有多个 document，但有且仅有一个 active document
> - 会话历史：session history，一个有序数组，数组每项都包含一个 URL 和 一个 document(可能已被销毁，可以通过URL重建)

## webview 生命周期行为

单个 webview 的生命周期中有以下四个核心行为：

- 创建(**create**），创建一个 webview 实例并挂载到 SPA 上
- 进入(**enter**)，当前 webview 变为 active webview 时触发
- 离开(**leave**)，当前 webview 变为 inactive webview 时触发
- 销毁(**destroy**)，销毁一个 webview 实例并从 SPA 上卸载

> 目前 create 内包括了自动挂载(mount)，destroy 内包括了自动卸载(unmount)

一个已创建的 webview 有 **active** 和 **inactive** 两个状态，这两个状态可以互相转换。
整个生命周期状态与转换关系如下所示：

![](https://pic.51zhangdan.com/u51/storage/d9/d59e273e-ed31-28e9-66a1-bfd5a232e759.png)

在 miox 管理的 SPA 中，webview 的生命周期会被 miox 智能管理起来。
特别地，当某个 webview 发生 leave 行为后，miox 会智能判断销毁该 webview 还是缓存起来。
开发者通过 `mioxOptions.max` 来指定 SPA 最大可缓存 webview 的数量。

> 选择销毁 webview 可以节省整个 SPA 的内存占用，
> 缓存 webview 可以避免下次 enter 时重新创建 webview 的耗时，另外对于保留页面滚动位置，用户输入等需求也是很大帮助。

## webview 渲染引擎

当开发者用 miox 结合 vue/react 来开发SPA时，还需要实现 miox 与 vue/react 的对接，在 miox 中称为**渲染引擎**，或称为驱动。
miox 官方提供了 `miox-vue2x`/`miox-react` 渲染引擎来对接 vue@2.x 和 react，让开发者能快速上手。
开发者也可以结合需要自己做更深度的定制，详见如何编写插件一章。

下面是使用 `miox-react` 编写的一个简易 SPA。

```javascript
import Miox from 'miox';
import ReactEngine from 'miox-react';
import React from 'react';

class ExamplePage extends React.Component {
    render() {
        return <h1>Hello World!</h1>;
    }
}

app = new Miox();
app.install(ReactEngine);
app.use(async app => await app.render(ExamplePage));
app.listen();
```

## webview 切换动画

正如前面说到，单个 webview 的生命周期过程中有 **enter**/**leave** 两个行为。
当 webview 发生这两个行为时，miox 会控制对应 webview 进行切换（切入或者切出），
miox 允许开发者编写插件，或使用官方插件 `miox-animation` 来定义切换动画，比如淡入淡出，飞入飞出等。
如果不做配置，则没有切换动画。

## 路由：从 URL 到 webview

当 SPA 的会话历史变化后，miox 会创建一个新的 webview 呈现给用户（如果对应 webview 没有在缓存中的话）。
此时的输入是一个 URL，输出是一个 webview，由开发者来定义输入输出间的映射关系，
把 **一个 URL 映射到具体 webview 的逻辑**，miox 称为路由(route)。

route 所定义的映射逻辑，与当前用户在SPA中的会话历史无关，只与当前访问的 URL 相关。

> 类比传统web开发，路由映射是将一个HTTP请求映射成一个HTTP响应(响应内容是html文件)，在 miox 中则更精简。
> 在 miox 中，我们剔除了内容协商，内容元信息描述等HTTP特性，只保留请求中的URL和响应中的webview。
> 此外，在传统web开发中，路由运行在服务器上，而在 SPA 中路由是运行在浏览器上，由 miox 驱动。

使用 miox 就可以直接定义路由规则，如下所示：

```javascript
import Home from './pages/home.jsx';
import Users from './pages/users.jsx';

app.use(async app => {
    switch (app.request.pathname) {
        case "/":
            await app.render(Home);
            break;
        case "/users":
            await app.render(Users);
            break;
    }
});
```

## 路由器: router

miox 具有直接描述 route 的能力，但在复杂应用中，它的路由表达能力较差。
在实际生产中，一般会引入路由器来增强路由表达能力，以进一步提升生产效率。

miox 官方提供了 `miox-router`：

```javascript
import Router from 'miox-router';
const router = new Router();
router
    .patch('/', async app => await app.render(Home))
    .patch('/users', async app => await app.render(Users));
app.use(router.routes());
```

## 快速上手的技术选型

- miox + `miox-router` + `miox-vue2x` + vuex
- miox + `miox-router` + `miox-react` + redux

建议使用 `miox-cli` 生成项目模板，一键搭建开发环境。