title: 核心目录结构
---

## 文件描述

```shell
.
├── index.js                # 入口文件
├── lib
│   ├── animate.js          # 与 webview 切换，切换动画对接
│   ├── history.js          # SPA 会话记录管理
│   ├── index.js            # Miox 核心实现
│   ├── plugin.js           # 集中管理渲染引擎插件和动画切换插件
│   ├── render.js           # app.render 实现，包括 webview 的缓存实现
│   ├── session.js          # 使用 sessionStorage 来维护 SPA 的会话历史
│   ├── util.js
│   └── webtree.js          # 实现 miox 顶层DOM树
└── miox_modules
    ├── dictionary.js       # 实现一个 observable Object
    ├── events.js           # 实现 async event emmiter
    ├── middleware.js       # 中间件机制，参考了 koa-middleware
    ├── request.js          # 请求
    └── response.js         # 响应
```

## 内部数据结构

![内部数据结构](https://pic.51zhangdan.com/u51/storage/85/8c5f1e7c-92e9-2ec1-f499-2ffb7c5ac6d5.png)



