//
// Generated file, do not edit! Created by nedtool 5.1 from powerrouting/routing/batman/BatmanMsg.msg.
//

// Disable warnings about unused variables, empty switch stmts, etc:
#ifdef _MSC_VER
#  pragma warning(disable:4101)
#  pragma warning(disable:4065)
#endif

#if defined(__clang__)
#  pragma clang diagnostic ignored "-Wshadow"
#  pragma clang diagnostic ignored "-Wconversion"
#  pragma clang diagnostic ignored "-Wunused-parameter"
#  pragma clang diagnostic ignored "-Wc++98-compat"
#  pragma clang diagnostic ignored "-Wunreachable-code-break"
#  pragma clang diagnostic ignored "-Wold-style-cast"
#elif defined(__GNUC__)
#  pragma GCC diagnostic ignored "-Wshadow"
#  pragma GCC diagnostic ignored "-Wconversion"
#  pragma GCC diagnostic ignored "-Wunused-parameter"
#  pragma GCC diagnostic ignored "-Wold-style-cast"
#  pragma GCC diagnostic ignored "-Wsuggest-attribute=noreturn"
#  pragma GCC diagnostic ignored "-Wfloat-conversion"
#endif

#include <iostream>
#include <sstream>
#include "BatmanMsg_m.h"

namespace omnetpp {

// Template pack/unpack rules. They are declared *after* a1l type-specific pack functions for multiple reasons.
// They are in the omnetpp namespace, to allow them to be found by argument-dependent lookup via the cCommBuffer argument

// Packing/unpacking an std::vector
template<typename T, typename A>
void doParsimPacking(omnetpp::cCommBuffer *buffer, const std::vector<T,A>& v)
{
    int n = v.size();
    doParsimPacking(buffer, n);
    for (int i = 0; i < n; i++)
        doParsimPacking(buffer, v[i]);
}

template<typename T, typename A>
void doParsimUnpacking(omnetpp::cCommBuffer *buffer, std::vector<T,A>& v)
{
    int n;
    doParsimUnpacking(buffer, n);
    v.resize(n);
    for (int i = 0; i < n; i++)
        doParsimUnpacking(buffer, v[i]);
}

// Packing/unpacking an std::list
template<typename T, typename A>
void doParsimPacking(omnetpp::cCommBuffer *buffer, const std::list<T,A>& l)
{
    doParsimPacking(buffer, (int)l.size());
    for (typename std::list<T,A>::const_iterator it = l.begin(); it != l.end(); ++it)
        doParsimPacking(buffer, (T&)*it);
}

template<typename T, typename A>
void doParsimUnpacking(omnetpp::cCommBuffer *buffer, std::list<T,A>& l)
{
    int n;
    doParsimUnpacking(buffer, n);
    for (int i=0; i<n; i++) {
        l.push_back(T());
        doParsimUnpacking(buffer, l.back());
    }
}

// Packing/unpacking an std::set
template<typename T, typename Tr, typename A>
void doParsimPacking(omnetpp::cCommBuffer *buffer, const std::set<T,Tr,A>& s)
{
    doParsimPacking(buffer, (int)s.size());
    for (typename std::set<T,Tr,A>::const_iterator it = s.begin(); it != s.end(); ++it)
        doParsimPacking(buffer, *it);
}

template<typename T, typename Tr, typename A>
void doParsimUnpacking(omnetpp::cCommBuffer *buffer, std::set<T,Tr,A>& s)
{
    int n;
    doParsimUnpacking(buffer, n);
    for (int i=0; i<n; i++) {
        T x;
        doParsimUnpacking(buffer, x);
        s.insert(x);
    }
}

// Packing/unpacking an std::map
template<typename K, typename V, typename Tr, typename A>
void doParsimPacking(omnetpp::cCommBuffer *buffer, const std::map<K,V,Tr,A>& m)
{
    doParsimPacking(buffer, (int)m.size());
    for (typename std::map<K,V,Tr,A>::const_iterator it = m.begin(); it != m.end(); ++it) {
        doParsimPacking(buffer, it->first);
        doParsimPacking(buffer, it->second);
    }
}

template<typename K, typename V, typename Tr, typename A>
void doParsimUnpacking(omnetpp::cCommBuffer *buffer, std::map<K,V,Tr,A>& m)
{
    int n;
    doParsimUnpacking(buffer, n);
    for (int i=0; i<n; i++) {
        K k; V v;
        doParsimUnpacking(buffer, k);
        doParsimUnpacking(buffer, v);
        m[k] = v;
    }
}

// Default pack/unpack function for arrays
template<typename T>
void doParsimArrayPacking(omnetpp::cCommBuffer *b, const T *t, int n)
{
    for (int i = 0; i < n; i++)
        doParsimPacking(b, t[i]);
}

template<typename T>
void doParsimArrayUnpacking(omnetpp::cCommBuffer *b, T *t, int n)
{
    for (int i = 0; i < n; i++)
        doParsimUnpacking(b, t[i]);
}

// Default rule to prevent compiler from choosing base class' doParsimPacking() function
template<typename T>
void doParsimPacking(omnetpp::cCommBuffer *, const T& t)
{
    throw omnetpp::cRuntimeError("Parsim error: No doParsimPacking() function for type %s", omnetpp::opp_typename(typeid(t)));
}

template<typename T>
void doParsimUnpacking(omnetpp::cCommBuffer *, T& t)
{
    throw omnetpp::cRuntimeError("Parsim error: No doParsimUnpacking() function for type %s", omnetpp::opp_typename(typeid(t)));
}

}  // namespace omnetpp


