#include "hostmodel.h"
#include <QDebug>
#include <QFile>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>

Host::Host(const QString &name,const QString& icon,const QString &ip, const QString &mac)
    :m_name(name),m_icon(icon), m_ip(ip), m_mac(mac)
{
}

QString Host::icon() const
{
    return m_icon;
}

QString Host::name() const
{
    return m_name;
}

QString Host::ip() const
{
    return m_ip;
}

QString Host::mac() const
{
    return m_mac;
}

HostListModel::HostListModel(QObject *parent)
    : QAbstractListModel(parent), m_changed(false)
{

}

void HostListModel::insert(int index, const Host &host)
{
    if(index < 0 || index > m_list.count()) {
        return;
    }

    emit beginInsertRows(QModelIndex(), index, index);
    m_list.insert(index, host);
    m_changed = true;
    emit endInsertRows();
    emit countChanged(m_list.count());
    m_changed = true;
}

void HostListModel::remove(int index)
{
    if(index < 0 || index >= m_list.count()) {
        return;
    }

    emit beginRemoveRows(QModelIndex(), index, index);
    m_list.removeAt( index );
    m_changed = true;
    emit endRemoveRows();
    emit countChanged(m_list.count());
}

void HostListModel::append(const Host &host)
{
    insert(count(), host);
}

void HostListModel::append(const QVariantMap map)
{
    QString name = map["name"].toString();
    QString icon = map["icon"].toString();
    QString ip = map["ip"].toString();
    QString mac = map["mac"].toString();
    Host host(name, icon, ip, mac);
    insert(count(), host);
}


int HostListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_list.count();
}

QVariant HostListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= m_list.count())
        return QVariant();

    const Host &host = m_list[index.row()];
    // qDebug() << "row: " << index.row();

    if (role == NameRole)
        return host.name();
    else if (role == IconRole)
        return host.icon();
    else if (role == IpRole)
        return host.ip();
    else if (role == MacRole)
        return host.mac();
    return QVariant();
}

QHash<int, QByteArray> HostListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[IpRole] = "ip";
    roles[MacRole] = "mac";

    return roles;
}

int HostListModel::count() const
{
    return rowCount(QModelIndex());
}

bool HostListModel::load(const QString& fileName)
{
    m_list.clear();
    QFile file(fileName);
    if(file.open(QIODevice::ReadOnly))
    {
        m_fileName = fileName;
        QByteArray byte_array =  file.readAll();
        file.close();
        QJsonParseError json_error;
        QJsonDocument document = QJsonDocument::fromJson(byte_array,&json_error);
        if(json_error.error == QJsonParseError::NoError) {

            if(document.isEmpty())  {
                return false;
            }
            if(document.isArray())  {
                const QJsonArray& array = document.array();
                int size = array.size();
                  for (int i=0; i < size; i++)
                  {
                      QJsonValue value = array.at(i);
                      if (value.isObject())
                      {

                          const QJsonObject& json = value.toObject();
                          QString name = json.value("name").toString();
                          QString icon = json.value("icon").toString();
                          QString ip = json.value("ip").toString();
                          QString mac = json.value("mac").toString();

//                          qDebug() << name << endl << ip << endl << mac << endl;
                          Host host(name, icon, ip, mac);
                          m_list.push_back(host);
                      }
                  }
            }
            if(document.isObject())  {
                QJsonObject json = document.object();
                QJsonObject::ConstIterator it = json.begin();
                while(it != json.end())
                {
                    //m_list.push_front((it.key(), it.value().toVariant());
                    it++;
                }
             }
         }
    }
    return m_list.size() >0 ? true : false;
}

bool HostListModel::save(const QString& fileName)
{
    if(!m_changed)
    {
        return true;
    }

    QJsonObject json;
    HostList::ConstIterator it = m_list.begin();



    QJsonArray array;
    while(it != m_list.end())
    {
        //QJsonValue value = QJsonValue::fromVariant(it.value());
        QJsonObject json_object;
        json_object.insert("name", it->name());
        json_object.insert("icon", it->icon());
        json_object.insert("ip", it->ip());
        json_object.insert("mac", it->mac());
        array.push_back(json_object);
        it++;
    }

    QJsonDocument document;

    document.setArray(array);
    QByteArray byte_array = document.toJson(QJsonDocument::Indented);
    QFile file(fileName);
    if(file.open(QIODevice::WriteOnly | QIODevice::Truncate))
    {
        file.write(byte_array);
        file.close();
        file.flush();
        m_changed = false;
        return true;
    }
    return false;
}


void HostListModel::file(const QString &fileName)
{
    m_fileName = fileName;
}

bool HostListModel::load()
{
    if(m_fileName.length() > 0)
    {
        return load(m_fileName);
    }
    return false;
}

bool HostListModel::save()
{
    if(m_fileName.length() > 0)
    {
        return save(m_fileName);
    }
    return false;
}
