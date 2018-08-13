// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBECGETRECENTUSERSRQ_ECPACK_H_
#define FLATBUFFERS_GENERATED_FBECGETRECENTUSERSRQ_ECPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace ecpack {

struct T_EC_GETRECENTUSERS_RQ;

struct T_EC_GETRECENTUSERS_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_B_ID = 6
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t b_id() const { return GetField<uint64_t>(VT_B_ID, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_B_ID) &&
           verifier.EndTable();
  }
};

struct T_EC_GETRECENTUSERS_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_EC_GETRECENTUSERS_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_b_id(uint64_t b_id) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTUSERS_RQ::VT_B_ID, b_id, 0); }
  T_EC_GETRECENTUSERS_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_EC_GETRECENTUSERS_RQBuilder &operator=(const T_EC_GETRECENTUSERS_RQBuilder &);
  flatbuffers::Offset<T_EC_GETRECENTUSERS_RQ> Finish() {
    auto o = flatbuffers::Offset<T_EC_GETRECENTUSERS_RQ>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_EC_GETRECENTUSERS_RQ> CreateT_EC_GETRECENTUSERS_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t b_id = 0) {
  T_EC_GETRECENTUSERS_RQBuilder builder_(_fbb);
  builder_.add_b_id(b_id);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const ecpack::T_EC_GETRECENTUSERS_RQ *GetT_EC_GETRECENTUSERS_RQ(const void *buf) {
  return flatbuffers::GetRoot<ecpack::T_EC_GETRECENTUSERS_RQ>(buf);
}

inline bool VerifyT_EC_GETRECENTUSERS_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<ecpack::T_EC_GETRECENTUSERS_RQ>(nullptr);
}

inline void FinishT_EC_GETRECENTUSERS_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<ecpack::T_EC_GETRECENTUSERS_RQ> root) {
  fbb.Finish(root);
}

}  // namespace ecpack

#endif  // FLATBUFFERS_GENERATED_FBECGETRECENTUSERSRQ_ECPACK_H_