// forward
template<typename T, typename A>
std::ostream& operator<<(std::ostream& out, const std::vector<T,A>& vec);

// Template rule which fires if a struct or class doesn't have operator<<
template<typename T>
inline std::ostream& operator<<(std::ostream& out,const T&) {return out;}

// operator<< for std::vector<T>
template<typename T, typename A>
inline std::ostream& operator<<(std::ostream& out, const std::vector<T,A>& vec)
{
    out.put('{');
    for(typename std::vector<T,A>::const_iterator it = vec.begin(); it != vec.end(); ++it)
    {
        if (it != vec.begin()) {
            out.put(','); out.put(' ');
        }
        out << *it;
    }
    out.put('}');
    
    char buf[32];
    sprintf(buf, " (size=%u)", (unsigned int)vec.size());
    out.write(buf, strlen(buf));
    return out;
}

vis_data::vis_data()
{
    this->type = 0;
    this->data = 0;
}

void __doPacking(omnetpp::cCommBuffer *b, const vis_data& a)
{
    doParsimPacking(b,a.type);
    doParsimPacking(b,a.data);
    doParsimPacking(b,a.ip);
}

void __doUnpacking(omnetpp::cCommBuffer *b, vis_data& a)
{
    doParsimUnpacking(b,a.type);
    doParsimUnpacking(b,a.data);
    doParsimUnpacking(b,a.ip);
}

class vis_dataDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    vis_dataDescriptor();
    virtual ~vis_dataDescriptor();

    virtual bool doesSupport(omnetpp::cObject *obj) const override;
    virtual const char **getPropertyNames() const override;
    virtual const char *getProperty(const char *propertyname) const override;
    virtual int getFieldCount() const override;
    virtual const char *getFieldName(int field) const override;
    virtual int findField(const char *fieldName) const override;
    virtual unsigned int getFieldTypeFlags(int field) const override;
    virtual const char *getFieldTypeString(int field) const override;
    virtual const char **getFieldPropertyNames(int field) const override;
    virtual const char *getFieldProperty(int field, const char *propertyname) const override;
    virtual int getFieldArraySize(void *object, int field) const override;

    virtual const char *getFieldDynamicTypeString(void *object, int field, int i) const override;
    virtual std::string getFieldValueAsString(void *object, int field, int i) const override;
    virtual bool setFieldValueAsString(void *object, int field, int i, const char *value) const override;

    virtual const char *getFieldStructName(int field) const override;
    virtual void *getFieldStructValuePointer(void *object, int field, int i) const override;
};

Register_ClassDescriptor(vis_dataDescriptor)

vis_dataDescriptor::vis_dataDescriptor() : omnetpp::cClassDescriptor("vis_data", "")
{
    propertynames = nullptr;
}

vis_dataDescriptor::~vis_dataDescriptor()
{
    delete[] propertynames;
}

bool vis_dataDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<vis_data *>(obj)!=nullptr;
}

const char **vis_dataDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *vis_dataDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int vis_dataDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 3+basedesc->getFieldCount() : 3;
}

unsigned int vis_dataDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISCOMPOUND,
    };
    return (field>=0 && field<3) ? fieldTypeFlags[field] : 0;
}

const char *vis_dataDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "type",
        "data",
        "ip",
    };
    return (field>=0 && field<3) ? fieldNames[field] : nullptr;
}

