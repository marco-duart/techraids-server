#!/bin/bash

APP_DIR="/home/bulk/tech-raids/techraids-server"
LOG_FILE="$APP_DIR/log/production.log"
PID_FILE="$APP_DIR/tmp/pids/server.pid"
PORT=3005

echo "Starting TechRaids Server..."

cd $APP_DIR

if [ -f $PID_FILE ]; then
    echo "Server might already be running. PID: $(cat $PID_FILE)"
    echo "Stop it first with: systemctl stop techraids-server"
    exit 1
fi

echo "Checking dependencies..."
bundle check || bundle install

echo "Running database migrations..."
bundle exec rails db:migrate RAILS_ENV=production

echo "Precompiling assets..."
bundle exec rails assets:precompile RAILS_ENV=production

echo "Starting Rails server on port $PORT..."
bundle exec rails s -e production -p $PORT > $LOG_FILE 2>&1 &

SERVER_PID=$!
echo $SERVER_PID > $PID_FILE
echo "Server started with PID: $SERVER_PID"
echo "Logs: $LOG_FILE"