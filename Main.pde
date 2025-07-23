// Import necessary Java utility classes
import java.util.ArrayList; // For dynamic arrays
import java.util.Collections; // For sorting and collection utilities
import java.util.Random; // For random number generation

// The current screen name controlling what is drawn
String currentScreen = "mainMenu";

// UI Buttons arrays for menu and level select
Button[] menuButtons; // Array of buttons for main menu
Button[] levelButtons; // Array of buttons for level selection

// Characters available in store
Character[] storeCharacters; // Array of characters available for purchase
Platform storePlatform; // Platform characters jump on in store

// Characters owned by player, to show in character screen
ArrayList<Character> ownedCharacters = new ArrayList<Character>(); // List of owned characters
Platform characterPlatform; // Platform in character screen

// Game objects
Player player; // The player character
Platform[] platforms; // Array of platforms in the game
ArrayList<Coin> coins; // List of coins in the game

// Game state variables
int level; // 1=UnderGround, 2=Earth, 3=Space - current game level
float cameraY = 0; // Camera vertical position for scrolling
int heightScore = 0; // Current height score
int coinScore = 0; // Coins collected in current game
int totalCoins = 0; // Persistent coins across games
PFont font; // Font used for text rendering

// Game over state
boolean gameOver = false; // Whether game is over
int gameOverTimer = 0; // Timer after game over before returning to menu

// Buttons for scoreboard toggling and sorting/searching
Button myScoreboardButton; // Button to show personal scores
Button worldwideScoreboardButton; // Button to show worldwide scores
Button sortAscButton; // Button to sort scores ascending
Button sortDescButton; // Button to sort scores descending
boolean showMyScores = true; // Flag: true=show personal scores, false=worldwide scores

// Flag to track if worldwide score has been saved this session
boolean worldwideScoreSaved = false;

// For scoreboard search
String searchName = ""; // Current search term for scoreboard
boolean isTypingSearch = false; // Whether user is typing in search box

PImage backgroundImage; // Current level background image
PImage mainMenuBackgroundImage; // Main menu background image

/**
 * Sets up the overall game environment and initial state.
 * Initializes window size, fonts, UI buttons, backgrounds, and game entities.
 *
 * @pre: none
 * @post: Game window is initialized, UI buttons prepared, background loaded,
 *                and game ready to start.
 * @return none
 */
void setup() {
  size(800, 600); // Set window size to 800x600 pixels
  font = createFont("Arial", 24); // Create Arial font at size 24
  textFont(font); // Set as default font
  setupMainMenu(); // Initialize main menu buttons
  setupLevelSelect(); // Initialize level select buttons
  setupStore(); // Initialize store characters
  setupCharacterScreen(); // Initialize character screen
  loadCoins(); // Load saved coins count
  setupGame(); // Initialize game objects
  myScoreboardButton = new Button("My Scoreboard", width/2 - 110, height - 100); // Initialize scoreboard buttons
  worldwideScoreboardButton = new Button("Worldwide Scoreboard", width/2 + 160, height - 100);
  sortAscButton = new Button("Sort Asc", 100, height - 60);
  sortDescButton = new Button("Sort Desc", 500, height - 60);
  
  mainMenuBackgroundImage = loadImage("IMG_1125.JPG"); // Load main menu background
  loadBackgroundImage(); // Load initial background based on level
  frameRate(60); // Set target frame rate to 60 FPS
}

/**
 * Loads and sets the background image based on the current game level.
 *
 * @pre: level variable is set to a valid integer.
 * @post: backgroundImage is assigned the appropriate background image for the level.
 * @return none
 */
void loadBackgroundImage() {
  switch(level) {
    case 1: 
      backgroundImage = loadImage("underground_background.jpg");
      break;
    case 2: 
      backgroundImage = loadImage("earth_background.jpg");
      break;
    case 3: 
      backgroundImage = loadImage("space_background.jpg");
      break;
    case 4: 
      backgroundImage = loadImage("IMG_1305.JPG");
      break;
    default: 
      backgroundImage = loadImage("IMG_1125.JPG");
      break;
  }
}

