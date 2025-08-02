using Godot;
using System;

public partial class Player : CharacterBody2D
{
	[Export]
	public float Speed = 300.0f;
	[Export]
	public float JumpVelocity = -400.0f;
	
	[Export]
	public float GravityMod = 1.0f;
	
	private AnimatedSprite2D animatedSprite2d;
	
	public const int MAX_VELOCITY = 5;
	
	private const string moveRight = "walk_right";
	private const string moveLeft = "walk_left";
	private const string interact = "interact";
	private const string jump = "jump";
	
	private bool grounded = false;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		animatedSprite2d = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
	}
	
	public void Start(Vector2 spawnPosition)
	{
		//Position = spawnPosition;
		//GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;
	}
	
	public override void _PhysicsProcess(double delta)
	{
		Movement(delta);
		SetAnimation();
	}

	private void Movement(double delta)
	{
		Vector2 velocity = Velocity;
		grounded = true;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta * GravityMod;
			grounded = false;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed(jump) && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
			grounded = false;
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

		Velocity = velocity;
		MoveAndSlide();
	}

	private void SetAnimation()
	{
		if (IsOnFloor())
		{
			if (Velocity.X != 0)
			{
				animatedSprite2d.Play("walk");
				if (Velocity.X < 0)
				{
					animatedSprite2d.FlipH = true;
				}
				else if (Velocity.X > 0)
				{
					animatedSprite2d.FlipH = false;
				}
			}
			else
			{
				animatedSprite2d.Play("idle");
			}
		}
		else
		{
			animatedSprite2d.Play("jump");
			
			if (Velocity.X < 0)
			{
				animatedSprite2d.FlipH = true;
			}
			else if (Velocity.X > 0)
			{
				animatedSprite2d.FlipH = false;
			}
		}
	}
}
