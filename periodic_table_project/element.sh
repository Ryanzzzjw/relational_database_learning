#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else
  # check existence of element
  RESULT=$($PSQL "SELECT COUNT(*) FROM elements WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name = '$1';")
  if [[ $RESULT == 0 ]]
  then
    echo "I could not find that element in the database."
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1' OR atomic_number::TEXT = '$1';")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    NAME=$($PSQL "SELECT NAME FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID;")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
    
  
fi


