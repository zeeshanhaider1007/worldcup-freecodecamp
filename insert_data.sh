#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
truncate=$($PSQL "TRUNCATE TABLE teams,games")
# Do not change code above this line. Use the PSQL variable above to query your database.
#inserting into teams
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
# do not store header
if [[ $year != 'year' ]]
then

# inserting winner
team_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
# inserting if not already there
if [[ -z $team_id ]]
then
insert_team_id=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
fi

# inserting opponent
team_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
# inserting if not already there
if [[ -z $team_id ]]
then
insert_team_id=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
fi

fi
done

# inserting into games
cat games.csv | while IFS="," read year_ round_ winner opponent winner_goals_ opponent_goals_
do
#do not read first line
if [[ $year_ != 'year' ]]
then

# winner_id and opponent_id are referencing to teams first insert them rest of the values are straight forward to insert
winner_id=$($PSQL "SELECT team_id from teams WHERE name = '$winner'")
opponent_id=$($PSQL "SELECT team_id from teams WHERE name = '$opponent'")
insert_into_games=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year_, '$round_', $winner_id, $opponent_id, $winner_goals_, $opponent_goals_)")

fi

done