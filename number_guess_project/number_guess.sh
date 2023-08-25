#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
secret_number=$(($RANDOM % 1000 + 1))
echo -e "Enter your username:"
read username

user=$($PSQL "SELECT username FROM users WHERE username = '$username';")


if [[ -z $user ]]
then
    # If user doesn't exist, create a new entry for the user in the database
    INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$username');")
    echo "Welcome, $username! It looks like this is your first time here."
else
    # If user exists, retrieve their data and print the welcome back message
    games_played=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING(user_id) WHERE username = '$username';")
    best_game=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN users USING(user_id) WHERE username = '$username';")
    
    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

user_id=$($PSQL "SELECT user_id FROM users WHERE username = '$username';")
number_of_guess=0
echo "Guess the secret number between 1 and 1000:"

# Loop until the user guesses the correct number
while read user_guess
do
  
  # Check if input is an integer
  if [[ ! $user_guess =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    read user_guess
  fi

  number_of_guess=$((number_of_guess + 1))
  
  # Check if the guess is too high, too low or correct
  if [[ $user_guess -gt $secret_number ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $user_guess -lt $secret_number ]]
  then
    echo "It's higher than that, guess again:"
  else
    echo "You guessed it in $number_of_guess tries. The secret number was $secret_number. Nice job!"
    INSERT_GAME=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($user_id, $number_of_guess);")

    break
  fi

done
