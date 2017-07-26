//
// Generated file, do not edit! Created by nedtool 5.1 from powerrouting/routing/dymo/DYMO.msg.
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
#include "DYMO_m.h"

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

Register_Class(AddressBlock)

AddressBlock::AddressBlock() : ::omnetpp::cObject()
{
    this->prefixLength = 0;
    this->hasValidityTime = false;
    this->validityTime = 0;
    this->hasMetric = false;
    this->metric = 0;
    this->hasMetricType = false;
    this->metricType = (DYMOMetricType)-1;
    this->hasSequenceNumber = false;
    this->sequenceNumber = 0;
}

AddressBlock::AddressBlock(const AddressBlock& other) : ::omnetpp::cObject(other)
{
    copy(other);
}

AddressBlock::~AddressBlock()
{
}

AddressBlock& AddressBlock::operator=(const AddressBlock& other)
{
    if (this==&other) return *this;
    ::omnetpp::cObject::operator=(other);
    copy(other);
    return *this;
}

void AddressBlock::copy(const AddressBlock& other)
{
    this->address = other.address;
    this->prefixLength = other.prefixLength;
    this->hasValidityTime = other.hasValidityTime;
    this->validityTime = other.validityTime;
    this->hasMetric = other.hasMetric;
    this->metric = other.metric;
    this->hasMetricType = other.hasMetricType;
    this->metricType = other.metricType;
    this->hasSequenceNumber = other.hasSequenceNumber;
    this->sequenceNumber = other.sequenceNumber;
}

void AddressBlock::parsimPack(omnetpp::cCommBuffer *b) const
{
    doParsimPacking(b,this->address);
    doParsimPacking(b,this->prefixLength);
    doParsimPacking(b,this->hasValidityTime);
    doParsimPacking(b,this->validityTime);
    doParsimPacking(b,this->hasMetric);
    doParsimPacking(b,this->metric);
    doParsimPacking(b,this->hasMetricType);
    doParsimPacking(b,this->metricType);
    doParsimPacking(b,this->hasSequenceNumber);
    doParsimPacking(b,this->sequenceNumber);
}

void AddressBlock::parsimUnpack(omnetpp::cCommBuffer *b)
{
    doParsimUnpacking(b,this->address);
    doParsimUnpacking(b,this->prefixLength);
    doParsimUnpacking(b,this->hasValidityTime);
    doParsimUnpacking(b,this->validityTime);
    doParsimUnpacking(b,this->hasMetric);
    doParsimUnpacking(b,this->metric);
    doParsimUnpacking(b,this->hasMetricType);
    doParsimUnpacking(b,this->metricType);
    doParsimUnpacking(b,this->hasSequenceNumber);
    doParsimUnpacking(b,this->sequenceNumber);
}

L3Address& AddressBlock::getAddress()
{
    return this->address;
}

void AddressBlock::setAddress(const L3Address& address)
{
    this->address = address;
}

int AddressBlock::getPrefixLength() const
{
    return this->prefixLength;
}

void AddressBlock::setPrefixLength(int prefixLength)
{
    this->prefixLength = prefixLength;
}

bool AddressBlock::getHasValidityTime() const
{
    return this->hasValidityTime;
}

void AddressBlock::setHasValidityTime(bool hasValidityTime)
{
    this->hasValidityTime = hasValidityTime;
}

::omnetpp::simtime_t AddressBlock::getValidityTime() const
{
    return this->validityTime;
}

void AddressBlock::setValidityTime(::omnetpp::simtime_t validityTime)
{
    this->validityTime = validityTime;
}

bool AddressBlock::getHasMetric() const
{
    return this->hasMetric;
}

void AddressBlock::setHasMetric(bool hasMetric)
{
    this->hasMetric = hasMetric;
}

double AddressBlock::getMetric() const
{
    return this->metric;
}

void AddressBlock::setMetric(double metric)
{
    this->metric = metric;
}

bool AddressBlock::getHasMetricType() const
{
    return this->hasMetricType;
}

void AddressBlock::setHasMetricType(bool hasMetricType)
{
    this->hasMetricType = hasMetricType;
}

DYMOMetricType& AddressBlock::getMetricType()
{
    return this->metricType;
}

void AddressBlock::setMetricType(const DYMOMetricType& metricType)
{
    this->metricType = metricType;
}

bool AddressBlock::getHasSequenceNumber() const
{
    return this->hasSequenceNumber;
}

void AddressBlock::setHasSequenceNumber(bool hasSequenceNumber)
{
    this->hasSequenceNumber = hasSequenceNumber;
}

DYMOSequenceNumber& AddressBlock::getSequenceNumber()
{
    return this->sequenceNumber;
}

void AddressBlock::setSequenceNumber(const DYMOSequenceNumber& sequenceNumber)
{
    this->sequenceNumber = sequenceNumber;
}

class AddressBlockDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    AddressBlockDescriptor();
    virtual ~AddressBlockDescriptor();

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

Register_ClassDescriptor(AddressBlockDescriptor)

AddressBlockDescriptor::AddressBlockDescriptor() : omnetpp::cClassDescriptor("AddressBlock", "omnetpp::cObject")
{
    propertynames = nullptr;
}

AddressBlockDescriptor::~AddressBlockDescriptor()
{
    delete[] propertynames;
}

bool AddressBlockDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<AddressBlock *>(obj)!=nullptr;
}

const char **AddressBlockDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *AddressBlockDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int AddressBlockDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 10+basedesc->getFieldCount() : 10;
}

unsigned int AddressBlockDescriptor::getFieldTypeFlags(int field) const
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
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISCOMPOUND,
        FD_ISEDITABLE,
        FD_ISCOMPOUND,
    };
    return (field>=0 && field<10) ? fieldTypeFlags[field] : 0;
}

