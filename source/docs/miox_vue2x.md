title: miox-vue2x
---

实现 miox 和 vue@2.x 桥接的渲染引擎。

## 使用

```javascript
import Miox from 'miox';
import vueEngine from 'miox-vue2x';
import ExamplePage from './example-page.vue';

app = new Miox();
app.install(vueEngine);
app.use(async app => await app.render(ExamplePage));
app.listen();
```

**example-page.vue**

```html
<template>
    <ul>
        <li v-go="b">B</li>
        <li @click="click">C</li>
        <li><a href="javascript:void(0);" v-link="d">Baidu</a></li>
    </ul>
</template>
<script>
    import Vue from 'vue';

    export default Vue.extend({
        created() {
            this.$on("webview:enter", function() {
                console.log("webview has entered!!")
            });
        },
        data() {
            return {
                b: '/b',
                d: 'http://baidu.com'
            }
        },
        methods: {
            click() {
                this.$miox.push("/c");
            }
        }
    })
</script>
```

## Vue 增强

> 这里的 webview 就是 VueComponent 实例

> 与 miox-react 不同，vue 采用了事件模式进行消息通讯

### webview.on("webview:enter", callback)
当前webview切换入后触发，不管这个webview是立即创建的还是从缓存中恢复的

### webview.on("webview:leave", callback)
当前webview切换出后触发

### webview.on("webview:active", callback)
当前webview被再次激活时触发，如果当前webview是立即创建的，该函数不会被调用，只在从缓存中激活才被调用

### webview.on("webview:searchchange", callback: function (prevUrlObj, nextUrlObj) {})
仅在非 `strict` 模式下有效，URL变化不涉及 pathname 且有 search 部分变化时才被调用，参数是变化前的URL和变化后的URL对象，
这里的URL对象通过 `Url.parse(urlStr, true)` 构造出来的对象，具体属性请查看[文档](https://www.npmjs.com/package/url)。

### webview.on("webview:hashchange", callback: function (prevUrlObj, nextUrlObj) {})
URL变化只涉及 hash 部分变化时才被调用，参数是变化前的URL和变化后的URL对象，
这里的URL对象通过 `Url.parse(urlStr, true)` 构造出来的对象，具体属性请查看[文档](https://www.npmjs.com/package/url)。

### webview.$miox.$push/$go/$replace/$redirect/$link
与 SPA 的会话历史交互，是一个代理方法，实际上调用了 mixo 的同名方法

### vue 全局指令(directive)  ---  v-push/v-go/v-replace/v-redirect/v-link
同上

### v-go:animate 与 v-push:animate

我们为这次跳转设定特殊的动画，而不使用默认动画。不过MIox创建时候需要启动`session:true`与设置动画引擎。

> `animate`为此次动画的名称字符串

```html
<div v-go:push="url">test 1</div>
<div v-push:slide="url">test 2</div>
```

