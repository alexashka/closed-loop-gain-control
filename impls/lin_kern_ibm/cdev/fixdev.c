#include <linux/fs.h> 
#include <linux/init.h> 
#include <linux/module.h> 
#include <asm/uaccess.h> 
#include <linux/cdev.h> 

MODULE_LICENSE( "GPL" ); 
MODULE_AUTHOR( "Oleg Tsiliuric <olej@front.ru>" ); 
MODULE_VERSION( "6.3" ); 

static char *hello_str = "Hello, world!\n";         // buffer! 

static ssize_t dev_read( struct file * file, char * buf, 
                         size_t count, loff_t *ppos ) { 
   int len = strlen( hello_str ); 
   printk( KERN_INFO "=== read : %d\n", count ); 
   if( count < len ) return -EINVAL; 
   if( *ppos != 0 ) { 
      printk( KERN_INFO "=== read return : 0\n" );  // EOF 
      return 0; 
   } 
   if( copy_to_user( buf, hello_str, len ) ) return -EINVAL; 
   *ppos = len; 
   printk( KERN_INFO "=== read return : %d\n", len ); 
   return len; 
} 

static int __init dev_init( void ); 
module_init( dev_init ); 

static void __exit dev_exit( void ); 
module_exit( dev_exit );

static int major = 0; 
module_param( major, int, S_IRUGO ); 

#define EOK 0 
static int device_open = 0; 

static int dev_open( struct inode *n, struct file *f ) { 
   if( device_open ) return -EBUSY; 
   device_open++; 
   return EOK; 
} 

static int dev_release( struct inode *n, struct file *f ) { 
   device_open--; 
   return EOK; 
} 

static const struct file_operations dev_fops = { 
   .owner = THIS_MODULE, 
   .open = dev_open, 
   .release = dev_release, 
   .read  = dev_read, 
}; 

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