const char *AddressBlockDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "address",
        "prefixLength",
        "hasValidityTime",
        "validityTime",
        "hasMetric",
        "metric",
        "hasMetricType",
        "metricType",
        "hasSequenceNumber",
        "sequenceNumber",
    };
    return (field>=0 && field<10) ? fieldNames[field] : nullptr;
}

int AddressBlockDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='a' && strcmp(fieldName, "address")==0) return base+0;
    if (fieldName[0]=='p' && strcmp(fieldName, "prefixLength")==0) return base+1;
    if (fieldName[0]=='h' && strcmp(fieldName, "hasValidityTime")==0) return base+2;
    if (fieldName[0]=='v' && strcmp(fieldName, "validityTime")==0) return base+3;
    if (fieldName[0]=='h' && strcmp(fieldName, "hasMetric")==0) return base+4;
    if (fieldName[0]=='m' && strcmp(fieldName, "metric")==0) return base+5;
    if (fieldName[0]=='h' && strcmp(fieldName, "hasMetricType")==0) return base+6;
    if (fieldName[0]=='m' && strcmp(fieldName, "metricType")==0) return base+7;
    if (fieldName[0]=='h' && strcmp(fieldName, "hasSequenceNumber")==0) return base+8;
    if (fieldName[0]=='s' && strcmp(fieldName, "sequenceNumber")==0) return base+9;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *AddressBlockDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "L3Address",
        "int",
        "bool",
        "simtime_t",
        "bool",
        "double",
        "bool",
        "DYMOMetricType",
        "bool",
        "DYMOSequenceNumber",
    };
    return (field>=0 && field<10) ? fieldTypeStrings[field] : nullptr;
}

const char **AddressBlockDescriptor::getFieldPropertyNames(int field) const
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

const char *AddressBlockDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int AddressBlockDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    AddressBlock *pp = (AddressBlock *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *AddressBlockDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    AddressBlock *pp = (AddressBlock *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string AddressBlockDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    AddressBlock *pp = (AddressBlock *)object; (void)pp;
    switch (field) {
        case 0: {std::stringstream out; out << pp->getAddress(); return out.str();}
        case 1: return long2string(pp->getPrefixLength());
        case 2: return bool2string(pp->getHasValidityTime());
        case 3: return simtime2string(pp->getValidityTime());
        case 4: return bool2string(pp->getHasMetric());
        case 5: return double2string(pp->getMetric());
        case 6: return bool2string(pp->getHasMetricType());
        case 7: {std::stringstream out; out << pp->getMetricType(); return out.str();}
        case 8: return bool2string(pp->getHasSequenceNumber());
        case 9: {std::stringstream out; out << pp->getSequenceNumber(); return out.str();}
        default: return "";
    }
}

bool AddressBlockDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    AddressBlock *pp = (AddressBlock *)object; (void)pp;
    switch (field) {
        case 1: pp->setPrefixLength(string2long(value)); return true;
        case 2: pp->setHasValidityTime(string2bool(value)); return true;
        case 3: pp->setValidityTime(string2simtime(value)); return true;
        case 4: pp->setHasMetric(string2bool(value)); return true;
        case 5: pp->setMetric(string2double(value)); return true;
        case 6: pp->setHasMetricType(string2bool(value)); return true;
        case 8: pp->setHasSequenceNumber(string2bool(value)); return true;
        default: return false;
    }
}

const char *AddressBlockDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 0: return omnetpp::opp_typename(typeid(L3Address));
        case 7: return omnetpp::opp_typename(typeid(DYMOMetricType));
        case 9: return omnetpp::opp_typename(typeid(DYMOSequenceNumber));
        default: return nullptr;
    };
}

void *AddressBlockDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    AddressBlock *pp = (AddressBlock *)object; (void)pp;
    switch (field) {
        case 0: return (void *)(&pp->getAddress()); break;
        case 7: return (void *)(&pp->getMetricType()); break;
        case 9: return (void *)(&pp->getSequenceNumber()); break;
        default: return nullptr;
    }
}

Register_Class(RREQTimer)

RREQTimer::RREQTimer(const char *name, short kind) : ::omnetpp::cMessage(name,kind)
{
}

RREQTimer::RREQTimer(const RREQTimer& other) : ::omnetpp::cMessage(other)
{
    copy(other);
}

RREQTimer::~RREQTimer()
{
}

RREQTimer& RREQTimer::operator=(const RREQTimer& other)
{
    if (this==&other) return *this;
    ::omnetpp::cMessage::operator=(other);
    copy(other);
    return *this;
}

void RREQTimer::copy(const RREQTimer& other)
{
    this->target = other.target;
}

void RREQTimer::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::omnetpp::cMessage::parsimPack(b);
    doParsimPacking(b,this->target);
}

void RREQTimer::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::omnetpp::cMessage::parsimUnpack(b);
    doParsimUnpacking(b,this->target);
}

L3Address& RREQTimer::getTarget()
{
    return this->target;
}

void RREQTimer::setTarget(const L3Address& target)
{
    this->target = target;
}

class RREQTimerDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREQTimerDescriptor();
    virtual ~RREQTimerDescriptor();

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

Register_ClassDescriptor(RREQTimerDescriptor)

RREQTimerDescriptor::RREQTimerDescriptor() : omnetpp::cClassDescriptor("RREQTimer", "omnetpp::cMessage")
{
    propertynames = nullptr;
}

RREQTimerDescriptor::~RREQTimerDescriptor()
{
    delete[] propertynames;
}

bool RREQTimerDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREQTimer *>(obj)!=nullptr;
}

const char **RREQTimerDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREQTimerDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREQTimerDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 1+basedesc->getFieldCount() : 1;
}

unsigned int RREQTimerDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISCOMPOUND,
    };
    return (field>=0 && field<1) ? fieldTypeFlags[field] : 0;
}

