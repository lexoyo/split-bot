cat license.txt add_to_haxe_js.txt bin/SplitBotTmp.js > bin/SplitBot.js
sudo cp bin/SplitBot.js "/usr/share/games/0ad/mods/public/simulation/ai/SplitBot/SplitBot.js"
sudo cp license.txt "/usr/share/games/0ad/mods/public/simulation/ai/SplitBot/license.txt"
./start_game_for_test.sh
