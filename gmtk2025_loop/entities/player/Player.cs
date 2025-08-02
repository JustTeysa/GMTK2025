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
	[Export] 
	public int TotalJumps = 1;
	
	[Export] 
	public string Item = "NONE";
	
	private AnimatedSprite2D animatedSprite2d;
	
	public const int MAX_VELOCITY = 5;
	
	private const string moveRight = "walk_right";
	private const string moveLeft = "walk_left";
	private const string interact = "interact";
	private const string jump = "jump";
	
	private bool grounded = false;
	private int jumpCount = 0;

	private float airTime = 0.0f;
	private float jumpXScale = 0.9f;
	
	bool squashing = false;
	private float defaultYScale = 1.0f;
	private float defaultXScale = 1.0f;
	private float squashPower = 0.0001f;
	private float maxSquashMagnitude = 0.4f;
	private float squashSpeed = 0.1f;
	private float unsquashSpeed = 0.06f;
	private float bigSquashSpeed = 0.2f;
	private float bigUnsquashSpeed = 0.15f;
	private float squashYTarget = 0.0f;
	private float squashXTarget = 0.0f;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		animatedSprite2d = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		defaultYScale = animatedSprite2d.Scale.Y;
		defaultXScale = animatedSprite2d.Scale.X;
		maxSquashMagnitude = defaultYScale * maxSquashMagnitude;
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
		CheckImpact();
		//animatedSprite2d.
	}

	private void Movement(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta * GravityMod;
			grounded = false;
			airTime += (float)delta;
		}
		else
		{
            grounded = true;
			jumpCount = 0;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed(jump))
		{
			if (jumpCount < TotalJumps)
			{
				jumpCount++;
				velocity.Y = JumpVelocity;
				grounded = false;
                animatedSprite2d.Play("jump");
            }
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

	private bool bigSquash = false;
	private void CheckImpact()
	{
		if (airTime > 0.2f && !squashing && IsOnFloor())
		{
            squashing = true;
			squashYTarget = Mathf.Clamp(airTime * squashPower * animatedSprite2d.Scale.Y, maxSquashMagnitude, defaultYScale);

			squashYTarget = (airTime < 1.0f) ? 0.70f * animatedSprite2d.Scale.Y : 0.3f * animatedSprite2d.Scale.Y;
			squashXTarget = (airTime < 1.0f) ? 1.2f * animatedSprite2d.Scale.X : 1.8f * animatedSprite2d.Scale.X;

			bigSquash = (airTime > 1.0f);
			
			airTime = 0.0f;
		}

		float sqSpd = 1.0f;
		if (squashing)
		{
			if (bigSquash)
				sqSpd = bigSquashSpeed;
			else
				sqSpd = squashSpeed;
			
			//animatedSprite2d.Scale = new Vector2(animatedSprite2d.Scale.X, Mathf.MoveToward(animatedSprite2d.Scale.Y, squashYTarget, squashSpeed));
			animatedSprite2d.Scale = new Vector2(Mathf.MoveToward(animatedSprite2d.Scale.X, squashXTarget, sqSpd), Mathf.MoveToward(animatedSprite2d.Scale.Y, squashYTarget, sqSpd));
			if (animatedSprite2d.Scale.Y == squashYTarget)
			{
				squashing = false;
			}
		}
		else
		{
			if (bigSquash)
				sqSpd = bigUnsquashSpeed;
			else
				sqSpd = unsquashSpeed;
			//animatedSprite2d.Scale = new Vector2(animatedSprite2d.Scale.X, Mathf.MoveToward(animatedSprite2d.Scale.Y, defaultYScale, unsquashSpeed));
			animatedSprite2d.Scale = new Vector2(Mathf.MoveToward(animatedSprite2d.Scale.X, defaultXScale, sqSpd), Mathf.MoveToward(animatedSprite2d.Scale.Y, defaultYScale, sqSpd));
		}
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
					animatedSprite2d.FlipH = false;
				}
				else if (Velocity.X > 0)
				{
					animatedSprite2d.FlipH = true;
				}
			}
			else
			{
				animatedSprite2d.Play("idle");
			}
		}
		else
		{
			//if (animatedSprite2d.Animation != "jump")
			
			if (Velocity.X < 0)
			{
				animatedSprite2d.FlipH = false;
			}
			else if (Velocity.X > 0)
			{
				animatedSprite2d.FlipH = true;
			}
		}
	}
}
