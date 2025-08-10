# Blackjack (LÖVE 2D)

A simple Blackjack card game built with [LÖVE](https://love2d.org/), inspired by the tutorial from [Berbasoft's Simple Game Tutorials](https://berbasoft.com/simplegametutorials/love/blackjack/) and extended with my own improvements.

## 📜 About

I started this project by following Berbasoft's Blackjack tutorial as a base, then refactored and expanded the code to make it cleaner, more modular, and easier to maintain.

### Improvements over the original tutorial

- **Modular structure**: Separated into `state`, `rules`, `render`, `input`, and `deck` modules for maintainability.
- **UI Buttons**: Mouse-driven Hit, Stand, and Play Again buttons, with hover effects.
- **Keyboard Support**: Press `H` to hit, `S` to stand, and any key to restart after a round.
- **Dealer Logic**: Configurable to hit on soft 17.
- **Encapsulated Deck Logic**: Self-contained `Deck` module with shuffle, draw, and reset functions.
- **Better Ace Handling**: Proper soft/hard Ace value calculation.
- **Cleaner Game Flow**: Player and dealer turns separated with reusable logic.
- **Code Readability**: Constants for card layout, colors, and UI dimensions.

---

## 🎮 How to Play

1. **Goal**: Get as close to 21 as possible without going over.  
2. **Controls**:
   - **Mouse**:
     - Click **Hit!** to draw a card.
     - Click **Stand** to end your turn and let the dealer play.
     - Click **Play Again** to start a new round.
   - **Keyboard**:
     - Press `H` to hit.
     - Press `S` to stand.
     - Press any key after the round to restart.
3. The dealer reveals their cards and draws until reaching at least 17 (or hits on soft 17 if configured).
4. Win, lose, or tie depending on final totals.

---

## 📂 Project Structure

```
project/
├─ main.lua                # Game entry point
├─ conf.lua                # LÖVE configuration
├─ assets/
│  └─ images/              # Card and UI assets
└─ src/
   ├─ game/
   │  ├─ state.lua         # Holds all game state & UI definitions
   │  ├─ deck.lua          # Encapsulated deck logic
   │  └─ rules.lua         # Blackjack rules, scoring, dealer logic
   ├─ systems/
   │  ├─ input.lua         # Mouse & keyboard input handling
   │  └─ render.lua        # Rendering logic
   └─ util/
      └─ ui.lua            # Button helper functions
```

---

## 🚀 Running the Game

1. Install [LÖVE](https://love2d.org/).
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/blackjack-love2d.git
   cd blackjack-love2d
   ```
3. Run the game:
   ```bash
   love .
   ```

---

## 🖼️ Assets

The card and pip images are loaded from `assets/images/` and must match the filenames expected in `state.lua`:
- `1.png` … `13.png`
- `pip_heart.png`, `pip_diamond.png`, `pip_club.png`, `pip_spade.png`
- `mini_heart.png`, `mini_diamond.png`, `mini_club.png`, `mini_spade.png`
- `card.png`, `card_face_down.png`
- `face_jack.png`, `face_queen.png`, `face_king.png`

---

## 🛠️ Technologies Used

- [Lua](https://www.lua.org/) — Scripting language.
- [LÖVE 2D](https://love2d.org/) — 2D game framework for Lua.

---

## 📜 License

This project is open source under the [MIT License](LICENSE).