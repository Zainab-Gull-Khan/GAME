[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/xA79OPRs)
# Fruit Ninja: Advanced Features
### **Deadline: 11:59 PM on Sunday, 6th April 2025**

**Duration:** _roughly 1.5 weeks_

**Difficulty: _Easy to Intermediate_**

## Overview
In this assignment, you will extend a basic Fruit Ninja game using Godot Engine. The starter code provides the fundamental mechanics of fruit spawning, slicing, and score tracking. Your task is to enhance the game by implementing additional features that will make it more engaging and complete.

## Learning Objectives

- Deepen your understanding of tweens for smooth animations and visual effects
- Apply timers for game logic, countdown mechanics, and spawn management
- Create interactive visual feedback for player actions
- Balance gameplay mechanics to create an engaging experience

## Core Requirements

### 1. Main Menu, Ready Screen, and Game Over Screen (10%)
Implement a main menu, ready screen, and game over screen to provide a complete user experience:

**Requirements:**
- Create a main menu with options to start the game and exit _(3)_
- Add a "Ready" screen that displays a timer of 3 seconds before the game actually starts _(3)_
    - When decrementing, _(say when changing from 3 to 2)_, the timer text should scale up and bounce _(1)_
    - Play a countdown sound effect _(1)_
- Include a "Game Over" screen that shows the final score and options to restart or return to the main menu _(2)_

**Bonus:**
- Implement transitions between screens using tweens and animations so for example one scene slides out and another slides in etc. _(+2)_

### 2. In-Game Countdown Timer (10%)
Implement a countdown timer that ends the game when time runs out.

**Requirements:**
- Display a countdown timer at the top of the screen _(2)_
- Start the timer at say 90 seconds _(1)_
- Update (decrement) the timer every second _(1)_ _(don't play sound every second, might be too distracting, unless the sound is very subtle)_
- Add visual/audio cues when time is running low (last 10 seconds) _(3)_
    - Change color of timer text _(flash it to red and back, scale its size using bounce)_ _(1.5)_
    - Play ticking sound effect _(1.5)_
- End the game when the timer reaches zero _(3)_
    - Tween a Game Over message, wait for say 2 seconds _(1.5)_
    - Move to game over scene _(1.5)_

### 3. Multiple Fruit Spawning (15%)
Enhance the spawning system to create more challenging gameplay.

**Requirements:**
- Modify the spawn system to release multiple fruits simultaneously _(3)_
- Start with 1-2 fruits and increase the number spawned at once as the game progresses _(3)_
- Implement a difficulty curve where fruits spawn more frequently over time _(3)_
    - increase the number of fruits spawned at once, say every 15 seconds?
- Ensure fruits spawn at different positions to create varied slicing patterns _(3)_
- Add random variations to the initial velocities to create more dynamic movement _(3)_
- **Bonus:** Implement _"fruit waves"_ with themed sets of fruits that spawn together _(all apples one after another in a wave, then all oranges, etc.)_ These waves will occur at specific intervals and increase in frequency as the game progresses. _(+3)_

### 4. Bomb Mechanics (15%)
Add bombs as hazards that players must avoid slicing.

**Requirements:**
- Create a bomb, textures are provided in the assets folder. _(2)_
- Program bombs to appear randomly among fruit spawns (15-20% spawn chance) _(2)_
- Implement a penalty when a bomb is sliced _(lose points, time, or end the game)_ _(3)_
- Add a distinctive visual effect when a bomb explodes _(3)_
    - Explosion texture is provided in the assets folder _(use tweens for animation)_
- Include audio feedback for bomb appearance and explosion _(2)_
- Flash the background red, play a siren sound, and briefly shake the screen _(3)_
- **Bonus:** Add a "warning" animation or sound when bombs are about to spawn _(+2)_
    
### 5. Combo System (20%)
Implement a combo system that rewards players for quick consecutive slices:

**Requirements:**
- The combo system should start at 1x and increase with each successful slice _(2)_
- Combo level should reset if the player misses a fruit or hits a bomb _(2)_
- The combo is one continuous chain of slices, i.e the player must slice with one long swipe _(2)_
- Create a combo counter that increases with each successful slice _(2)_
- Implement a 0.4-second timeout for maintaining combos _(3)_
    - that is, if the player doesn't slice a fruit within 0.4 seconds, the combo resets
- Display combo text with animations _(tweens)_: _(4)_
  - Text should remain on the screen as long as the combo is active _(1)_
  - During the combo, with each strike the text should scale up with a bounce effect _(1)_
  - Fade out smoothly _(1)_
  - Move upward slightly _(1)_
- Implement different sound effects for different combo levels (1x, 2x, 3x) _(2)_
- Score multiplier should increase with combo level _(2)_
- For the background, change its color dynamically based on combo level _(1)_
- **Bonus:** Add a combo meter that fills up as combos increase _(+3)_

#### Hints on Implementing Combos:
- As soon as user swipes, create and start a timer for 0.4 seconds
- If the user slices a fruit again before the timer ends, increment the combo
- If the timer ends and user didn't slice a fruit during that, reset the combo, stop the timer.


## Grading Criteria
- **Functionality (70%):** Does the game meet all core requirements? Are the features implemented correctly?
  - Main Menu, Ready Screen, and Game Over Screen (10%)
  - In-Game Countdown Timer (10%)
  - Multiple Fruit Spawning (15%)
  - Bomb Mechanics (15%)
  - Combo System (20%)

- **Polish (20%):** Does the game have a professional, "polished" look and feel?
  - Smoothness of animations and transitions (5%)
  - Effective visual feedback (5%)
  - Appropriate and well-timed audio feedback (5%)
  - Overall user experience and game flow (5%)

- **Code Quality (10%):** Is the code well-structured and maintainable?
  - Proper organization of code (2%)
  - Meaningful variable and function names (2%)
  - Appropriate comments (2%)
  - Efficient implementation (2%)
  - Absence of bugs and glitches (2%)

## Submission Requirements
1. Complete source code uploaded to your GitHub repository
2. A `A5_details.md` file with the following:
    - Overview of the assignment
    - Instructions on how to play the game
    - List of core requirements implemented
    - Any additional features
    - Any known issues
    - Performance analysis
    - Video demonstration
3. A playable web build of the game uploaded to [itch.io](itch.io)
4. A video demonstration of your game uploaded to YouTube

## Resources
- [Godot Engine Documentation](https://docs.godotengine.org/en/stable/index.html)
- [Fruit Ninja Game](https://fruitninja.com/)

## Extra Tips:
`Good artists copy, great artists steal`

Watch the original video footage in very slow motion _(I recommend to download and watch frame by frame)_ and try to deconstruct the special effects and animations in terms of tweens:
- [Fruit Ninja Trailer](https://www.youtube.com/watch?v=i56jtNZZzoQ)
- [Fruit Ninja Gameplay Video](https://www.youtube.com/shorts/94MWBBa8htI)

## Fruit Ninja Assets

Here are some additional assets you can use for your game:

- [Images](https://github.com/jaredly/fruit-ninja-assets)
- [Sound files](https://www.sounds-resource.com/mobile/fruitninja/sound/6076/)
- [Royalty Free Music](https://incompetech.com/music/royalty-free/music.html)