/**
 * The main game rendering loop called repeatedly to draw the game frame.
 * Selects rendering behavior based on the currentScreen state.
 *
 * @pre none
 * @post Screen contents are drawn on the canvas for current frame.
 * @return none
 */
void draw() {
  if(currentScreen.equals("mainMenu")) {
    if(mainMenuBackgroundImage != null) {
      image(mainMenuBackgroundImage, 0, 0, width, height);
    } else {
      background(50, 100, 200);
    }
    drawMainMenu();
  } else {
    if(backgroundImage != null) image(backgroundImage, 0, 0, width, height);
    else background(200);

    switch(currentScreen) {
      case "store": drawStore(); break;
      case "howtoplay": drawHowToPlay(); break;
      case "characters": drawCharacters(); break;
      case "scoreboard": drawScoreboard(); break;
      case "levelselect": drawLevelSelect(); break;
      case "play": drawPlay(); break;
      default:
        background(0);
        fill(255);
        textAlign(CENTER,CENTER);
        text("Unknown screen: " + currentScreen, width/2, height/2);
    }
  }
}

/**
 * Handles all mouse press events by routing click events to the appropriate screen handler.
 *
 * @prec currentScreen is set appropriately.
 * @post Relevant screen-specific click handler is invoked.
 * @return none
 */
void mousePressed() {
  switch (currentScreen) {
    case "mainMenu":
      mousePressedMainMenu();
      break;
    case "scoreboard":
      mousePressedScoreboard();
      break;
    case "store":
      mousePressedStore();
      break;
    case "levelselect":
      mousePressedLevelSelect();
      break;
    default:
      // No specific handler needed for other screens
      break;
  }
}

/**
 * Handles mouse clicks on main menu buttons.
 * Starts the game, exits, or changes screen based on clicked button.
 *
 * @pre menuButtons array is initialized with clickable buttons.
 * @post Either the game exits, current screen changes, or game initialization occurs.
 * @return none
 */
void mousePressedMainMenu() {
  for(Button b : menuButtons) {
    if(b.isClicked()) {
      if(b.label.equals("Quit")) {
        exit(); // Terminates the program.
      } else if(b.label.equals("Play")) {
        currentScreen = "levelselect";
        String playerName = generateRandomName();
        savePlayerInfo(playerName, level, 0); // Save initial player data
      } else {
        currentScreen = b.label.toLowerCase().replace(" ",""); // Map label to screen name
      }
      return; // Prevent checking other buttons after a click
    }
  }
}

/**
 * Handles mouse presses on scoreboard buttons.
 * Toggles which scoreboard is shown or changes sorting order.
 *
 * @pre Scoreboard buttons are initialized and displayed.
 * @post Flags for which scores to show and sorting order are changed accordingly.
 * @return none
 */
void mousePressedScoreboard() {
  if(myScoreboardButton.isClicked()) {
    showMyScores = true;
  } else if(worldwideScoreboardButton.isClicked()) {
    showMyScores = false;
  } else if(sortAscButton.isClicked()) {
    currentSortAsc = true;
  } else if(sortDescButton.isClicked()) {
    currentSortAsc = false;
  }
}

/**
 * Handles clicks on level select buttons.
 * Sets level, re-initializes the game, loads new background, and enters play mode.
 *
 * @pre Level buttons are set up and clickable.
 * @post The game level is set and gameplay begins at selected level.
 * @return none
 */
void mousePressedLevelSelect() {
  for(Button b : levelButtons) {
    if(b.isClicked()) {
      if(b.label.equals("UnderGround")) level = 1;
      else if(b.label.equals("Earth")) level = 2;
      else if(b.label.equals("Space")) level = 3;
      setupGame();
      loadBackgroundImage();
      currentScreen = "play";
      return;
    }
  }
}

/**
 * Processes keyboard input for search and screen navigation.
 * Supports search typing on scoreboard and screen switching.
 *
 * @pre currentScreen and isTypingSearch are properly set.
 * @post Updates search string or changes the current screen.
 * @param key implicitly provided by Processing's keyPressed event.
 * @return none
 */
