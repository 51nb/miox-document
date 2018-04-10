title: Hello World
---

让我们从头来创建一个SPA，加深对 miox 的理解。

## 1. 创建实例

首先我们需要创建 Miox 实例，以移动端场景为例：

```javascript
import Miox from 'miox';
import 'miox-css';
const app = new Miox({
    max: 3,
    session: true,
});
```

> 引入 `miox-css`，它包含了 normalize.css 和 miox 顶层DOM样式

## 2. 配置渲染引擎

webview渲染需要渲染引擎驱动，这里我们选择 Vue 来编写页面逻辑，因此直接使用官方提供的渲染引擎 `miox-vue2x`：

```javascript
import Engine from 'miox-vue2x';
app.install(Engine);
```

## 3. 设置 webview 切换动画

如果你需要让页面切换时具有动画效果，直接使用官方提供 `miox-animation` 插件：

```javascript
import Animate from 'miox-animation';
app.install(Animate('slide'));
```

## 4. 设置路由规则

使用官方提供的 `miox-router` 来定义路由关系：

**routes.js**

```javascript
import Router from 'miox-router';
const router = new Router();
router.patch('/', async ctx => {
    await ctx.render(...);
});
export default router.routes();
```

我们引入这个路由：

```javascript
import routes from './routes';
app.use(routes);
```

## 5. 开始监听SPA的会话历史变更

一旦启动监听服务，Miox 才会正式接管 SPA。

```javascript
export default app.listen();
```

## 6. 完整代码

**app.js**

```javascript
import Miox from 'miox';
import Engine from 'miox-vue2x';
import Animate from 'miox-animation';
import routes from './routes';

const app = new Miox(options);
app.install(Engine);
app.install(Animate('slide'));
app.use(routes);
export default app.listen();
```

## 7. 编写 hello world 页面

**hello-world.vue**

```html
<template>
    <div class="page">
        <h1>Hello World!</h1>
    </div>
</template>
<script>
    import Vue from 'vue';
    export default Vue.extend({
        mounted() {
            console.log('Hello World is active');
        }
    })
</script>
```

修改 `routes.js` 中的代码为：

```javascript
import HelloWorld from './hello-world.vue';
router.patch('/', async ctx => {
    await ctx.render(HelloWorld);
});
```

## 8. 文件回顾

```shell
- app.js                 # spa 入口文件
- routes.js              # 集中定义所有路由规则
- hello-world.vue        # 业务页面，webview
```
