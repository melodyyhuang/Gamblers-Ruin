#-------------------------------------------------------------------------------
#Author(s): Melody Huang
#Last modified: 09/24/2018
#Gambler's Ruin Example
#-------------------------------------------------------------------------------
rm(list=ls(all=TRUE))
#-------------------------------------------------------------------------------
#Basic simulation: 
#------------------------------------------------------------------------------------
#Gambler's ruin with doubling down
run_simulation<-function(starting_bet = 1, n_iter = 1000, p=0.5){
	money_made<-0
	bet=starting_bet
	for(i in 1:n_iter){
		result<-rbinom(1, 1, p) #Assume 1 means you won
		if(result == 1){
			#We won: 
			money_made<-append(money_made, money_made[length(money_made)]+bet)
			bet<-starting_bet
		}else{
			money_made<-append(money_made, money_made[length(money_made)]-bet)
			#We lost: 
			bet<-bet*2
		}
	}
	return(money_made)
}
#------------------------------------------------------------------------------------
#set.seed(1)
earnings<-run_simulation(p=0.5)
plot(earnings, type='l', ylab="Total Earnings", xlab="Iterations (Rounds Played)",
	main = "Gambler's Ruin (p=0.5)")

#How much we earned in total: 
earnings[length(earnings)] 
#How much did we lose?
range(diff(earnings))
#------------------------------------------------------------------------------------
#Loss Streaks
#------------------------------------------------------------------------------------
calculate_loss_streaks<-function(earnings){
	loss<-ifelse(diff(earnings) < 0, 1, 0)
	n<-length(loss)-1
	longest_loss_streak<-1
	streak<-1
	for(i in 1:n){
		if(loss[i] == 1){
			if(loss[i+1]==1){
				streak<-streak+1
			}else{
				longest_loss_streak<-max(longest_loss_streak, streak)
				streak<-1
			}
		}
	}
	return(longest_loss_streak)
}

print(calculate_loss_streaks(earnings))
#We observe that even when p=0.5, we almost never end with making a positive amount of money
#What threshold of p must exist for us to end with profits? 
#------------------------------------------------------------------------------------
#Repeating the simulation... 

#Helper functions: 
rbind_list<-function(x, list_iter, list_whole){
	return(rbind(list_whole[[x]], list_iter[[x]]))
}

winnings_all<-vector('list', 24)
loss_streaks<-c()
#Each list in the vector denotes different intervals of time we are playing for
#in 50 iteration increments
for(j in 1:1000){
	#Initialize: 
	winnings<-vector('list', 24)
	loss_streaks_iter<-c()
	for(p_win in seq(0.1, 0.9, by=0.05)){
		result<-run_simulation(p=p_win) #Simulation varies probability of winning a bet
		for(i in 1:24){
			if(i < 5){
				winnings[[i]]<-append(winnings[[i]], result[i*10])
			}else{
				winnings[[i]]<-append(winnings[[i]], result[(i-4)*50])	
			}
		}
		loss_streaks_iter<-append(loss_streaks_iter, calculate_loss_streaks(result))
	}
	winnings_all<-lapply(1:24, rbind_list, winnings_all, winnings)
	loss_streaks<-rbind(loss_streaks, loss_streaks_iter)
}
#------------------------------------------------------------------------------------
#Results: 
row.names(loss_streaks)<-NULL
loss_streaks
2^loss_streaks

#Average Winnings: 
average_winnings<-c()
for(i in 1:24){
	average_winnings<-rbind(average_winnings, colMeans(winnings_all[[i]]))
}
#------------------------------------------------------------------------------------
#Export Data: 
write.csv(average_winnings, 'data.csv')
write.csv(2^loss_streaks, 'largest_bets.csv')