void keyPressed() {
  if(currentScreen.equals("scoreboard") && isTypingSearch) {
    if(key == BACKSPACE) {
      if(searchName.length() > 0)
        searchName = searchName.substring(0, searchName.length() - 1);
    } else if(key == ENTER) {
      isTypingSearch = false;
    } else if(key != CODED) {
      searchName += key;
    }
  } else {
    if(key == 'm' || key == 'M') {
      currentScreen = "mainMenu";
      isTypingSearch = false;
      searchName = "";
    }
    if(currentScreen.equals("scoreboard") && (key == 's' || key == 'S')) {
      isTypingSearch = true;
      searchName = "";
    }
  }
}

/**
 * Returns a random player name from a fixed set of predefined names.
 *
 * @pre None.
 * @post Returns a valid player name string.
 * @return String - randomly selected player name.
 */
String generateRandomName() {
  String[] names = {"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "kdkdk", "asjsa", "ksaksa", "ksasm","ldfq"};
  Random rand = new Random();
  return names[rand.nextInt(names.length)];
}

/**
 * Saves player information to persistent storage in CSV format.
 *
 * @param playerName the player's name.
 * @param level the current game level.
 * @param score the player's score to save.
 * @pre Parameters are non-null; file system writable.
 * @post Player data appended to "playerInfo.txt".
 * @return none
 */
void savePlayerInfo(String playerName, int level, int score) {
  String dataLine = playerName + "," + level + "," + score;
  String[] existing = loadStrings("playerInfo.txt");
  ArrayList<String> allLines = new ArrayList<>();
  if(existing != null) {
    Collections.addAll(allLines, existing);
  }
  allLines.add(dataLine);
  saveStrings("playerInfo.txt", allLines.toArray(new String[0]));
}

/**
 * Initializes main menu buttons with fixed labels and positions.
 *
 * @pre None.
 * @post menuButtons array initialized with Button objects.
 * @return none
 */
void setupMainMenu() {
  menuButtons = new Button[] {
    new Button("Play", 300, 150),
    new Button("How to Play", 300, 210),
    new Button("Characters", 300, 270),
    new Button("Store", 300, 330),
    new Button("Scoreboard", 300, 390),
    new Button("Quit", 300, 450)
  };
}

/**
 * Initializes the level select buttons with predefined labels and locations.
 *
 * @pre None.
 * @post levelButtons array initialized with Button objects.
 * @return none
 */
void setupLevelSelect() {
  levelButtons = new Button[] {
    new Button("UnderGround", width/2 - 100, height/2 - 60),
    new Button("Earth", width/2 - 100, height/2),
    new Button("Space", width/2 - 100, height/2 + 60)
  };
}

/**
 * Sets up the character screen by creating the platform and loading owned characters.
 *
 * @pre None.
 * @post characterPlatform initialized and owned characters loaded.
 * @return none
 */
void setupCharacterScreen() {
  characterPlatform = new Platform(width / 2 - 120, height - 100);
  loadOwnedCharacters();
}


/**
 * Initializes game objects and level platforms, positions player and resets scores.
 *
 * @pre None.
 * @post Game entities are set up, ready for gameplay.
 * @return none
 */
void setupGame() {
  player = new Player(width/2, height - 100);
  platforms = new Platform[10];
  coins = new ArrayList<Coin>();

  float maxVerticalGap = abs(player.jumpForce * player.jumpForce / (2 * player.gravity)) * 0.9;

  for (int i=0; i < platforms.length; i++) {
    float y = height - i * maxVerticalGap * 0.9;
    float x = (i == 0) ? width/2 : constrain(platforms[i-1].x + random(-player.getMaxHorizontalReach(), player.getMaxHorizontalReach()), 0, width - 80);
    platforms[i] = new Platform(x, y);
    coins.add(new Coin(x + 20, y - 30));
  }

  player.x = platforms[0].x;
  player.y = platforms[0].y - player.h;

  heightScore = 0;
  coinScore = 0;
  cameraY = 0;
  gameOver = false;
  gameOverTimer = 0;
}
/**
 * Draws the main menu screen with title and menu buttons.
 *
 * @pre menuButtons array is initialized with Button instances.
 * @post Main menu elements are rendered on the screen.
 * @return none
 */
void drawMainMenu() {
  fill(255); // Set text color to white
  textAlign(CENTER);
  textSize(36);
  text("DENIGOR ASCEND", width/2, 80); // Game title
  for(Button b : menuButtons) {
    b.display(); // Draw each menu button
  }
}

/**
 * Sets up the store characters available for purchase with colors and positions.
 *
 * @pre none.
 * @post storeCharacters array is initialized and populated with Character instances.
 * @return none
 */
void setupStore() {
  storeCharacters = new Character[8];
  storeCharacters[0] = new Character("Red", width / 2 - 240, height / 2 - 40, color(255, 0, 0), 10);
  storeCharacters[1] = new Character("Blue", width / 2 - 180, height / 2 - 40, color(0, 0, 255), 15);
  storeCharacters[2] = new Character("Green", width / 2 - 120, height / 2 - 40, color(0, 255, 0), 20);
  storeCharacters[3] = new Character("Yellow", width / 2 - 60, height / 2 - 40, color(255, 255, 0), 25);
  storeCharacters[4] = new Character("Cyan", width / 2 + 60, height / 2 - 40, color(0, 255, 255), 30);
  storeCharacters[5] = new Character("Magenta", width / 2 + 120, height / 2 - 40, color(255, 0, 255), 35);
  storeCharacters[6] = new Character("Orange", width / 2 + 180, height / 2 - 40, color(255, 165, 0), 40);
  storeCharacters[7] = new Character("Purple", width / 2 + 240, height / 2 - 40, color(128, 0, 128), 45);
}

/**
 * Draws the store UI, including characters and coin count.
 *
 * @pre storeCharacters array initialized and background already drawn.
 * @post Characters and text are drawn on screen, showing store layout.
 * @return none
 */
void drawStore() {
  background(0); // Black background
  fill(255, 255, 0); // Yellow text
  textAlign(CENTER);
  textSize(32);
  text("Store - Select a Character", width / 2, 40);

  for (Character c : storeCharacters) {
    c.display(); // Draw each character in store
  }

  fill(255, 255, 0);
  textSize(20);
  text("Total Coins: " + totalCoins, width / 2, height - 60); // Show total coins
  textSize(18);
  text("Press 'M' to return to Main Menu", width / 2, height - 30); // Instruction
}

/**
 * Draws "how to play" instructional screen.
 *
 * @pre None.
 * @post Instructional texts are rendered on screen.
 * @return none
 */
void drawHowToPlay() {
  level = 4; // Special background level for instructions
  loadBackgroundImage();
  fill(255,165,0); // Orange text color
  textAlign(CENTER);
  textSize(24);
  text("Use LEFT/RIGHT to move.", width/2, height/2 - 40);
  text("Land on platforms, collect coins to spend in the store.", width/2, height/2 - 10);
  text("Press 'M' anytime to return to Main Menu.", width/2, height/2 + 20);
}

/**
 * Draws the character selection screen displaying owned characters.
 *
 * @pre ownedCharacters list is initialized.
 * @post owned characters and UI elements are rendered.
 * @return none
 */
void drawCharacters() {
  background(0); // Black background
  fill(255,255,0); // Yellow text
  textAlign(CENTER);
  textSize(24);
  text("Character Selection Screen", width/2, 40);

  for (int i = 0; i < ownedCharacters.size(); i++) {
    Character c = ownedCharacters.get(i);
    c.x = width / 2 - 250 + i * 70; // Horizontally position characters
    c.y = height / 2; // Vertically center
    c.display(); // Draw each owned character
  }

  textSize(18);
  text("Press 'M' to return to Main Menu", width/2, height - 30);
}

/**
 * Draws the scoreboard screen, displaying scores filtered and sorted accordingly.
 *
 * @pre Score files exist or are empty; buttons initialized.
 * @post Scoreboard UI with scores, buttons and search field displays accurately.
 * @return none
 */
void drawScoreboard() {
  background(255); // White background
  fill(0); // Black text

  textAlign(CENTER);
  textSize(28);
  text("Scoreboard", width/2, 40);

  ArrayList<ScoreEntry> entries = new ArrayList<>();

  String[] lines;
  if(showMyScores) {
    lines = loadStrings("playerInfo.txt");
  } else {
    lines = loadStrings("worldwideScores.txt");
  }

  if(lines == null || lines.length == 0) {
    textSize(24);
    text("No scores saved yet.", width/2, 100);
  } else {
    for(String line : lines) {
      String[] parts = splitTokens(line, ",");
      if(parts.length == 3) {
        try {
          String n = parts[0];
          int l = Integer.parseInt(parts[1]);
          int s = Integer.parseInt(parts[2]);
          if(searchName.length() == 0 || n.toLowerCase().contains(searchName.toLowerCase())) {
            entries.add(new ScoreEntry(n, l, s));
          }
        } catch(Exception e) {
          // Ignore malformed lines
        }
      }
    }
    if(currentSortAsc) {
      insertionSortScoresAscending(entries);
    } else {
      insertionSortScores(entries);
    }

    textSize(20);
    for(int i=0; i < min(10, entries.size()); i++) {
      text((i+1) + ". " + entries.get(i).toString(), width/2, 90 + i*30);
    }
  }
  myScoreboardButton.display();
  worldwideScoreboardButton.display();
  sortAscButton.display();
  sortDescButton.display();

  fill(230); // Light gray search box background
  rect(width/2 - 300, height - 80, 220, 30, 5);
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);
  text("Search: " + (isTypingSearch ? searchName + "|" : searchName), width/2 - 395, height - 80);

  textAlign(CENTER);
  textSize(16);
  text("Press 'M' to return to Main Menu | Press 'S' to search by name", width/2, height - 110);
}
boolean currentSortAsc = false; // Flag for current sort order
/**
 * Sort scores in descending order using insertion sort.
 *
 * @param list ArrayList of ScoreEntry objects to sort.
 * @pre list contains ScoreEntry objects.
 * @post list sorted descending by scores.
 * @return none
 */
