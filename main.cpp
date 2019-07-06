#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickTextDocument>
#include "highlighter.h"

template <class T> T childObject(QQmlApplicationEngine& engine,
                                 const QString& objectName,
                                 const QString& propertyName) {
    QList<QObject*> rootObjects = engine.rootObjects();
    foreach (QObject* object, rootObjects)
    {
        QObject* child = object->findChild<QObject*>(objectName);
        if (child != nullptr)
        {
            std::string s = propertyName.toStdString();
            QObject* object = child->property(s.c_str()).value<QObject*>();
            Q_ASSERT(object != nullptr);
            T prop = dynamic_cast<T>(object);
            Q_ASSERT(prop != 0);
            return prop;
        }
    }
    return nullptr;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QQuickTextDocument* doc =
            childObject<QQuickTextDocument*>(engine, "editor", "textDocument");
    Q_ASSERT(doc != nullptr);
    Highlighter* parser = new Highlighter(doc->textDocument());
    // highlighter = new Highlighter(editor->document());

    return app.exec();
}
