/**
 * Represents a collectible coin in a game.
 * Coins can be displayed and marked as collected.
 */
class Coin {
  /** The x-coordinate of the coin's position */
  float x;

  /** The y-coordinate of the coin's position */
  float y;

  /** The diameter of the coin (default: 15) */
  float size = 15;

  /** Indicates whether the coin has been collected */
  boolean collected = false;

  /**
   * Constructs a Coin at the specified position.
   *
   * @param x the x-coordinate of the coin
   * @param y the y-coordinate of the coin
   */
  Coin(float x, float y) { 
    this.x = x; 
    this.y = y; 
  }

  /**
   * Displays the coin on the screen as a yellow circle if it hasn't been collected.
   */
  void display() { 
    if (!collected) {   
      fill(255, 215, 0); // Yellow color
      ellipse(x, y, size, size); // Draw the coin as a circle
    } 
  }
}