void insertionSortScores(ArrayList<ScoreEntry> list) {
  for (int i = 1; i < list.size(); i++) {
    ScoreEntry key = list.get(i);
    int j = i - 1;
    while (j >= 0 && list.get(j).score < key.score) {
      list.set(j + 1, list.get(j));
      j--;
    }
    list.set(j + 1, key);
  }
}

/**
 * Sort scores in ascending order using insertion sort.
 *
 * @param list ArrayList of ScoreEntry objects to sort.
 * @pre list contains ScoreEntry objects.
 * @post list sorted ascending by scores.
 * @return none
 */
void insertionSortScoresAscending(ArrayList<ScoreEntry> list) {
  for (int i = 1; i < list.size(); i++) {
    ScoreEntry key = list.get(i);
    int j = i - 1;
    while (j >= 0 && list.get(j).score > key.score) {
      list.set(j + 1, list.get(j));
      j--;
    }
    list.set(j + 1, key);
  }
}

/**
 * Draws the level selection screen with selection buttons.
 *
 * @pre levelButtons array is initialized.
 * @post Level selection screen rendered.
 * @return none
 */
void drawLevelSelect() {
  background(100,100,150); 
  fill(255);
  textAlign(CENTER);
  textSize(36);
  text("Choose Your Level", width/2, height/4);
  for(Button b : levelButtons) b.display();
  
  fill(255);
  textSize(20);
  text("Press 'M' to return to Main Menu", width/2, height - 30);
}

