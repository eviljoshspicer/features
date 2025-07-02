#!/bin/sh
set -e

echo "Activating feature 'fortune'"
echo "The provided category is: ${CATEGORY}"

# Create fortune command with developer-focused quotes
cat > /usr/local/bin/devfortune \
<< 'EOF'
#!/bin/sh

CATEGORY=${CATEGORY:-mixed}

get_motivational_quote() {
    quotes=(
        "Code is like humor. When you have to explain it, it's bad. - Cory House"
        "First, solve the problem. Then, write the code. - John Johnson"
        "Experience is the name everyone gives to their mistakes. - Oscar Wilde"
        "In order to be irreplaceable, one must always be different. - Coco Chanel"
        "Java is to JavaScript what car is to Carpet. - Chris Heilmann"
        "Knowledge is power. - Francis Bacon"
        "Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday's code. - Dan Salomon"
        "Perfection is achieved not when there is nothing more to add, but rather when there is nothing more to take away. - Antoine de Saint-Exupery"
    )
    echo "${quotes[$((RANDOM % ${#quotes[@]}))]}"
}

get_technical_quote() {
    quotes=(
        "Talk is cheap. Show me the code. - Linus Torvalds"
        "Programs must be written for people to read, and only incidentally for machines to execute. - Harold Abelson"
        "Any fool can write code that a computer can understand. Good programmers write code that humans can understand. - Martin Fowler"
        "Truth can only be found in one place: the code. - Robert C. Martin"
        "Give someone a program, you frustrate them for a day; teach them how to program, you frustrate them for a lifetime. - David Leinweber"
        "It's not a bug – it's an undocumented feature. - Anonymous"
        "Debugging is twice as hard as writing the code in the first place. - Brian Kernighan"
        "Code never lies, comments sometimes do. - Ron Jeffries"
    )
    echo "${quotes[$((RANDOM % ${#quotes[@]}))]}"
}

get_funny_quote() {
    quotes=(
        "Programming is 10% science, 20% ingenuity, and 70% getting the ingenuity to work with the science. - Anonymous"
        "There are only 10 types of people in the world: those who understand binary and those who don't. - Anonymous"
        "99 little bugs in the code, 99 little bugs. Take one down, patch it around, 117 little bugs in the code. - Anonymous"
        "A user interface is like a joke. If you have to explain it, it's not that good. - Martin LeBlanc"
        "I would love to change the world, but they won't give me the source code. - Anonymous"
        "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the universe trying to produce bigger and better idiots. So far, the universe is winning. - Rick Cook"
        "Software and cathedrals are much the same – first we build them, then we pray. - Anonymous"
        "Deleted code is debugged code. - Jeff Sickel"
    )
    echo "${quotes[$((RANDOM % ${#quotes[@]}))]}"
}

case $CATEGORY in
    "motivational")
        get_motivational_quote
        ;;
    "technical")
        get_technical_quote
        ;;
    "funny")
        get_funny_quote
        ;;
    *)
        # Mixed - randomly choose a category
        categories=("motivational" "technical" "funny")
        selected_category=${categories[$((RANDOM % 3))]}
        case $selected_category in
            "motivational") get_motivational_quote ;;
            "technical") get_technical_quote ;;
            "funny") get_funny_quote ;;
        esac
        ;;
esac
EOF

chmod +x /usr/local/bin/devfortune

echo "Fortune feature installed! Use 'devfortune' command to get developer quotes."