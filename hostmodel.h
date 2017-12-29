#ifndef HOSTMODEL_H
#define HOSTMODEL_H


class HostModel
{
public:
    HostModel();
};
#include <QAbstractListModel>
#include <QStringList>

class Host
{
public:
    Host(const QString &name, const QString &icon, const QString &ip, const QString &mac);
    QString icon() const;
    QString name() const;
    QString ip() const;
    QString mac() const;

private:
    QString m_name;
    QString m_icon;
    QString m_ip;
    QString m_mac;
};

class HostListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum DataRoles {
        NameRole = Qt::UserRole + 1,
        IconRole,
        IpRole,
        MacRole
    };

    HostListModel(QObject *parent = 0);
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE void insert(int index, const Host &host);
    Q_INVOKABLE void append(const Host &host);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void append(const QVariantMap map);
    Q_INVOKABLE bool load(const QString &fileName);
    Q_INVOKABLE bool save(const QString &fileName);
    Q_INVOKABLE void file(const QString &fileName);
    Q_INVOKABLE bool load();
    Q_INVOKABLE bool save();
signals:
    void countChanged(int arg);

private:
    int count() const;

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    typedef QList<Host> HostList;
    QString m_fileName;
    HostList m_list;
    bool m_changed;
};

#endif // HOSTMODEL_H
