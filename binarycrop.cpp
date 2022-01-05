#include "binarycrop.h"

BinaryCrop::BinaryCrop(QObject *parent) : QObject(parent)
{
    //class를 qml에서 사용하기 위해서 등록해주는 부분
    qmlRegisterType<BinaryCrop>("BinaryCrop", 1, 0,
                                "BinaryCrop");

    file_opend = false;
}

void BinaryCrop::setWindow(QQuickWindow *window)
{
    mMainView = window;

    QObject::connect(mMainView, SIGNAL(fileSelected(QString)),
                     this, SLOT(fileOpen(QString)));
    QObject::connect(mMainView, SIGNAL(saveBinary(QString,QString,QString)),
                     this, SLOT(fileSave(QString,QString,QString)));
    QObject::connect(this, SIGNAL(log(QVariant)),
                     mMainView, SLOT(qmlLog(QVariant)));
}

void BinaryCrop::fileOpen(const QString &path)
{
    qDebug() << "fileOpen";
    QString _path = path;
#if defined (Q_OS_LINUX)
    QString result = _path.replace("file://","");
#else
    QString result = _path.replace("file:///","");
#endif

    if(!QFile::exists(result))
    {
        emit log("** error: " + QUrl(result).fileName() + " not exists");
        return;
    }

    file_opend = true;
    srcFilePath = result;
    emit log(QUrl(srcFilePath).fileName() + " set");
}

void BinaryCrop::fileSave(const QString &path, const QString &offset, const QString &length)
{
    qDebug() << "fileSave";
    if(!file_opend)
    {
        return;
    }

    QString _path = path;
#if defined (Q_OS_LINUX)
    QString result = _path.replace("file://","");
#else
    QString result = _path.replace("file:///","");
#endif

    QFile source(srcFilePath);
    if(!source.open(QFile::ReadOnly))
    {
        emit log("** error: " + QUrl(srcFilePath).fileName() + " not exists");
        return;
    }

    QByteArray srcData = source.readAll();
    source.close();

    bool ok = false;
    int iOffset = offset.toInt(&ok, 16);
    if(!ok)
    {
        emit log("** error: " + offset + " is not hexa");
        return;
    }
    int iLength = length.toInt(&ok, 10);
    if(!ok)
    {
        emit log("** error: " + length + " is not decimal");
        return;
    }

    if(iLength == 0)
    {
        emit log("** error: data length is 0");
        return;
    }
    if(iOffset + iLength > srcData.length())
    {
        emit log(QString("** error: data out of range / dst_offset=%1, dst_length=%2 / src_length=%3")
                 .arg(iOffset).arg(iLength).arg(srcData.length()));
        return;
    }

    QByteArray dstData = QByteArray::fromRawData(srcData.data() + iOffset, iLength);

    QFile destination(result);
    if(!destination.open(QFile::WriteOnly))
    {
        emit log("** error: " + QUrl(result).fileName() + " not exists");
        return;
    }

    if(!destination.write(dstData.data(), dstData.length()))
    {
        emit log("** error: " + QUrl(result).fileName() + " save failed : " + destination.errorString());
        return;
    }

    destination.close();
    emit log(QString("%1 saved : offset=%2, length=%3")
             .arg(QUrl(result).fileName()).arg(iOffset).arg(iLength));
}
