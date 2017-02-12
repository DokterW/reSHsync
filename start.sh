#!/bin/bash
# reSHsync v0.1
# Made by Dr. Waldijk
# A simple manager for your Resilio Sync folders.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
RESHVER="0.1"
RESHNAM="reSHsync"
RESHFIL="reSH.csv"
RESHCRP="reSH.csv.nc"
RESHLOC=""
# Supported algorithms: cast-128, gost, rijndael-128, twofish, arcfour, cast-256
#                       loki97, rijndael-192, saferplus, wake, blowfish-compat, des
#                       rijndael-256, serpent, xtea, blowfish, enigma, rc2b, tripledes
RESHALG="twofish"
# Supported hashes: crc32, md5, sha1, haval256, ripemd160, tiger, gost, crc32b
#                   haval224, haval192, haval160, haval128, tiger128, tiger160, md4
#                   sha256, adler32, sha224, sha512, sha384, whirlpool, ripemd128
#                   ripemd256, ripemd320, snefru128, snefru256, md2
RESHHSH="whirlpool"
# Function --------------------------------------------------------------------------
reshclear () {
    RESHFOL=""
    RESHRED=""
    RESHREW=""
    RESHENT=""
    RESHCSV=""
    RESHLIN=""
    RESHMEM=""
    RESHVER=""
    RESHNAM=""
    RESHLOC=""
    RESHFIL=""
    RESHCRP=""
    RESHALG=""
    RESHHSH=""
    RESHPWD=""
}
reshclr () {
    RESHFOL=""
    RESHRED=""
    RESHREW=""
    RESHENT=""
    RESHCSV=""
    RESHLIN=""
    RESHMEM=""
    RESHPWD=""
}
reshnepr () {
    if [ "$RESHLIN" -ge "$RESHCNT" ]; then
        RESHLIN=$(echo "$RESHCNT")
    elif [ "$RESHLIN" -le "0" ]; then
        RESHLIN="1"
    fi
}
reshdel () {
    if [ "$RESHLIN" = "0[1-9]" ]; then
        RESHKEY=$(echo $RESHLIN | cut -c 2)
    fi
}
# Install dependencies --------------------------------------------------------------
if [ ! -e /usr/bin/mcrypt ]; then
    sudo dnf -y install mcrypt
fi
if [ ! -e /usr/bin/shred ]; then
    sudo dnf -y install shred
