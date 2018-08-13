// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBECGETOFFLINEMESSAGERQ_ECPACK_H_
#define FLATBUFFERS_GENERATED_FBECGETOFFLINEMESSAGERQ_ECPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace ecpack {

struct T_EC_GET_OFFLINE_MESSAGE_RQ;

struct T_EC_GET_OFFLINE_MESSAGE_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_B_ID = 6,
    VT_OFFSET = 8
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t b_id() const { return GetField<uint64_t>(VT_B_ID, 0); }
  int32_t offset() const { return GetField<int32_t>(VT_OFFSET, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_B_ID) &&
           VerifyField<int32_t>(verifier, VT_OFFSET) &&
           verifier.EndTable();
  }
};

struct T_EC_GET_OFFLINE_MESSAGE_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_EC_GET_OFFLINE_MESSAGE_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_b_id(uint64_t b_id) { fbb_.AddElement<uint64_t>(T_EC_GET_OFFLINE_MESSAGE_RQ::VT_B_ID, b_id, 0); }
  void add_offset(int32_t offset) { fbb_.AddElement<int32_t>(T_EC_GET_OFFLINE_MESSAGE_RQ::VT_OFFSET, offset, 0); }
  T_EC_GET_OFFLINE_MESSAGE_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_EC_GET_OFFLINE_MESSAGE_RQBuilder &operator=(const T_EC_GET_OFFLINE_MESSAGE_RQBuilder &);
  flatbuffers::Offset<T_EC_GET_OFFLINE_MESSAGE_RQ> Finish() {
    auto o = flatbuffers::Offset<T_EC_GET_OFFLINE_MESSAGE_RQ>(fbb_.EndTable(start_, 3));
    return o;
  }
};

inline flatbuffers::Offset<T_EC_GET_OFFLINE_MESSAGE_RQ> CreateT_EC_GET_OFFLINE_MESSAGE_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t b_id = 0,
    int32_t offset = 0) {
  T_EC_GET_OFFLINE_MESSAGE_RQBuilder builder_(_fbb);
  builder_.add_b_id(b_id);
  builder_.add_offset(offset);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const ecpack::T_EC_GET_OFFLINE_MESSAGE_RQ *GetT_EC_GET_OFFLINE_MESSAGE_RQ(const void *buf) {
  return flatbuffers::GetRoot<ecpack::T_EC_GET_OFFLINE_MESSAGE_RQ>(buf);
}

inline bool VerifyT_EC_GET_OFFLINE_MESSAGE_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<ecpack::T_EC_GET_OFFLINE_MESSAGE_RQ>(nullptr);
}

inline void FinishT_EC_GET_OFFLINE_MESSAGE_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<ecpack::T_EC_GET_OFFLINE_MESSAGE_RQ> root) {
  fbb.Finish(root);
}

}  // namespace ecpack

#endif  // FLATBUFFERS_GENERATED_FBECGETOFFLINEMESSAGERQ_ECPACK_H_
