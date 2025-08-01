using Godot;
using System;

public partial class Main : Node
{
	//[Export]
	//public Area2D Player;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		NewGame();
	}
	
	public void NewGame()
	{
		var startPosition = GetNode<Marker2D>("StartPosition");
		
		//Player.Start(startPosition.Position);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
