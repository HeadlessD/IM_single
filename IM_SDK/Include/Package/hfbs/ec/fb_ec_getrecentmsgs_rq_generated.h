// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBECGETRECENTMSGSRQ_ECPACK_H_
#define FLATBUFFERS_GENERATED_FBECGETRECENTMSGSRQ_ECPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace ecpack {

struct T_EC_GETRECENTMSGS_RQ;

struct T_EC_GETRECENTMSGS_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_B_ID = 6,
    VT_C_ID = 8,
    VT_MESSAGE_ID = 10,
    VT_MAX_CNT = 12
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t b_id() const { return GetField<uint64_t>(VT_B_ID, 0); }
  uint64_t c_id() const { return GetField<uint64_t>(VT_C_ID, 0); }
  uint64_t message_id() const { return GetField<uint64_t>(VT_MESSAGE_ID, 0); }
  int32_t max_cnt() const { return GetField<int32_t>(VT_MAX_CNT, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_B_ID) &&
           VerifyField<uint64_t>(verifier, VT_C_ID) &&
           VerifyField<uint64_t>(verifier, VT_MESSAGE_ID) &&
           VerifyField<int32_t>(verifier, VT_MAX_CNT) &&
           verifier.EndTable();
  }
};

struct T_EC_GETRECENTMSGS_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_EC_GETRECENTMSGS_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_b_id(uint64_t b_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTMSGS_RQ::VT_B_ID, b_id, 0); }
  void add_c_id(uint64_t c_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTMSGS_RQ::VT_C_ID, c_id, 0); }
  void add_message_id(uint64_t message_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTMSGS_RQ::VT_MESSAGE_ID, message_id, 0); }
  void add_max_cnt(int32_t max_cnt) { fbb_.AddElement<int32_t>(T_EC_GETRECENTMSGS_RQ::VT_MAX_CNT, max_cnt, 0); }
  T_EC_GETRECENTMSGS_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_EC_GETRECENTMSGS_RQBuilder &operator=(const T_EC_GETRECENTMSGS_RQBuilder &);
  flatbuffers::Offset<T_EC_GETRECENTMSGS_RQ> Finish() {
    auto o = flatbuffers::Offset<T_EC_GETRECENTMSGS_RQ>(fbb_.EndTable(start_, 5));
    return o;
  }
};

inline flatbuffers::Offset<T_EC_GETRECENTMSGS_RQ> CreateT_EC_GETRECENTMSGS_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t b_id = 0,
    uint64_t c_id = 0,
    uint64_t message_id = 0,
    int32_t max_cnt = 0) {
  T_EC_GETRECENTMSGS_RQBuilder builder_(_fbb);
  builder_.add_message_id(message_id);
  builder_.add_c_id(c_id);
  builder_.add_b_id(b_id);
  builder_.add_max_cnt(max_cnt);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const ecpack::T_EC_GETRECENTMSGS_RQ *GetT_EC_GETRECENTMSGS_RQ(const void *buf) {
  return flatbuffers::GetRoot<ecpack::T_EC_GETRECENTMSGS_RQ>(buf);
}

inline bool VerifyT_EC_GETRECENTMSGS_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<ecpack::T_EC_GETRECENTMSGS_RQ>(nullptr);
}

inline void FinishT_EC_GETRECENTMSGS_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<ecpack::T_EC_GETRECENTMSGS_RQ> root) {
  fbb.Finish(root);
}

}  // namespace ecpack

#endif  // FLATBUFFERS_GENERATED_FBECGETRECENTMSGSRQ_ECPACK_H_
