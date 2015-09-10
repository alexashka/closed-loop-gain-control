//#include <device.h>
// http://lwn.net/Kernel/LDD2/ch05.lwn

#include <linux/fs.h> 
#include <linux/init.h> 
#include <linux/module.h> 
#include <asm/uaccess.h> 
#include <linux/cdev.h> 

#include "poll.h"
//#include <linux/wait.h>
//#include <linux/ioctl.h>


MODULE_LICENSE( "GPL" );
MODULE_AUTHOR( "Oleg Tsiliuric <olej@front.ru>" );
MODULE_VERSION( "6.2" );

static int pause = 100;
//module_param( pause, int, S_IRUGO );
static int major = 0; 
module_param( major, int, S_IRUGO ); 

static struct private {       // блок данных устройства
   atomic_t read_offset;             // смещение для чтения
   char buf[ LEN_MSG + 2 ];   // буфер данных
} devblock = {   // статическая инициализация того, что динамически делается в open()
   .read_offset = ATOMIC_INIT( 0 ),
   .buf = "not initialized yet!\n",
};

static struct private *s_dev_ptr = &devblock;
static DECLARE_WAIT_QUEUE_HEAD( s_q_wait );

// FIXME: impl fopen()

static ssize_t read( struct file *file, char *buf, size_t count, loff_t *ppos ) 
{
   int len = 0;
   int offset = atomic_read( &s_dev_ptr->read_offset );
   if ( offset > strlen( s_dev_ptr->buf ) ) {         
      // нет доступных данных
      // FIXME: разделение на блок/неблок
      if( file->f_flags & O_NONBLOCK ) {
         return -EAGAIN;
      } else {
         // wait someting
         // http://stackoverflow.com/questions/12117227/linux-kernel-wait-for-other-threads-to-complete
         // not work in x64
         //interruptible_sleep_on( &s_q_wait );  // very old! never use it
      }
   }
   offset = atomic_read( &s_dev_ptr->read_offset );         // повторное обновление
   
   if( offset == strlen( s_dev_ptr->buf ) ) {
      atomic_set( &s_dev_ptr->read_offset, offset + 1 );
      return 0;                             // EOF
   }

   len = strlen( s_dev_ptr->buf ) - offset;          // данные есть (появились?)
   len = count < len ? count : len;
   if( copy_to_user( buf, s_dev_ptr->buf + offset, len ) ) 
      return -EFAULT;

   atomic_set( &s_dev_ptr->read_offset, offset + len );
   return len;
}

static ssize_t write( struct file *file, const char *buf, size_t count, loff_t *ppos ) 
{
   int res = 0;
   int len = count < LEN_MSG ? count : LEN_MSG;
   
   res = copy_from_user( s_dev_ptr->buf, (void*)buf, len );

   s_dev_ptr->buf[ len ] = '\0';                  // восстановить завершение строки
   if( '\n' != s_dev_ptr->buf[ len - 1 ] ) 
      strcat( s_dev_ptr->buf, "\n" );

   atomic_set( &s_dev_ptr->read_offset, 0 );             // разрешить следующее чтение
   
   // FIXME: wakeup?
   wake_up_interruptible( &s_q_wait );
   return len;
}

// interaction with poll/select
// FIXME: how connect with read/write
//
// "Целью вызовов poll и select является определить заранее, 
// будет ли операция ввода/вывода блокирована."
unsigned int poll( struct file *file, struct poll_table_struct *poll_table_ptr ) 
{
   // 1. poll_wait()
   // 2. return byte mask

   int flag = POLLOUT | POLLWRNORM;
   // call for on wait queue
   poll_wait( file, &s_q_wait, poll_table_ptr );

   // not work in x64
   //sleep_on_timeout( &s_q_wait, pause );
   
   // flags for read
   if( atomic_read( &s_dev_ptr->read_offset ) <= strlen( s_dev_ptr->buf ) ) {
      flag |= ( POLLIN | POLLRDNORM );
   }

   // flags for write
   // down(&dev->sem);
   //poll_wait(filp, &dev->inq, wait);
   //poll_wait(filp, &dev->outq, wait);
   //if (dev->rp != dev->wp)
   //  mask |= POLLIN | POLLRDNORM; /* читаемо */
   //if (spacefree(dev))
   //mask |= POLLOUT | POLLWRNORM; /* записываемо */
   //up(&dev->sem);

   // FIXME: need POLLHUP?

   return flag;
};

static const struct file_operations 
//fops 
dev_fops
= {
   .owner = THIS_MODULE,
   // http://www.ibm.com/developerworks/ru/library/l-linux_kernel_24/
   // .open = ...
   .read  = read,
   .write = write,
   .poll  = poll,
};

//static struct miscdevice pool_dev = {
//   MISC_DYNAMIC_MINOR,
//   DEVNAME,
//   &fops
//};

// make no misc
//static int __init init( void ) {
//   int ret = misc_register( &pool_dev );
//   if( ret ) printk( KERN_ERR "=== unable to register device\n" );
//   return ret;
//}
//module_init( init );

//static void __exit exit( void ) {
//   misc_deregister( &pool_dev );
//}
//module_exit( exit );

#define DEVICE_FIRST  0 
#define DEVICE_COUNT  3 
#define MODNAME "my_cdev_dev" 

static struct cdev hcdev; 


static int __init dev_init( void ) { 
   int ret; 
   dev_t dev; 
   if( major != 0 ) { 
      dev = MKDEV( major, DEVICE_FIRST ); 
      ret = register_chrdev_region( dev, DEVICE_COUNT, MODNAME ); 
   } 
   else { 
      ret = alloc_chrdev_region( &dev, DEVICE_FIRST, DEVICE_COUNT, MODNAME ); 
      major = MAJOR( dev );  // не забыть зафиксировать! 
   } 
   if( ret < 0 ) { 
      printk( KERN_ERR "=== Can not register char device region\n" ); 
      goto err; 
   } 
   cdev_init( &hcdev, &dev_fops ); 
   hcdev.owner = THIS_MODULE; 
   ret = cdev_add( &hcdev, dev, DEVICE_COUNT ); 
   if( ret < 0 ) { 
      unregister_chrdev_region( MKDEV( major, DEVICE_FIRST ), DEVICE_COUNT ); 
      printk( KERN_ERR "=== Can not add char device\n" ); 
      goto err; 
   } 
   printk( KERN_INFO "=========== module installed %d:%d =========\n", 
           MAJOR( dev ), MINOR( dev ) ); 
err: 
   return ret; 
} 

static void __exit dev_exit( void ) { 
   cdev_del( &hcdev ); 
   unregister_chrdev_region( MKDEV( major, DEVICE_FIRST ), DEVICE_COUNT ); 
   printk( KERN_INFO "=============== module removed =============\n" ); 
}

module_init( dev_init ); 
module_exit( dev_exit );