int vis_dataDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='t' && strcmp(fieldName, "type")==0) return base+0;
    if (fieldName[0]=='d' && strcmp(fieldName, "data")==0) return base+1;
    if (fieldName[0]=='i' && strcmp(fieldName, "ip")==0) return base+2;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *vis_dataDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "uint8_t",
        "uint8_t",
        "L3Address",
    };
    return (field>=0 && field<3) ? fieldTypeStrings[field] : nullptr;
}

const char **vis_dataDescriptor::getFieldPropertyNames(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldPropertyNames(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

const char *vis_dataDescriptor::getFieldProperty(int field, const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldProperty(field, propertyname);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

int vis_dataDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    vis_data *pp = (vis_data *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *vis_dataDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    vis_data *pp = (vis_data *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string vis_dataDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    vis_data *pp = (vis_data *)object; (void)pp;
    switch (field) {
        case 0: return ulong2string(pp->type);
        case 1: return ulong2string(pp->data);
        case 2: {std::stringstream out; out << pp->ip; return out.str();}
        default: return "";
    }
}

bool vis_dataDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    vis_data *pp = (vis_data *)object; (void)pp;
    switch (field) {
        case 0: pp->type = string2ulong(value); return true;
        case 1: pp->data = string2ulong(value); return true;
        default: return false;
    }
}

const char *vis_dataDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 2: return omnetpp::opp_typename(typeid(L3Address));
        default: return nullptr;
    };
}

void *vis_dataDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    vis_data *pp = (vis_data *)object; (void)pp;
    switch (field) {
        case 2: return (void *)(&pp->ip); break;
        default: return nullptr;
    }
}

HnaElement::HnaElement()
{
    this->netmask = 0;
}

void __doPacking(omnetpp::cCommBuffer *b, const HnaElement& a)
{
    doParsimPacking(b,a.addr);
    doParsimPacking(b,a.netmask);
}

void __doUnpacking(omnetpp::cCommBuffer *b, HnaElement& a)
{
    doParsimUnpacking(b,a.addr);
    doParsimUnpacking(b,a.netmask);
}

class HnaElementDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    HnaElementDescriptor();
    virtual ~HnaElementDescriptor();

    virtual bool doesSupport(omnetpp::cObject *obj) const override;
    virtual const char **getPropertyNames() const override;
    virtual const char *getProperty(const char *propertyname) const override;
    virtual int getFieldCount() const override;
    virtual const char *getFieldName(int field) const override;
    virtual int findField(const char *fieldName) const override;
    virtual unsigned int getFieldTypeFlags(int field) const override;
    virtual const char *getFieldTypeString(int field) const override;
    virtual const char **getFieldPropertyNames(int field) const override;
    virtual const char *getFieldProperty(int field, const char *propertyname) const override;
    virtual int getFieldArraySize(void *object, int field) const override;

    virtual const char *getFieldDynamicTypeString(void *object, int field, int i) const override;
    virtual std::string getFieldValueAsString(void *object, int field, int i) const override;
    virtual bool setFieldValueAsString(void *object, int field, int i, const char *value) const override;

    virtual const char *getFieldStructName(int field) const override;
    virtual void *getFieldStructValuePointer(void *object, int field, int i) const override;
};

Register_ClassDescriptor(HnaElementDescriptor)

HnaElementDescriptor::HnaElementDescriptor() : omnetpp::cClassDescriptor("HnaElement", "")
{
    propertynames = nullptr;
}

HnaElementDescriptor::~HnaElementDescriptor()
{
    delete[] propertynames;
}

bool HnaElementDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<HnaElement *>(obj)!=nullptr;
}

const char **HnaElementDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *HnaElementDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int HnaElementDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 2+basedesc->getFieldCount() : 2;
}

unsigned int HnaElementDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISCOMPOUND,
        FD_ISEDITABLE,
    };
    return (field>=0 && field<2) ? fieldTypeFlags[field] : 0;
}

const char *HnaElementDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "addr",
        "netmask",
    };
    return (field>=0 && field<2) ? fieldNames[field] : nullptr;
}

int HnaElementDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='a' && strcmp(fieldName, "addr")==0) return base+0;
    if (fieldName[0]=='n' && strcmp(fieldName, "netmask")==0) return base+1;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *HnaElementDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "L3Address",
        "uint8_t",
    };
    return (field>=0 && field<2) ? fieldTypeStrings[field] : nullptr;
}