/**
 * Draws gameplay screen, manages player, platforms, coins, camera,
 * and handles game over state with UI.
 *
 * @pre Game entities initialized. cameraY, player, platforms, coins available.
 * @post Gameplay visuals and logic updated and displayed.
 * @return none
 */
void drawPlay() {
  pushMatrix();
  translate(0, cameraY);

  if(!gameOver) {
    if (player != null) {
      player.update();
      player.display();

      if(player.y < height/2) heightScore = int(height - player.y);

      // Manage platforms
      for (Platform p : platforms) {
        p.display();
        player.checkCollision(p);
        if(p.y > player.y + height) {
          p.y = player.y - random(player.getMaxJumpHeight()*0.9, player.getMaxJumpHeight()*1.2);
          Platform aboveP = closestPlatformAbove(p);
          if(aboveP != null) {
            p.x = constrain(aboveP.x + random(-player.getMaxHorizontalReach(), player.getMaxHorizontalReach()), 0, width - p.w);
          } else {
            p.x = random(width - p.w);
          }
          coins.add(new Coin(p.x+20, p.y - 30));
        }
      }

      // Manage coins
      for(int i=coins.size()-1; i >= 0; i--) {
        Coin c = coins.get(i);
        c.display();
        if(!c.collected && player.collidesWithCoin(c)) {
          c.collected = true;
          coinScore++;
          totalCoins++;
          saveCoins();
        }
        if(c.y > player.y + height || c.collected) coins.remove(i);
      }

      if(player.y < height/2 - cameraY) cameraY = height/2 - player.y;

      if(player.y > height - cameraY + 300) {
        gameOver = true;
        gameOverTimer = 0;
      }
    }
  } else {
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(48);
    float msgX = constrain(player.x + player.w/2, 100, width-100);
    float msgY = constrain(player.y + player.h/2, 100, height-100);
    text("GAME OVER!", msgX, msgY - 60);
    textSize(32);
    text("Height Score: " + heightScore, msgX, msgY);
    text("Coins collected this run: " + coinScore, msgX, msgY + 40);
    textSize(20);
    text("Returning to Main Menu...", msgX, msgY + 80);

    if (!worldwideScoreSaved) {
      String playerName = generateRandomName();
      saveWorldwideScore(playerName, level, heightScore);
      worldwideScoreSaved = true;
    }

    gameOverTimer++;
    if(gameOverTimer > 180) {
      savePlayerInfo(generateRandomName(), level, heightScore);
      currentScreen = "mainMenu";
      setupGame();
      coinScore = 0;
      gameOver = false;
      worldwideScoreSaved = false;
    }
  }

  popMatrix();

  // HUD display
  fill(255);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Score: " + heightScore, 20, 20);
  text("Coins: " + totalCoins, 20, 50);

  textSize(16);
  textAlign(CENTER);
  text("Press 'M' to return to Main Menu", width/2, 20);
}

