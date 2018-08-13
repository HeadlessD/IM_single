// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBSERVEROFFCIALMESSAGERQ_OFFCIALPACK_H_
#define FLATBUFFERS_GENERATED_FBSERVEROFFCIALMESSAGERQ_OFFCIALPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace offcialpack {

struct T_SERVER_OFFCIAL_MESSAGE_RQ;

struct T_SERVER_OFFCIAL_MESSAGE_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_MESSAGE_ID = 6,
    VT_OFFCIAL_ID = 8,
    VT_S_MSG = 10,
    VT_B_ID = 12,
    VT_W_ID = 14,
    VT_C_ID = 16
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t message_id() const { return GetField<uint64_t>(VT_MESSAGE_ID, 0); }
  uint64_t offcial_id() const { return GetField<uint64_t>(VT_OFFCIAL_ID, 0); }
  const commonpack::S_MSG *s_msg() const { return GetPointer<const commonpack::S_MSG *>(VT_S_MSG); }
  uint64_t b_id() const { return GetField<uint64_t>(VT_B_ID, 0); }
  uint64_t w_id() const { return GetField<uint64_t>(VT_W_ID, 0); }
  uint64_t c_id() const { return GetField<uint64_t>(VT_C_ID, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_MESSAGE_ID) &&
           VerifyField<uint64_t>(verifier, VT_OFFCIAL_ID) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_S_MSG) &&
           verifier.VerifyTable(s_msg()) &&
           VerifyField<uint64_t>(verifier, VT_B_ID) &&
           VerifyField<uint64_t>(verifier, VT_W_ID) &&
           VerifyField<uint64_t>(verifier, VT_C_ID) &&
           verifier.EndTable();
  }
};

struct T_SERVER_OFFCIAL_MESSAGE_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_message_id(uint64_t message_id) { fbb_.AddElement<uint64_t>(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_MESSAGE_ID, message_id, 0); }
  void add_offcial_id(uint64_t offcial_id) { fbb_.AddElement<uint64_t>(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_OFFCIAL_ID, offcial_id, 0); }
  void add_s_msg(flatbuffers::Offset<commonpack::S_MSG> s_msg) { fbb_.AddOffset(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_S_MSG, s_msg); }
  void add_b_id(uint64_t b_id) { fbb_.AddElement<uint64_t>(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_B_ID, b_id, 0); }
  void add_w_id(uint64_t w_id) { fbb_.AddElement<uint64_t>(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_W_ID, w_id, 0); }
  void add_c_id(uint64_t c_id) { fbb_.AddElement<uint64_t>(T_SERVER_OFFCIAL_MESSAGE_RQ::VT_C_ID, c_id, 0); }
  T_SERVER_OFFCIAL_MESSAGE_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_SERVER_OFFCIAL_MESSAGE_RQBuilder &operator=(const T_SERVER_OFFCIAL_MESSAGE_RQBuilder &);
  flatbuffers::Offset<T_SERVER_OFFCIAL_MESSAGE_RQ> Finish() {
    auto o = flatbuffers::Offset<T_SERVER_OFFCIAL_MESSAGE_RQ>(fbb_.EndTable(start_, 7));
    return o;
  }
};

inline flatbuffers::Offset<T_SERVER_OFFCIAL_MESSAGE_RQ> CreateT_SERVER_OFFCIAL_MESSAGE_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t message_id = 0,
    uint64_t offcial_id = 0,
    flatbuffers::Offset<commonpack::S_MSG> s_msg = 0,
    uint64_t b_id = 0,
    uint64_t w_id = 0,
    uint64_t c_id = 0) {
  T_SERVER_OFFCIAL_MESSAGE_RQBuilder builder_(_fbb);
  builder_.add_c_id(c_id);
  builder_.add_w_id(w_id);
  builder_.add_b_id(b_id);
  builder_.add_offcial_id(offcial_id);
  builder_.add_message_id(message_id);
  builder_.add_s_msg(s_msg);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const offcialpack::T_SERVER_OFFCIAL_MESSAGE_RQ *GetT_SERVER_OFFCIAL_MESSAGE_RQ(const void *buf) {
  return flatbuffers::GetRoot<offcialpack::T_SERVER_OFFCIAL_MESSAGE_RQ>(buf);
}

inline bool VerifyT_SERVER_OFFCIAL_MESSAGE_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<offcialpack::T_SERVER_OFFCIAL_MESSAGE_RQ>(nullptr);
}

inline void FinishT_SERVER_OFFCIAL_MESSAGE_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<offcialpack::T_SERVER_OFFCIAL_MESSAGE_RQ> root) {
  fbb.Finish(root);
}

}  // namespace offcialpack

#endif  // FLATBUFFERS_GENERATED_FBSERVEROFFCIALMESSAGERQ_OFFCIALPACK_H_
