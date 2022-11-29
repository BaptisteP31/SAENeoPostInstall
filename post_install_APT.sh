#!/bin/bash

if [ "$EUID" != 0 ] #Demande les accès administrateur si l'utilisateur n'est pas super user
then
    sudo "$0" "$@"
    exit $?
fi

if whiptail --title "PostInstall" --yesno "Bienvenue dans le script d'installation NeoPostInstall édition SAÉ, ce script installera les paquets nécessaires à la réalisation de la SAÉ S1-03" 8 78 --yes-button "Continuer" --no-button "Quitter";
then

    sudo apt update -y && sudo apt upgrade -y

    SELECTED=$(whiptail --title "Sélection des paquets à installer" --checklist "Sélectionnez les paquets à installer (il est conseillé d'installer ceux qui sont déjà sélectionnés)" 20 75 10 \
    g++ "Compilateur C++" ON \
    gcc "Compilateur C" ON \
    make "Constructeur de fichiers" ON \
    build-essentials "Essentiels pour la compilation" ON \
    git "Utilisé pour le contrôle de version" ON \
    wget "Utilisé pour le téléchargement de fichiers" ON \
    curl "Utilisé pour le téléchargement à disance" ON \
    vim "Meilleur éditeur de texte" ON \
    python3 "Pour le développement en python" ON \
    htop "top, en mieux" ON 3>&1 1>&2 2>&3) #Redirection de la sortie


    SELECTED=$(echo $SELECTED | sed 's/"//g') #Retire les "" par substitution

    for i in $SELECTED #Pour chaque paquet sélectionné ...
    do
        sudo apt install -y $i
    done

    whiptail --title "Terminé" --msgbox "L'installation des paquets sélectionnés est terminée." 10 50

    if whiptail --title "Paquets supplémentaires" --yesno "Souhaitez vous installer des paquets supplémentaires (non essentiels) ?" 8 78 --yes-button "Oui" --no-button "Non, bloat is bloat";
    then

        SELECTED_OPT=$(whiptail --title "Paquets supplémentaire" --checklist "Les paquets ci-dessous sont nons essentiels et de ce fait ne doivent être installé que si vous avez \"l'utilité\"" 20 65 10 \
        neofetch "Pour montrer à tout le monde votre distro" OFF \
        zsh "un joli shell" OFF  3>&1 1>&2 2>&3) #Redirection de la sortie

        SELECTED_OPT=$(echo $SELECTED_OPT | sed 's/"//g') #Retire les "" par substitution
        for i in $SELECTED_OPT
        do
            sudo apt install -y $i
        done

    fi

    whiptail --title "Terminé" --msgbox "L'installation est terminée, merci d'avoir utilisé NeoPostInstall édition SAE" 10 50

fi