title: API
---

## Constructor

### `new Miox(options)`

| 参数               | 含义                                | 数据类型    | 默认值   |
| ---------------- | --------------------------------- | ------- | ----- |
| options.max      | SPA中允许缓存的最大 webview 个数            | number  | 1     |
| options.popState | 是否使用 popState 来改变会话历史，默认使用 hash | boolean | false |
| options.session  | 是否使用 sessionStorage 来存储SPA的会话历史 | boolean | false |
| options.strict   | 是否严格模式，非严格模式下search变化不会触发路由处理 | boolean | true  |

建议在移动端上使用：

```javascript
const options = {
    max: 3,
    popState: false,
    session: true,
    strict: false
}
```

在PC端使用：

```javascript
const options = {
    max: 1,
    popState: false,
    session: false,
    strict: true
}
```

使用SSR模式：

```javascript
const options = {
    max: 1,
    popState: true,
    session: false,
    strict: true
}
```

> **Note:**
>
> 以下 `app` 表示 `new Miox()` 取得的对象

## Property

### `app.container -- setter only`

在 app.listen() 之前才可以被设置，否则会产生错误。默认使用 `document.body`。

app.container 是一个 HTMLElement，它直接挂载了 app.element 元素。

### `app.element -- getter only`

miox DOM树的根节点，会（间接）挂载各个 webview，自身直接挂载在 app.container 上。

在 app.listen() 之后才可以被访问到。

### `app.request`

通过 `Url.parse(urlStr, true)` 构造出来的对象，
具体属性请查看[文档](https://www.npmjs.com/package/url)。

app.request 只能在 miox 运行时中才能被访问到。

> 在通过 `Url.parse` 构建出 request 对象之前，`urlStr` 已经被 miox 进行了标准化处理。
> 也就是说，在 hash 模式下的 `/a/b.html?c=d#/e/f?g=h` 会被标准化成 `/e/f?g=h&c=d` 才被运行时处理。

## Methods

### `app.use(middleware)`

添加一个运行时的中间件。

- **Arguments:**
    - `{async Function:(app, next) => {}} middleware`
- **Return:**
    - `{Miox}`
- **Usage:**
```javascript
app.use(fn1).use(fn5, fn6, [fn7, fn8]);
```

> 中间件回调函数中的 app 就是 miox 实例，且额外添加了 `app.request` 和 `app.render`。
> 调用 `next` 表示执行下一中间件。

### `app.push(url)`

打开指定URL对应的 webview，在会话历史中清空位于当前记录后的所有记录并新增一条记录。

- **Arguments:**
    - `{string} url`
- **Return:**
    - `{Promise}`
- **Usage:**
```javascript
app.push('/a/b?a=1#c');
```

### `app.replace(url)`

打开指定URL对应的 webview，在会话历史中替换当前记录。

- **Arguments:**
    - `{string} url`
- **Return:**
    - `{Promise}`
- **Usage:**
```javascript
app.replace('/a/b?a=1#c');
```

### `app.go(step)` / `app.go(url)`

- 如果参数为数字，则打开会话历史中相对当前记录距离为 step 的 URL。
- 如果参数为字符串，miox 会从会话历史中搜索是否已存在该URL。
    - 如果存在，计算出相对距离 step 后调用 `app.go(step)`
    - 如果不存在，调用 `app.push(url)`

- **Arguments:**
    - `{number} step | {string} url` 相对步数，或跳转地址
- **Return:**
    - `<Promise>`
- **Usage:**
```javascript
app.go(-2);
app.go(2);
app.go('/a/b?a=1#c');
```

### `app.redirect(url)`

重定向当前 webview 到指定URL对应的 webview

> 此方法属于中断式方法。

- **Arguments:**
    - `{string} url`
- **Return:**
    - `<Promise>`
- **Usage:**
```javascript
app.redirect('/a/b?a=1#c');
```

### `app.link(url)`

跳出当前SPA进入到其他页面时调用

- **Arguments:**
    - `{string} url`
- **Usage:**
```javascript
app.link('//www.baidu.com/');
```

### `app.listen()`

让 miox 接管整个 SPA 的控制权，会自动监听会话历史变化，实际就是启动了 miox 运行时。

### `app.render(webviewConstructor, args) -- 仅在请求响应过程中`

- 在没有缓存情况下，创建并挂载 webview；在有缓存情况下，获取缓存中的 webview（已挂载）
- 将上一步取到的 webview 与当前SPA的 active webview 进行状态交换(inactive <--> active)

内部会调用渲染引擎进行webview的创建，使用动画插件来完成切入切出动画。

- **Arguments:**
    - `{vueComponent | React.Component | ...} webviewConstructor` webview构造函数
    - `{object|undefined} args` 额外参数
- **Return:**
    - `<Promise>`
- **Usage:**
```javascript
import Home from './home.vue'
app.render(Home);
```

### `app.fetch`

用于自动适应环境选择的方法，详见 SSR 相关文档。

> 此方法仅能在SSR模式下使用

- **Arguments:**
    - `{Function} client`  client端回调
    - `{Function} server`  server端回调
- **Return:**
    - `<Promise>`
- **Usage:**
```javascript
app.fetch(async () => ajax.post('....', { a, b, c }));
```