const char **HnaElementDescriptor::getFieldPropertyNames(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldPropertyNames(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

const char *HnaElementDescriptor::getFieldProperty(int field, const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldProperty(field, propertyname);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

int HnaElementDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    HnaElement *pp = (HnaElement *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *HnaElementDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    HnaElement *pp = (HnaElement *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string HnaElementDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    HnaElement *pp = (HnaElement *)object; (void)pp;
    switch (field) {
        case 0: {std::stringstream out; out << pp->addr; return out.str();}
        case 1: return ulong2string(pp->netmask);
        default: return "";
    }
}

bool HnaElementDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    HnaElement *pp = (HnaElement *)object; (void)pp;
    switch (field) {
        case 1: pp->netmask = string2ulong(value); return true;
        default: return false;
    }
}

const char *HnaElementDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 0: return omnetpp::opp_typename(typeid(L3Address));
        default: return nullptr;
    };
}

void *HnaElementDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    HnaElement *pp = (HnaElement *)object; (void)pp;
    switch (field) {
        case 0: return (void *)(&pp->addr); break;
        default: return nullptr;
    }
}

Register_Class(BatmanPacket)

BatmanPacket::BatmanPacket(const char *name, short kind) : ::omnetpp::cPacket(name,kind)
{
    this->setByteLength(BatPacketSize);

    this->version = 0;
    this->flags = 0;
    this->ttl = 0;
    this->gatewayFlags = 0;
    this->seqNumber = 0;
    this->gatewayPort = 0;
    this->tq = 0;
    this->hops = 0;
    hnaMsg_arraysize = 0;
    this->hnaMsg = 0;
}

BatmanPacket::BatmanPacket(const BatmanPacket& other) : ::omnetpp::cPacket(other)
{
    hnaMsg_arraysize = 0;
    this->hnaMsg = 0;
    copy(other);
}

BatmanPacket::~BatmanPacket()
{
    delete [] this->hnaMsg;
}

BatmanPacket& BatmanPacket::operator=(const BatmanPacket& other)
{
    if (this==&other) return *this;
    ::omnetpp::cPacket::operator=(other);
    copy(other);
    return *this;
}

void BatmanPacket::copy(const BatmanPacket& other)
{
    this->version = other.version;
    this->flags = other.flags;
    this->ttl = other.ttl;
    this->gatewayFlags = other.gatewayFlags;
    this->seqNumber = other.seqNumber;
    this->gatewayPort = other.gatewayPort;
    this->orig = other.orig;
    this->prevSender = other.prevSender;
    this->tq = other.tq;
    this->hops = other.hops;
    delete [] this->hnaMsg;
    this->hnaMsg = (other.hnaMsg_arraysize==0) ? nullptr : new HnaElement[other.hnaMsg_arraysize];
    hnaMsg_arraysize = other.hnaMsg_arraysize;
    for (unsigned int i=0; i<hnaMsg_arraysize; i++)
        this->hnaMsg[i] = other.hnaMsg[i];
}

void BatmanPacket::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::omnetpp::cPacket::parsimPack(b);
    doParsimPacking(b,this->version);
    doParsimPacking(b,this->flags);
    doParsimPacking(b,this->ttl);
    doParsimPacking(b,this->gatewayFlags);
    doParsimPacking(b,this->seqNumber);
    doParsimPacking(b,this->gatewayPort);
    doParsimPacking(b,this->orig);
    doParsimPacking(b,this->prevSender);
    doParsimPacking(b,this->tq);
    doParsimPacking(b,this->hops);
    b->pack(hnaMsg_arraysize);
    doParsimArrayPacking(b,this->hnaMsg,hnaMsg_arraysize);
}

void BatmanPacket::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::omnetpp::cPacket::parsimUnpack(b);
    doParsimUnpacking(b,this->version);
    doParsimUnpacking(b,this->flags);
    doParsimUnpacking(b,this->ttl);
    doParsimUnpacking(b,this->gatewayFlags);
    doParsimUnpacking(b,this->seqNumber);
    doParsimUnpacking(b,this->gatewayPort);
    doParsimUnpacking(b,this->orig);
    doParsimUnpacking(b,this->prevSender);
    doParsimUnpacking(b,this->tq);
    doParsimUnpacking(b,this->hops);
    delete [] this->hnaMsg;
    b->unpack(hnaMsg_arraysize);
    if (hnaMsg_arraysize==0) {
        this->hnaMsg = 0;
    } else {
        this->hnaMsg = new HnaElement[hnaMsg_arraysize];
        doParsimArrayUnpacking(b,this->hnaMsg,hnaMsg_arraysize);
    }
}

