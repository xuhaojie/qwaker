#include "LoginNetworkManager.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkProxy>
#include <QUrlQuery>

//QString baseURL("https://xuhaojie.ddns.net:8443");

QString md5(const QString &text)
{
    QByteArray byteArray;
    byteArray.append(text);
    QByteArray hash = QCryptographicHash::hash(byteArray, QCryptographicHash::Md5);

    return hash.toHex();
}
LoginNetworkManager::LoginNetworkManager(): m_currentAction(ACTION_NONE),m_pReply(NULL)
{

    manager = new QNetworkAccessManager(this);
    cookieJar = new QNetworkCookieJar(manager);
    manager->setCookieJar(cookieJar);
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("127.0.0.1");
    proxy.setPort(8888);
//    manager->setProxy(proxy);
//    proxy.setUser("username");
//    proxy.setPassword("password");
//    QNetworkProxy::setApplicationProxy(proxy);
    // SSL认证
    m_sslConfig = QSslConfiguration::defaultConfiguration();
    m_sslConfig.setPeerVerifyMode(QSslSocket::VerifyNone);
    m_sslConfig.setProtocol(QSsl::TlsV1_2);

    connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply *)));
}

// 结束请求
LoginNetworkManager::~LoginNetworkManager()
{
    if (m_pReply != NULL)
    {
        m_pReply->abort();
        m_pReply->deleteLater();
    }
    delete manager;
}


void LoginNetworkManager::Login(const QString& userName, const QString& password)
{

//    QByteArray userNameByteArray = m_strUserName.toUtf8();
//    QByteArray userNameEncoding = userNameByteArray.toPercentEncoding();

    // 设置发送的数据
    QByteArray dataArray;
    QByteArray passArray = userName.toUtf8() + ":" + password.toUtf8();

    QUrlQuery query;
    query.addQueryItem("group_id","");
    query.addQueryItem("action_mode","");
    query.addQueryItem("action_script","");
    query.addQueryItem("action_wait","5");
    query.addQueryItem("login_authorization","aG9kZ2U6U2doLVI3MDAwIQ==");
    query.addQueryItem("next_page","Main_WOL_Content.asp");
    query.addQueryItem("current_page","Main_WOL_Content.asp");
//    qDebug() << query.toString();
    //passArray.toBase64();

    dataArray.append(query.toString());
    // 设置消息头
    QNetworkRequest request;
    request.setSslConfiguration(m_sslConfig);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Referer", QByteArray((m_baseUrl + QString("/Main_Login.asp")).toUtf8()));

    request.setHeader(QNetworkRequest::ContentLengthHeader, dataArray.length());
    request.setUrl(QUrl(m_baseUrl + "/login.cgi"));

    // 开始请求
    m_currentAction = ACTION_LOGIN;
    m_pReply = manager->post(request, dataArray);
}

void LoginNetworkManager::GetPage(const QString& url)
{
    QNetworkRequest request;
    request.setSslConfiguration(m_sslConfig);
//  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    //request.setRawHeader("Referer", "https://xuhaojie.ddns.net:8443/index.asp");
    request.setUrl(QUrl(m_baseUrl + url));

    m_pReply = manager->get(request);
}


void LoginNetworkManager::ExecuteCommand(const QString& cmd)
{
//    QByteArray userNameByteArray = m_strUserName.toUtf8();
//    QByteArray userNameEncoding = userNameByteArray.toPercentEncoding();

    // 设置发送的数据
    QByteArray dataArray;
    QUrlQuery query;
    query.addQueryItem("group_id","");
    query.addQueryItem("action_mode"," Refresh ");
    query.addQueryItem("action_script","");
    query.addQueryItem("action_wait","");
    query.addQueryItem("next_page","Main_WOL_Content.asp");
    query.addQueryItem("current_page","Main_WOL_Content.asp");
    query.addQueryItem("firmver","3.0.0.4");
    query.addQueryItem("first_time","");
    query.addQueryItem("modified","0");
    query.addQueryItem("preferred_lang","CN");
    query.addQueryItem("SystemCmd",cmd);
//    qDebug() << query.toString();
    dataArray.append(query.toString());


    // 设置消息头
    QNetworkRequest request;
    request.setSslConfiguration(m_sslConfig);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QByteArray referer(m_baseUrl.toUtf8());// + "/Main_WOL_Content.asp");
    request.setRawHeader("Referer", referer);

    request.setHeader(QNetworkRequest::ContentLengthHeader, dataArray.length());
    request.setUrl(QUrl(m_baseUrl + "/apply.cgi"));

    // 开始请求
    m_currentAction = ACTION_COMMAND;
    m_pReply = manager->post(request, dataArray);
}

void LoginNetworkManager::WakeUp(const QString& target)
{
    ExecuteCommand("ether-wake -i br0 -b " + target);
}

void LoginNetworkManager::Logout()
{
    // 设置消息头
    QNetworkRequest request;
    request.setSslConfiguration(m_sslConfig);

    request.setUrl(QUrl(m_baseUrl + "/Logout.asp"));

    // 开始请求
    m_pReply = manager->get(request);
}

void LoginNetworkManager::SetupUrl(const QString&  url)
{
    m_baseUrl = url;
}

void LoginNetworkManager::dumpCookies()
{
    typedef QList<QNetworkCookie> CookieList;
    CookieList cookies = manager->cookieJar()->cookiesForUrl(m_baseUrl);
    CookieList::iterator it = cookies.begin();

    while(it!=cookies.end())
    {
        qDebug() << *it << endl;
        it++;
    }
}

// 响应结束
void LoginNetworkManager::replyFinished(QNetworkReply *reply)
{
    QByteArray bytes = reply->readAll();
    char *data = bytes.data();
    qDebug() << data;
    // dumpCookies();
    reply->deleteLater();
    return;
}
