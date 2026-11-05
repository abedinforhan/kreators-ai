#!/usr/bin/env bash
<<<<<<< HEAD

if [ ! -f .venv/bin/python ]; then
    echo "Setup has not been completed yet."
    echo "Please run: bash setup.sh"
    exit 1
fi

=======
if [ ! -f .venv/kreators_setup_v2.ok ]; then
    echo "Setup has not been completed, or it is from an older version."
    echo "Please run: bash setup.sh   (and wait for SETUP COMPLETE)"
    exit 1
fi
>>>>>>> d2aae20 (fixed the issues)
source .venv/bin/activate

while true; do
    clear
    echo "=================================================="
    echo "                 KREATORS AI"
    echo "=================================================="
    echo
    echo "  [1] Train My AI"
<<<<<<< HEAD
    echo "  [2] Test My AI"
    echo "  [3] Exit"
    echo
    read -p "Choose an option: " choice
    case $choice in
        1) echo; echo "Starting training..."; echo; python train.py; echo; read -p "Press Enter..." ;;
        2) python test.py ;;
        3) exit 0 ;;
        *) echo "Choose 1, 2, or 3."; sleep 1 ;;
=======
    echo "  [2] Test My Trained AI (after training)"
    echo "  [3] Test Untrained Brain (base model - compare!)"
    echo "  [4] Exit"
    echo
    read -p "Choose an option: " choice
    case $choice in
        1) echo; python train.py; echo; read -p "Press Enter..." ;;
        2) python test.py ;;
        3) python test_base.py ;;
        4) exit 0 ;;
        *) echo "Choose 1-4."; sleep 1 ;;
>>>>>>> d2aae20 (fixed the issues)
    esac
done