const char *RREQTimerDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "target",
    };
    return (field>=0 && field<1) ? fieldNames[field] : nullptr;
}

int RREQTimerDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='t' && strcmp(fieldName, "target")==0) return base+0;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREQTimerDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "L3Address",
    };
    return (field>=0 && field<1) ? fieldTypeStrings[field] : nullptr;
}

const char **RREQTimerDescriptor::getFieldPropertyNames(int field) const
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

const char *RREQTimerDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREQTimerDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREQTimer *pp = (RREQTimer *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREQTimerDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQTimer *pp = (RREQTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREQTimerDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQTimer *pp = (RREQTimer *)object; (void)pp;
    switch (field) {
        case 0: {std::stringstream out; out << pp->getTarget(); return out.str();}
        default: return "";
    }
}

bool RREQTimerDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREQTimer *pp = (RREQTimer *)object; (void)pp;
    switch (field) {
        default: return false;
    }
}

const char *RREQTimerDescriptor::getFieldStructName(int field) const
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

void *RREQTimerDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREQTimer *pp = (RREQTimer *)object; (void)pp;
    switch (field) {
        case 0: return (void *)(&pp->getTarget()); break;
        default: return nullptr;
    }
}

Register_Class(RREQWaitRREPTimer)

RREQWaitRREPTimer::RREQWaitRREPTimer(const char *name, short kind) : ::RREQTimer(name,kind)
{
    this->retryCount = 0;
}

RREQWaitRREPTimer::RREQWaitRREPTimer(const RREQWaitRREPTimer& other) : ::RREQTimer(other)
{
    copy(other);
}

RREQWaitRREPTimer::~RREQWaitRREPTimer()
{
}

RREQWaitRREPTimer& RREQWaitRREPTimer::operator=(const RREQWaitRREPTimer& other)
{
    if (this==&other) return *this;
    ::RREQTimer::operator=(other);
    copy(other);
    return *this;
}

void RREQWaitRREPTimer::copy(const RREQWaitRREPTimer& other)
{
    this->retryCount = other.retryCount;
}

void RREQWaitRREPTimer::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::RREQTimer::parsimPack(b);
    doParsimPacking(b,this->retryCount);
}

void RREQWaitRREPTimer::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::RREQTimer::parsimUnpack(b);
    doParsimUnpacking(b,this->retryCount);
}

int RREQWaitRREPTimer::getRetryCount() const
{
    return this->retryCount;
}

void RREQWaitRREPTimer::setRetryCount(int retryCount)
{
    this->retryCount = retryCount;
}

class RREQWaitRREPTimerDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREQWaitRREPTimerDescriptor();
    virtual ~RREQWaitRREPTimerDescriptor();

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

Register_ClassDescriptor(RREQWaitRREPTimerDescriptor)

RREQWaitRREPTimerDescriptor::RREQWaitRREPTimerDescriptor() : omnetpp::cClassDescriptor("RREQWaitRREPTimer", "RREQTimer")
{
    propertynames = nullptr;
}

RREQWaitRREPTimerDescriptor::~RREQWaitRREPTimerDescriptor()
{
    delete[] propertynames;
}

bool RREQWaitRREPTimerDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREQWaitRREPTimer *>(obj)!=nullptr;
}

const char **RREQWaitRREPTimerDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREQWaitRREPTimerDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREQWaitRREPTimerDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 1+basedesc->getFieldCount() : 1;
}

unsigned int RREQWaitRREPTimerDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
    };
    return (field>=0 && field<1) ? fieldTypeFlags[field] : 0;
}

const char *RREQWaitRREPTimerDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "retryCount",
    };
    return (field>=0 && field<1) ? fieldNames[field] : nullptr;
}

int RREQWaitRREPTimerDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='r' && strcmp(fieldName, "retryCount")==0) return base+0;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREQWaitRREPTimerDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "int",
    };
    return (field>=0 && field<1) ? fieldTypeStrings[field] : nullptr;
}

const char **RREQWaitRREPTimerDescriptor::getFieldPropertyNames(int field) const
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

const char *RREQWaitRREPTimerDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREQWaitRREPTimerDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREQWaitRREPTimer *pp = (RREQWaitRREPTimer *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREQWaitRREPTimerDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQWaitRREPTimer *pp = (RREQWaitRREPTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREQWaitRREPTimerDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQWaitRREPTimer *pp = (RREQWaitRREPTimer *)object; (void)pp;
    switch (field) {
        case 0: return long2string(pp->getRetryCount());
        default: return "";
    }
}

bool RREQWaitRREPTimerDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREQWaitRREPTimer *pp = (RREQWaitRREPTimer *)object; (void)pp;
    switch (field) {
        case 0: pp->setRetryCount(string2long(value)); return true;
        default: return false;
    }
}

const char *RREQWaitRREPTimerDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    };
}

void *RREQWaitRREPTimerDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREQWaitRREPTimer *pp = (RREQWaitRREPTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(RREQBackoffTimer)

RREQBackoffTimer::RREQBackoffTimer(const char *name, short kind) : ::RREQTimer(name,kind)
{
    this->retryCount = 0;
}

RREQBackoffTimer::RREQBackoffTimer(const RREQBackoffTimer& other) : ::RREQTimer(other)
{
    copy(other);
}

RREQBackoffTimer::~RREQBackoffTimer()
{
}

RREQBackoffTimer& RREQBackoffTimer::operator=(const RREQBackoffTimer& other)
{
    if (this==&other) return *this;
    ::RREQTimer::operator=(other);
    copy(other);
    return *this;
}

void RREQBackoffTimer::copy(const RREQBackoffTimer& other)
{
    this->retryCount = other.retryCount;
}

void RREQBackoffTimer::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::RREQTimer::parsimPack(b);
    doParsimPacking(b,this->retryCount);
}

