// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGETMSGUNREADRS_SCPACK_H_
#define FLATBUFFERS_GENERATED_FBGETMSGUNREADRS_SCPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace scpack {

struct T_GET_MSG_UNREAD_RS;

struct T_GET_MSG_UNREAD_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_UNREAD_COUNT = 6
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  int32_t unread_count() const { return GetField<int32_t>(VT_UNREAD_COUNT, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<int32_t>(verifier, VT_UNREAD_COUNT) &&
           verifier.EndTable();
  }
};

struct T_GET_MSG_UNREAD_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_GET_MSG_UNREAD_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_unread_count(int32_t unread_count) { fbb_.AddElement<int32_t>(T_GET_MSG_UNREAD_RS::VT_UNREAD_COUNT, unread_count, 0); }
  T_GET_MSG_UNREAD_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GET_MSG_UNREAD_RSBuilder &operator=(const T_GET_MSG_UNREAD_RSBuilder &);
  flatbuffers::Offset<T_GET_MSG_UNREAD_RS> Finish() {
    auto o = flatbuffers::Offset<T_GET_MSG_UNREAD_RS>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_GET_MSG_UNREAD_RS> CreateT_GET_MSG_UNREAD_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    int32_t unread_count = 0) {
  T_GET_MSG_UNREAD_RSBuilder builder_(_fbb);
  builder_.add_unread_count(unread_count);
  builder_.add_s_rs_head(s_rs_head);
  return builder_.Finish();
}

inline const scpack::T_GET_MSG_UNREAD_RS *GetT_GET_MSG_UNREAD_RS(const void *buf) {
  return flatbuffers::GetRoot<scpack::T_GET_MSG_UNREAD_RS>(buf);
}

inline bool VerifyT_GET_MSG_UNREAD_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<scpack::T_GET_MSG_UNREAD_RS>(nullptr);
}

inline void FinishT_GET_MSG_UNREAD_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<scpack::T_GET_MSG_UNREAD_RS> root) {
  fbb.Finish(root);
}

}  // namespace scpack

#endif  // FLATBUFFERS_GENERATED_FBGETMSGUNREADRS_SCPACK_H_