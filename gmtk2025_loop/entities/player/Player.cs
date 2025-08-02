using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;
	
	public Vector2 ScreenSize;
	//public Vector2 Velocity;
	
	//[Export]
	private AnimatedSprite2D animatedSprite2d;
	
	public const int MAX_VELOCITY = 5;
	
	private const string moveRight = "walk_right";
	private const string moveLeft = "walk_left";
	private const string interact = "interact";
	private const string jump = "jump";
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ScreenSize = GetViewportRect().Size;
		animatedSprite2d = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		//Position = new Vector2(ScreenSize.X / 2, ScreenSize.Y / 2);
		
	}
	
	public void Start(Vector2 spawnPosition)
	{
		//Position = spawnPosition;
		//Show();
		GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	/*
	public override void _Process(double delta)
	{
		HandleInputs();
		
		//Update position & clamp to screen bounds
		Position += Velocity * (float)delta;
		Position = new Vector2(x: Mathf.Clamp(Position.X, 0 , ScreenSize.X), y: Mathf.Clamp(Position.Y, 0, ScreenSize.Y));
	}
	*/
	
	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed(jump) && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector(moveLeft, moveRight, "ui_up", "ui_down");
		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * Speed;
			
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
		}

		if (velocity.X != 0)
		{
			animatedSprite2d.Play("walk");
			if (velocity.X < 0)
			{
				animatedSprite2d.FlipH = true;
			}
			else if (velocity.X > 0)
			{
				animatedSprite2d.FlipH = false;
			}
		}
		else
		{
			animatedSprite2d.Play("idle");
		}

		Velocity = velocity;
		MoveAndSlide();
	}
	
	//IM DED
	/*
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
	*/
}
