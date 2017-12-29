#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkCookieJar>
#include <QNetworkCookie>
const QString LOGIN_URL ="https://192.168.1.1:8443/login.cgi";




class LoginNetworkManager : public QObject {
    Q_OBJECT
public:
    enum Action {
        ACTION_NONE,
        ACTION_LOGIN,
        ACTION_COMMAND,
        ACTION_LOGOUT,
    };

    explicit LoginNetworkManager();
    virtual ~LoginNetworkManager();

    Q_INVOKABLE void Login(const QString& userName, const QString& password);
    Q_INVOKABLE void GetPage(const QString& url);
    Q_INVOKABLE void ExecuteCommand(const QString& cmd);
    Q_INVOKABLE void WakeUp(const QString& target);
    Q_INVOKABLE void Logout();
    Q_INVOKABLE void SetupUrl(const QString& url);

protected:
    void dumpCookies();
    QSslConfiguration m_sslConfig;
    QNetworkAccessManager* manager;
    QNetworkCookieJar* cookieJar ;
    Action m_currentAction;
    QNetworkReply* m_pReply;
    QString m_baseUrl;
signals:
    void colorChanged(const QColor & color);
private slots:
    void replyFinished(QNetworkReply *reply);

};
