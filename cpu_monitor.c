#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/timer.h>
#include <linux/sched/loadavg.h>
#include <linux/cpumask.h>

MODULE_LICENSE("GPL");

static int interval = 10;
module_param(interval, int, 0644);
MODULE_PARM_DESC(interval, "Interwał w sekundach między logami obciążenia CPU");

static struct timer_list log_timer;

static void log_cpu_load(struct timer_list *t) {
    unsigned long load = (avenrun[0] * 100) >> 11;
    int cpu_count = num_online_cpus();
    unsigned long load_percentage = load / cpu_count;

    printk(KERN_INFO "Bieżące obciążenie CPU: %lu%%\n", load_percentage);
    mod_timer(&log_timer, jiffies + msecs_to_jiffies(interval * 1000));
}

static int __init cpu_load_logger_init(void) {
    printk(KERN_INFO "Moduł logujący obciążenie CPU załadowany z interwałem = %d sekund\n", interval);
    timer_setup(&log_timer, log_cpu_load, 0);
    mod_timer(&log_timer, jiffies + msecs_to_jiffies(interval * 1000));
    return 0;
}

static void __exit cpu_load_logger_exit(void) {
    printk(KERN_INFO "Moduł logujący obciążenie CPU wyładowany\n");
    del_timer(&log_timer);
}

module_init(cpu_load_logger_init);
module_exit(cpu_load_logger_exit);