uint8_t BatmanPacket::getVersion() const
{
    return this->version;
}

void BatmanPacket::setVersion(uint8_t version)
{
    this->version = version;
}

uint8_t BatmanPacket::getFlags() const
{
    return this->flags;
}

void BatmanPacket::setFlags(uint8_t flags)
{
    this->flags = flags;
}

uint8_t BatmanPacket::getTtl() const
{
    return this->ttl;
}

void BatmanPacket::setTtl(uint8_t ttl)
{
    this->ttl = ttl;
}

uint8_t BatmanPacket::getGatewayFlags() const
{
    return this->gatewayFlags;
}

void BatmanPacket::setGatewayFlags(uint8_t gatewayFlags)
{
    this->gatewayFlags = gatewayFlags;
}

unsigned short BatmanPacket::getSeqNumber() const
{
    return this->seqNumber;
}

void BatmanPacket::setSeqNumber(unsigned short seqNumber)
{
    this->seqNumber = seqNumber;
}

unsigned short BatmanPacket::getGatewayPort() const
{
    return this->gatewayPort;
}

void BatmanPacket::setGatewayPort(unsigned short gatewayPort)
{
    this->gatewayPort = gatewayPort;
}

L3Address& BatmanPacket::getOrig()
{
    return this->orig;
}

void BatmanPacket::setOrig(const L3Address& orig)
{
    this->orig = orig;
}

L3Address& BatmanPacket::getPrevSender()
{
    return this->prevSender;
}

void BatmanPacket::setPrevSender(const L3Address& prevSender)
{
    this->prevSender = prevSender;
}

uint8_t BatmanPacket::getTq() const
{
    return this->tq;
}

void BatmanPacket::setTq(uint8_t tq)
{
    this->tq = tq;
}

uint8_t BatmanPacket::getHops() const
{
    return this->hops;
}

void BatmanPacket::setHops(uint8_t hops)
{
    this->hops = hops;
}

void BatmanPacket::setHnaMsgArraySize(unsigned int size)
{
    HnaElement *hnaMsg2 = (size==0) ? nullptr : new HnaElement[size];
    unsigned int sz = hnaMsg_arraysize < size ? hnaMsg_arraysize : size;
    for (unsigned int i=0; i<sz; i++)
        hnaMsg2[i] = this->hnaMsg[i];
    hnaMsg_arraysize = size;
    delete [] this->hnaMsg;
    this->hnaMsg = hnaMsg2;
}

unsigned int BatmanPacket::getHnaMsgArraySize() const
{
    return hnaMsg_arraysize;
}

HnaElement& BatmanPacket::getHnaMsg(unsigned int k)
{
    if (k>=hnaMsg_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", hnaMsg_arraysize, k);
    return this->hnaMsg[k];
}

void BatmanPacket::setHnaMsg(unsigned int k, const HnaElement& hnaMsg)
{
    if (k>=hnaMsg_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", hnaMsg_arraysize, k);
    this->hnaMsg[k] = hnaMsg;
}

class BatmanPacketDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    BatmanPacketDescriptor();
    virtual ~BatmanPacketDescriptor();

    virtual bool doesSupport(omnetpp::cObject *obj) const override;
    virtual const char **getPropertyNames() const override;
    virtual const char *getProperty(const char *propertyname) const override;
    virtual int getFieldCount() const override;
    virtual const char *getFieldName(int field) const override;
    virtual int findField(const char *fieldName) const override;
    virtual unsigned int getFieldTypeFlags(int field) const override;
    virtual const char *getFieldTypeString(int field) const override;
    virtual const char **getFieldPropertyNames(int field) const override;
    virtual const char *getFieldProperty(int field, const char *propertyname) const override;
    virtual int getFieldArraySize(void *object, int field) const override;

    virtual const char *getFieldDynamicTypeString(void *object, int field, int i) const override;
    virtual std::string getFieldValueAsString(void *object, int field, int i) const override;
    virtual bool setFieldValueAsString(void *object, int field, int i, const char *value) const override;

    virtual const char *getFieldStructName(int field) const override;
    virtual void *getFieldStructValuePointer(void *object, int field, int i) const override;
};

Register_ClassDescriptor(BatmanPacketDescriptor)

BatmanPacketDescriptor::BatmanPacketDescriptor() : omnetpp::cClassDescriptor("BatmanPacket", "omnetpp::cPacket")
{
    propertynames = nullptr;
}

BatmanPacketDescriptor::~BatmanPacketDescriptor()
{
    delete[] propertynames;
}

bool BatmanPacketDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<BatmanPacket *>(obj)!=nullptr;
}

