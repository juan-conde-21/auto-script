using System.Globalization;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var logger = app.Logger;

int RollDice()
{
    return Random.Shared.Next(1, 7);
}

string HandleRollDice(string? player)
{
    var result = RollDice();

    if (string.IsNullOrEmpty(player))
    {
        logger.LogInformation($"Anonymous player is rolling the dice: {result}", result.ToString());
    }
    else
    {
        logger.LogInformation("{player} is rolling the dice: {result}", player, result);
    }


    switch (result)
    {
        case < 3:
            logger.LogError($"Lower value {result}");
            break;
        case < 4:
            logger.LogCritical($"Medium value {result}");
            break;
        default:
            logger.LogWarning($"High value {result}");
            break;
    }

    return result.ToString(CultureInfo.InvariantCulture);
}

app.MapGet("/rolldice/{player?}", HandleRollDice);

app.Run();
