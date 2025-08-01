using Godot;
using System;

public partial class Player : Area2D
{
	[Export]
	public int Speed {get; set; } = 400;
	public Vector2 ScreenSize;
	public Vector2 Velocity;
	
	public const int MAX_VELOCITY = 5;
	
	private AnimatedSprite2D animatedSprite2d;
	private const string moveRight = "move_right";
	private const string moveLeft = "move_left";
	private const string interact = "interact";
	private const string jump = "jump";
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ScreenSize = GetViewportRect().Size;
	}
	
	public void Start(Vector2 position)
	{
		Position = position;
		//Show();
		GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;
		//animatedSprite2d = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		HandleInputs();
		
		//Update position & clamp to screen bounds
		Position += Velocity * (float)delta;
		Position = new Vector2(x: Mathf.Clamp(Position.X, 0 , ScreenSize.X), y: Mathf.Clamp(Position.Y, 0, ScreenSize.Y));
	}
	
	private void HandleInputs()
	{
		Velocity = Vector2.Zero;
		
		if (Input.IsActionPressed(moveRight))
		{
			Velocity.X += 1;
		}
		
		if (Input.IsActionPressed(moveLeft))
		{
			Velocity.X -= 1;
		}
		
		if (Input.IsActionPressed(jump))
		{
			Velocity.Y -= 1;
		}
		
		if (Input.IsActionPressed(interact))
		{
			Velocity.X += 1;
		}
		
		if (Velocity.Length() > 0)
		{
			Velocity = Velocity.Normalized() * Speed;
			//animatedSprite2d.Play();
		}
		else
		{
			//animatedSprite2d.Stop();
		}
	}
}
