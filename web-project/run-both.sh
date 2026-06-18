#!/bin/bash
cd "$(dirname "$0")/backend"
npm install
npm run dev &
sleep 3
cd "../frontend"
npm install
npm run dev
