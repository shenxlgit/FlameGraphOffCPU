#!/usr/bin/awk -f

BEGIN {
    # 1: schedule out, 2: schedule stat, 3: schedule in
    in_stack = 0; 
    print_next = 0;
    in_head = 0;
}

/sched_switch/ {
    if (in_stack == 2) {
        in_stack = 3;
    } else {
        in_stack = 1;
        in_head = 1;
        stack = "";
        head = $0;
    }
}

/sched_stat_sleep/ {
    if (in_stack == 1) {
        delay = $8;
        print_next = 1;
    }
    in_stack = 2;
}

/sched_stat_iowait/ {
    if (in_stack == 1) {
        delay = $8;
        print_next = 1;
    }
    in_stack = 2;
}

{
    if (in_stack == 1) {
        if (in_head == 1){
           in_head = 0;
        } else {
           stack = stack $0 "\n";
        }
    }

    if (print_next == 1) {
        printf "%s %s\n%s", head, delay, stack;
        print_next = 0;
    }
}
