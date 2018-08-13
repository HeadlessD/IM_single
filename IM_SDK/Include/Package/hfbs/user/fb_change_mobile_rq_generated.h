// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBCHANGEMOBILERQ_USERPACK_H_
#define FLATBUFFERS_GENERATED_FBCHANGEMOBILERQ_USERPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace userpack {

struct T_CHANGE_MOBILE_RQ;

struct T_CHANGE_MOBILE_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_OLD_MOBLIE = 6,
    VT_NEW_MOBLIE = 8
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t old_moblie() const { return GetField<uint64_t>(VT_OLD_MOBLIE, 0); }
  uint64_t new_moblie() const { return GetField<uint64_t>(VT_NEW_MOBLIE, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_OLD_MOBLIE) &&
           VerifyField<uint64_t>(verifier, VT_NEW_MOBLIE) &&
           verifier.EndTable();
  }
};

struct T_CHANGE_MOBILE_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_CHANGE_MOBILE_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_old_moblie(uint64_t old_moblie) { fbb_.AddElement<uint64_t>(T_CHANGE_MOBILE_RQ::VT_OLD_MOBLIE, old_moblie, 0); }
  void add_new_moblie(uint64_t new_moblie) { fbb_.AddElement<uint64_t>(T_CHANGE_MOBILE_RQ::VT_NEW_MOBLIE, new_moblie, 0); }
  T_CHANGE_MOBILE_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_CHANGE_MOBILE_RQBuilder &operator=(const T_CHANGE_MOBILE_RQBuilder &);
  flatbuffers::Offset<T_CHANGE_MOBILE_RQ> Finish() {
    auto o = flatbuffers::Offset<T_CHANGE_MOBILE_RQ>(fbb_.EndTable(start_, 3));
    return o;
  }
};

inline flatbuffers::Offset<T_CHANGE_MOBILE_RQ> CreateT_CHANGE_MOBILE_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t old_moblie = 0,
    uint64_t new_moblie = 0) {
  T_CHANGE_MOBILE_RQBuilder builder_(_fbb);
  builder_.add_new_moblie(new_moblie);
  builder_.add_old_moblie(old_moblie);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const userpack::T_CHANGE_MOBILE_RQ *GetT_CHANGE_MOBILE_RQ(const void *buf) {
  return flatbuffers::GetRoot<userpack::T_CHANGE_MOBILE_RQ>(buf);
}

inline bool VerifyT_CHANGE_MOBILE_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<userpack::T_CHANGE_MOBILE_RQ>(nullptr);
}

inline void FinishT_CHANGE_MOBILE_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<userpack::T_CHANGE_MOBILE_RQ> root) {
  fbb.Finish(root);
}

}  // namespace userpack

#endif  // FLATBUFFERS_GENERATED_FBCHANGEMOBILERQ_USERPACK_H_