void RREQBackoffTimer::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::RREQTimer::parsimUnpack(b);
    doParsimUnpacking(b,this->retryCount);
}

int RREQBackoffTimer::getRetryCount() const
{
    return this->retryCount;
}

void RREQBackoffTimer::setRetryCount(int retryCount)
{
    this->retryCount = retryCount;
}

class RREQBackoffTimerDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREQBackoffTimerDescriptor();
    virtual ~RREQBackoffTimerDescriptor();

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

Register_ClassDescriptor(RREQBackoffTimerDescriptor)

RREQBackoffTimerDescriptor::RREQBackoffTimerDescriptor() : omnetpp::cClassDescriptor("RREQBackoffTimer", "RREQTimer")
{
    propertynames = nullptr;
}

RREQBackoffTimerDescriptor::~RREQBackoffTimerDescriptor()
{
    delete[] propertynames;
}

bool RREQBackoffTimerDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREQBackoffTimer *>(obj)!=nullptr;
}

const char **RREQBackoffTimerDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREQBackoffTimerDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREQBackoffTimerDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 1+basedesc->getFieldCount() : 1;
}

unsigned int RREQBackoffTimerDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
    };
    return (field>=0 && field<1) ? fieldTypeFlags[field] : 0;
}

const char *RREQBackoffTimerDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "retryCount",
    };
    return (field>=0 && field<1) ? fieldNames[field] : nullptr;
}

int RREQBackoffTimerDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='r' && strcmp(fieldName, "retryCount")==0) return base+0;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREQBackoffTimerDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "int",
    };
    return (field>=0 && field<1) ? fieldTypeStrings[field] : nullptr;
}

const char **RREQBackoffTimerDescriptor::getFieldPropertyNames(int field) const
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

const char *RREQBackoffTimerDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREQBackoffTimerDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREQBackoffTimer *pp = (RREQBackoffTimer *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREQBackoffTimerDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQBackoffTimer *pp = (RREQBackoffTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREQBackoffTimerDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQBackoffTimer *pp = (RREQBackoffTimer *)object; (void)pp;
    switch (field) {
        case 0: return long2string(pp->getRetryCount());
        default: return "";
    }
}

bool RREQBackoffTimerDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREQBackoffTimer *pp = (RREQBackoffTimer *)object; (void)pp;
    switch (field) {
        case 0: pp->setRetryCount(string2long(value)); return true;
        default: return false;
    }
}

const char *RREQBackoffTimerDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    };
}

void *RREQBackoffTimerDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREQBackoffTimer *pp = (RREQBackoffTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(RREQHolddownTimer)

RREQHolddownTimer::RREQHolddownTimer(const char *name, short kind) : ::RREQTimer(name,kind)
{
}

RREQHolddownTimer::RREQHolddownTimer(const RREQHolddownTimer& other) : ::RREQTimer(other)
{
    copy(other);
}

RREQHolddownTimer::~RREQHolddownTimer()
{
}

RREQHolddownTimer& RREQHolddownTimer::operator=(const RREQHolddownTimer& other)
{
    if (this==&other) return *this;
    ::RREQTimer::operator=(other);
    copy(other);
    return *this;
}

void RREQHolddownTimer::copy(const RREQHolddownTimer& other)
{
}

void RREQHolddownTimer::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::RREQTimer::parsimPack(b);
}

void RREQHolddownTimer::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::RREQTimer::parsimUnpack(b);
}

class RREQHolddownTimerDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREQHolddownTimerDescriptor();
    virtual ~RREQHolddownTimerDescriptor();

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

Register_ClassDescriptor(RREQHolddownTimerDescriptor)

RREQHolddownTimerDescriptor::RREQHolddownTimerDescriptor() : omnetpp::cClassDescriptor("RREQHolddownTimer", "RREQTimer")
{
    propertynames = nullptr;
}

RREQHolddownTimerDescriptor::~RREQHolddownTimerDescriptor()
{
    delete[] propertynames;
}

bool RREQHolddownTimerDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREQHolddownTimer *>(obj)!=nullptr;
}

const char **RREQHolddownTimerDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREQHolddownTimerDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREQHolddownTimerDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 0+basedesc->getFieldCount() : 0;
}

unsigned int RREQHolddownTimerDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    return 0;
}

const char *RREQHolddownTimerDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

int RREQHolddownTimerDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREQHolddownTimerDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

const char **RREQHolddownTimerDescriptor::getFieldPropertyNames(int field) const
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

const char *RREQHolddownTimerDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREQHolddownTimerDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREQHolddownTimer *pp = (RREQHolddownTimer *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREQHolddownTimerDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQHolddownTimer *pp = (RREQHolddownTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREQHolddownTimerDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQHolddownTimer *pp = (RREQHolddownTimer *)object; (void)pp;
    switch (field) {
        default: return "";
    }
}

bool RREQHolddownTimerDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREQHolddownTimer *pp = (RREQHolddownTimer *)object; (void)pp;
    switch (field) {
        default: return false;
    }
}

const char *RREQHolddownTimerDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

void *RREQHolddownTimerDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREQHolddownTimer *pp = (RREQHolddownTimer *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(DYMOPacket)

DYMOPacket::DYMOPacket(const char *name, short kind) : ::omnetpp::cPacket(name,kind)
{
    this->hopLimit = 0;
}

DYMOPacket::DYMOPacket(const DYMOPacket& other) : ::omnetpp::cPacket(other)
{
    copy(other);
}

DYMOPacket::~DYMOPacket()
{
}

DYMOPacket& DYMOPacket::operator=(const DYMOPacket& other)
{
    if (this==&other) return *this;
    ::omnetpp::cPacket::operator=(other);
    copy(other);
    return *this;
}

void DYMOPacket::copy(const DYMOPacket& other)
{
    this->hopLimit = other.hopLimit;
}

void DYMOPacket::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::omnetpp::cPacket::parsimPack(b);
    doParsimPacking(b,this->hopLimit);
}

