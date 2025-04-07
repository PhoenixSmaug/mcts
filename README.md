# MCTS from scratch in Julia

## MCTS

[Monte Carlo Tree Search](https://en.wikipedia.org/wiki/Monte_Carlo_tree_search) is a powerful algorithm in unsupervised reinforcement learning, where we want to find optimal strategies for strategic games without specifying beforehand how a strong player would look like. Instead, the algorithm only learns from its own experiments which game states are preferable and finds an optimal balance between exploring new strategies and utilizing its current knowledge. This method is the basis of Google's [AlphaGo](https://deepmind.google/research/breakthroughs/alphago/), which was able to beat the best human Go player. The self-invented game “Tupitu”, which is described in detail in the next section, is chosen here to illustrate the algorithm.

## Tupitu

```math
\begin{array}{|c|c|c|c|c|} \hline - & - & - & - & - \\ \hline - & - & - & B & - \\ \hline - & - & - & - & - \\ \hline - & A & - & - & - \\ \hline - & - & - & - & - \\ \hline\end{array}
```

The game Tupitu is played on a 5x5 grid with the two players A and B positioned as shown in the figure. The players take turns, with player A starting. In the first half of the turn, the player must move to one of the up to 8 adjacent pieces, just like the king in chess. In the second half of the turn, he chooses one of the tiles on which no player is standing. This tile is then cleared for the rest of the game, meaning that no player can move on it anymore. The first player who can no longer move on his turn loses.

Using Knuth's algorithm for deciding two-player games with perfect information, I also have implemented a perfect solver for this game [here](https://github.com/PhoenixSmaug/knuth-game-solver). It can prove in around 24 hours of computation that the starting player A can always force a win with optimal play.

## Code

For maximal efficiency, all game logic is implemented using pure bitwise operations. With `MCTSvsRandom` you can simulate games between the MCTS player and a player making random moves, where one observes a practically 100% win rate for the MCTS player. You can also have two MCTS players play against each other by using `MCTSvsMCTS`.

(c) Mia Muessig
