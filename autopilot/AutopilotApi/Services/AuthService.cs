using AutopilotApi.Models;
using BCrypt.Net;

namespace AutopilotApi.Services;

public class AuthService : IAuthService
{
    // 简单的内存用户存储 (演示版本)
    private static readonly Dictionary<string, User> Users = new()
    {
        {
            "demo",
            new User
            {
                Id = 1,
                Username = "demo",
                Email = "demo@example.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("demo123"),
                CreatedAt = DateTime.UtcNow,
                IsActive = true
            }
        },
        {
            "admin",
            new User
            {
                Id = 2,
                Username = "admin",
                Email = "admin@example.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
                CreatedAt = DateTime.UtcNow,
                IsActive = true
            }
        }
    };

    public User? Authenticate(string username, string password)
    {
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            return null;

        var user = GetUserByUsername(username);
        if (user == null || !user.IsActive)
            return null;

        if (BCrypt.Net.BCrypt.Verify(password, user.PasswordHash))
            return user;

        return null;
    }

    public User? GetUserByUsername(string username)
    {
        if (string.IsNullOrEmpty(username))
            return null;

        return Users.TryGetValue(username.ToLower(), out var user) ? user : null;
    }
}