void DYMOPacket::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::omnetpp::cPacket::parsimUnpack(b);
    doParsimUnpacking(b,this->hopLimit);
}

int DYMOPacket::getHopLimit() const
{
    return this->hopLimit;
}

void DYMOPacket::setHopLimit(int hopLimit)
{
    this->hopLimit = hopLimit;
}

class DYMOPacketDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    DYMOPacketDescriptor();
    virtual ~DYMOPacketDescriptor();

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

Register_ClassDescriptor(DYMOPacketDescriptor)

DYMOPacketDescriptor::DYMOPacketDescriptor() : omnetpp::cClassDescriptor("DYMOPacket", "omnetpp::cPacket")
{
    propertynames = nullptr;
}

DYMOPacketDescriptor::~DYMOPacketDescriptor()
{
    delete[] propertynames;
}

bool DYMOPacketDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<DYMOPacket *>(obj)!=nullptr;
}

const char **DYMOPacketDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *DYMOPacketDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int DYMOPacketDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 1+basedesc->getFieldCount() : 1;
}

unsigned int DYMOPacketDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
    };
    return (field>=0 && field<1) ? fieldTypeFlags[field] : 0;
}

const char *DYMOPacketDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "hopLimit",
    };
    return (field>=0 && field<1) ? fieldNames[field] : nullptr;
}

int DYMOPacketDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='h' && strcmp(fieldName, "hopLimit")==0) return base+0;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *DYMOPacketDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "int",
    };
    return (field>=0 && field<1) ? fieldTypeStrings[field] : nullptr;
}

const char **DYMOPacketDescriptor::getFieldPropertyNames(int field) const
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

const char *DYMOPacketDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int DYMOPacketDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    DYMOPacket *pp = (DYMOPacket *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *DYMOPacketDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    DYMOPacket *pp = (DYMOPacket *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string DYMOPacketDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    DYMOPacket *pp = (DYMOPacket *)object; (void)pp;
    switch (field) {
        case 0: return long2string(pp->getHopLimit());
        default: return "";
    }
}

bool DYMOPacketDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    DYMOPacket *pp = (DYMOPacket *)object; (void)pp;
    switch (field) {
        case 0: pp->setHopLimit(string2long(value)); return true;
        default: return false;
    }
}

const char *DYMOPacketDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        default: return nullptr;
    };
}

void *DYMOPacketDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    DYMOPacket *pp = (DYMOPacket *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(RteMsg)

RteMsg::RteMsg(const char *name, short kind) : ::DYMOPacket(name,kind)
{
    this->hopCount = 0;
    addedNode_arraysize = 0;
    this->addedNode = 0;
}

RteMsg::RteMsg(const RteMsg& other) : ::DYMOPacket(other)
{
    addedNode_arraysize = 0;
    this->addedNode = 0;
    copy(other);
}

RteMsg::~RteMsg()
{
    delete [] this->addedNode;
}

RteMsg& RteMsg::operator=(const RteMsg& other)
{
    if (this==&other) return *this;
    ::DYMOPacket::operator=(other);
    copy(other);
    return *this;
}

void RteMsg::copy(const RteMsg& other)
{
    this->hopCount = other.hopCount;
    this->originatorNode = other.originatorNode;
    this->targetNode = other.targetNode;
    delete [] this->addedNode;
    this->addedNode = (other.addedNode_arraysize==0) ? nullptr : new AddressBlock[other.addedNode_arraysize];
    addedNode_arraysize = other.addedNode_arraysize;
    for (unsigned int i=0; i<addedNode_arraysize; i++)
        this->addedNode[i] = other.addedNode[i];
}

void RteMsg::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::DYMOPacket::parsimPack(b);
    doParsimPacking(b,this->hopCount);
    doParsimPacking(b,this->originatorNode);
    doParsimPacking(b,this->targetNode);
    b->pack(addedNode_arraysize);
    doParsimArrayPacking(b,this->addedNode,addedNode_arraysize);
}

void RteMsg::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::DYMOPacket::parsimUnpack(b);
    doParsimUnpacking(b,this->hopCount);
    doParsimUnpacking(b,this->originatorNode);
    doParsimUnpacking(b,this->targetNode);
    delete [] this->addedNode;
    b->unpack(addedNode_arraysize);
    if (addedNode_arraysize==0) {
        this->addedNode = 0;
    } else {
        this->addedNode = new AddressBlock[addedNode_arraysize];
        doParsimArrayUnpacking(b,this->addedNode,addedNode_arraysize);
    }
}

int RteMsg::getHopCount() const
{
    return this->hopCount;
}

void RteMsg::setHopCount(int hopCount)
{
    this->hopCount = hopCount;
}

AddressBlock& RteMsg::getOriginatorNode()
{
    return this->originatorNode;
}

void RteMsg::setOriginatorNode(const AddressBlock& originatorNode)
{
    this->originatorNode = originatorNode;
}

AddressBlock& RteMsg::getTargetNode()
{
    return this->targetNode;
}

void RteMsg::setTargetNode(const AddressBlock& targetNode)
{
    this->targetNode = targetNode;
}

void RteMsg::setAddedNodeArraySize(unsigned int size)
{
    AddressBlock *addedNode2 = (size==0) ? nullptr : new AddressBlock[size];
    unsigned int sz = addedNode_arraysize < size ? addedNode_arraysize : size;
    for (unsigned int i=0; i<sz; i++)
        addedNode2[i] = this->addedNode[i];
    addedNode_arraysize = size;
    delete [] this->addedNode;
    this->addedNode = addedNode2;
}

unsigned int RteMsg::getAddedNodeArraySize() const
{
    return addedNode_arraysize;
}

