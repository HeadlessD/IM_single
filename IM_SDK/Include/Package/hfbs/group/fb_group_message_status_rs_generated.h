// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGROUPMESSAGESTATUSRS_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGROUPMESSAGESTATUSRS_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace grouppack {

struct T_GROUP_MESSAGE_STATUS_RS;

struct T_GROUP_MESSAGE_STATUS_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_GROUP_ID = 6,
    VT_MESSAGE_STATUS = 8
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  uint64_t group_id() const { return GetField<uint64_t>(VT_GROUP_ID, 0); }
  int8_t message_status() const { return GetField<int8_t>(VT_MESSAGE_STATUS, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_ID) &&
           VerifyField<int8_t>(verifier, VT_MESSAGE_STATUS) &&
           verifier.EndTable();
  }
};

struct T_GROUP_MESSAGE_STATUS_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_GROUP_MESSAGE_STATUS_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_group_id(uint64_t group_id) { fbb_.AddElement<uint64_t>(T_GROUP_MESSAGE_STATUS_RS::VT_GROUP_ID, group_id, 0); }
  void add_message_status(int8_t message_status) { fbb_.AddElement<int8_t>(T_GROUP_MESSAGE_STATUS_RS::VT_MESSAGE_STATUS, message_status, 0); }
  T_GROUP_MESSAGE_STATUS_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GROUP_MESSAGE_STATUS_RSBuilder &operator=(const T_GROUP_MESSAGE_STATUS_RSBuilder &);
  flatbuffers::Offset<T_GROUP_MESSAGE_STATUS_RS> Finish() {
    auto o = flatbuffers::Offset<T_GROUP_MESSAGE_STATUS_RS>(fbb_.EndTable(start_, 3));
    return o;
  }
};

inline flatbuffers::Offset<T_GROUP_MESSAGE_STATUS_RS> CreateT_GROUP_MESSAGE_STATUS_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    uint64_t group_id = 0,
    int8_t message_status = 0) {
  T_GROUP_MESSAGE_STATUS_RSBuilder builder_(_fbb);
  builder_.add_group_id(group_id);
  builder_.add_s_rs_head(s_rs_head);
  builder_.add_message_status(message_status);
  return builder_.Finish();
}

inline const grouppack::T_GROUP_MESSAGE_STATUS_RS *GetT_GROUP_MESSAGE_STATUS_RS(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GROUP_MESSAGE_STATUS_RS>(buf);
}

inline bool VerifyT_GROUP_MESSAGE_STATUS_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GROUP_MESSAGE_STATUS_RS>(nullptr);
}

inline void FinishT_GROUP_MESSAGE_STATUS_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GROUP_MESSAGE_STATUS_RS> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGROUPMESSAGESTATUSRS_GROUPPACK_H_