#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]] # Used to skip the first line of the csv
  then
    # Try to get a team_id with the given name
    WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    if [[ -z $WINNER_TEAM_ID ]] # If the winner team doesn't exist, add it and get the ID
    then
      ADD_WINNER_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi

    # Try to get a team_id with the given name
    OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $OPPONENT_TEAM_ID ]] # If the opponent team doesn't exist, add it and get the ID
    then
      ADD_OPPONENT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi


    INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
  fi
done
