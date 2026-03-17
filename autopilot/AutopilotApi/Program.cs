using AutopilotApi.Services;
using AutopilotApi.Models;
using AutopilotApi.Dto;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IJwtService, JwtService>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast =  Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast")
.Produces<IEnumerable<WeatherForecast>>(StatusCodes.Status200OK);

app.MapPost("/auth/login", (LoginRequest request, IAuthService authService, IJwtService jwtService) =>
{
    if (string.IsNullOrWhiteSpace(request.Username) || string.IsNullOrWhiteSpace(request.Password))
    {
        return Results.BadRequest(new AuthResponse
        {
            Success = false,
            Message = "Username and password are required"
        });
    }

    var user = authService.Authenticate(request.Username, request.Password);
    if (user == null)
    {
        return Results.Unauthorized();
    }

    var token = jwtService.GenerateToken(user);
    var expiresAt = DateTime.UtcNow.AddMinutes(60);

    var response = new AuthResponse
    {
        Success = true,
        Message = "Login successful",
        Token = token,
        ExpiresAt = expiresAt,
        User = new UserDto
        {
            Id = user.Id,
            Username = user.Username,
            Email = user.Email,
            CreatedAt = user.CreatedAt,
            IsActive = user.IsActive
        }
    };

    return Results.Ok(response);
})
.WithName("Login")
.Produces<AuthResponse>(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest)
.Produces(StatusCodes.Status401Unauthorized);

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
