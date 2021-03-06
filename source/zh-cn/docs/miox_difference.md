title: Miox 与其他主流框架的不同点
---
> Miox是一个兼容多种渲染引擎的，提供高度自动化 Webview 生命周期管理的一个中间件/框架，同时提供了开箱即用的若干自动化脚手架，快速生成项目。它可以自动帮你处理路由切换、webview 生命周期管理等各种单页应用会面临的问题，让你专注于 webview 内的业务开发。Miox 实现了生命周期和路由管理的最佳实践，避免了不统一的开发方式可能造成的性能下降和错误，并且可以平滑接入SSR这样的开发技术，达到开发效率和接近原生体验两者之间的最佳平衡。Miox 并不依赖任何框架，这意味着你的业务开发无论是基于 React、Vue 还是其他框架，都可以完美的接入到其中来，无需担心是否在公司中不能使用某些框架的问题。

现在主流的框架，除去`Angular`，就只有`Vue`与`React`了。它们各自有各自的路由模块。总的来说，他们的路由模式，都是遵循自己的设计原则来设计的，都是采用组件化路由的思想，达到分发路由的目的。我们基于的理念与它们完全不同。我们基于服务端MPA的思想，表现在前端以SPA模式展现。我们的路由机制遵循`PAGE = TEMPLATE + DATA`思想实现。所以我们归纳出：

- `Miox`遵循后端路由思想，而`Vue`与`React`则遵循前端路由思想。
- `Miox`的页面之间数据不互通，需要通过Store等中间产物来达到互通，理论上是完全隔离的。而`Vue`与`React`则都是组件啊，数据上可以通过顶层（父）组件传递数据下来，页面之间数据可以互通。

## Vue-Router

它是一套静态路由，不具备动态选择组件的能力，需要通过各种`HOOK`手段来达到选择组件，比如说`<component />`组件等。但是在官方的文档上我们可以看到`动态路由匹配`，其实这是动态URI的概念，而非真正的动态路由概念。

```javascript
const router = new VueRouter({
  routes: [
    // 动态路径参数 以冒号开头
    { path: '/user/:id', component: User }
  ]
})
```

在实际的场景中，`/user/:id`变化的任意路径都只会对应到`User`组件，而非不同的组件来渲染。所以这个概念不是很正确。如果基于后端对路由概念到理解，那么我们应该是通过这样到模式来反映出动态路由的概念。

```javascript
router.get('/user/:id', ctx => {
  if (global.opened) {
    return ctx.render(webviewA);
  }
  ctx.render(webviewB);
})
```

这个demo中，表现出了既是动态URI，也是动态路由。

## React-Router

**React-router**的V4版本，已支持动态路由的概念。而这个我们早在2年前就已经提出，经过2年时间的沉淀才开源了这个框架。它们两者的区别在于是否单一页面管理和数据是否隔离上：

- `react-router`在**一个页面内基于状态不同分层为不同的组件**显示，做到了动态路由区分页面内容，内部可以共享顶层（父）组件数据。
- `Miox`分为多个页面由统一的`service`服务进行管理，数据隔离，不共享页面数据。

```javascript
<Route path="/home" render={() => <div>Home</div>}/>
```

在`render`中传入的回调，即可实现动态路由分发，但是`React`还未做的是性能上的考虑。

> 两者由于设计理念的差异，在不同的场景中各有利弊。

Miox另外一个优势在于，当我们使用KOA作为我们的服务应用框架，要接入Miox的时候，由于设计理念的一致性，我们完全可以直接接管掉`koa-router`来进行自我处理，意思就是对同构非常友好。当然说回来，REACT对后端的支持也非常好，`next.js`帮我们完成了这些工作。

Miox比较适合大型项目的开发，灵活的路由分层结构和服务化思想给大家带来很多类似后端书写的体验和维护体验。我们可以直接使用很多不关系`nodejs`环境变量的中间件包，而不用我们自己去重新造轮子。一套中间件也许就能直接在前端和后端同时使用，何乐而不为呢？

## 补充动态路由的性能说明

基于后端路由理念，体系无非就是`页面 = 模板 + 数据`。从这个公式上面，您可以看到，对于一个页面的渲染，模板至关重要。在Miox的世界里，模板就是我们所谓的`Vue`或者`react`。那么什么时候创建与什么时候销毁的问题，通过后端请求的机制可以知道，当一个URL进入的时候，我们会动态根据一些变量生成出数据，同时对应选择模板来渲染。MIox也是如此。Miox其实是架设在Web端的一套服务系统，简称`web service`。Miox将使用对应的模板和数据进行页面的渲染。但是考虑浏览器端的特殊性，比如渲染性能等问题，我们需要对其作出调整。最明显的做法就是加入缓存机制，我们是用空间来换效率和性能。我们会缓存这些生成出来的对象（类似后端最终生成出来的页面），加入到内存堆栈中，通过一种动态算法来计算进入的这个URL到底是要从缓存中拿还是需要重新创建。算法可能比较复杂，您可以通过[这里](https://github.com/51nb/miox/blob/master/src/miox/src/lib/render.js)看下源码。我们会将浏览过的页面缓存起来，表现为节点的堆叠。当然我们也不会那么傻，节点堆叠多了，也是要影响性能的。所以在Miox启动服务之前，我们就会让用户设置一个`max`属性，让用户来选择我们最大缓存多少个页面。当每次渲染后，发现页面缓存堆栈超过了这个最大的指，那么我们会通过`最远距离`关系将那个需要被删除的页面（对象）给删除，达到一种动态平衡。

再说一点比较深入的，其实我们的缓存不仅仅存在于页面堆栈，还在于您渲染的模板上，您可以通过`webview.dic`属性来看下这个模板上被缓存的一些特征。我们的原则是，路由不对应具体页面，而是对应具体页面的`constructor`原型对象。这个点，很多小伙伴由于没有看过`render.js`的实现而没能理解。这个才是缓存特性的关键，理论来讲，路由不对应页面，而是对应生成页面的原型对象。