AddressBlock& RteMsg::getAddedNode(unsigned int k)
{
    if (k>=addedNode_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", addedNode_arraysize, k);
    return this->addedNode[k];
}

void RteMsg::setAddedNode(unsigned int k, const AddressBlock& addedNode)
{
    if (k>=addedNode_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", addedNode_arraysize, k);
    this->addedNode[k] = addedNode;
}

class RteMsgDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RteMsgDescriptor();
    virtual ~RteMsgDescriptor();

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

Register_ClassDescriptor(RteMsgDescriptor)

RteMsgDescriptor::RteMsgDescriptor() : omnetpp::cClassDescriptor("RteMsg", "DYMOPacket")
{
    propertynames = nullptr;
}

RteMsgDescriptor::~RteMsgDescriptor()
{
    delete[] propertynames;
}

bool RteMsgDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RteMsg *>(obj)!=nullptr;
}

const char **RteMsgDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RteMsgDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RteMsgDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 4+basedesc->getFieldCount() : 4;
}

unsigned int RteMsgDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
        FD_ISCOMPOUND | FD_ISCOBJECT,
        FD_ISCOMPOUND | FD_ISCOBJECT,
        FD_ISARRAY | FD_ISCOMPOUND | FD_ISCOBJECT,
    };
    return (field>=0 && field<4) ? fieldTypeFlags[field] : 0;
}

const char *RteMsgDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "hopCount",
        "originatorNode",
        "targetNode",
        "addedNode",
    };
    return (field>=0 && field<4) ? fieldNames[field] : nullptr;
}

int RteMsgDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='h' && strcmp(fieldName, "hopCount")==0) return base+0;
    if (fieldName[0]=='o' && strcmp(fieldName, "originatorNode")==0) return base+1;
    if (fieldName[0]=='t' && strcmp(fieldName, "targetNode")==0) return base+2;
    if (fieldName[0]=='a' && strcmp(fieldName, "addedNode")==0) return base+3;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RteMsgDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "int",
        "AddressBlock",
        "AddressBlock",
        "AddressBlock",
    };
    return (field>=0 && field<4) ? fieldTypeStrings[field] : nullptr;
}

const char **RteMsgDescriptor::getFieldPropertyNames(int field) const
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

const char *RteMsgDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RteMsgDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RteMsg *pp = (RteMsg *)object; (void)pp;
    switch (field) {
        case 3: return pp->getAddedNodeArraySize();
        default: return 0;
    }
}

const char *RteMsgDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RteMsg *pp = (RteMsg *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RteMsgDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RteMsg *pp = (RteMsg *)object; (void)pp;
    switch (field) {
        case 0: return long2string(pp->getHopCount());
        case 1: {std::stringstream out; out << pp->getOriginatorNode(); return out.str();}
        case 2: {std::stringstream out; out << pp->getTargetNode(); return out.str();}
        case 3: {std::stringstream out; out << pp->getAddedNode(i); return out.str();}
        default: return "";
    }
}

bool RteMsgDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RteMsg *pp = (RteMsg *)object; (void)pp;
    switch (field) {
        case 0: pp->setHopCount(string2long(value)); return true;
        default: return false;
    }
}

const char *RteMsgDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 1: return omnetpp::opp_typename(typeid(AddressBlock));
        case 2: return omnetpp::opp_typename(typeid(AddressBlock));
        case 3: return omnetpp::opp_typename(typeid(AddressBlock));
        default: return nullptr;
    };
}

void *RteMsgDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RteMsg *pp = (RteMsg *)object; (void)pp;
    switch (field) {
        case 1: return (void *)static_cast<omnetpp::cObject *>(&pp->getOriginatorNode()); break;
        case 2: return (void *)static_cast<omnetpp::cObject *>(&pp->getTargetNode()); break;
        case 3: return (void *)static_cast<omnetpp::cObject *>(&pp->getAddedNode(i)); break;
        default: return nullptr;
    }
}

Register_Class(RREQ)

RREQ::RREQ(const char *name, short kind) : ::RteMsg(name,kind)
{
}

RREQ::RREQ(const RREQ& other) : ::RteMsg(other)
{
    copy(other);
}

RREQ::~RREQ()
{
}

RREQ& RREQ::operator=(const RREQ& other)
{
    if (this==&other) return *this;
    ::RteMsg::operator=(other);
    copy(other);
    return *this;
}

void RREQ::copy(const RREQ& other)
{
}

void RREQ::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::RteMsg::parsimPack(b);
}

void RREQ::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::RteMsg::parsimUnpack(b);
}

class RREQDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREQDescriptor();
    virtual ~RREQDescriptor();

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

Register_ClassDescriptor(RREQDescriptor)

RREQDescriptor::RREQDescriptor() : omnetpp::cClassDescriptor("RREQ", "RteMsg")
{
    propertynames = nullptr;
}

RREQDescriptor::~RREQDescriptor()
{
    delete[] propertynames;
}

bool RREQDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREQ *>(obj)!=nullptr;
}

const char **RREQDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREQDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREQDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 0+basedesc->getFieldCount() : 0;
}

unsigned int RREQDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    return 0;
}

const char *RREQDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

int RREQDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREQDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

const char **RREQDescriptor::getFieldPropertyNames(int field) const
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

const char *RREQDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREQDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREQ *pp = (RREQ *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREQDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQ *pp = (RREQ *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREQDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREQ *pp = (RREQ *)object; (void)pp;
    switch (field) {
        default: return "";
    }
}

bool RREQDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREQ *pp = (RREQ *)object; (void)pp;
    switch (field) {
        default: return false;
    }
}

const char *RREQDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

void *RREQDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREQ *pp = (RREQ *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(RREP)

RREP::RREP(const char *name, short kind) : ::RteMsg(name,kind)
{
}

RREP::RREP(const RREP& other) : ::RteMsg(other)
{
    copy(other);
}

RREP::~RREP()
{
}

RREP& RREP::operator=(const RREP& other)
{
    if (this==&other) return *this;
    ::RteMsg::operator=(other);
    copy(other);
    return *this;
}

void RREP::copy(const RREP& other)
{
}

void RREP::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::RteMsg::parsimPack(b);
}

