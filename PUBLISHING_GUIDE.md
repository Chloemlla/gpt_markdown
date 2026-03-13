# 发布到 pub.dev 完整指南

本指南将教你如何从零开始将 Flutter 包发布到 pub.dev。

## 前置准备

### 1. 创建 pub.dev 账号

1. 访问 https://pub.dev
2. 点击右上角 "Sign in" 使用 Google 账号登录
3. 完成账号设置

### 2. 准备项目

确保你的项目符合 pub.dev 要求：

#### 必需文件

- ✅ `pubspec.yaml` - 包含正确的元数据
- ✅ `README.md` - 项目说明文档
- ✅ `CHANGELOG.md` - 版本更新日志
- ✅ `LICENSE` - 开源许可证
- ✅ `lib/` - 源代码目录
- ✅ `example/` - 示例代码（推荐）

#### 检查 pubspec.yaml

```yaml
name: your_package_name
description: 简短的包描述（60-180字符）
version: 1.0.0
homepage: https://github.com/your-username/your-package

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

## 本地发布流程

### 步骤 1: 验证包

```bash
# 检查包是否符合 pub.dev 要求
flutter pub publish --dry-run
```

这会检查：
- 包名是否可用
- 文件结构是否正确
- pubspec.yaml 是否有效
- 是否有必需的文件

### 步骤 2: 运行测试

```bash
# 运行所有测试
flutter test

# 检查代码格式
dart format --set-exit-if-changed .

# 分析代码
flutter analyze
```

### 步骤 3: 更新版本号

在 `pubspec.yaml` 中更新版本号：

```yaml
version: 1.0.0  # 遵循语义化版本
```

版本号规则：
- `MAJOR.MINOR.PATCH`
- `MAJOR`: 不兼容的 API 变更
- `MINOR`: 向后兼容的功能新增
- `PATCH`: 向后兼容的问题修复

### 步骤 4: 更新 CHANGELOG.md

```markdown
## 1.0.0

* 初始版本发布
* 添加 CSS 解析支持
* 完整的测试覆盖
```

### 步骤 5: 发布到 pub.dev

```bash
# 发布包
flutter pub publish
```

系统会：
1. 显示将要发布的文件列表
2. 要求你确认
3. 打开浏览器进行 Google 账号授权
4. 完成发布

## 使用 GitHub Actions 自动发布

### 步骤 1: 获取 pub.dev 凭证

1. 在本地运行一次手动发布：
   ```bash
   flutter pub publish --dry-run
   ```

2. 获取凭证文件：
   - Windows: `%APPDATA%\dart\pub-credentials.json`
   - macOS/Linux: `~/.pub-cache/credentials.json`

3. 复制文件内容

### 步骤 2: 添加 GitHub Secret

1. 进入 GitHub 仓库
2. 点击 `Settings` > `Secrets and variables` > `Actions`
3. 点击 `New repository secret`
4. 名称：`PUB_DEV_CREDENTIALS`
5. 值：粘贴 `pub-credentials.json` 的内容
6. 点击 `Add secret`

### 步骤 3: 创建 Git Tag 触发发布

```bash
# 提交所有更改
git add .
git commit -m "Release version 1.0.0"

# 创建标签
git tag v1.0.0

# 推送到 GitHub
git push origin main
git push origin v1.0.0
```

GitHub Actions 会自动：
1. 运行测试
2. 检查代码格式
3. 分析代码
4. 发布到 pub.dev

## 发布检查清单

在发布前，确保：

- [ ] 所有测试通过
- [ ] 代码格式正确
- [ ] 没有分析警告
- [ ] README.md 完整且清晰
- [ ] CHANGELOG.md 已更新
- [ ] 版本号已更新
- [ ] 示例代码可运行
- [ ] 文档完整
- [ ] LICENSE 文件存在

## 发布后

### 1. 验证发布

访问 https://pub.dev/packages/your_package_name 确认：
- 包信息正确
- 文档显示正常
- 示例代码可见
- 版本号正确

### 2. 添加徽章到 README

```markdown
[![pub package](https://img.shields.io/pub/v/your_package_name.svg)](https://pub.dev/packages/your_package_name)
[![popularity](https://img.shields.io/pub/popularity/your_package_name?logo=dart)](https://pub.dev/packages/your_package_name/score)
[![likes](https://img.shields.io/pub/likes/your_package_name?logo=dart)](https://pub.dev/packages/your_package_name/score)
[![pub points](https://img.shields.io/pub/points/your_package_name?logo=dart)](https://pub.dev/packages/your_package_name/score)
```

### 3. 推广你的包

- 在 Flutter 社区分享
- 在 Reddit r/FlutterDev 发帖
- 在 Twitter 上宣传
- 写博客文章介绍

## 更新已发布的包

### 发布新版本

1. 修改代码
2. 更新版本号
3. 更新 CHANGELOG.md
4. 运行测试
5. 创建新的 Git tag
6. 推送到 GitHub

```bash
# 更新版本
# 在 pubspec.yaml 中: version: 1.0.1

# 提交更改
git add .
git commit -m "Release version 1.0.1"

# 创建标签
git tag v1.0.1

# 推送
git push origin main
git push origin v1.0.1
```

## 常见问题

### Q: 包名已被占用怎么办？
A: 选择一个不同的包名。包名必须是唯一的。

### Q: 发布失败怎么办？
A: 检查错误信息，通常是：
- 版本号已存在
- 文件缺失
- pubspec.yaml 格式错误

### Q: 如何撤回已发布的版本？
A: pub.dev 不支持删除已发布的版本。你只能发布新版本来修复问题。

### Q: 如何转移包的所有权？
A: 在 pub.dev 包页面的 Admin 标签中可以添加其他维护者。

## 最佳实践

1. **语义化版本**：严格遵循 semver 规范
2. **完整文档**：提供清晰的 API 文档和示例
3. **测试覆盖**：保持高测试覆盖率
4. **及时更新**：定期更新依赖和修复问题
5. **响应社区**：及时回复 issues 和 pull requests
6. **保持兼容**：避免破坏性变更，或在主版本号中体现

## 本项目发布示例

对于 gpt_markdown 项目：

```bash
# 1. 确保所有测试通过
flutter test

# 2. 检查代码质量
dart format --set-exit-if-changed .
flutter analyze

# 3. 验证包
flutter pub publish --dry-run

# 4. 更新版本号（在 pubspec.yaml）
# version: 1.1.6

# 5. 更新 CHANGELOG.md
# ## 1.1.6
# * 添加 CSS 解析支持
# * 新增 HtmlTagMd 组件
# * 完整的测试覆盖

# 6. 提交并创建标签
git add .
git commit -m "feat: add CSS parsing support"
git tag v1.1.6
git push origin main
git push origin v1.1.6

# GitHub Actions 会自动发布到 pub.dev
```

## 参考资源

- [pub.dev 官方文档](https://dart.dev/tools/pub/publishing)
- [Flutter 包开发指南](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [语义化版本规范](https://semver.org/lang/zh-CN/)
- [Dart 包布局约定](https://dart.dev/tools/pub/package-layout)
