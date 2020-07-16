name=`echo $SEED | sha1sum | cut -d ' ' -f 1`.elf

cp challenge.elf /tmp/challenge.elf
echo /tmp/challenge.elf
