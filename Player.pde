/**
 * Represents a player in a 2D platformer game.
 * Handles movement, jumping, gravity, and interactions with platforms and coins.
 */
class Player extends GameObject{
  /** The player's width (default: 40) */
  float w = 40;

  /** The player's height (default: 40) */
  float h = 40;

  /** The player's vertical velocity (affected by gravity and jumping) */
  float yVelocity = 0;

  /** The acceleration due to gravity */
  float gravity = 0.6f;

  /** The force applied when jumping (a negative value for upward movement) */
  float jumpForce = -15;

  /** Indicates whether the player is currently on a platform */
  boolean onPlatform = false;

  /**
   * Constructs a Player at a specified position.
   *
   * @param x the x-coordinate of the player
   * @param y the y-coordinate of the player
   */
  Player(float x, float y) {
    super(x,y);
  }

  /**
   * Calculates the maximum vertical height the player can reach with a jump.
   *
   * @return the estimated jump height
   */
  float getMaxJumpHeight() {
    return (jumpForce * jumpForce) / (2 * gravity); // h = v² / (2g)
  }

  /**
   * Estimates the maximum horizontal distance the player can reach while in the air during a full jump.
   *
   * @return the estimated horizontal reach
   */
  float getMaxHorizontalReach() {
    float timeInAir = (-2 * jumpForce) / gravity; // total time in air
    return 5 * timeInAir * 0.6f; // 60% margin to account for user input delays
  }

  /**
   * Updates the player's position and velocity based on gravity and keyboard input.
   * Allows horizontal movement and wraps the player horizontally on screen edges.
   */
  void update() {
    yVelocity += gravity;
    y += yVelocity;

    if (keyPressed) {
      if (keyCode == LEFT) x -= 5;
      else if (keyCode == RIGHT) x += 5;
    }

    // Wrap around horizontally if player goes off-screen
    if (x < 0) x = width;
    if (x > width) x = 0;
  }

  /**
   * Draws the player on the screen as a red rectangle with rounded corners.
   */
  void display() {
    fill(255, 0, 0);
    rect(x, y, w, h, 8);
  }

  /**
   * Makes the player jump by setting their vertical velocity.
   */
  void jump() {
    yVelocity = jumpForce;
  }

  /**
   * Checks if the player is colliding with a platform and triggers a jump when landing on it.
   *
   * @param p the platform to check collision against
   */
  void checkCollision(Platform p) {
    if (yVelocity > 0 &&
        x + w > p.x && x < p.x + p.w &&
        y + h >= p.y && y + h <= p.y + p.h) {
      y = p.y - h;  // Position the player on top of the platform
      jump();       // Auto-jump upon landing
    }
  }

  /**
   * Checks if the player collides with a given coin.
   *
   * @param c the coin to check
   * @return true if the player's bounds intersect with the coin's bounds
   */
  boolean collidesWithCoin(Coin c) {
    return (c.x + c.size / 2 > x &&
            c.x - c.size / 2 < x + w &&
            c.y + c.size / 2 > y &&
            c.y - c.size / 2 < y + h);
  }
}
