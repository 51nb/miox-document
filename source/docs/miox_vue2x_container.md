title: miox-vue2x-container
---

默认情况下，当url发生改变时，Miox会重新渲染整个视图（webview）。在大部分情况下，这正是我们想要的。但在某些情况下，例如在后台管理系统中，我们希望能做局部渲染。插件 `miox-vue2x-container`正是为此而生。


## 用法

Step1. 在项目的入口js中，引入 miox-vue2x-container 插件，并注册局部渲染容器组件：

```javascript
// entry.js

import Miox from 'miox';
import VueContainer from 'miox-vue2x-container';
import Container from './components/container/index.vue';

const app = new Miox();

// 注册局部渲染容器组件
app.install(VueContainer(Container));

// 其他代码...
```

Step2. 在容器组件中，指定作为局部渲染容器的Dom元素:

```javascript
<template>
    <div>
        <header><h1>后台管理系统</h1></header>
        <aside>
            <menu>
                <ul>
                    <li v-go="'/user/list'">用户管理</li>
                    <li v-go="'/product/list'">商品管理</li>
                </ul>
            </menu>
        </aside>
        <!-- 局部渲染容器 -->
        <div class="container" ref="container"></div>
    </div>
</template>

<script>
    import { Component } from 'miox-vue2x-component-classify';

    @Component
    export default class Index {
        // 指定局部渲染容器
        // 注意：名称是固定的，必须是 mioxContainerElement
        get mioxContainerElement() {
            return this.$refs.container;
            // 注意：当容器是组件（非html原生标签）时，应返回container.$el
        }

        // 其他方法和属性声明...
    }
</script>
```

Step3. 在页面的template中，只写各自的内容即可：

```javascript
// 首页，路径为 /

<template>
    <p>欢迎来到XXX后台管理系统，请点击左侧菜单选择你要管理的内容</p>
</template>

<script>
    import { Component } from  'miox-vue2x-component-classify';

    @Component
    export default class Index {}
</script>
```

```javascript
// 用户列表页，路径为 /user/list

<template>
    <ul class='user-list'>
        <li v-for="(user, index) in users" key="index">{{user}}</li>
    </ul>
</template>

<script>
    import { Component } from  'miox-vue2x-component-classify';

    @Component
    export default class UserList {
        users = ['user1', 'user2', 'user3'];
    }
</script>
```

```javascript
// 商品列表页，路径为 /product/list

<template>
    <ul class='product-list'>
        <li v-for="(product, index) in products" key="index">{{product}}</li>
    </ul>
</template>

<script>
    import { Component } from  'miox-vue2x-component-classify';

    @Component
    export default class ProductList {
        products = ['product1', 'product2', 'product3'];
    }
</script>
```

> 需要说明的是，一旦设置了局部渲染，项目中所有页面都只会渲染在局部容器中，暂时不支持对个别页面进行全屏渲染。