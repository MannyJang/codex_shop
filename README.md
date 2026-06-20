# 拾味庭 Vue 3 首页

这是一个使用 Vue 3 和 Vite 构建的项目，不能通过双击 `index.html` 运行。

## 启动方式

双击 `start.command`，或在项目目录运行：

```bash
npm run start
```

然后访问：

```text
http://127.0.0.1:4173/
```

## 其他命令

```bash
npm run build
npm run preview
```

## Supabase 预约数据库

1. 在 Supabase 项目的 SQL Editor 中执行：

   ```text
   supabase/migrations/20260620000000_create_reservation.sql
   ```

2. 复制环境变量模板并填写项目设置中的 Project URL 和 Publishable key：

   ```bash
   cp .env.example .env.local
   ```

3. 重启开发服务器。预约表单会向 `public.reservation` 写入数据。

表已启用 Row Level Security。公开网页仅有新增权限，没有读取、修改或删除预约记录的权限。
