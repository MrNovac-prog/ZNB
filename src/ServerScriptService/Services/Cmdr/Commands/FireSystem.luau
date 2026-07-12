return {
    Name = "fireSystem";
    Aliases = {"fire", "f"};
    Description = "Fire the core gun system";
    Group = "Admin";
    Args = {
        {
           Type = "player";
            Name = "Player";
            Description = "Player to fire the gun system for";
        },
        {
            Type = "boolean";
            Name = "Enable";
            Description = "Enable or Disable system";
        }
    }
}