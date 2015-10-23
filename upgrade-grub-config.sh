declare -a DATA
index=0
inc=1
NEW=2
OLD=1
set -e
fname="ostree-fedora-atomic-host-0.conf"
fname1="ostree-fedora-atomic-host-1.conf"
cd /boot/loader/entries
for i in `ls -a *.*`
do
if [[ ("$i" == "$fname") || ("$i" == "$fname1") ]]; then
echo "$i"

while read -ra line;
do
    for word in "${line[@]}";
    do
       DATA[index]=`echo "$word"`;
       index=$(expr "$index" + "$inc")
    done;
        done < "$i"
        CURRENT=`echo ${DATA[16]}`;
        echo ${DATA[15]} $CURRENT

        if [ "$CURRENT" == "$OLD" ]; then
           echo "configuring bootconfig for old deployment";
        echo -e "menuentry 'Fedora 22 (Twenty Two) Ostree OLD' { \n
        linux "${DATA[14]}" "${DATA[3]}" "${DATA[4]}"  "${DATA[5]}" \n
        initrd "${DATA[1]}"
        \n}" > /boot/loader/grub1.cfg
        fi
        fi

        if [ "$CURRENT" == "$NEW" ]; then
         echo "configuring bootconfig for new deployment";
        echo -e "menuentry 'Fedora 22 (Twenty Two) Ostree NEW' { \n
        linux "${DATA[14]}" "${DATA[3]}" "${DATA[4]}"  "${DATA[5]}" \n
        initrd "${DATA[1]}"
        \n}" >> /boot/loader/grub1.cfg
        fi
fi
index=0
done
cd /boot/grub2/
rm grub.cfg
ln -s ../loader/grub1.cfg grub.cfg
