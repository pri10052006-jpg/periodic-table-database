#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::TEXT='$1' OR symbol='$1' OR name='$1'")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

$PSQL "SELECT 'The element with atomic number ' || elements.atomic_number || ' is ' || elements.name || ' (' || elements.symbol || '). It''s a ' || types.type || ', with a mass of ' || properties.atomic_mass || ' amu. ' || elements.name || ' has a melting point of ' || properties.melting_point_celsius || ' celsius and a boiling point of ' || properties.boiling_point_celsius || ' celsius.' FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number=$ELEMENT;"