void RREP::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::RteMsg::parsimUnpack(b);
}

class RREPDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREPDescriptor();
    virtual ~RREPDescriptor();

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

Register_ClassDescriptor(RREPDescriptor)

RREPDescriptor::RREPDescriptor() : omnetpp::cClassDescriptor("RREP", "RteMsg")
{
    propertynames = nullptr;
}

RREPDescriptor::~RREPDescriptor()
{
    delete[] propertynames;
}

bool RREPDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREP *>(obj)!=nullptr;
}

const char **RREPDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREPDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREPDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 0+basedesc->getFieldCount() : 0;
}

unsigned int RREPDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    return 0;
}

const char *RREPDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

int RREPDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREPDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

const char **RREPDescriptor::getFieldPropertyNames(int field) const
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

const char *RREPDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREPDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREP *pp = (RREP *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREPDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREP *pp = (RREP *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREPDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREP *pp = (RREP *)object; (void)pp;
    switch (field) {
        default: return "";
    }
}

bool RREPDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREP *pp = (RREP *)object; (void)pp;
    switch (field) {
        default: return false;
    }
}

const char *RREPDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

void *RREPDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREP *pp = (RREP *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(RREP_ACK)

RREP_ACK::RREP_ACK(const char *name, short kind) : ::DYMOPacket(name,kind)
{
}

RREP_ACK::RREP_ACK(const RREP_ACK& other) : ::DYMOPacket(other)
{
    copy(other);
}

RREP_ACK::~RREP_ACK()
{
}

RREP_ACK& RREP_ACK::operator=(const RREP_ACK& other)
{
    if (this==&other) return *this;
    ::DYMOPacket::operator=(other);
    copy(other);
    return *this;
}

void RREP_ACK::copy(const RREP_ACK& other)
{
}

void RREP_ACK::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::DYMOPacket::parsimPack(b);
}

void RREP_ACK::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::DYMOPacket::parsimUnpack(b);
}

class RREP_ACKDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RREP_ACKDescriptor();
    virtual ~RREP_ACKDescriptor();

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

Register_ClassDescriptor(RREP_ACKDescriptor)

RREP_ACKDescriptor::RREP_ACKDescriptor() : omnetpp::cClassDescriptor("RREP_ACK", "DYMOPacket")
{
    propertynames = nullptr;
}

RREP_ACKDescriptor::~RREP_ACKDescriptor()
{
    delete[] propertynames;
}

bool RREP_ACKDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RREP_ACK *>(obj)!=nullptr;
}

const char **RREP_ACKDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RREP_ACKDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RREP_ACKDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 0+basedesc->getFieldCount() : 0;
}

unsigned int RREP_ACKDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    return 0;
}

const char *RREP_ACKDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

int RREP_ACKDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RREP_ACKDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

const char **RREP_ACKDescriptor::getFieldPropertyNames(int field) const
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

const char *RREP_ACKDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RREP_ACKDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RREP_ACK *pp = (RREP_ACK *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

const char *RREP_ACKDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREP_ACK *pp = (RREP_ACK *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RREP_ACKDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RREP_ACK *pp = (RREP_ACK *)object; (void)pp;
    switch (field) {
        default: return "";
    }
}

bool RREP_ACKDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RREP_ACK *pp = (RREP_ACK *)object; (void)pp;
    switch (field) {
        default: return false;
    }
}

const char *RREP_ACKDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    return nullptr;
}