const char **BatmanPacketDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *BatmanPacketDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int BatmanPacketDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 11+basedesc->getFieldCount() : 11;
}

unsigned int BatmanPacketDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISCOMPOUND,
        FD_ISCOMPOUND,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISARRAY | FD_ISCOMPOUND,
    };
    return (field>=0 && field<11) ? fieldTypeFlags[field] : 0;
}

const char *BatmanPacketDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "version",
        "flags",
        "ttl",
        "gatewayFlags",
        "seqNumber",
        "gatewayPort",
        "orig",
        "prevSender",
        "tq",
        "hops",
        "hnaMsg",
    };
    return (field>=0 && field<11) ? fieldNames[field] : nullptr;
}

int BatmanPacketDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='v' && strcmp(fieldName, "version")==0) return base+0;
    if (fieldName[0]=='f' && strcmp(fieldName, "flags")==0) return base+1;
    if (fieldName[0]=='t' && strcmp(fieldName, "ttl")==0) return base+2;
    if (fieldName[0]=='g' && strcmp(fieldName, "gatewayFlags")==0) return base+3;
    if (fieldName[0]=='s' && strcmp(fieldName, "seqNumber")==0) return base+4;
    if (fieldName[0]=='g' && strcmp(fieldName, "gatewayPort")==0) return base+5;
    if (fieldName[0]=='o' && strcmp(fieldName, "orig")==0) return base+6;
    if (fieldName[0]=='p' && strcmp(fieldName, "prevSender")==0) return base+7;
    if (fieldName[0]=='t' && strcmp(fieldName, "tq")==0) return base+8;
    if (fieldName[0]=='h' && strcmp(fieldName, "hops")==0) return base+9;
    if (fieldName[0]=='h' && strcmp(fieldName, "hnaMsg")==0) return base+10;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *BatmanPacketDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "uint8_t",
        "uint8_t",
        "uint8_t",
        "uint8_t",
        "unsigned short",
        "unsigned short",
        "L3Address",
        "L3Address",
        "uint8_t",
        "uint8_t",
        "HnaElement",
    };
    return (field>=0 && field<11) ? fieldTypeStrings[field] : nullptr;
}

const char **BatmanPacketDescriptor::getFieldPropertyNames(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldPropertyNames(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

const char *BatmanPacketDescriptor::getFieldProperty(int field, const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldProperty(field, propertyname);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

int BatmanPacketDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    BatmanPacket *pp = (BatmanPacket *)object; (void)pp;
    switch (field) {
        case 10: return pp->getHnaMsgArraySize();
        default: return 0;
    }
}

const char *BatmanPacketDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    BatmanPacket *pp = (BatmanPacket *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string BatmanPacketDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    BatmanPacket *pp = (BatmanPacket *)object; (void)pp;
    switch (field) {
        case 0: return ulong2string(pp->getVersion());
        case 1: return ulong2string(pp->getFlags());
        case 2: return ulong2string(pp->getTtl());
        case 3: return ulong2string(pp->getGatewayFlags());
        case 4: return ulong2string(pp->getSeqNumber());
        case 5: return ulong2string(pp->getGatewayPort());
        case 6: {std::stringstream out; out << pp->getOrig(); return out.str();}
        case 7: {std::stringstream out; out << pp->getPrevSender(); return out.str();}
        case 8: return ulong2string(pp->getTq());
        case 9: return ulong2string(pp->getHops());
        case 10: {std::stringstream out; out << pp->getHnaMsg(i); return out.str();}
        default: return "";
    }
}

bool BatmanPacketDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    BatmanPacket *pp = (BatmanPacket *)object; (void)pp;
    switch (field) {
        case 0: pp->setVersion(string2ulong(value)); return true;
        case 1: pp->setFlags(string2ulong(value)); return true;
        case 2: pp->setTtl(string2ulong(value)); return true;
        case 3: pp->setGatewayFlags(string2ulong(value)); return true;
        case 4: pp->setSeqNumber(string2ulong(value)); return true;
        case 5: pp->setGatewayPort(string2ulong(value)); return true;
        case 8: pp->setTq(string2ulong(value)); return true;
        case 9: pp->setHops(string2ulong(value)); return true;
        default: return false;
    }
}

const char *BatmanPacketDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 6: return omnetpp::opp_typename(typeid(L3Address));
        case 7: return omnetpp::opp_typename(typeid(L3Address));
        case 10: return omnetpp::opp_typename(typeid(HnaElement));
        default: return nullptr;
    };
}

