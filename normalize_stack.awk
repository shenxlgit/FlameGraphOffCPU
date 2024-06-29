#!/usr/bin/awk -f

BEGIN {
    segment_start = 1;
    print_start = 0
}

{
    if ($0 ~ /^$/) {
        if (print_start == 1) {
            printf "%s\n%d\n\n", exec, delay_value;
            print_start = 0;
        }
        segment_start = 1;
        next;
    }

    if (segment_start == 1) {
	segment_start = 0;
        exec = $1;
        match($0, /delay=([0-9]+)/, arr);
	delay_value = arr[1];
    } else {
        match($2, /([^(<]+)/, arr);
	print arr[1];
        print_start = 1;
    }
}