/**
 * Finds the closest platform located above a given platform.
 *
 * @param  The platform reference to find closest above.
 * @preplatforms array contains all active platforms.
 * @post Returns platform closest above or null if none.
 * @return Platform - closest platform above `p`, or null.
 */
Platform closestPlatformAbove(Platform p) {
  Platform closest = null;
  float closestY = Float.NEGATIVE_INFINITY;
  for (Platform plt : platforms) {
    if(plt.y < p.y && plt.y > closestY) {
      closest = plt;
      closestY = plt.y;
    }
  }
  return closest;
}

/**
 * Loads the total coin count from persistent storage.
 *
 * @pre coins.txt exists or is empty/nonexistent.
 * @post totalCoins set from saved file or zero.
 * @return none
 */
void loadCoins() {
  String[] loaded = loadStrings("coins.txt");
  if(loaded == null || loaded.length == 0) totalCoins = 0;
  else {
    try {
      totalCoins = Integer.parseInt(loaded[0]);
    } catch(Exception e) {
      totalCoins = 0;
    }
  }
}

/**
 * Saves the current total coin count to persistent storage.
 *
 * @pre totalCoins contains current valid coin count.
 * @post coins.txt contains updated coin count as text.
 * @return none
 */
void saveCoins() {
  saveStrings("coins.txt", new String[] { str(totalCoins) });
}

/**
 * Adds a new score to the personal scores list and saves top 100 descending.
 *
 * @param score The new score to be saved.
 * @pre myScores.txt is readable/writable.
 * @post Score added and the file saved with top 100 scores descending.
 * @return void
 */