void *BatmanPacketDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    BatmanPacket *pp = (BatmanPacket *)object; (void)pp;
    switch (field) {
        case 6: return (void *)(&pp->getOrig()); break;
        case 7: return (void *)(&pp->getPrevSender()); break;
        case 10: return (void *)(&pp->getHnaMsg(i)); break;
        default: return nullptr;
    }
}

Register_Class(visPacket)

visPacket::visPacket(const char *name, short kind) : ::omnetpp::cPacket(name,kind)
{
    this->version = 0;
    this->gwClass = 0;
    this->tqMax = 0;
    visData_arraysize = 0;
    this->visData = 0;
}

visPacket::visPacket(const visPacket& other) : ::omnetpp::cPacket(other)
{
    visData_arraysize = 0;
    this->visData = 0;
    copy(other);
}

visPacket::~visPacket()
{
    delete [] this->visData;
}

visPacket& visPacket::operator=(const visPacket& other)
{
    if (this==&other) return *this;
    ::omnetpp::cPacket::operator=(other);
    copy(other);
    return *this;
}

void visPacket::copy(const visPacket& other)
{
    this->senderIp = other.senderIp;
    this->version = other.version;
    this->gwClass = other.gwClass;
    this->tqMax = other.tqMax;
    delete [] this->visData;
    this->visData = (other.visData_arraysize==0) ? nullptr : new vis_data[other.visData_arraysize];
    visData_arraysize = other.visData_arraysize;
    for (unsigned int i=0; i<visData_arraysize; i++)
        this->visData[i] = other.visData[i];
}

void visPacket::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::omnetpp::cPacket::parsimPack(b);
    doParsimPacking(b,this->senderIp);
    doParsimPacking(b,this->version);
    doParsimPacking(b,this->gwClass);
    doParsimPacking(b,this->tqMax);
    b->pack(visData_arraysize);
    doParsimArrayPacking(b,this->visData,visData_arraysize);
}

void visPacket::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::omnetpp::cPacket::parsimUnpack(b);
    doParsimUnpacking(b,this->senderIp);
    doParsimUnpacking(b,this->version);
    doParsimUnpacking(b,this->gwClass);
    doParsimUnpacking(b,this->tqMax);
    delete [] this->visData;
    b->unpack(visData_arraysize);
    if (visData_arraysize==0) {
        this->visData = 0;
    } else {
        this->visData = new vis_data[visData_arraysize];
        doParsimArrayUnpacking(b,this->visData,visData_arraysize);
    }
}

L3Address& visPacket::getSenderIp()
{
    return this->senderIp;
}

void visPacket::setSenderIp(const L3Address& senderIp)
{
    this->senderIp = senderIp;
}

unsigned char visPacket::getVersion() const
{
    return this->version;
}

void visPacket::setVersion(unsigned char version)
{
    this->version = version;
}

unsigned char visPacket::getGwClass() const
{
    return this->gwClass;
}

void visPacket::setGwClass(unsigned char gwClass)
{
    this->gwClass = gwClass;
}

unsigned char visPacket::getTqMax() const
{
    return this->tqMax;
}

void visPacket::setTqMax(unsigned char tqMax)
{
    this->tqMax = tqMax;
}

void visPacket::setVisDataArraySize(unsigned int size)
{
    vis_data *visData2 = (size==0) ? nullptr : new vis_data[size];
    unsigned int sz = visData_arraysize < size ? visData_arraysize : size;
    for (unsigned int i=0; i<sz; i++)
        visData2[i] = this->visData[i];
    visData_arraysize = size;
    delete [] this->visData;
    this->visData = visData2;
}

unsigned int visPacket::getVisDataArraySize() const
{
    return visData_arraysize;
}

