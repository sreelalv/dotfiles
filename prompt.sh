#!/bin/bash

__prompt__(){


	if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
        TERM='gnome-256color'
    elif infocmp xterm-256color >/dev/null 2>&1; then
        TERM='xterm-256color'
    fi


	prompt_git() {
        local s=''
        local branchName=''

        # Check if the current directory is in a Git repository.
        git rev-parse --is-inside-work-tree &>/dev/null || return

        # Check for what branch we’re on.
        # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
        # tracking remote branch or tag. Otherwise, get the
        # short SHA for the latest commit, or give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git describe --all --exact-match HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')"

        # Early exit for Chromium & Blink repo, as the dirty check takes too long.
        repoUrl="$(git config --get remote.origin.url)"
        if grep -q 'chromium/src.git' <<< "${repoUrl}"; then
            s+="${UNX}●"
        else
        	# Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+="${UNT}●"
            fi
            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s+="${UNS}●"
            fi
            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+="${STH}●"
            fi
            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+="${STG}●"
            fi
        fi

        [ -n "${s}" ] && details=" ${s}"
   
        branch="${BRANCH_COLOR}${branchName}"


        final_git_details=" ${BRK}git:(${branch}${BRK})${details}"
        echo -e "${final_git_details}"
    }



	# Highlight the user name when logged in as root.
   	if [[ "${USER}" == "root" ]]; then
       	PROMPT_USER="${TX3} ROOT "
   	else
        PROMPT_USER="${USER_NAME}"
   	fi


    ps1(){

        # Check exit status of last executed process, the prompt the prompt accordingly
        if [ "$?" -eq 0 ]; then
            local PROMPT_RESULT="${TX1} ${PROMPT_SYMBOL} "
        else
            local PROMPT_RESULT="${TX2} ${PROMPT_SYMBOL} "
        fi
    	
    	PS1="\n"
        PS1+="${PROMPT_USER}${P_IN}"
        PS1+="${PROMPT_RESULT}${P_IN} "
        PS1+="${TX4}\W${P_N}"
        PS1+="$(prompt_git)${P_N}"
        PS1+="${P_IN} "
    }
    
    PROMPT_COMMAND=ps1

    PS2="${PS2_COLOR} ➤${P_IN} "
}


format_font(){
        
        local output=$1
        local F=$FG
        local B=$BG
        local E

       
        case $# in
                2)
						[ $2 = $FG_DEFAULT ] && F=""
                        eval $output="'\[\e[0${F}${2}m\]'"
                        ;;
                3)
						[ $2 = $DEFAULT ] && E="" || E=$2
						[ $3 = $FG_DEFAULT ] && F=""
                        eval $output="'\[\e[0${E}${F}${3}m\]'"
                        ;;
                4)
						[ $2 = $DEFAULT ] && E="" || E=$2
						[ $3 = $FG_DEFAULT ] && F=""
						[ $4 = $BG_DEFAULT ] && B=""

                        eval $output="'\[\e[0${E}${F}${3}${B}${4}m\]'"
                        ;;
                *)
                        output="'\[\e[0m\]'"
                        ;;
        esac

}


