#!/bin/bash

CURRENT_SINK=$(pactl get-default-sink)
SINK_INPUTS=$(pactl list short sink-inputs | awk '{print $1}')

SPEAKER=$(pactl list short sinks | grep analog | awk '{print $2}')
HEADPHONE=$(pactl list short sinks | grep K03S | awk '{print $2}')

#echo "识别到的扬声器: $SPEAKER"
#echo "识别到的耳机: $HEADPHONE"

if [[ "$CURRENT_SINK" = "$SPEAKER" ]]; then
  pactl set-default-sink "$HEADPHONE"
else
  pactl set-default-sink "$SPEAKER"
fi

CURRENT_SINK=$(pactl get-default-sink)
for i in $SINK_INPUTS; do
  pactl move-sink-input $i "$CURRENT_SINK"
done

notify-send "The sink has been changed,the current sink is $CURRENT_SINK" -i audio-speakers
