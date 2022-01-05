#ifndef BINARYCROP_H
#define BINARYCROP_H

#include <QQuickView>
#include <QObject>
#include <QDebug>
#include <QFile>
#include <QString>

class BinaryCrop : public QObject
{
    Q_OBJECT
public:
    explicit BinaryCrop(QObject *parent = nullptr);
    void setWindow(QQuickWindow *window);

signals:
    void log(QVariant data);

public slots:
    void fileOpen(const QString &path);
    void fileSave(const QString &path, const QString &offset, const QString &length);

private:
    QQuickWindow* mMainView;
    bool file_opend;
    QString srcFilePath;
    QString dstFilePath;
};

#endif // BINARYCROP_H
