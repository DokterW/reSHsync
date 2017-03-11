#!/bin/bash
# reSHsync v0.1
# Made by Dr. Waldijk
# A simple manager for your Resilio Sync folders.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
# These configurations can be changed if you want to run this script from a specific location and use different filenames.
# It should be obvious how, but consult the README.md if you are unsure.
RESHVER="0.1"
RESHNAM="reSHsync"
RESHFIL="reSH.csv"
RESHCRP="reSH.csv.nc"
RESHESH="reSH.nc"
RESHLOC=""
#if [ ! -e $HOME/.dokter/reSHsync/reshloc ]; then
    #statements
#else
#    RESHLOC=$(cat $HOME/.dokter/reSHsync/reshloc)
#fi
# Supported algorithms: cast-128, gost, rijndael-128, twofish, arcfour, cast-256
#                       loki97, rijndael-192, saferplus, wake, blowfish-compat, des
#                       rijndael-256, serpent, xtea, blowfish, enigma, rc2b, tripledes
# Algorithm
RESHALG="twofish"
# Supported hashes: crc32, md5, sha1, haval256, ripemd160, tiger, gost, crc32b
#                   haval224, haval192, haval160, haval128, tiger128, tiger160, md4
#                   sha256, adler32, sha224, sha512, sha384, whirlpool, ripemd128
#                   ripemd256, ripemd320, snefru128, snefru256, md2
# Hash
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
    RESHESH=""
    RESHALG=""
    RESHHSH=""
    RESHPWD=""
    RESHDWP=""
    RESHPDC=""
    RESHPWDX=""
    RESHDWPX=""
}
reshclr () {
    RESHFOL=""
    RESHRED=""
    RESHREW=""
    RESHENT=""
    RESHCSV=""
    RESHLIN=""
    RESHMEM=""
    RESHDWP=""
    RESHPDC=""
    RESHPWDX=""
    RESHDWPX=""
}
reshgele () {
    if [ "$RESHLIN" -ge "$RESHCNT" ]; then
        RESHLIN=$(echo "$RESHCNT")
    elif [ "$RESHLIN" -le "0" ]; then
        RESHLIN="1"
    fi
}
reshentry () {
    RESHFOL=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 1)
    RESHRED=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 2)
    RESHREW=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 3)
    RESHENT=$(echo "$RESHMEM" | sed -n "$RESHLIN p" | cut -d , -f 4)
}
reshpmm () {
    echo "Password mismatch!"
    echo "Try again..."
    reshclr
    sleep 3
}
reshexpo () {
    echo "    Folder: $RESHFOL" > $HOME/reSH.txt
    echo "      Read: $RESHRED" >> $HOME/reSH.txt
    echo "Read/Write: $RESHREW" >> $HOME/reSH.txt
    echo " Encrypted: $RESHENT" >> $HOME/reSH.txt
    echo "" >> $HOME/reSH.txt
    echo "Exported from $RESHNAM v$RESHVER" >> $HOME/reSH.txt
}
# Install dependencies --------------------------------------------------------------
if [ ! -e /usr/bin/mcrypt ] && [ ! -e /usr/bin/shred ]; then
    sudo dnf -y install mcrypt shred
elif [ ! -e /usr/bin/mcrypt ]; then
    sudo dnf -y install mcrypt
elif [ ! -e /usr/bin/shred ]; then
    sudo dnf -y install shred
