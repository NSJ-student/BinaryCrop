#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "binarycrop.h"


int main(int argc, char *argv[])
{
//    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    BinaryCrop binary_crop;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    //qrc:/main.qml를 등록한 엔진의 object값을 가져옴
    QObject *root = engine.rootObjects().first();
    //qrc:/main.qml를 등록한 엔진의 object값을 window타입으로 변경해준다.
    QQuickWindow * p_window = qobject_cast<QQuickWindow *>(root);

    binary_crop.setWindow(p_window);

    return app.exec();
}
