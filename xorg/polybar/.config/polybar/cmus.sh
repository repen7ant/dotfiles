#!/bin/bash

prepend_zero() {
    seq -f "%02g" $1 $1
}

STATUS=$(cmus-remote -C status 2>/dev/null)
artist=$(echo -n $(echo "$STATUS" | grep "tag artist" | cut -c 12-))

if [[ $artist = *[!\ ]* ]]; then
    song=$(echo -n $(echo "$STATUS" | grep "tag title" | cut -c 11-))
    position=$(echo "$STATUS" | grep "^position" | cut -c 10-)
    duration=$(echo "$STATUS" | grep "^duration" | cut -c 10-)
    minutes1=$(prepend_zero $(($position / 60)))
    seconds1=$(prepend_zero $(($position % 60)))
    minutes2=$(prepend_zero $(($duration / 60)))
    seconds2=$(prepend_zero $(($duration % 60)))

    playing=$(echo "$STATUS" | grep "^status" | grep -c "playing")

    if [ $playing -eq 1 ]; then
        play_btn="%{A1:cmus-remote --pause:}⏸%{A}"
    else
        play_btn="%{A1:cmus-remote --pause:}▶%{A}"
    fi

    prev_btn="%{A1:cmus-remote --prev:}⏮%{A}"
    next_btn="%{A1:cmus-remote --next:}⏭%{A}"

    echo -n "$prev_btn $play_btn $next_btn  %{F#957fb8}$artist - $song%{F-} [$minutes1:$seconds1/$minutes2:$seconds2]"
else
    echo -n "%{F#6c7086}cmus not playing%{F-}"
fi
