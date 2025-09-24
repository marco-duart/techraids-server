#!/bin/bash
echo "Starting Rails server"

bundle exec rails s -e production -p 3005

echo "Application started successfully"