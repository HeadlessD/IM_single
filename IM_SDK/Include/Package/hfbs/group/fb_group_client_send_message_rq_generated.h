// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGROUPCLIENTSENDMESSAGERQ_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGROUPCLIENTSENDMESSAGERQ_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace grouppack {

struct T_GROUP_CLIENT_SEND_MESSAGE_RQ;

struct T_GROUP_CLIENT_SEND_MESSAGE_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_MESSAGE_ID = 6,
    VT_GROUP_ID = 8,
    VT_S_MSG = 10,
    VT_GROUP_NAME = 12
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t message_id() const { return GetField<uint64_t>(VT_MESSAGE_ID, 0); }
  uint64_t group_id() const { return GetField<uint64_t>(VT_GROUP_ID, 0); }
  const commonpack::S_MSG *s_msg() const { return GetPointer<const commonpack::S_MSG *>(VT_S_MSG); }
  const flatbuffers::String *group_name() const { return GetPointer<const flatbuffers::String *>(VT_GROUP_NAME); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_MESSAGE_ID) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_ID) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_S_MSG) &&
           verifier.VerifyTable(s_msg()) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_GROUP_NAME) &&
           verifier.Verify(group_name()) &&
           verifier.EndTable();
  }
};

struct T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_GROUP_CLIENT_SEND_MESSAGE_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_message_id(uint64_t message_id) { fbb_.AddElement<uint64_t>(T_GROUP_CLIENT_SEND_MESSAGE_RQ::VT_MESSAGE_ID, message_id, 0); }
  void add_group_id(uint64_t group_id) { fbb_.AddElement<uint64_t>(T_GROUP_CLIENT_SEND_MESSAGE_RQ::VT_GROUP_ID, group_id, 0); }
  void add_s_msg(flatbuffers::Offset<commonpack::S_MSG> s_msg) { fbb_.AddOffset(T_GROUP_CLIENT_SEND_MESSAGE_RQ::VT_S_MSG, s_msg); }
  void add_group_name(flatbuffers::Offset<flatbuffers::String> group_name) { fbb_.AddOffset(T_GROUP_CLIENT_SEND_MESSAGE_RQ::VT_GROUP_NAME, group_name); }
  T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder &operator=(const T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder &);
  flatbuffers::Offset<T_GROUP_CLIENT_SEND_MESSAGE_RQ> Finish() {
    auto o = flatbuffers::Offset<T_GROUP_CLIENT_SEND_MESSAGE_RQ>(fbb_.EndTable(start_, 5));
    return o;
  }
};

inline flatbuffers::Offset<T_GROUP_CLIENT_SEND_MESSAGE_RQ> CreateT_GROUP_CLIENT_SEND_MESSAGE_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t message_id = 0,
    uint64_t group_id = 0,
    flatbuffers::Offset<commonpack::S_MSG> s_msg = 0,
    flatbuffers::Offset<flatbuffers::String> group_name = 0) {
  T_GROUP_CLIENT_SEND_MESSAGE_RQBuilder builder_(_fbb);
  builder_.add_group_id(group_id);
  builder_.add_message_id(message_id);
  builder_.add_group_name(group_name);
  builder_.add_s_msg(s_msg);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_GROUP_CLIENT_SEND_MESSAGE_RQ> CreateT_GROUP_CLIENT_SEND_MESSAGE_RQDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t message_id = 0,
    uint64_t group_id = 0,
    flatbuffers::Offset<commonpack::S_MSG> s_msg = 0,
    const char *group_name = nullptr) {
  return CreateT_GROUP_CLIENT_SEND_MESSAGE_RQ(_fbb, s_rq_head, message_id, group_id, s_msg, group_name ? _fbb.CreateString(group_name) : 0);
}

inline const grouppack::T_GROUP_CLIENT_SEND_MESSAGE_RQ *GetT_GROUP_CLIENT_SEND_MESSAGE_RQ(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GROUP_CLIENT_SEND_MESSAGE_RQ>(buf);
}

inline bool VerifyT_GROUP_CLIENT_SEND_MESSAGE_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GROUP_CLIENT_SEND_MESSAGE_RQ>(nullptr);
}

inline void FinishT_GROUP_CLIENT_SEND_MESSAGE_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GROUP_CLIENT_SEND_MESSAGE_RQ> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGROUPCLIENTSENDMESSAGERQ_GROUPPACK_H_
