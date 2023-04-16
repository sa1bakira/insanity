#!/bin/sh

cp -v /home/panku/bin/* /home/panku/websites/insanity/_backup/bin

printf """
<!DOCTYPE html>
<html>
    <head>
        <title>insanity</title>
    </head>

<body>

""" > /home/panku/websites/insanity/list.html

for FILE in $(find /home/panku/websites/insanity/_backup/bin | tail -n+2); do
    printf "<a href=\"%s\">%s</a><br>\n" "$FILE" "$(echo "$FILE" | rev | cut -d '/' -f1 | rev )" >> /home/panku/websites/insanity/list.html
done

printf """
</body>

</html>
""" >> /home/panku/websites/insanity/list.html

git -C /home/panku/websites/insanity status
git -C /home/panku/websites/insanity add -A
git -C /home/panku/websites/insanity commit -m "backup"
git -C /home/panku/websites/insanity push
