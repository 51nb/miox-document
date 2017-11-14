title: 如何下载与安装？
---

Miox编译基于`Nodejs`运行环境，采用`webpack`打包编译。请使用的小伙伴优先确认已安装了`Nodejs`环境。

## 源码

- Github: [https://github.com/51nb/miox](https://github.com/51nb/miox)
- NPM Package: [https://www.npmjs.com/package/miox](https://www.npmjs.com/package/miox)

## 脚手架工具

开始项目时，通过使用`miox-cli`，可以迅速生成Miox开发所需环境和配置，无需担心上手配置问题。

官方推荐使用`miox-cli`来创建您的项目。如果你对Miox熟悉，那么你可以自己创建一套适合自己的模板，方便以后自己的重复创建。

```bash
npm install -g miox-cli
```

官方提供两套模板，基于浏览器端渲染的模板和基于[koa](https://www.npmjs.com/package/koa)的SSR模板。模板一旦创建完毕，业务逻辑即可开始编写，你只需要专注于内部业务逻辑的开发。

```bash
# 创建一个项目/工程/应用
miox create
```

> [miox-cli 使用文档](https://github.com/51nb/miox-cli)

## miox 组成

Miox主要分以下几部分组成：

- 核心：`miox`
- 路由插件：`miox-router`
- 引擎插件：`miox-vue2x` `miox-react`
- 动画插件：`miox-animation`
- 其他插件：`miox-vue2x-container`
- 服务端渲染：
    - `miox-koa-vue2x-server-render`
    - `miox-express-vue2x-server-render`
    - `miox-koa-react-server-render`
    - `miox-express-react-server-render`
- webpack: `miox-vue2x-webpack-config`

除了核心，你可以使用自己编写的插件替换掉其中的任意部分，但是对于初学者，并不建议马上编写自己的插件。
开发者根据自己需要从 npm 上安装对应模块。

```shell
npm install miox-*
```