vis_data& visPacket::getVisData(unsigned int k)
{
    if (k>=visData_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", visData_arraysize, k);
    return this->visData[k];
}

void visPacket::setVisData(unsigned int k, const vis_data& visData)
{
    if (k>=visData_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", visData_arraysize, k);
    this->visData[k] = visData;
}

class visPacketDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    visPacketDescriptor();
    virtual ~visPacketDescriptor();

    virtual bool doesSupport(omnetpp::cObject *obj) const override;
    virtual const char **getPropertyNames() const override;
    virtual const char *getProperty(const char *propertyname) const override;
    virtual int getFieldCount() const override;
    virtual const char *getFieldName(int field) const override;
    virtual int findField(const char *fieldName) const override;
    virtual unsigned int getFieldTypeFlags(int field) const override;
    virtual const char *getFieldTypeString(int field) const override;
    virtual const char **getFieldPropertyNames(int field) const override;
    virtual const char *getFieldProperty(int field, const char *propertyname) const override;
    virtual int getFieldArraySize(void *object, int field) const override;

    virtual const char *getFieldDynamicTypeString(void *object, int field, int i) const override;
    virtual std::string getFieldValueAsString(void *object, int field, int i) const override;
    virtual bool setFieldValueAsString(void *object, int field, int i, const char *value) const override;

    virtual const char *getFieldStructName(int field) const override;
    virtual void *getFieldStructValuePointer(void *object, int field, int i) const override;
};

Register_ClassDescriptor(visPacketDescriptor)

visPacketDescriptor::visPacketDescriptor() : omnetpp::cClassDescriptor("visPacket", "omnetpp::cPacket")
{
    propertynames = nullptr;
}

visPacketDescriptor::~visPacketDescriptor()
{
    delete[] propertynames;
}

bool visPacketDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<visPacket *>(obj)!=nullptr;
}

const char **visPacketDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *visPacketDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int visPacketDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 5+basedesc->getFieldCount() : 5;
}

unsigned int visPacketDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISCOMPOUND,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISARRAY | FD_ISCOMPOUND,
    };
    return (field>=0 && field<5) ? fieldTypeFlags[field] : 0;
}

const char *visPacketDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "senderIp",
        "version",
        "gwClass",
        "tqMax",
        "visData",
    };
    return (field>=0 && field<5) ? fieldNames[field] : nullptr;
}

int visPacketDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='s' && strcmp(fieldName, "senderIp")==0) return base+0;
    if (fieldName[0]=='v' && strcmp(fieldName, "version")==0) return base+1;
    if (fieldName[0]=='g' && strcmp(fieldName, "gwClass")==0) return base+2;
    if (fieldName[0]=='t' && strcmp(fieldName, "tqMax")==0) return base+3;
    if (fieldName[0]=='v' && strcmp(fieldName, "visData")==0) return base+4;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *visPacketDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "L3Address",
        "unsigned char",
        "unsigned char",
        "unsigned char",
        "vis_data",
    };
    return (field>=0 && field<5) ? fieldTypeStrings[field] : nullptr;
}

const char **visPacketDescriptor::getFieldPropertyNames(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldPropertyNames(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

const char *visPacketDescriptor::getFieldProperty(int field, const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldProperty(field, propertyname);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    }
}

int visPacketDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    visPacket *pp = (visPacket *)object; (void)pp;
    switch (field) {
        case 4: return pp->getVisDataArraySize();
        default: return 0;
    }
}

const char *visPacketDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    visPacket *pp = (visPacket *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string visPacketDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    visPacket *pp = (visPacket *)object; (void)pp;
    switch (field) {
        case 0: {std::stringstream out; out << pp->getSenderIp(); return out.str();}
        case 1: return ulong2string(pp->getVersion());
        case 2: return ulong2string(pp->getGwClass());
        case 3: return ulong2string(pp->getTqMax());
        case 4: {std::stringstream out; out << pp->getVisData(i); return out.str();}
        default: return "";
    }
}

bool visPacketDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    visPacket *pp = (visPacket *)object; (void)pp;
    switch (field) {
        case 1: pp->setVersion(string2ulong(value)); return true;
        case 2: pp->setGwClass(string2ulong(value)); return true;
        case 3: pp->setTqMax(string2ulong(value)); return true;
        default: return false;
    }
}

const char *visPacketDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 0: return omnetpp::opp_typename(typeid(L3Address));
        case 4: return omnetpp::opp_typename(typeid(vis_data));
        default: return nullptr;
    };
}

void *visPacketDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    visPacket *pp = (visPacket *)object; (void)pp;
    switch (field) {
        case 0: return (void *)(&pp->getSenderIp()); break;
        case 4: return (void *)(&pp->getVisData(i)); break;
        default: return nullptr;
    }
}