void *RREP_ACKDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RREP_ACK *pp = (RREP_ACK *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

Register_Class(RERR)

RERR::RERR(const char *name, short kind) : ::DYMOPacket(name,kind)
{
    unreachableNode_arraysize = 0;
    this->unreachableNode = 0;
}

RERR::RERR(const RERR& other) : ::DYMOPacket(other)
{
    unreachableNode_arraysize = 0;
    this->unreachableNode = 0;
    copy(other);
}

RERR::~RERR()
{
    delete [] this->unreachableNode;
}

RERR& RERR::operator=(const RERR& other)
{
    if (this==&other) return *this;
    ::DYMOPacket::operator=(other);
    copy(other);
    return *this;
}

void RERR::copy(const RERR& other)
{
    this->PktSource = other.PktSource;
    delete [] this->unreachableNode;
    this->unreachableNode = (other.unreachableNode_arraysize==0) ? nullptr : new AddressBlock[other.unreachableNode_arraysize];
    unreachableNode_arraysize = other.unreachableNode_arraysize;
    for (unsigned int i=0; i<unreachableNode_arraysize; i++)
        this->unreachableNode[i] = other.unreachableNode[i];
}

void RERR::parsimPack(omnetpp::cCommBuffer *b) const
{
    ::DYMOPacket::parsimPack(b);
    doParsimPacking(b,this->PktSource);
    b->pack(unreachableNode_arraysize);
    doParsimArrayPacking(b,this->unreachableNode,unreachableNode_arraysize);
}

void RERR::parsimUnpack(omnetpp::cCommBuffer *b)
{
    ::DYMOPacket::parsimUnpack(b);
    doParsimUnpacking(b,this->PktSource);
    delete [] this->unreachableNode;
    b->unpack(unreachableNode_arraysize);
    if (unreachableNode_arraysize==0) {
        this->unreachableNode = 0;
    } else {
        this->unreachableNode = new AddressBlock[unreachableNode_arraysize];
        doParsimArrayUnpacking(b,this->unreachableNode,unreachableNode_arraysize);
    }
}

L3Address& RERR::getPktSource()
{
    return this->PktSource;
}

void RERR::setPktSource(const L3Address& PktSource)
{
    this->PktSource = PktSource;
}

void RERR::setUnreachableNodeArraySize(unsigned int size)
{
    AddressBlock *unreachableNode2 = (size==0) ? nullptr : new AddressBlock[size];
    unsigned int sz = unreachableNode_arraysize < size ? unreachableNode_arraysize : size;
    for (unsigned int i=0; i<sz; i++)
        unreachableNode2[i] = this->unreachableNode[i];
    unreachableNode_arraysize = size;
    delete [] this->unreachableNode;
    this->unreachableNode = unreachableNode2;
}

unsigned int RERR::getUnreachableNodeArraySize() const
{
    return unreachableNode_arraysize;
}

AddressBlock& RERR::getUnreachableNode(unsigned int k)
{
    if (k>=unreachableNode_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", unreachableNode_arraysize, k);
    return this->unreachableNode[k];
}

void RERR::setUnreachableNode(unsigned int k, const AddressBlock& unreachableNode)
{
    if (k>=unreachableNode_arraysize) throw omnetpp::cRuntimeError("Array of size %d indexed by %d", unreachableNode_arraysize, k);
    this->unreachableNode[k] = unreachableNode;
}

class RERRDescriptor : public omnetpp::cClassDescriptor
{
  private:
    mutable const char **propertynames;
  public:
    RERRDescriptor();
    virtual ~RERRDescriptor();

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

Register_ClassDescriptor(RERRDescriptor)

RERRDescriptor::RERRDescriptor() : omnetpp::cClassDescriptor("RERR", "DYMOPacket")
{
    propertynames = nullptr;
}

RERRDescriptor::~RERRDescriptor()
{
    delete[] propertynames;
}

bool RERRDescriptor::doesSupport(omnetpp::cObject *obj) const
{
    return dynamic_cast<RERR *>(obj)!=nullptr;
}

const char **RERRDescriptor::getPropertyNames() const
{
    if (!propertynames) {
        static const char *names[] = {  nullptr };
        omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
        const char **basenames = basedesc ? basedesc->getPropertyNames() : nullptr;
        propertynames = mergeLists(basenames, names);
    }
    return propertynames;
}

const char *RERRDescriptor::getProperty(const char *propertyname) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : nullptr;
}

int RERRDescriptor::getFieldCount() const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 2+basedesc->getFieldCount() : 2;
}

unsigned int RERRDescriptor::getFieldTypeFlags(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeFlags(field);
        field -= basedesc->getFieldCount();
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISCOMPOUND,
        FD_ISARRAY | FD_ISCOMPOUND | FD_ISCOBJECT,
    };
    return (field>=0 && field<2) ? fieldTypeFlags[field] : 0;
}

const char *RERRDescriptor::getFieldName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldName(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldNames[] = {
        "PktSource",
        "unreachableNode",
    };
    return (field>=0 && field<2) ? fieldNames[field] : nullptr;
}

int RERRDescriptor::findField(const char *fieldName) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount() : 0;
    if (fieldName[0]=='P' && strcmp(fieldName, "PktSource")==0) return base+0;
    if (fieldName[0]=='u' && strcmp(fieldName, "unreachableNode")==0) return base+1;
    return basedesc ? basedesc->findField(fieldName) : -1;
}

const char *RERRDescriptor::getFieldTypeString(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldTypeString(field);
        field -= basedesc->getFieldCount();
    }
    static const char *fieldTypeStrings[] = {
        "L3Address",
        "AddressBlock",
    };
    return (field>=0 && field<2) ? fieldTypeStrings[field] : nullptr;
}

const char **RERRDescriptor::getFieldPropertyNames(int field) const
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

const char *RERRDescriptor::getFieldProperty(int field, const char *propertyname) const
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

int RERRDescriptor::getFieldArraySize(void *object, int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldArraySize(object, field);
        field -= basedesc->getFieldCount();
    }
    RERR *pp = (RERR *)object; (void)pp;
    switch (field) {
        case 1: return pp->getUnreachableNodeArraySize();
        default: return 0;
    }
}

const char *RERRDescriptor::getFieldDynamicTypeString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldDynamicTypeString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RERR *pp = (RERR *)object; (void)pp;
    switch (field) {
        default: return nullptr;
    }
}

std::string RERRDescriptor::getFieldValueAsString(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldValueAsString(object,field,i);
        field -= basedesc->getFieldCount();
    }
    RERR *pp = (RERR *)object; (void)pp;
    switch (field) {
        case 0: {std::stringstream out; out << pp->getPktSource(); return out.str();}
        case 1: {std::stringstream out; out << pp->getUnreachableNode(i); return out.str();}
        default: return "";
    }
}

bool RERRDescriptor::setFieldValueAsString(void *object, int field, int i, const char *value) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->setFieldValueAsString(object,field,i,value);
        field -= basedesc->getFieldCount();
    }
    RERR *pp = (RERR *)object; (void)pp;
    switch (field) {
        default: return false;
    }
}

const char *RERRDescriptor::getFieldStructName(int field) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructName(field);
        field -= basedesc->getFieldCount();
    }
    switch (field) {
        case 0: return omnetpp::opp_typename(typeid(L3Address));
        case 1: return omnetpp::opp_typename(typeid(AddressBlock));
        default: return nullptr;
    };
}

void *RERRDescriptor::getFieldStructValuePointer(void *object, int field, int i) const
{
    omnetpp::cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount())
            return basedesc->getFieldStructValuePointer(object, field, i);
        field -= basedesc->getFieldCount();
    }
    RERR *pp = (RERR *)object; (void)pp;
    switch (field) {
        case 0: return (void *)(&pp->getPktSource()); break;
        case 1: return (void *)static_cast<omnetpp::cObject *>(&pp->getUnreachableNode(i)); break;
        default: return nullptr;
    }
}


