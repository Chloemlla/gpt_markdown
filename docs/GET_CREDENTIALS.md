# 获取 pub.dev 凭证的步骤

## 第一步：运行发布命令

在项目目录下运行：

```bash
cd F:\Repositories\GitHub\gpt_markdown
flutter pub publish --dry-run
```

## 第二步：完成 Google 账号授权

命令会自动打开浏览器，要求你：
1. 使用 Google 账号登录 pub.dev
2. 授权 Dart 访问你的 pub.dev 账号
3. 完成授权后，浏览器会显示成功消息

## 第三步：获取凭证文件

授权成功后，凭证文件会自动生成在：

```
C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json
```

## 第四步：复制凭证内容

运行以下命令查看凭证内容：

```bash
cat "C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json"
```

或者直接用记事本打开：

```bash
notepad "C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json"
```

## 第五步：添加到 GitHub Secrets

1. 复制整个 JSON 文件的内容
2. 进入 GitHub 仓库：https://github.com/ContextFound/gpt_markdown
3. 点击 `Settings` > `Secrets and variables` > `Actions`
4. 点击 `New repository secret`
5. Name: `PUB_DEV_CREDENTIALS`
6. Value: 粘贴刚才复制的 JSON 内容
7. 点击 `Add secret`

## 完成！

现在你可以使用 GitHub Actions 自动发布了。

## 注意事项

- ⚠️ 凭证文件包含敏感信息，不要公开分享
- ⚠️ 不要将凭证文件提交到 Git
- ✅ 凭证文件只需要获取一次，可以重复使用
- ✅ 如果凭证过期，重新运行 `flutter pub publish --dry-run` 即可

## 快速命令

```bash
# 1. 生成凭证
cd F:\Repositories\GitHub\gpt_markdown
flutter pub publish --dry-run

# 2. 查看凭证
cat "C:\Users\Administrator\AppData\Roaming\dart\pub-credentials.json"

# 3. 复制内容到 GitHub Secrets
```
