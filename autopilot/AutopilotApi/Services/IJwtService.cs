using AutopilotApi.Models;

namespace AutopilotApi.Services;

public interface IJwtService
{
    string GenerateToken(User user, int expirationMinutes = 60);
    bool ValidateToken(string token);
}