fi
# -----------------------------------------------------------------------------------
RESHLOG=1
while :; do
    clear
    if [ "$RESHLOG" = 1 ]; then
        if [ -e $HOME/.dokter/resh/$RESHESH ]; then
            echo "$RESHNAM v$RESHVER"
            echo ""
            read -p "(L)og in, (C)hange password or (Q)uit: " -s -n1 RESHKEY
            case "$RESHKEY" in
                [lL])
                    while :; do
                        clear
                        echo "$RESHNAM v$RESHVER"
                        echo ""
                        read -s -p "      Enter password: " RESHPWD
                        read -s -p "Enter password again: " RESHDWP
                        if [ "$RESHPWD" = "$RESHDWP" ]; then
                            mcrypt -qbd -a $RESHALG -h $RESHHSH $HOME/.dokter/resh/$RESHESH -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHCRP
                            RESHPDC=$(cat $HOME/.dokter/resh/reSH)
                            mcrypt -qb -a $RESHALG -h $RESHHSH $HOME/.dokter/resh/reSH -k $RESHPWD --flush
                            shred -uz $HOME/.dokter/resh/reSH
                            if [ "$RESHPWD" = "$RESHPDC" ]; then
                                RESHLOG=0
                            else
                                reshpmm
                            fi
                        else
                            reshpmm
                        fi
                    done
                ;;
                [cC])
                    while :; do
                        clear
                        echo "$RESHNAM v$RESHVER"
                        echo ""
                        read -s -p "      Enter old password: " RESHPWD
                        read -s -p "Enter old password again: " RESHDWP
                        read -s -p "      Enter new password: " RESHPWDX
                        read -s -p "Enter new password again: " RESHDWPX
                        if [ "$RESHPWD" = "$RESHDWP" ]; then
                            mcrypt -qbd -a $RESHALG -h $RESHHSH $HOME/.dokter/resh/$RESHESH -k $RESHPWD --flush
                            shred -uz $RESHLOC$RESHCRP
                            RESHPDC=$(cat $HOME/.dokter/resh/reSH)
                            mcrypt -qb -a $RESHALG -h $RESHHSH $HOME/.dokter/resh/reSH -k $RESHPWD --flush
                            shred -uz $HOME/.dokter/resh/reSH
                            if [ "$RESHPWD" = "$RESHPDC" ]; then
                                if [ "$RESHPWDX" = "$RESHDWPX" ]; then
                                    echo "$RESHPWDX" > $HOME/.dokter/resh/reSH
                                    shred -uz $RESHLOC$RESHCRP
                                    mcrypt -qb -a $RESHALG -h $RESHHSH $HOME/.dokter/resh/reSH -k $RESHPWD --flush
                                    shred -uz $HOME/.dokter/resh/reSH
                                    reshclr
                                    RESHPWD=""
                                else
                                    reshpmm
                                fi
                            else
                                reshpmm
                            fi
                        else
                            reshpmm
                        fi
                    done
                ;;
                [qQ])
                    clear
                    reshclear
                    break
                ;;
            esac
            if [ "$RESHPWD" = "$RESHPDC" ]; then
                RESHLOG=0
            else
                reshclr
                RESHPWD=""
            fi
        elif [ ! -e $HOME/.dokter/resh/$RESHESH ]; then
            echo "$RESHNAM v$RESHVER"
            echo ""
            read -p "(C)reate password or (Q)uit: " -s -n1 RESHKEY
            case "$RESHKEY" in
                [cC])
                    while :; do
                        clear
                        echo "$RESHNAM v$RESHVER"
                        echo ""
                        read -s -p "      Enter password: " RESHPWD
                        read -s -p "Enter password again: " RESHDWP
                        if [ "$RESHPWD" = "$RESHDWP" ]; then
                            echo "$RESHPWD" > $HOME/.dokter/resh/reSH
                            mcrypt -qb -a $RESHALG -h $RESHHSH $HOME/.dokter/resh/reSH -k $RESHPWD --flush
                            shred -uz $HOME/.dokter/resh/reSH
                            reshclr
                            RESHLOG=0
                            break
                        else
                            reshpmm
                        fi
                    done
                ;;
                [qQ])
                    reshclr
                    break
                ;;
            esac
        fi
    elif [ "$RESHLOG" = 0 ]; then
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
                    RESHCNT=$(cat $RESHLOC$RESHFIL | wc -l)
                    shred -uz $RESHLOC$RESHFIL
                    while :; do
                        clear
                        echo "$RESHNAM v$RESHVER"
                        echo ""
                        echo "$RESHMEM" | cut -d , -f 1 | nl -nrz -w2 -s- | sed 's/-/ /g'
                        echo ""
                        echo "01-99. List entry / RR. Browse all / BB. Back"
                        echo ""
                        read -p "Enter option: " -s -n2 RESHKEY
                        RESHLIN=$(echo "$RESHKEY" | sed 's/^0*//')
                        if [ "$RESHLIN" -gt "$RESHCNT" ] || [ "$RESHLIN" -lt "0" ]; then
                            continue
                        else
                            case "$RESHKEY" in
                                [0-9][0-9])
                                    clear
                                    reshentry
                                    echo "$RESHNAM v$RESHVER"
                                    echo ""
                                    echo "    Folder: $RESHFOL"
                                    echo "      Read: $RESHRED"
                                    echo "Read/Write: $RESHREW"
                                    echo " Encrypted: $RESHENT"
                                    echo ""
                                    read -p "(B)ack: " -s -n1 RESHKEY
                                    case "$RESHKEY" in
                                        [bB])
                                            #reshclr
                                            continue
                                        ;;
                                    esac
                                ;;
                                rr|RR)
                                RESHLIN="1"
                                while :; do
                                    clear
                                    reshentry
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
                                            reshgele
                                        ;;
                                        [pP])
                                            RESHLIN=$(expr $RESHLIN - 1)
                                            reshgele
                                        ;;
                                        [bB])
                                            # reshclr
                                            break
                                        ;;
                                    esac
                                done
                                ;;
                                bb|BB)
                                    # reshclr
                                    break
                                ;;
                            esac
                        fi
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
                    while :; do
                        clear
                        echo "$RESHNAM v$RESHVER"
                        echo ""
                        echo "$RESHMEM" | cut -d , -f 1 | nl -nrz -w2 -s- | sed 's/-/ /g'
                        echo ""
                        echo "BB. Back"
                        echo ""
                        read -p "Edit: " -s -n2 RESHKEY
                        RESHLIN=$(echo "$RESHKEY" | sed 's/^0*//')
                        if [ "$RESHLIN" -gt "$RESHCNT" ] || [ "$RESHLIN" -lt "0" ]; then
                            continue
                        else
                            case "$RESHKEY" in
                                [0-9][0-9])
                                    clear
                                    mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                                    shred -uz $RESHLOC$RESHFIL
                                    reshentry
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
                                            #reshclr
                                            continue
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
                                    #reshclr
                                ;;
                                bb|BB)
                                    reshclr
                                    break
                                ;;
                            esac
                        fi
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
                    while :; do
                        clear
                        echo "$RESHNAM v$RESHVER"
                        echo ""
                        echo "$RESHMEM" | cut -d , -f 1 | nl -nrz -w2 -s- | sed 's/-/ /g'
                        echo ""
                        read -p "DD. Delete / BB. Back: " -s -n2 RESHKEY
                        RESHLIN=$(echo "$RESHKEY" | sed 's/^0*//')
                        if [ "$RESHLIN" -gt "$RESHCNT" ] || [ "$RESHLIN" -lt "0" ]; then
                            continue
                        else
                            case "$RESHKEY" in
                                [0-9][0-9])
                                    mcrypt -qbd -a $RESHALG -h $RESHHSH $RESHLOC$RESHCRP -k $RESHPWD --flush
                                    shred -uz $RESHLOC$RESHCRP
                                    RESHMEM=$(cat $RESHLOC$RESHFIL | sed "$RESHLIN d")
                                    echo "$RESHMEM" > $RESHLOC$RESHFIL
                                    mcrypt -qb -a $RESHALG -h $RESHHSH $RESHLOC$RESHFIL -k $RESHPWD --flush
                                    shred -uz $RESHLOC$RESHFIL
                                    reshgele
                                ;;
                                bb|BB)
                                    reshclr
                                    break
                                ;;
                            esac
                        fi
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
                RESHLOG=1
                continue
            ;;
        esac
    fi
done
