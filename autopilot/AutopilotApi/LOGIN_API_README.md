# AutopilotApi - 用户登录API文档

## 概述

AutopilotApi 是一个 ASP.NET Core 10.0 Web API 项目，提供了用户登录身份验证功能和示例端点。

## 功能特性

- ✅ **用户登录 API** - 支持用户身份验证
- ✅ **JWT 令牌生成** - 生成安全的 JSON Web Token
- ✅ **密码哈希** - 使用 BCrypt 进行安全密码存储
- ✅ **示例 API 端点** - 天气预报示例端点
- ✅ **OpenAPI/Swagger** - 自动生成 API 文档

## 环境要求

- .NET 10.0 或更高版本
- Visual Studio、VS Code 或其他 C# 开发工具

## 项目结构

```
AutopilotApi/
├── Models/                 # 数据模型
│   ├── User.cs            # 用户模型
│   └── LoginRequest.cs    # 登录请求
├── Services/              # 业务逻辑服务
│   ├── IAuthService.cs    # 身份验证接口
│   ├── AuthService.cs     # 身份验证实现
│   ├── IJwtService.cs     # JWT 服务接口
│   └── JwtService.cs      # JWT 实现
├── Dto/                   # 数据传输对象
│   └── AuthResponse.cs    # 认证响应
├── Program.cs             # 应用程序入口和配置
├── appsettings.json       # 应用配置
└── AutopilotApi.csproj   # 项目文件
```

## API 端点

### 1. 登录端点
**请求方式**: `POST /auth/login`

**请求头**:
```
Content-Type: application/json
```

**请求体**:
```json
{
  "username": "demo",
  "password": "demo123"
}
```

**成功响应 (200 OK)**:
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "demo",
    "email": "demo@example.com",
    "createdAt": "2026-03-17T06:34:51.234Z",
    "isActive": true
  },
  "expiresAt": "2026-03-17T07:49:51Z"
}
```

**错误响应 (401 Unauthorized)**:
```
HTTP 401 Unauthorized
```

**错误响应 (400 Bad Request)**:
```json
{
  "success": false,
  "message": "Username and password are required"
}
```

### 2. 天气预报端点 (示例)
**请求方式**: `GET /weatherforecast`

**成功响应 (200 OK)**:
```json
[
  {
    "date": "2026-03-18",
    "temperatureC": 13,
    "summary": "Chilly",
    "temperatureF": 55
  }
]
```

## 预配置的测试用户

系统提供两个预配置用户用于测试：

| 用户名 | 密码 | 邮箱 |
|-------|------|------|
| demo | demo123 | demo@example.com |
| admin | admin123 | admin@example.com |

## 使用方式

### 1. 构建项目
```bash
cd autopilot\AutopilotApi
dotnet build
```

### 2. 运行项目
```bash
dotnet run
```

应用将在 `http://localhost:5000` 启动。

### 3. 测试登录 API

使用 curl:
```bash
curl -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"demo123"}'
```

使用 PowerShell:
```powershell
$body = @{
    username = "demo"
    password = "demo123"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:5000/auth/login" `
  -Method Post `
  -Body $body `
  -ContentType "application/json" `
  -UseBasicParsing
```

### 4. 查看 API 文档
访问 OpenAPI 文档: `http://localhost:5000/openapi/v1.json`

## JWT 令牌信息

- **算法**: HS256 (HMAC with SHA-256)
- **发行者**: AutopilotApi
- **受众**: AutopilotApiUsers
- **过期时间**: 60 分钟

令牌中包含以下声明:
- `NameIdentifier` - 用户 ID
- `Name` - 用户名
- `Email` - 用户邮箱

## 安全配置

JWT 配置位于 `appsettings.json`:

```json
"Jwt": {
  "SecretKey": "your-super-secret-key-that-is-long-enough-for-256-bits-encryption",
  "Issuer": "AutopilotApi",
  "Audience": "AutopilotApiUsers",
  "ExpirationMinutes": 60
}
```

⚠️ **重要**: 在生产环境中，应将密钥存储在安全的位置（如环境变量或 Azure Key Vault），不应提交到版本控制。

## 依赖包

项目使用以下 NuGet 包:

- `System.IdentityModel.Tokens.Jwt` (8.16.0) - JWT 令牌处理
- `BCrypt.Net-Next` (4.1.0) - 密码哈希

## 测试验证

✅ 项目编译成功
✅ 登录端点功能正常
✅ 正确的凭证返回 JWT 令牌
✅ 错误的凭证返回 401 Unauthorized
✅ 响应包含完整的用户信息和过期时间

## 下一步

- 集成实际数据库 (SQL Server, PostgreSQL 等)
- 添加 JWT 令牌验证中间件保护其他端点
- 实现用户注册端点
- 添加密码重置功能
- 添加用户权限和角色管理
- 完善错误处理和日志记录

## 许可证

本项目用于学习和演示目的。
