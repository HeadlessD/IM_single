// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBECGETRECENTORDERSRQ_ECPACK_H_
#define FLATBUFFERS_GENERATED_FBECGETRECENTORDERSRQ_ECPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace ecpack {

struct T_EC_GETRECENTORDERS_RQ;

struct T_EC_GETRECENTORDERS_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_SELLERID = 6,
    VT_BUYERID = 8
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t sellerId() const { return GetField<uint64_t>(VT_SELLERID, 0); }
  uint64_t buyerId() const { return GetField<uint64_t>(VT_BUYERID, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_SELLERID) &&
           VerifyField<uint64_t>(verifier, VT_BUYERID) &&
           verifier.EndTable();
  }
};

struct T_EC_GETRECENTORDERS_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_EC_GETRECENTORDERS_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_sellerId(uint64_t sellerId) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTORDERS_RQ::VT_SELLERID, sellerId, 0); }
  void add_buyerId(uint64_t buyerId) { fbb_.AddElement<uint64_t>(T_EC_GETRECENTORDERS_RQ::VT_BUYERID, buyerId, 0); }
  T_EC_GETRECENTORDERS_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_EC_GETRECENTORDERS_RQBuilder &operator=(const T_EC_GETRECENTORDERS_RQBuilder &);
  flatbuffers::Offset<T_EC_GETRECENTORDERS_RQ> Finish() {
    auto o = flatbuffers::Offset<T_EC_GETRECENTORDERS_RQ>(fbb_.EndTable(start_, 3));
    return o;
  }
};

inline flatbuffers::Offset<T_EC_GETRECENTORDERS_RQ> CreateT_EC_GETRECENTORDERS_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t sellerId = 0,
    uint64_t buyerId = 0) {
  T_EC_GETRECENTORDERS_RQBuilder builder_(_fbb);
  builder_.add_buyerId(buyerId);
  builder_.add_sellerId(sellerId);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const ecpack::T_EC_GETRECENTORDERS_RQ *GetT_EC_GETRECENTORDERS_RQ(const void *buf) {
  return flatbuffers::GetRoot<ecpack::T_EC_GETRECENTORDERS_RQ>(buf);
}

inline bool VerifyT_EC_GETRECENTORDERS_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<ecpack::T_EC_GETRECENTORDERS_RQ>(nullptr);
}

inline void FinishT_EC_GETRECENTORDERS_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<ecpack::T_EC_GETRECENTORDERS_RQ> root) {
  fbb.Finish(root);
}

}  // namespace ecpack

#endif  // FLATBUFFERS_GENERATED_FBECGETRECENTORDERSRQ_ECPACK_H_
