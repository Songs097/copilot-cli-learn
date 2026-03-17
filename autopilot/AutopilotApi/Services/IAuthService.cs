using AutopilotApi.Models;

namespace AutopilotApi.Services;

public interface IAuthService
{
    User? Authenticate(string username, string password);
    User? GetUserByUsername(string username);
}