void saveScore(int score) {
  String[] scores = loadStrings("myScores.txt");
  ArrayList<Integer> allScores = new ArrayList<>();

  if(scores != null) {
    for(String s : scores) {
      try {
        allScores.add(Integer.parseInt(s));
      } catch(Exception e) {
        println("Error parsing score: " + s);
      }
    }
  }

  allScores.add(score);

  Collections.sort(allScores);
  Collections.reverse(allScores);

  ArrayList<String> top100 = new ArrayList<>();
  for(int i = 0; i < min(100, allScores.size()); i++) {
    top100.add(str(allScores.get(i)));
  }

  try {
    saveStrings("myScores.txt", top100.toArray(new String[0]));
  } catch (Exception e) {
    println("Error saving scores: " + e.getMessage());
  }
}

/**
 * Saves owned character names to file for persistence.
 *
 * @pre ownedCharacters list is current.
 * @post ownedCharacters.txt updated with character names.
 * @return void
 */
void saveOwnedCharacters() {
  ArrayList<String> lines = new ArrayList<>();
  for(Character c : ownedCharacters) {
    lines.add(c.name);
  }
  saveStrings("ownedCharacters.txt", lines.toArray(new String[0]));
}

/**
 * Saves a score entry to worldwideScores.txt file.
 *
 * @param playerName Player's name.
 * @param level Game level.
 * @param score Player's score.
 * @pre File is writable; parameters valid.
 * @post New score added to worldwideScores.txt.
 * @return void
 */
void saveWorldwideScore(String playerName, int level, int score) {
  String dataLine = playerName + "," + level + "," + score;
  String[] existingScores = loadStrings("worldwideScores.txt");
  ArrayList<String> allLines = new ArrayList<>();

  if(existingScores != null) {
    Collections.addAll(allLines, existingScores);
  }

  allLines.add(dataLine);

  try {
    saveStrings("worldwideScores.txt", allLines.toArray(new String[0]));
  } catch (Exception e) {
    println("Error saving worldwide scores: " + e.getMessage());
  }
}
/**
 * Handles mouse clicks in the store screen to buy characters.
 * Ensures ownership check and coin sufficiency with detailed debug output.
 *
 * @pre storeCharacters and ownedCharacters are initialized.
 * @post Character purchased and ownership saved if affordable and not already owned.
 * @return void
 */
void mousePressedStore() {
  for (Character c : storeCharacters) {
    if (c.isClicked()) {
      String storeCharName = c.name.trim().toLowerCase();
      boolean alreadyOwned = false;

      println("Clicked character: " + c.name + " | Price: " + c.price);

      for (Character oc : ownedCharacters) {
        String ownedCharName = oc.name.trim().toLowerCase();
        if (ownedCharName.equals(storeCharName)) {
          alreadyOwned = true;
          break;
        }
      }

      if (alreadyOwned) {
        println("You already own " + c.name);
      } else {
        if (totalCoins >= c.price) {
          totalCoins -= c.price;
          println("Purchasing " + c.name + " for " + c.price + " coins. Coins left before purchase: " + (totalCoins + c.price));
          saveCoins();
          ownedCharacters.add(new Character(c.name, 0, 0, c.c, c.price));
          saveOwnedCharacters();
          println("Successfully purchased " + c.name + "!");
        } else {
          println("Not enough coins to buy " + c.name + ". Price: " + c.price + ", Total Coins: " + totalCoins);
        }
      }
      return; // Only one purchase per click
    }
  }
}


/**
 * Loads owned characters from file, matching them to store characters if possible.
 *
 * @pre ownedCharacters.txt exists or is empty.
 * @post ownedCharacters list populated with stored characters.
 * @return void
 */
void loadOwnedCharacters() {
  ownedCharacters.clear();
  String[] loaded = loadStrings("ownedCharacters.txt");
  if (loaded != null) {
    for (String name : loaded) {
      String normalizedName = name.trim().toLowerCase();
      Character matched = null;
      for (Character sc : storeCharacters) {
        if (sc.name.trim().toLowerCase().equals(normalizedName)) {
          matched = sc;
          break;
        }
      }
      if (matched != null) {
        ownedCharacters.add(new Character(matched.name, 0, 0, matched.c, matched.price));
      } else {
        ownedCharacters.add(new Character(name, 0, 0, color(255), 0)); // Fallback white character
      }
    }
  }
}
