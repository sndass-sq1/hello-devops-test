#!/usr/bin/env bash
# Linux treasure hunt. From the repo root in Git Bash:
#   chmod +x maze/make-maze.sh     (make the script executable, once)
#   ./maze/make-maze.sh            (builds maze/island)
#
# Every run hides the clues in different places and creates a unique FLAG,
# so neighbours cannot copy (the FLAG carries their GitHub username). The story is always the same:
#   START_HERE.txt -> jungle: one chest.txt says "ls -a", .secret sits beside it
#   -> cave: grep finds the GOLD chest -> harbour: abandoned ship
#   -> beach: footprints -> village: "where the sun sets" = west
#   -> 50 treasure_chest-NN.txt files; 5 of them say "wc -l ship.log"
#   -> line count of village/west/ship.log = number of the treasure chest
set -e
cd "$(dirname "$0")"
rm -rf island && mkdir -p island && cd island

# Place names are printed in bold yellow so they stand out when you cat a file
C() { printf '\033[1;33m%s\033[0m' "$1"; }

pick() { local a=("$@"); echo "${a[RANDOM % $#]}"; }

DIRS4=(north south east west)
CAVE_DIRS=(north south east west northeast northwest southeast southwest)

# Every spot starts with a boring chest
for a in beach jungle village harbour; do
  for b in "${DIRS4[@]}"; do
    mkdir -p "$a/$b"
    echo "Nothing here but sand. Keep looking." > "$a/$b/chest.txt"
  done
done
for b in "${CAVE_DIRS[@]}"; do
  mkdir -p "cave/$b"
  echo "Too many chests to open one by one? Stand in the $(C cave) and search them all at once: grep -r ^GOLD ." > "cave/$b/chest.txt"
done

# Random hiding places for this run
JUNGLE=$(pick "${DIRS4[@]}")
CAVE=$(pick "${CAVE_DIRS[@]}")
HARBOUR=$(pick "${DIRS4[@]}")
BEACH=$(pick "${DIRS4[@]}")
ANSWER=$(( RANDOM % 39 + 11 ))                       # 11..49
while (( ANSWER % 10 == 0 )); do ANSWER=$(( RANDOM % 39 + 11 )); done
# FLAG carries the trainee's GitHub username, read from the repo they cloned
# (https://github.com/<user>/... or git@github.com:<user>/...). Fallback: random code.
GH_USER=$(git remote get-url origin 2>/dev/null | sed -nE 's#.*github\.com[:/]+([^/]+)/.*#\1#p')
FLAG="FLAG{linux-is-not-scary-${GH_USER:-$(printf '%04X%04X' $RANDOM $RANDOM)}}"

# Clue 1: the jungle
echo "Clue 1: Pirates hide their secrets deep in the $(C jungle). Find the hidden file!" > START_HERE.txt
echo "Psst... a parrot whispers: pirates hide things in files whose name starts with a dot. Plain ls cannot see them. Try: ls -a" > "jungle/$JUNGLE/chest.txt"
echo "Clue 2: You found the pirates' secret! They hid their GOLD somewhere in the $(C cave)." > "jungle/$JUNGLE/.secret"

# Clue 2: the cave (line must start with GOLD for grep ^GOLD)
echo "GOLD! Clue 3: The pirates know you are coming for their treasure, so they are running away in their ship! Catch them at the $(C harbour) before they sail." > "cave/$CAVE/chest.txt"

# Clue 3: the harbour
echo "Too late! The pirates have abandoned the ship and run off. Footprints lead to the $(C beach). Search the $(C beach) for the treasure." > "harbour/$HARBOUR/chest.txt"

# Clue 4: the beach
echo "More footprints... The pirates did not bury it here. They stored the treasure in the $(C village)." > "beach/$BEACH/chest.txt"

# Clue 5: the village (the sun sets in the west)
for b in north south east; do
  echo "The villager said they were heading in the direction the sun sets." > "village/$b/chest.txt"
done
rm village/west/chest.txt            # west holds only the 50 chests + ship.log

# The ship's log: random gibberish, only its number of lines matters
for i in $(seq 1 $ANSWER); do
  printf '%04x%04x %04x-%04x %04x\n' $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM >> village/west/ship.log
done

for i in $(seq -w 1 50); do
  echo "Empty, but we found a note: the right chest number is hidden in the ship's log. Keep opening other chests to find the decryption key." > "village/west/treasure_chest-$i.txt"
done
# One key hidden in every block of 10 chests (never the treasure chest)
for start in 1 11 21 31 41; do
  n=$(( start + RANDOM % 10 ))
  while (( n == ANSWER )); do n=$(( start + RANDOM % 10 )); done
  echo "We found the key! Run: wc -l ship.log" > "village/west/treasure_chest-$(printf %02d $n).txt"
done
echo "$FLAG  Shout it out to win!" > "village/west/treasure_chest-$(printf %02d $ANSWER).txt"

echo "Island created. Start with:  cd maze/island   then   cat START_HERE.txt"
