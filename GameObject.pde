abstract class GameObject {
  float x, y;
  
  GameObject(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  // Abstract method to be implemented by subclasses
  abstract void display();


  // Optional: abstract method for update logic if applicable
  void update() {
    // Default empty update, or can be abstract if all subclasses should implement it
  }
}
