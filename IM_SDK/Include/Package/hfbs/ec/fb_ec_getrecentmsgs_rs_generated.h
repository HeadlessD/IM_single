// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBECGETRECENTMSGSRS_ECPACK_H_
#define FLATBUFFERS_GENERATED_FBECGETRECENTMSGSRS_ECPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"
#include "fb_ec_msginfo_generated.h"

namespace ecpack {

struct T_EC_GETRECENTMSGS_RS;

struct T_EC_GETRECENTMSGS_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_B_ID = 6,
    VT_C_ID = 8,
    VT_MESSAGE_ID = 10,
    VT_MAX_CNT = 12,
    VT_MSG_LIST = 14
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  uint64_t b_id() const { return GetField<uint64_t>(VT_B_ID, 0); }
  uint64_t c_id() const { return GetField<uint64_t>(VT_C_ID, 0); }
  uint64_t message_id() const { return GetField<uint64_t>(VT_MESSAGE_ID, 0); }
  int32_t max_cnt() const { return GetField<int32_t>(VT_MAX_CNT, 0); }
  const flatbuffers::Vector<flatbuffers::Offset<ecpack::T_ECMSG_INFO>> *msg_list() const { return GetPointer<const flatbuffers::Vector<flatbuffers::Offset<ecpack::T_ECMSG_INFO>> *>(VT_MSG_LIST); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_B_ID) &&
           VerifyField<uint64_t>(verifier, VT_C_ID) &&
           VerifyField<uint64_t>(verifier, VT_MESSAGE_ID) &&
           VerifyField<int32_t>(verifier, VT_MAX_CNT) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_MSG_LIST) &&
           verifier.Verify(msg_list()) &&
           verifier.VerifyVectorOfTables(msg_list()) &&
           verifier.EndTable();
  }
};

struct T_EC_GETRECENTMSGS_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_EC_GETRECENTMSGS_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_b_id(uint64_t b_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTMSGS_RS::VT_B_ID, b_id, 0); }
  void add_c_id(uint64_t c_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTMSGS_RS::VT_C_ID, c_id, 0); }
  void add_message_id(uint64_t message_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTMSGS_RS::VT_MESSAGE_ID, message_id, 0); }
  void add_max_cnt(int32_t max_cnt) { fbb_.AddElement<int32_t>(T_EC_GETRECENTMSGS_RS::VT_MAX_CNT, max_cnt, 0); }
  void add_msg_list(flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<ecpack::T_ECMSG_INFO>>> msg_list) { fbb_.AddOffset(T_EC_GETRECENTMSGS_RS::VT_MSG_LIST, msg_list); }
  T_EC_GETRECENTMSGS_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_EC_GETRECENTMSGS_RSBuilder &operator=(const T_EC_GETRECENTMSGS_RSBuilder &);
  flatbuffers::Offset<T_EC_GETRECENTMSGS_RS> Finish() {
    auto o = flatbuffers::Offset<T_EC_GETRECENTMSGS_RS>(fbb_.EndTable(start_, 6));
    return o;
  }
};

inline flatbuffers::Offset<T_EC_GETRECENTMSGS_RS> CreateT_EC_GETRECENTMSGS_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    uint64_t b_id = 0,
    uint64_t c_id = 0,
    uint64_t message_id = 0,
    int32_t max_cnt = 0,
    flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<ecpack::T_ECMSG_INFO>>> msg_list = 0) {
  T_EC_GETRECENTMSGS_RSBuilder builder_(_fbb);
  builder_.add_message_id(message_id);
  builder_.add_c_id(c_id);
  builder_.add_b_id(b_id);
  builder_.add_msg_list(msg_list);
  builder_.add_max_cnt(max_cnt);
  builder_.add_s_rs_head(s_rs_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_EC_GETRECENTMSGS_RS> CreateT_EC_GETRECENTMSGS_RSDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    uint64_t b_id = 0,
    uint64_t c_id = 0,
    uint64_t message_id = 0,
    int32_t max_cnt = 0,
    const std::vector<flatbuffers::Offset<ecpack::T_ECMSG_INFO>> *msg_list = nullptr) {
  return CreateT_EC_GETRECENTMSGS_RS(_fbb, s_rs_head, b_id, c_id, message_id, max_cnt, msg_list ? _fbb.CreateVector<flatbuffers::Offset<ecpack::T_ECMSG_INFO>>(*msg_list) : 0);
}

inline const ecpack::T_EC_GETRECENTMSGS_RS *GetT_EC_GETRECENTMSGS_RS(const void *buf) {
  return flatbuffers::GetRoot<ecpack::T_EC_GETRECENTMSGS_RS>(buf);
}

inline bool VerifyT_EC_GETRECENTMSGS_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<ecpack::T_EC_GETRECENTMSGS_RS>(nullptr);
}

inline void FinishT_EC_GETRECENTMSGS_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<ecpack::T_EC_GETRECENTMSGS_RS> root) {
  fbb.Finish(root);
}

}  // namespace ecpack

#endif  // FLATBUFFERS_GENERATED_FBECGETRECENTMSGSRS_ECPACK_H_
