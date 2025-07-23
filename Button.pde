/**
 * Represents a simple clickable button in a Processing sketch.
 * The button has a label and responds to hover and click events with visual feedback.
 */
class Button {
  /** The text label displayed on the button */
  String label;
  
  /** The x and y coordinates of the top-left corner of the button */
  float x, y;
  
  /** The width of the button (default: 200) */
  float w = 200;
  
  /** The height of the button (default: 40) */
  float h = 40;

  /**
   * Constructs a Button with a given label and position.
   *
   * @param label the text to display on the button
   * @param x the x-coordinate of the button's top-left corner
   * @param y the y-coordinate of the button's top-left corner
   */
  Button(String label, float x, float y) {
    this.label = label;
    this.x = x;
    this.y = y;
  }

  /**
   * Draws the button on the screen.
   * Changes color and text size when hovered.
   */
  void display() {
    if (isHovered()) {
      fill(255, 100, 100); // Red background when hovered
      textSize(28);
    } else {
      fill(255); // White background when not hovered
      textSize(24);
    }
    rectMode(CENTER);
    rect(x + w / 2, y + h / 2, w, h, 8); // Draw rectangle with rounded corners
    fill(0); // Black text
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2); // Centered text
  }

  /**
   * Checks if the mouse is currently hovering over the button.
   *
   * @return true if the mouse is over the button; false otherwise
   */
  boolean isHovered() {
    return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
  }

  /**
   * Checks if the button is being clicked.
   *
   * @return true if the mouse is over the button and pressed; false otherwise
   */
  boolean isClicked() {
    return isHovered() && mousePressed;
  }
}
