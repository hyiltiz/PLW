#! /bin/bash

echo "Are you sure you do NOT need all the test.mat buggy.mat data files?"
select var in "Yes, delete them" "No, STOP!" ; do
  break
done
echo "You have selected: $var";

if [ "$var" = "Yes, delete them" ]; then
  echo "Then I'll delete them all.";
  for file in test test.mat buggy buggy.mat all all.mat; do
    find . -name $file -exec svn rm '{}' \;
  done;
  echo "All cleared successfully!";
else
  echo "Check if you still need any of them!";
fi

#if $var
#find . -name all -exec svn rm '{}' \;
#find . -name test -exec svn rm '{}' \;
#find . -name buggy -exec svn rm '{}' \;
#find . -name all.mat -exec svn rm '{}' \;
#find . -name test.mat -exec svn rm '{}' \;
#find . -name buggy.mat -exec svn rm '{}' \;
