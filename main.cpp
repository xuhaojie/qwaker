#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QThread>
#include <QQuickView>
#include <QStandardPaths>
#include "setting.h"
#include "hostmodel.h"
#include "LoginNetworkManager.h"


int main(int argc, char *argv[])
{
    QString password = "password";
    QByteArray passwordByteArray = password.toUtf8();
    QByteArray passwordEncoding = passwordByteArray.toPercentEncoding();
    qDebug() << password;

    // http://stackoverflow.com/questions/27982443/qnetworkaccessmanager-crash-related-to-ssl
    qunsetenv("OPENSSL_CONF");
    QString path =  QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    // QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation); //QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation).first();
    //settings = new QSettings(path.append("/todo1-2-3.ini"), QSettings::IniFormat);
    const QString stettingFileName = path + "/qwaker.setting";
    const QString hostFileName = path + "/qwaker.hosts";
    Setting setting;

    if(!setting.load(stettingFileName))
    {
//        QString audioPath =QStandardPaths::writableLocation(QStandardPaths::MusicLocation);
        setting.set("Protocol","https");
        setting.set("Address","192.168.1.1");
        setting.set("Port","443");
        setting.set("UserName","admin");
        setting.set("Password","admin");
    }

    HostListModel hostList;
//    hostList.append(Host("Nas","192.168.1.138","12:34:56:78:90"));
//    hostList.append(Host("Q6600","192.168.1.168","12:34:56:78:90"));
//    hostList.append(Host("4790K","192.168.1.198","12:34:56:78:90"));
    hostList.load(hostFileName);

    LoginNetworkManager *pLoginNetworkManager = new LoginNetworkManager();
    qmlRegisterType<LoginNetworkManager>("routerMaster.autopard.com", 1, 0, "RouterMaster");


    QGuiApplication app(argc, argv);
    app.setApplicationName("qwaker");
    app.setOrganizationName("www.autopard.com");
    QQuickView view;
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("RouterMaster", pLoginNetworkManager);
    ctxt->setContextProperty("hostModel", &hostList);
    ctxt->setContextProperty("appSetting", &setting);
    //   ctxt->setContextProperty("AppSetting", &setting);
    QObject::connect(ctxt->engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));
    view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setMinimumSize(QSize(480,640));
    view.resize(720,1280);
    view.show();
    int result =  app.exec();
    hostList.save(hostFileName);
    setting.save(stettingFileName);
//       state.save(stateFileName);
//   delete pLoginNetworkManager;
   return result;

}
