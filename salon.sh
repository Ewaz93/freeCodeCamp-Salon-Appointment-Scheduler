#! /bin/bash
# This script was written by Ewaz93 with debugging assistance from AI, I did my best possible.

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ PROFESSIONAL SERVICE SCHEDULER ~~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]

  then 

  echo -e "\n$1"

  fi

  echo "How can we help you today? Please choose a service:"

  LIST_SERVICES=$($PSQL "select service_id, name from services order by service_id")

  echo "$LIST_SERVICES" | while IFS="|" read ID NAME

  do

  echo "$ID) $NAME"

  done

  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]

  then 

  MAIN_MENU "That is not a valid number. Please try again."

  else

  SERVICE_NAME=$($PSQL "select name from services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_NAME ]]

  then 

  MAIN_MENU "I could not find that SERVICE. What would you like today?"

  else 

  echo -e "\nWhat's your phone number?"

  read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]

then 

echo -e "\nI don't have a record for $CUSTOMER_PHONE. What's your name?"

read CUSTOMER_NAME

INSERT_CUST=$($PSQL "INSERT INTO customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

fi

CUST_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")

CLEAN_NAME=$(echo $CUSTOMER_NAME | sed -E 's/^ +| +$//g')

CLEAN_SERVICE=$(echo $SERVICE_NAME | sed -E 's/^ +| +$//g')

echo -e "\nWhat time would you like your $CLEAN_SERVICE, $CLEAN_NAME?"

read SERVICE_TIME

INSERT_APP=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUST_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo -e "\nI have put you down for a $CLEAN_SERVICE at $SERVICE_TIME, $CLEAN_NAME."

fi

fi

}

MAIN_MENU


