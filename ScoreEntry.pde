/**
 * Represents an entry in a high score leaderboard.
 * Stores the player's name, level reached, and score.
 * Implements Comparable to allow sorting by score in descending order.
 */
class ScoreEntry implements Comparable<ScoreEntry> {
  
  /** The player's name */
  String name;

  /** The level the player reached */
  int level;

  /** The player's score */
  int score;

  /**
   * Constructs a new ScoreEntry.
   *
   * @param n the player's name
   * @param l the level the player reached
   * @param s the score achieved
   */
  ScoreEntry(String n, int l, int s) {
    name = n;
    level = l;
    score = s;
  }

  /**
   * Compares this score entry with another for sorting.
   * Sorting is in descending order of score (higher scores come first).
   *
   * @param other another ScoreEntry to compare against
   * @return a negative number if this score is higher than the other,
   *         zero if equal, or a positive number if lower
   */
  public int compareTo(ScoreEntry other) {
    return other.score - this.score; // Descending order
  }

  /**
   * Returns a string representation of the score entry.
   *
   * @return a formatted string containing the player's name, level, and score
   */
  public String toString() {
    return name + " | Lvl:" + level + " | Score:" + score;
  }
}
