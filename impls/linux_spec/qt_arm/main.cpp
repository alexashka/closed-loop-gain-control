#include <QtCore/QCoreApplication>

//#include <>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    qDebug("Hello Qt!");
    
    return a.exec();
}//main
