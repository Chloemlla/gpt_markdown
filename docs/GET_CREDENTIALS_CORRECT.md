# 🔑 获取 pub.dev 凭证 - 正确步骤

## ⚠️ 重要说明

`flutter pub publish --dry-run` 只是验证包，**不会**触发授权。

要获取凭证，需要运行真正的发布命令。

## ✅ 正确步骤

### 方式 1：直接发布（推荐）

如果你准备好发布了，直接运行：

```bash
cd F:\Repositories\GitHub\gpt_markdown
flutter pub publish
```

这会：
1. ✅ 打开浏览器进行 Google 账号授权
2. ✅ 生成凭证文件
3. ✅ 发布包到 pub.dev

### 方式 2：只获取凭证（不发布）

如果你只想获取凭证，不想现在发布：

```bash
# 1. 运行发布命令
flutter pub publish

# 2. 在浏览器完成授权

# 3. 当提示 "Do you want to publish gpt_markdown 1.1.5 to https://pub.dev (y/N)?" 时
#    输入 N (不发布)

# 4. 凭证已经生成，可以取消发布
```

## 📍 凭证文件位置

授权成功后，凭证文件会生成在：

```
C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json
```

## 🔍 查看凭证

```bash
cat "C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json"
```

或用记事本打开：

```bash
notepad "C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json"
```

## 📋 下一步

1. **如果选择方式 1（直接发布）**：
   - 包会立即发布到 pub.dev
   - 凭证文件已生成
   - 可以将凭证添加到 GitHub Secrets 用于后续自动发布

2. **如果选择方式 2（只获取凭证）**：
   - 凭证文件已生成
   - 包没有发布
   - 将凭证添加到 GitHub Secrets
   - 后续使用 GitHub Actions 自动发布

## 💡 建议

**推荐方式 1（直接发布）**，因为：
- ✅ 包已经验证通过
- ✅ 测试全部通过
- ✅ 一步完成发布和凭证获取
- ✅ 可以立即在 pub.dev 上看到你的包

## ⚡ 快速命令

```bash
# 直接发布（推荐）
cd F:\Repositories\GitHub\gpt_markdown
flutter pub publish
# 在提示时输入 y 确认发布
```

准备好了吗？运行 `flutter pub publish` 开始吧！
