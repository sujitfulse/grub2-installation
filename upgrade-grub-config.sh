declare -a DATA
index=0
inc=1
NEW=2
OLD=1

fname="ostree-fedora-atomic-host-0.conf"
fname1="ostree-fedora-atomic-host-1.conf"

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
           echo "No New Deployment found !!!"
          // exit;
        fi

        if [ "$CURRENT" == "$NEW" ]; then
         echo "configuring bootconfig for new deployment";
        echo -e "menuentry 'Fedora 22 (Twenty Two) Ostree' { \n
        linux "${DATA[14]}" "${DATA[3]}" "${DATA[4]}"  "${DATA[5]}" \n
        initrd "${DATA[1]}"
        \n}" > grub-update.cfg
        fi
fi
index=0
done
