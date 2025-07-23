/**
 * Represents a platform in a 2D game environment.
 * Characters can stand or land on this platform.
 */
class Platform {
  /** The x-coordinate of the platform's top-left corner */
  float x;

  /** The y-coordinate of the platform's top-left corner */
  float y;

  /** The width of the platform (default: 80) */
  float w = 80;

  /** The height of the platform (default: 15) */
  float h = 15;

  /**
   * Constructs a platform at the specified position.
   *
   * @param x the x-coordinate of the platform
   * @param y the y-coordinate of the platform
   */
  Platform(float x, float y) {
    this.x = x;
    this.y = y;
  }

  /**
   * Displays the platform as a green rectangle with rounded corners.
   */
  void display() {
    fill(100, 255, 0); // Light green color
    rect(x, y, w, h, 6); // Draw rectangle with rounded corners
  }
}
