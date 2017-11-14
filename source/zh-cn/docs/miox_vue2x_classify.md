title: miox-vue2x-classify
---

支持以 [Class](http://es6.ruanyifeng.com/#docs/class) + [Decorator](http://es6.ruanyifeng.com/#docs/decorator) 的方式书写Vue.


## 语法规则

- data通过赋值语句直接写在类体内；

- 计算属性通过getter 和 setter直接写在类体内；

- methods直接声明为类的成员方法；

- render直接声明为类的成员方法，但更推荐在*.vue文件中，通过template指定模板；

- 生命周期钩子，以生命周期的事件名作为方法名，声明为类的成员方法，并通过 @life 修饰；

- watch的属性，以要监听的属性名作为方法名，声明为类的成员方法，并通过 @watch 修饰；

- filters，以过滤名称作为方法名，声明为类的成员方法，并通过 @filter 修饰；

- directives，以指令名称（不含 v- 前缀）作为方法名，声明为类的成员方法，并通过 @directives 修饰，注意返回值需为对象。或者，通过@Component参数声明；

- renderError 和 errorCapture 直接声明为类的成员方法，并通过 @error 修饰;

- 其他选项，作为 @Component(options) 的options传入。


## 示例

```html
// index.vue

<script>
import { Component, life, filter, watch, directive } from  'miox-vue2x-classify';
import Loading from '../components/loading/index.vue';
import BaseMixin from '../mixins/base/index.js';

@Component({
    components: {
        loading: Loading,
    },
    mixins: [BaseMixin],
})
export default class Test {
    /*
        第一部分：数据相关
        建议按照 data --> computed --> watch --> filter 的顺序声明
    */
    // data属性
    isLoading = true;
    greeting = 'Hello';
    num = 1;
    username = '';
    response = '';
    done = false;

    // computed属性
    get fullGreeting() {
        return `${this.greeting} World!`;
    }

    @watch done(newVal, oldVal) {
        // sayHi为base mixin中定义的方法
        newVal === true && this.sayHi(this.username);
    }

    @filter double(val) {
        return val * 2;
    }

    /*
        第二部分：指令 和 生命周期
    */
    // 自定义指定
    @directive focus() {
        return {
            // 当元素插入DOM后自动聚集
            inserted(el) {
                el.focus();
            }
        };
    }

    // 生命周期
    @life mounted() {
        window.setTimeout(() => {
            this.isLoading = false;
        }, 1000);
    }

    // 普通方法
    accept() {
        this.response = `Good, we are firends now :)`;
    }

    refuse() {
        this.response = `Ok, wish you'll change your mind soon :)`;
    }
}
</script>
```

```javascript
// mixins/base.js

export default {
    data() {
        return {
            a: 1,
            msg: 'hi',
        };
    },
    methods: {
        sayHi(name) {
            console.log(`${this.msg}, ${name}!`);
        },
    },
};
```

```html
// index.html

<div>
    <loading v-if="isLoading" />
    <template v-else>
        <h1>{{ fullGreeting }}</h1>
        <p>data from mixin: {{a}}, data handled by filter: {{num | double}}</p>
        <p>
            Please input your name:
            <input
                type="text"
                v-focus v-model="username"
                @keyup.enter="done = true;"/>
        </p>
        <p v-if="done">
            Hello, {{username}}! <br/> Can we be friends?
            <button @click="accept">Sure</button>
            <button @click="refuse">Nope</button>
        </p>
        <p v-if="response">{{response}}</p>
    </template>
</div>
```
