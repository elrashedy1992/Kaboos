#!/bin/bash

# Check if nmap is installed
if ! command -v nmap &> /dev/null
then
    # Install nmap using apt
    sudo apt install nmap
fi

# Check if lolcat is installed
if ! command -v lolcat &> /dev/null
then
    # Install lolcat using gem
    sudo gem install lolcat
fi

# Check if figlet is installed
if ! command -v figlet &> /dev/null
then
    # Install figlet using apt
    sudo apt install figlet
fi

# Create a banner using lolcat and figlet
figlet -f slant "kaboos scanner" | lolcat

# Ask the user for the IP or domain
read -p "Enter the IP or domain to scan: " target

# Ask the user if they want to use proxychains
read -p "Do you want to use proxychains during the scanning process? (y/n) " proxy

# Check the user's answer
if [ "$proxy" == "y" ] || [ "$proxy" == "Y" ]
then
    # Activate the tor service with proxychains
    #tor
    #echo "Tor service activated with proxychains"
    # Display the available scanning commands
    echo "Choose one of the following scanning commands:"
    echo "1) proxychains4 nmap -sT -Pn -A -v $target"
    echo "2) proxychains4 nmap -sS -Pn -A -v $target"
    echo "3) proxychains4 nmap -sU -Pn -A -v $target"
    echo "4) proxychains4 nmap -sV -Pn -A -v $target"
    echo "5) proxychains4 nmap -sC -Pn -A -v $target"
    # Ask the user to choose a scanning command
    read -p "Enter the number of the scanning command: " scan
    # Check the user's choice
    case $scan in
        1) proxychains4 nmap -sT -Pn -A -v $target;;
        2) proxychains4 nmap -sS -Pn -A -v $target;;
        3) proxychains4 nmap -sU -Pn -A -v $target;;
        4) proxychains4 nmap -sV -Pn -A -v $target;;
        5) proxychains4 nmap -sC -Pn -A -v $target;;
        *) echo "Invalid choice";;
    esac
else
    # Display the available scanning commands
    echo "Choose one of the following scanning commands:"
    echo "1) nmap -sT -Pn -A -v $target"
    echo "2) nmap -sS -Pn -A -v $target"
    echo "3) nmap -sU -Pn -A -v $target"
    echo "4) nmap -sV -Pn -A -v $target"
    echo "5) nmap -sC -Pn -A -v $target"
    # Ask the user to choose a scanning command
    read -p "Enter the number of the scanning command: " scan
    # Check the user's choice
    case $scan in
        1) nmap -sT -Pn -A -v $target;;
        2) nmap -sS -Pn -A -v $target;;
        3) nmap -sU -Pn -A -v $target;;
        4) nmap -sV -Pn -A -v $target;;
        5) nmap -sC -Pn -A -v $target;;
        *) echo "Invalid choice";;
    esac
fi

# Ask the user if they want to check for vulnerabilities
read -p "Do you want to check for vulnerabilities? (y/n) " vuln

# Check the user's answer
if [ "$vuln" == "y" ] || [ "$vuln" == "Y" ]
then
    # Check for vulnerabilities using nmap scripts
    nmap --script vuln -Pn -A -v $target
    # Check if any vulnerabilities are found
    if grep -q "VULNERABLE" vuln.nmap
    then
        # Tell the user that vulnerabilities are found
        echo "Vulnerabilities are found"
        # Ask the user if they want to exploit the vulnerabilities
        read -p "Do you want to exploit the vulnerabilities? (y/n) " exploit
        # Check the user's answer
        if [ "$exploit" == "y" ] || [ "$exploit" == "Y" ]
        then
            # Exploit the vulnerabilities using nmap scripts
            nmap --script exploit -Pn -A -v $target
            # Check if the exploitation is successful
            if grep -q "Exploit completed" exploit.nmap
            then
                # Tell the user that the exploitation is successful
                echo "Exploitation is successful"
                # Show the user the information that was accessed after the exploitation
                cat exploit.nmap | grep -A 10 "Exploit completed"
            else
                # Tell the user that the exploitation failed
                echo "Exploitation failed"
            fi
        else
            # Tell the user that they chose not to exploit the vulnerabilities
            echo "You chose not to exploit the vulnerabilities"
        fi
    else
        # Tell the user that no vulnerabilities are found
        echo "No vulnerabilities are found"
    fi
else
    # Tell the user that they chose not to check for vulnerabilities
    echo "You chose not to check for vulnerabilities"
fi

# Ask the user if they want to continue using the tool
read -p "Do you want to continue using the tool? (y/n) " cont

# Check the user's answer
if [ "$cont" == "y" ] || [ "$cont" == "Y" ]
then
    # Start the script again
    ./kaboos.sh
else
    # Thank the user for using the tool and exit the program
    echo "Thank you for using the kaboos tool"
    exit 0
fi
