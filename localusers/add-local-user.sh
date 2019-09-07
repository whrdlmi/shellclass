#!/bin/bash
#
# This script creates a new user on the local system.
# You will be promted to enter the username (login), the person name, and a password.
# The username, password, and host for the account will be displayed

# Make sure the script is being executed with superuser privlidges.
if [[ "${UID}" -ne 0 ]]
then 
  echo 'Please run with sudo or as root.'
  exit 1
fi

# Get the username (login).
read -p 'Enter the user name to create: ' USERNAME

# Get the real name (contents for the description field).
read -p 'Enter the name of the person or application that will be using this account: ' COMMENT

# Get the password
read -p 'Enter the password for the new account: ' PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USERNAME}

# Check to see if the useradd command succeeded. 
if [[ "${?}" -ne 0 ]]
then
  echo 'The account could not be created.'
  exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USERNAME}

if [[ "${?}" -ne 0 ]]
then
  echo 'The password could not be set.'
  exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME}

if [[ "${?}" -ne 0 ]]
then
  echo 'The password could not be expired.'
  exit 1
fi

# Display the username, password, and the host where the user was created.
echo 
echo 'username:'
echo "${USERNAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'hostname:'
echo "${HOSTNAME}"
exit 0