__customize_prompt__(){


        ############################################################################
        ##                          COLOR CODES                                   ##
        ############################################################################


                
        ## FONT EFFECT
        local      BOLD=";1"
        local       DIM=";2"
        local UNDERLINE=";4"
        local     BLINK=";5"
        local    INVERT=";7"
        local    HIDDEN=";8"

        ##DEFAULTS
		local	FG_DEFAULT=";39"
        local   BG_DEFAULT=";49"
        local	   DEFAULT="0"


        ## COLORS, 256 COLOR SHEETS BASED
        local     BLACK=";0"
        local     WHITE=";15"
        local       RED=";160"
        local     GREEN=";46"
        local	D_GREEN=";22"
        local    YELLOW=";184"
        local      BLUE=";20"
        local    L_BLUE=";32"
        local   MAGENTA=";5"
        local      CYAN=";14"
        local    ORANGE=";166"
        local      LIME=";10"
        local      GRAY=";235"
        local      PINK=";201"
        
        ## TYPE
        local       RE="\[\e[0m\]" #RESET
        local     NONE=""
        local       FG=";38;5"   #FOREGROUND TEXT COLOR
        local       BG=";48;5"  #BACKGROUND TEXT COLOR


        ##################################################################################################
        ##                                                                                              ##
        ##                          >>>>>>>>>>EDIT YOUR PROMPT HERE<<<<<<<<<<                           ##
        ##                                                                                              ##
        ##################################################################################################

        #SET OVERALL BACKGROUND DEFAULT
        SET_DEFAULT_BG='NO'   #set [YES/NO] #Recommended 'YES' for a neat prompt, Also try 'NO' for different varieties of styles
		SET_DEFAULT_FG='NO'		#NOT Recommeded # Feel free to use different Forground Colours and 
		STABLE_BG=$BG_DEFAULT
		STABLE_FG=$FG_DEFAULT


        #INPUT FORMAT
        P_IN=$RE                #Set default font color to terminal
        PROMPT_SYMBOL="→"
#        PROMPT_SYMBOL="▶"

        #To add username
        local USR_NAME=""   #Enter username to add username to the prompt
        local USR_F=$WHITE
        local USR_B=$L_BLUE
        local USR_T=$BOLD

        # SUCCESS PROMPT
        #Checks for the exit code for last executed program/code and prompts accordingly.( Exit status =0 )
        local FC1=$GREEN        			#FONT_COLOR_1
        local BG1=$L_BLUE       			#BACKGROUND_1
        local TE1=$BOLD      				#TEXT_EFFECT_1

        # FAILED PROMPT
        #Checks for the exit code for last executed program/code and prompts accordingly.( Exit status !=0 )
        local FC2=$WHITE   					#FONT_COLOR_2
        local BG2=$RED 	        			#BACKGROUND_2
        local TE2=$BOLD         			#TEXT_EFFECT_2


        # ROOT LOGIN PROMPT
        local FC3=$RED 						#FONT_COLOR_3
        local BG3=$BG_DEFAULT   			#BACKGROUND_3
        local TE3=$BOLD         			#TEXT_EFFECT_3


        #Working Directory 
        local FC4=$CYAN					#FONT_COLOR_4
        local BG4=$BG_DEFAULT				#BACKGROUND_4
        local TE4=$BOLD 					#TEXT_EFFECT_4
        
        ## PS2
        local FCX=$YELLOW       			#FONT_COLOR_PS2
        local BGX=$BG_DEFAULT   			#BACKGROUND_PS2
        local TEX=$DEFAULT      			#TEX_TEFFECT_PS2


        ###GIT REPOSITORY FORMAT STYLE

        # STATUS
		local   EFFECT=$BOLD
		local	BG_GIT=$BG_DEFAULT

        ##STATUS
		local  UNTRACK=$RED
		local UNSTAGED=$ORANGE
		local    STASH=$PINK
		local   STAGED=$GREEN

		## BRANCH 
		local FC_BR=$RED					#FONT_COLOR_BRANCH
		local BG_BR=$BG_DEFAULT					#BACKGROUND_COLOR_BRANCH
		local TE_BR=$BOLD					#TEXT_EFFECTT_BRANCH

        #git brackets
        local FCb=$BLUE
        local BGb=$BG_DEFAULT
        local TEb=$BOLD



        ##################################################################################################
        ##                                          END                                                 ##
        ##################################################################################################


		if [ $SET_DEFAULT_BG = 'YES' ]; then
			local    BG1=$STABLE_BG
			local    BG2=$STABLE_BG
			local    BG3=$STABLE_BG
			local    BG4=$STABLE_BG
			local	 BGX=$STABLE_BG
			local BG_GIT=$STABLE_BG
			local  BG_BR=$STABLE_BG
		fi
		if [ $SET_DEFAULT_FG = 'YES' ]; then
			local    FG1=$STABLE_FG
			local    FG2=$STABLE_FG
			local    FG3=$STABLE_FG
			local    FG4=$STABLE_FG
			local	 FGX=$STABLE_FG
			local FG_GIT=$STABLE_FG
			local  FG_BR=$STABLE_FG
		fi

        if [ -n USR_NAME ]; then
            format_font USR $USR_T $USR_F $USR_B        #USERNAME_FORMAT
            USER_NAME="${USR}${USR_NAME}"
            export USER_NAME
        fi

        format_font TX1 $TE1 $FC1 $BG1 					#TEXT_FORMAT_1
        export TX1
        format_font TX2 $TE2 $FC2 $BG2      			#TEXT_FORMAT_2
        export TX2
        format_font TX3 $TE3 $FC3 $BG3      			#TEXT_FORMAT_3
        export TX3
		format_font TX4 $TE4 $FC4 $BG4      			#TEXT_FORMAT_4
        export TX4
        format_font PS2_COLOR $TEX $FCX $BGX    		#TEXT_FORMAT_PS2
        export PS2_COLOR
		format_font BRANCH_COLOR $TE_BR $FC_BR $BG_BR 	#BRANCH_COLOR
		export BRANCH_COLOR
		format_font UNT $EFFECT $UNTRACK $BG_GIT
		export UNT
		format_font UNS $EFFECT $UNSTAGED $BG_GIT
		export UNS


        format_font BRK $TEb $FCb $BGb
        export UNS


		format_font STH $EFFECT $STASH $BG_GIT
		export STH
		format_font STG $EFFECT $STAGED $BG_GIT
		export STG
		format_font UNX $EFFECT $MAGENTA $BG_GIT
		export UNX




}

__customize_prompt__
unset __customize_prompt__
__prompt__
unset __prompt__