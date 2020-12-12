#!/bin/bash

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#shotcuts 
alias project='cd ~/Documents/Project/ && la'
alias Downloads='cd ~/Downloads/ &&  la'



#show external drives
alias usb='cd /media/${USER}/ 2>/dev/null && la' #show installed drives 

#Navigate to Phone storage
alias phone='cd /run/user/1000/gvfs/*/ 2>/dev/null && la' 
