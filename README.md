# Gambler's Ruin

A basic simulation of Gambler's Ruin, with the following specifications: 
* Begin with some starting bet.
* The probability of winning a bet is *p* and fixed for all rounds in a simuluation.
* Each time you lose a bet, you double your bet for the next round. 
* When you win, you revert your bet for the next round back to the starting bet. 

The code tracks the amount of money you have made, across *n* rounds, given a starting bet and *p*. 

*p* is varied across several thresholds and the simulations are repeated 1000 times to generate an expected amount of money made, given you've played *n* rounds. 

The simulation will give you results that look something akin to the following: 
<img src="https://raw.githubusercontent.com/melodyyhuang/Gamblers-Ruin/master/Figures/result.png"/>