fi
# -----------------------------------------------------------------------------------
while :
do
    clear
    echo "$RESHNAM v$RESHVER"
    echo ""
    echo "A. Add entry  |  R. Read list  |  E. Edit entry  |  D. Delete entry"
    echo "Q. Quit"
    echo ""
    read -p "Enter option: " -s -n1 RESHKEY
    case "$RESHKEY" in
        [aA])
            clear
            echo "$RESHNAM v$RESHVER"
            echo ""
            read -p "    Folder: " RESHFOL
            read -p "      Read: " RESHRED
            read -p "Read/Write: " RESHREW
            read -p " Encrypted: " RESHENT
            RESHCSV=$(echo $RESHFOL,$RESHRED,$RESHREW,$RESHENT)
            echo ""
            read -s -p "Enter password: " RESHPWD
            if [ -e $RESHLOC$RESHCRP ]; then
                mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                shred -uz $RESHLOC$RESHCRP
                echo "$RESHCSV" >> $RESHLOC$RESHFIL
                RESHMEM=$(cat $RESHLOC$RESHFIL | sort -f | sed '/^$/d' | sed '/./!d')
                echo "$RESHMEM" > $RESHLOC$RESHFIL
            else
                echo "$RESHCSV" > $RESHLOC$RESHFIL
            fi
            mcrypt -qb -a $RESHALG -h $RESHHSH $RESHLOC$RESHFIL -k $RESHPWD --flush
            shred -uz $RESHLOC$RESHFIL
            reshclr
        ;;
        [rR])
            clear
            if [ -e $RESHLOC$RESHCRP ]; then
                echo "$RESHNAM v$RESHVER"
                echo ""
                read -s -p "Enter password: " RESHPWD
                mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                RESHMEM=$(cat $RESHLOC$RESHFIL)
                RESHLIN="1"
                RESHCNT=$(cat $RESHLOC$RESHFIL | wc -l)
                shred -uz $RESHLOC$RESHFIL
                while :; do
                    clear
                    RESHFOL=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 1)
                    RESHRED=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 2)
                    RESHREW=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 3)
                    RESHENT=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 4)
                    echo "$RESHNAM v$RESHVER"
                    echo ""
                    echo "    Folder: $RESHFOL"
                    echo "      Read: $RESHRED"
                    echo "Read/Write: $RESHREW"
                    echo " Encrypted: $RESHENT"
                    echo ""
                    read -p "(N)ext / (P)revious / (B)ack: " -s -n1 RESHKEY
                    case "$RESHKEY" in
                        [nN])
                            RESHLIN=$(expr $RESHLIN + 1)
                            reshnepr
                        ;;
                        [pP])
                            RESHLIN=$(expr $RESHLIN - 1)
                            reshnepr
                            ;;
                        [bB])
                            reshclr
                            break
                        ;;
                    esac
                done
            else
                echo "Nothing to read here. Try to create an entry first."
                echo ""
                read -p "Press (the infamous) any key to continue... " -n1 -s
            fi
        ;;
        [eE])
            if [ -e $RESHLOC$RESHCRP ]; then
                clear
                echo "$RESHNAM v$RESHVER"
                echo ""
                read -s -p "Enter password: " RESHPWD
                mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                RESHMEM=$(cat $RESHLOC$RESHFIL)
                RESHCNT=$(cat $RESHLOC$RESHFIL | wc -l)
                shred -uz $RESHLOC$RESHFIL
                RESHFOL=$(echo "$RESHMEM" | cut -d , -f 1)
                while :; do
                    clear
                    echo "$RESHNAM v$RESHVER"
                    echo ""
                    echo "$RESHFOL" | nl -nrz -w2 -s- | sed 's/-/ /g'
                    echo ""
                    echo "BB. Back"
                    echo ""
                    read -p "Edit: " -s -n2 RESHKEY
                    RESHLIN=$(echo "$RESHKEY")
                    case "$RESHKEY" in
                        [0-9][0-9])
                            clear
                            mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHFIL
                            reshdel
                            RESHFOL=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 1)
                            RESHRED=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 2)
                            RESHREW=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 3)
                            RESHENT=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 4)
                            echo "$RESHNAM v$RESHVER"
                            echo ""
                            echo "1)     Folder: $RESHFOL"
                            echo "2)       Read: $RESHRED"
                            echo "3) Read/Write: $RESHREW"
                            echo "4)  Encrypted: $RESHENT"
                            echo ""
                            echo "(B)ack"
                            echo ""
                            read -p "Edit: " -s -n1 RESHKEY
                            clear
                            case "$RESHKEY" in
                                1)
                                    echo "$RESHNAM v$RESHVER"
                                    echo ""
                                    echo "Old value: " $RESHFOL
                                    read -p "New value: " RESHFOL
                                ;;
                                2)
                                    echo "$RESHNAM v$RESHVER"
                                    echo ""
                                    echo "Old value: " $RESHRED
                                    read -p "New value: " RESHRED
                                ;;
                                3)
                                    echo "$RESHNAM v$RESHVER"
                                    echo ""
                                    echo "Old value: " $RESHREW
                                    read -p "New value: " RESHREW
                                ;;
                                4)
                                    echo "$RESHNAM v$RESHVER"
                                    echo ""
                                    echo "Old value: " $RESHENT
                                    read -p "New value: " RESHENT
                                ;;
                                [bB])
                                    reshclr
                                    break
                                ;;
                            esac
                            RESHCSV=$(echo $RESHFOL,$RESHRED,$RESHREW,$RESHENT)
                            mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHCRP
                            RESHMEM=$(cat $RESHLOC$RESHFIL | sed "$RESHLIN d")
                            echo "$RESHMEM" > $RESHLOC$RESHFIL
                            echo "$RESHCSV" >> $RESHLOC$RESHFIL
                            RESHMEM=$(cat $RESHLOC$RESHFIL | sort -f | sed '/^$/d' | sed '/./!d')
                            echo "$RESHMEM" > $RESHLOC$RESHFIL
                            mcrypt -qb -a $RESHALG -h $RESHHSH $RESHLOC$RESHFIL -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHFIL
                            reshclr
                        ;;
                        bb|BB)
                            reshclr
                            break
                        ;;
                    esac
                done
            else
                echo "Nothing to edit here. Try to create an entry first."
                echo ""
                read -p "Press (the infamous) any key to continue... " -n1 -s
            fi
        ;;
        [dD])
            clear
            if [ -e $RESHLOC$RESHCRP ]; then
                echo "$RESHNAM v$RESHVER"
                echo ""
                read -s -p "Enter password: " RESHPWD
                mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                RESHMEM=$(cat $RESHLOC$RESHFIL)
                RESHCNT=$(cat $RESHLOC$RESHFIL | wc -l)
                shred -uz $RESHLOC$RESHFIL
                RESHFOL=$(echo "$RESHMEM" | cut -d , -f 1)
                while :; do
                    clear
                    echo "$RESHNAM v$RESHVER"
                    echo ""
                    echo "$RESHFOL" | nl -nrz -w2 -s- | sed 's/-/ /g'
                    echo ""
                    read -p "DD. Delete / BB. Back: " -s -n2 RESHKEY
                    RESHLIN=$(echo "$RESHKEY")
                    case "$RESHKEY" in
                        [0-9][0-9])
                            mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHCRP
                            reshdel
                            RESHMEM=$(cat $RESHLOC$RESHFIL | sed "$RESHLIN d")
                            echo "$RESHMEM" > $RESHLOC$RESHFIL
                            mcrypt -qb -a $RESHALG -h $RESHHSH $RESHLOC$RESHFIL -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHFIL
                            reshnepr
                        ;;
                        BB|BB)
                            reshclr
                            break
                        ;;
                    esac
                done
            else
                echo "Nothing to delete here. Try to create an entry first."
                echo ""
                read -p "Press (the infamous) any key to continue... " -n1 -s
            fi
        ;;
        [qQ])
            clear
            reshclear
            break
        ;;
    esac
done
