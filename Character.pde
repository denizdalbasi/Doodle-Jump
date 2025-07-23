/**
 * Represents a playable character in a game that can jump when clicked and stand on platforms.
 * Extends the Player class to inherit position and movement properties.
 */
class Character extends Player {
  /** The name of the character */
  String name;

  /** The character's display color */
  color c;

  /** Indicates whether the character is currently jumping */
  boolean jumping = false;

  /** The Y position where the character should land (top of the platform) */
  float groundY;

  /** The price of the character (used for selection or unlocking) */
  int price;

  /**
   * Constructs a Character object with a name, position, color, and price.
   *
   * @param name the name of the character
   * @param x the x-coordinate of the character
   * @param y the y-coordinate of the character
   * @param c the color of the character
   * @param price the price of the character
   */
  Character(String name, float x, float y, color c, int price) {
    super(x, y);
    this.name = name;
    this.c = c;
    this.groundY = y;
    this.price = price;
  }

  /**
   * Displays the character on the screen as a colored square.
   * Also displays the character's name and price below the square.
   */
  void display() {
    fill(c); // Use the assigned color  
    rect(x, y, 50, 50); // Display character as a rectangle
    fill(255);
    textAlign(CENTER);
    textSize(12);
    text(name, x, y + 40); // Display character name below the square
    text("Price: " + price, x + 5, y + 65); // Display price slightly further below
  }

  /**
   * Updates the character's behavior in relation to a platform.
   * Handles jumping mechanics and gravity.
   *
   * @param plat the platform on which the character stands
   */
  void updateOnPlatform(Platform plat) {
    groundY = plat.y - h;
    
    // Trigger jump if mouse hovers over character and not already jumping
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h && !jumping) {
      jump();
    }

    // Handle jumping motion
    if (jumping) {
      yVelocity += gravity;
      y += yVelocity;

      // Stop jumping when landing
      if (y > groundY) {
        y = groundY;
        jumping = false;
        yVelocity = 0;
      }
    }
  }

  /**
   * Initiates a jump if the character is not already jumping.
   */
  void jump() {
    if (!jumping) {
      yVelocity = jumpForce;
      jumping = true;
    }
  }

  /**
   * Checks if the character was clicked (mouse is inside its bounds).
   *
   * @return true if the mouse is within the character's bounds; false otherwise
   */
  boolean isClicked() {
    return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
  }

  /**
   * Triggers a jump if the character is clicked.
   */
  void checkClick() {
    if (isClicked()) {
      jump();
    }
  }
}
