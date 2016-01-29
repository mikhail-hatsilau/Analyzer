#!/bin/bash
echo Starting application
npm install
grunt build
node app.js
firefox http://localhost:3000/
exit
